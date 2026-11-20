// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';

class ChainProxyItem {
  String id;
  String name;
  List<String> hops; // Ordered: [entry, ...transits, exit], length >= 2
  bool enabled;
  int? delay;

  ChainProxyItem({
    String? id,
    required this.name,
    List<String>? hops,
    String? hop1,
    String? hop2,
    this.enabled = true,
    this.delay,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       hops = hops != null
           ? List<String>.from(hops)
           : <String>[
               if (hop1 != null && hop1.isNotEmpty) hop1,
               if (hop2 != null && hop2.isNotEmpty) hop2,
             ];

  String get hop1 => hops.isNotEmpty ? hops.first : '';
  String get hop2 => hops.length >= 2 ? hops.last : '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'hops': hops,
    'enabled': enabled,
    'delay': delay,
  };

  factory ChainProxyItem.fromJson(Map<String, dynamic> json) {
    List<String> parsedHops = [];
    final rawHops = json['hops'];
    if (rawHops is List) {
      parsedHops = rawHops
          .map((e) => e?.toString() ?? '')
          .where((e) => e.isNotEmpty)
          .toList();
    } else {
      final h1 = json['hop1']?.toString() ?? '';
      final h2 = json['hop2']?.toString() ?? '';
      if (h1.isNotEmpty) parsedHops.add(h1);
      if (h2.isNotEmpty) parsedHops.add(h2);
    }

    return ChainProxyItem(
      id: json['id']?.toString(),
      name: json['name']?.toString() ?? '',
      hops: parsedHops,
      enabled: json['enabled'] ?? true,
      delay: json['delay'] is num ? (json['delay'] as num).toInt() : null,
    );
  }

  ChainProxyItem clone() => ChainProxyItem(
    id: id,
    name: name,
    hops: List<String>.from(hops),
    enabled: enabled,
    delay: delay,
  );
}

enum ChainValidationIssue {
  emptyName,
  insufficientHops,
  emptyHop,
  duplicateHops,
  missingHop,
  groupInNonEntryHop,
}

class ChainValidationResult {
  final List<ChainValidationIssue> issues;
  final Set<int> missingHopIndices;
  final Set<int> invalidGroupHopIndices;

  const ChainValidationResult({
    this.issues = const [],
    this.missingHopIndices = const {},
    this.invalidGroupHopIndices = const {},
  });

  bool get isValid => issues.isEmpty;
}

class ChainProxyManager {
  static const String _kFileName = "chain_proxies.json";
  static const String _kTagBegin = "# BEGIN WMIMO CHAIN PROXIES";
  static const String _kTagEnd = "# END WMIMO CHAIN PROXIES";
  static const String _kGroupItemMarker = "# WMIMO_CHAIN_PROXY_ITEM";

  static List<ChainProxyItem> _items = [];
  static bool _initialized = false;
  static final List<VoidCallback> onChainProxiesChanged = [];

  static List<ChainProxyItem> get items => List.unmodifiable(_items);
  static int get enabledCount => _items.where((e) => e.enabled).length;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await load();
  }

  static Future<String> _getFilePath() async {
    final baseDir = await PathUtils.profileDir();
    return path.join(baseDir, _kFileName);
  }

  static Future<void> load() async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      if (!await file.exists()) {
        _items = [];
        return;
      }
      final content = (await file.readAsString()).trim();
      if (content.isEmpty) {
        _items = [];
        return;
      }
      final decoded = jsonDecode(content);
      if (decoded is List) {
        _items = decoded
            .whereType<Map<String, dynamic>>()
            .map((e) => ChainProxyItem.fromJson(e))
            .toList();
      }
    } catch (e) {
      Log.w("ChainProxyManager.load error: $e");
    }
  }

  static Future<void> save() async {
    try {
      final filePath = await _getFilePath();
      const encoder = JsonEncoder.withIndent('  ');
      final content = encoder.convert(_items.map((e) => e.toJson()).toList());
      final file = File(filePath);
      final tmpFile = File("$filePath.tmp");
      await tmpFile.writeAsString(content, flush: true);
      try {
        await tmpFile.rename(file.path);
      } catch (_) {
        await file.writeAsString(content, flush: true);
        try {
          if (await tmpFile.exists()) await tmpFile.delete();
        } catch (_) {}
      }
    } catch (e) {
      Log.w("ChainProxyManager.save error: $e");
    }
  }

  static void _notifyChanged() {
    for (var cb in List<VoidCallback>.from(onChainProxiesChanged)) {
      try {
        cb();
      } catch (_) {}
    }
  }

  static Future<void> addOrUpdate(ChainProxyItem item) async {
    final idx = _items.indexWhere((e) => e.id == item.id);
    if (idx >= 0) {
      _items[idx] = item;
    } else {
      _items.add(item);
    }
    await save();
    _notifyChanged();
    await applyToCurrentAndReload();
  }

  static Future<void> delete(String id) async {
    _items.removeWhere((e) => e.id == id);
    await save();
    _notifyChanged();
    await applyToCurrentAndReload();
  }

  static Future<void> toggle(String id, bool enabled) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _items[idx].enabled = enabled;
      if (!enabled) {
        _items[idx].delay = null;
      }
      await save();
      _notifyChanged();
      await applyToCurrentAndReload();
    }
  }

  static void updateDelay(String id, int? delay) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx >= 0) {
      _items[idx].delay = delay;
      _notifyChanged();
    }
  }

  /// Validates a [ChainProxyItem] against concrete [proxyNames] and policy [groupNames].
  static ChainValidationResult validateItem(
    ChainProxyItem item, {
    required Set<String> proxyNames,
    Set<String> groupNames = const {},
  }) {
    final issues = <ChainValidationIssue>[];
    final missingIndices = <int>{};
    final invalidGroupIndices = <int>{};

    if (item.name.trim().isEmpty) {
      issues.add(ChainValidationIssue.emptyName);
    }
    if (item.hops.length < 2) {
      issues.add(ChainValidationIssue.insufficientHops);
    }

    final seen = <String>{};
    for (var i = 0; i < item.hops.length; i++) {
      final hop = item.hops[i].trim();
      if (hop.isEmpty) {
        issues.add(ChainValidationIssue.emptyHop);
        missingIndices.add(i);
        continue;
      }
      if (!seen.add(hop) && !issues.contains(ChainValidationIssue.duplicateHops)) {
        issues.add(ChainValidationIssue.duplicateHops);
      }

      if (i == 0) {
        if (!proxyNames.contains(hop) && !groupNames.contains(hop)) {
          missingIndices.add(i);
          if (!issues.contains(ChainValidationIssue.missingHop)) {
            issues.add(ChainValidationIssue.missingHop);
          }
        }
      } else {
        if (!proxyNames.contains(hop)) {
          if (groupNames.contains(hop)) {
            invalidGroupIndices.add(i);
            if (!issues.contains(ChainValidationIssue.groupInNonEntryHop)) {
              issues.add(ChainValidationIssue.groupInNonEntryHop);
            }
          } else {
            missingIndices.add(i);
            if (!issues.contains(ChainValidationIssue.missingHop)) {
              issues.add(ChainValidationIssue.missingHop);
            }
          }
        }
      }
    }

    return ChainValidationResult(
      issues: issues,
      missingHopIndices: missingIndices,
      invalidGroupHopIndices: invalidGroupIndices,
    );
  }

  /// Injects active chain proxies into the target profile YAML file using Mihomo `dialer-proxy`.
  static Future<void> applyToProfile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return;

      var content = await file.readAsString();
      if (content.trim().isEmpty) return;

      final updated = applyToProfileContent(content, _items);
      if (updated != content) {
        await _atomicWrite(file, updated);
      }
    } catch (e) {
      Log.w("ChainProxyManager.applyToProfile error: $e");
    }
  }

  /// Pure string transformation that strips prior chain injections and injects
  /// multi-hop `dialer-proxy` nodes into `proxies:` and selector `proxy-groups:`.
  static String applyToProfileContent(
    String rawContent,
    List<ChainProxyItem> chains,
  ) {
    var content = removeInjectedBlock(rawContent);
    final normalizedNewline = content.contains('\r\n') ? '\r\n' : '\n';
    content = content.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    final activeChains = chains.where((e) => e.enabled).toList();
    if (activeChains.isEmpty) {
      return normalizedNewline == '\r\n'
          ? content.replaceAll('\n', '\r\n')
          : content;
    }

    // Extract original concrete proxies & group names for validation and cloning
    final proxiesList = ProxyNodeLoader.extractProxiesList(content);
    final groupsList = ProxyNodeLoader.extractProxyGroupsList(content);

    final Map<String, Map<String, dynamic>> proxyConfigMap = {};
    for (final p in proxiesList) {
      final pName = p['name']?.toString() ?? '';
      if (pName.isNotEmpty) {
        proxyConfigMap[pName] = p;
      }
    }

    final Set<String> groupNames = {};
    for (final g in groupsList) {
      final gName = g['name']?.toString() ?? '';
      if (gName.isNotEmpty) {
        groupNames.add(gName);
      }
    }

    final Set<String> reservedNames = {
      ...proxyConfigMap.keys,
      ...groupNames,
      'DIRECT',
      'REJECT',
      'REJECT-DROP',
      'PASS',
    };

    final List<Map<String, dynamic>> generatedProxyMaps = [];
    final List<String> finalChainNames = [];

    for (final chain in activeChains) {
      final validation = validateItem(
        chain,
        proxyNames: proxyConfigMap.keys.toSet(),
        groupNames: groupNames,
      );
      if (!validation.isValid) {
        continue;
      }

      // Prevent duplicate proxy/group name collisions inside Mihomo
      String effectiveFinalName = chain.name.trim();
      if (reservedNames.contains(effectiveFinalName)) {
        continue;
      }

      String prevHopTarget = chain.hops.first.trim();
      final List<Map<String, dynamic>> chainHopConfigs = [];
      bool chainBuildOk = true;

      for (int i = 1; i < chain.hops.length; i++) {
        final hopKey = chain.hops[i].trim();
        final baseConfig = proxyConfigMap[hopKey];
        if (baseConfig == null) {
          chainBuildOk = false;
          break;
        }

        final cloned = _deepConvertMap(baseConfig);
        cloned['dialer-proxy'] = prevHopTarget;

        final bool isFinalHop = i == chain.hops.length - 1;
        String hopNodeName;
        if (isFinalHop) {
          hopNodeName = effectiveFinalName;
        } else {
          hopNodeName = "⛓️ ${effectiveFinalName} · Hop ${i + 1}";
          int suffix = 1;
          while (reservedNames.contains(hopNodeName)) {
            hopNodeName = "⛓️ ${effectiveFinalName} · Hop ${i + 1} ($suffix)";
            suffix++;
          }
        }

        cloned['name'] = hopNodeName;
        reservedNames.add(hopNodeName);
        chainHopConfigs.add(cloned);
        prevHopTarget = hopNodeName;
      }

      if (chainBuildOk && chainHopConfigs.isNotEmpty) {
        generatedProxyMaps.addAll(chainHopConfigs);
        finalChainNames.add(effectiveFinalName);
      }
    }

    if (generatedProxyMaps.isEmpty || finalChainNames.isEmpty) {
      return normalizedNewline == '\r\n'
          ? content.replaceAll('\n', '\r\n')
          : content;
    }

    // 1. Inject generated dialer-proxy nodes into top-level `proxies:`
    content = _injectIntoProxiesSection(content, generatedProxyMaps);

    // 2. Inject final chain node names into selector `proxy-groups:`
    content = _injectIntoSelectorGroups(content, finalChainNames);

    return normalizedNewline == '\r\n'
        ? content.replaceAll('\n', '\r\n')
        : content;
  }

  static String _injectIntoProxiesSection(
    String content,
    List<Map<String, dynamic>> generatedProxies,
  ) {
    final lines = content.split('\n');
    final proxiesHeader = RegExp(r'''^(["']?proxies["']?)\s*:\s*(\[\s*\])?\s*(?:#.*)?$''');
    final topLevelHeader = RegExp(r'^[a-zA-Z0-9_-]+\s*:');

    int headerIdx = -1;
    bool wasEmptyArray = false;
    String indent = '  ';

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith(' ') || line.startsWith('\t')) continue;
      final match = proxiesHeader.firstMatch(line);
      if (match != null) {
        headerIdx = i;
        wasEmptyArray = match.group(2) != null;
        // Detect existing list item indentation under `proxies:`
        for (int j = i + 1; j < lines.length; j++) {
          final nextTrim = lines[j].trim();
          if (nextTrim.isEmpty || nextTrim.startsWith('#')) continue;
          if (!lines[j].startsWith(' ') &&
              !lines[j].startsWith('\t') &&
              !lines[j].startsWith('-') &&
              topLevelHeader.hasMatch(lines[j])) {
            break;
          }
          final itemMatch = RegExp(r'^([ \t]*)-\s').firstMatch(lines[j]);
          if (itemMatch != null) {
            indent = itemMatch.group(1) ?? '  ';
            break;
          }
        }
        break;
      }
    }

    final injectedLines = <String>[
      "$indent$_kTagBegin",
      ...generatedProxies.map((m) => "$indent- ${jsonEncode(m)}"),
      "$indent$_kTagEnd",
    ];

    if (headerIdx != -1) {
      if (wasEmptyArray) {
        lines[headerIdx] = "proxies:";
      }
      lines.insertAll(headerIdx + 1, injectedLines);
      return lines.join('\n');
    }

    // Fallback: append top-level proxies section if absent
    final trimmed = content.trimRight();
    return "$trimmed\n\nproxies:\n${injectedLines.join('\n')}\n";
  }

  static String _injectIntoSelectorGroups(
    String content,
    List<String> chainNames,
  ) {
    final lines = content.split('\n');
    final pgHeader = RegExp(r'''^(["']?proxy-groups["']?)\s*:\s*(?:#.*)?$''');
    final topLevelHeader = RegExp(r'^[a-zA-Z0-9_-]+\s*:');

    int pgStart = -1;
    int pgEnd = lines.length;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (line.startsWith(' ') || line.startsWith('\t')) continue;
      if (pgHeader.hasMatch(line)) {
        pgStart = i + 1;
        for (int j = pgStart; j < lines.length; j++) {
          final l = lines[j];
          if (l.trim().isEmpty || l.trim().startsWith('#')) continue;
          if (!l.startsWith(' ') &&
              !l.startsWith('\t') &&
              !l.startsWith('-') &&
              topLevelHeader.hasMatch(l)) {
            pgEnd = j;
            break;
          }
        }
        break;
      }
    }

    if (pgStart == -1) return content;

    // Determine indentation of group list items under `proxy-groups:`
    int? groupDashIndentLen;
    for (int i = pgStart; i < pgEnd; i++) {
      final m = RegExp(r'^([ \t]*)-\s').firstMatch(lines[i]);
      if (m != null) {
        groupDashIndentLen = m.group(1)!.length;
        break;
      }
    }
    if (groupDashIndentLen == null) return content;

    // Collect start indices of each group item in `proxy-groups:`
    final List<int> groupStarts = [];
    for (int i = pgStart; i < pgEnd; i++) {
      final m = RegExp(r'^([ \t]*)-\s').firstMatch(lines[i]);
      if (m != null && m.group(1)!.length == groupDashIndentLen) {
        groupStarts.add(i);
      }
    }

    // Process groups in reverse order so insertions don't shift earlier line indices
    for (int gIdx = groupStarts.length - 1; gIdx >= 0; gIdx--) {
      final start = groupStarts[gIdx];
      final end = (gIdx + 1 < groupStarts.length) ? groupStarts[gIdx + 1] : pgEnd;
      final groupChunk = lines.sublist(start, end).join('\n');

      Map<String, dynamic>? parsedGroup;
      try {
        final yaml = loadYaml(groupChunk);
        if (yaml is List && yaml.isNotEmpty && yaml.first is Map) {
          parsedGroup = _deepConvertMap(Map<dynamic, dynamic>.from(yaml.first as Map));
        }
      } catch (_) {}

      if (parsedGroup == null) continue;
      final groupName = parsedGroup['name']?.toString().trim() ?? '';
      final rawType = parsedGroup['type']?.toString().toLowerCase().replaceAll('-', '').replaceAll('_', '') ?? '';
      final upperName = groupName.toUpperCase();
      if ((rawType != 'select' && rawType != 'selector') ||
          upperName == 'DIRECT' ||
          upperName == 'REJECT') {
        continue;
      }

      final existingProxies = (parsedGroup['proxies'] is List)
          ? (parsedGroup['proxies'] as List).map((e) => e.toString()).toSet()
          : <String>{};
      final toInsert = chainNames.where((n) => !existingProxies.contains(n)).toList();
      if (toInsert.isEmpty) continue;

      // Locate `proxies:` key within [start, end)
      int proxiesKeyLine = -1;
      int keyIndentLen = groupDashIndentLen + 2;
      for (int i = start; i < end; i++) {
        final m = RegExp(r'''^([ \t]*)["']?proxies["']?\s*:''').firstMatch(lines[i]);
        if (m != null) {
          proxiesKeyLine = i;
          keyIndentLen = m.group(1)!.length;
          break;
        }
      }
      if (proxiesKeyLine == -1) continue;

      final keyLine = lines[proxiesKeyLine];
      final flowMatch = RegExp(r'''^([ \t]*["']?proxies["']?\s*:)\s*\[([^\[\]\n]*)\]\s*(?:#.*)?$''').firstMatch(keyLine);

      if (flowMatch != null) {
        // Convert single-line flow list `proxies: [A, B]` into block list cleanly
        final itemIndent = ' ' * (keyIndentLen + 2);
        final rawItems = flowMatch.group(2)!.trim();
        final existingFlowItems = <String>[];
        if (rawItems.isNotEmpty) {
          try {
            final parsedList = loadYaml('[$rawItems]');
            if (parsedList is List) {
              for (final item in parsedList) {
                existingFlowItems.add(item.toString());
              }
            }
          } catch (_) {}
        }
        final replacement = <String>[
          '${' ' * keyIndentLen}proxies:',
          ...existingFlowItems.map((e) => '$itemIndent- ${jsonEncode(e)}'),
          ...toInsert.map((n) => '$itemIndent- ${jsonEncode(n)} $_kGroupItemMarker'),
        ];
        lines.replaceRange(proxiesKeyLine, proxiesKeyLine + 1, replacement);
      } else {
        // Block-style `proxies:` list: find end of list items and matching indentation
        String itemIndent = ' ' * (keyIndentLen + 2);
        int insertAt = proxiesKeyLine + 1;
        for (int i = proxiesKeyLine + 1; i < end; i++) {
          final l = lines[i];
          final trim = l.trim();
          if (trim.isEmpty || trim.startsWith('#')) {
            continue;
          }
          final itemMatch = RegExp(r'^([ \t]*)-\s').firstMatch(l);
          if (itemMatch != null && itemMatch.group(1)!.length >= keyIndentLen) {
            itemIndent = itemMatch.group(1)!;
            insertAt = i + 1;
          } else {
            break;
          }
        }
        final newLines = toInsert
            .map((n) => '$itemIndent- ${jsonEncode(n)} $_kGroupItemMarker')
            .toList();
        lines.insertAll(insertAt, newLines);
      }
    }

    return lines.join('\n');
  }

  /// Removes all WMIMO chain proxy blocks and selector references cleanly from a YAML string.
  static String removeInjectedBlock(String content) {
    final blockPattern = RegExp(
      r'[ \t]*' + RegExp.escape(_kTagBegin) + r'[\s\S]*?' + RegExp.escape(_kTagEnd) + r'\r?\n?',
      multiLine: true,
    );
    var cleaned = content.replaceAll(blockPattern, '');

    final markerPattern = RegExp(
      r'^[^\n]*' + RegExp.escape(_kGroupItemMarker) + r'\r?\n?',
      multiLine: true,
    );
    cleaned = cleaned.replaceAll(markerPattern, '');
    return cleaned;
  }

  /// Applies chain proxies to current active profile and reloads Mihomo if active.
  static Future<void> applyToCurrentAndReload() async {
    final current = ProfileManager.getCurrent();
    if (current == null) return;
    final dir = await PathUtils.profilesDir();
    final filePath = path.join(dir, current.id);
    await applyToProfile(filePath);
    ProxyNodeLoader.clearCache(current.id);

    final isVpnStarted = await VPNService.getStarted();
    if (isVpnStarted) {
      try {
        await VPNService.reload(const Duration(seconds: 3), smooth: true);
      } catch (e) {
        Log.w("ChainProxyManager.reload error: $e");
      }
    }
  }

  /// Switches the active profile's primary selector group to [chainName] via Clash API.
  /// Returns the switched group name on success, or null if not found / failed.
  static Future<String?> activateChainInPrimaryGroup(String chainName) async {
    final res = await ClashHttpApi.getProxies();
    if (res.error != null || res.data == null || res.data!.isEmpty) {
      return null;
    }

    final proxies = res.data!;
    final selectorGroups = proxies.where((n) {
      final lowerType =
          n.type.toLowerCase().replaceAll('-', '').replaceAll('_', '');
      return lowerType == 'selector' || lowerType == 'select';
    }).toList();

    final primary = ClashHttpApi.findPrimaryRuleGroup(selectorGroups);
    if (primary != null && primary.all.contains(chainName)) {
      final err = await ClashHttpApi.setProxiesNode(primary.name, chainName);
      if (err == null) {
        return primary.name;
      }
    }

    // Fallback to any selector group containing the chain proxy
    for (final g in selectorGroups) {
      if (g.all.contains(chainName)) {
        final err = await ClashHttpApi.setProxiesNode(g.name, chainName);
        if (err == null) {
          return g.name;
        }
      }
    }
    return null;
  }

  static Map<String, dynamic> _deepConvertMap(Map<dynamic, dynamic> raw) {
    final out = <String, dynamic>{};
    raw.forEach((k, v) {
      out[k.toString()] = _deepConvertValue(v);
    });
    return out;
  }

  static dynamic _deepConvertValue(dynamic v) {
    if (v is YamlMap || v is Map) {
      return _deepConvertMap(Map<dynamic, dynamic>.from(v as Map));
    }
    if (v is YamlList || v is List) {
      return (v as List).map(_deepConvertValue).toList();
    }
    return v;
  }

  static Future<void> _atomicWrite(File targetFile, String content) async {
    final tempPath = "${targetFile.path}.tmp_${DateTime.now().microsecondsSinceEpoch}";
    final tempFile = File(tempPath);
    await tempFile.writeAsString(content, flush: true);
    try {
      if (await targetFile.exists()) {
        if (Platform.isWindows) {
          final oldBackup = "${targetFile.path}.old_${DateTime.now().microsecondsSinceEpoch}";
          final oldFile = File(oldBackup);
          await targetFile.rename(oldBackup);
          await tempFile.rename(targetFile.path);
          if (await oldFile.exists()) await oldFile.delete();
        } else {
          await tempFile.rename(targetFile.path);
        }
      } else {
        await tempFile.rename(targetFile.path);
      }
    } catch (_) {
      await targetFile.writeAsString(content, flush: true);
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
    }
  }
}
