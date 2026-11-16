// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/path_utils.dart';

class ChainProxyItem {
  String id;
  String name;
  String hop1; // Entry / 前置跳板
  String hop2; // Exit / 落地出口
  bool enabled;
  int? delay;

  ChainProxyItem({
    String? id,
    required this.name,
    required this.hop1,
    required this.hop2,
    this.enabled = true,
    this.delay,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'hop1': hop1,
    'hop2': hop2,
    'enabled': enabled,
    'delay': delay,
  };

  factory ChainProxyItem.fromJson(Map<String, dynamic> json) => ChainProxyItem(
    id: json['id']?.toString(),
    name: json['name']?.toString() ?? '',
    hop1: json['hop1']?.toString() ?? '',
    hop2: json['hop2']?.toString() ?? '',
    enabled: json['enabled'] ?? true,
    delay: json['delay'] is num ? (json['delay'] as num).toInt() : null,
  );

  ChainProxyItem clone() => ChainProxyItem(
    id: id,
    name: name,
    hop1: hop1,
    hop2: hop2,
    enabled: enabled,
    delay: delay,
  );
}

class ChainProxyManager {
  static const String _kFileName = "chain_proxies.json";
  static const String _kTagBegin = "# BEGIN WMIMO CHAIN PROXIES";
  static const String _kTagEnd = "# END WMIMO CHAIN PROXIES";

  static List<ChainProxyItem> _items = [];
  static bool _initialized = false;
  static final List<VoidCallback> onChainProxiesChanged = [];

  static List<ChainProxyItem> get items => List.unmodifiable(_items);

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await load();
  }

  static String _escapeYamlString(String input) {
    if (input.contains('"') || input.contains(':') || input.contains('#') || input.contains('[')) {
      return '"${input.replaceAll('\\', '\\\\').replaceAll('"', '\\"')}"';
    }
    return '"$input"';
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
    for (var cb in onChainProxiesChanged) {
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
    final item = _items.firstWhere((e) => e.id == id, orElse: () => ChainProxyItem(name: '', hop1: '', hop2: ''));
    if (item.id.isNotEmpty) {
      item.enabled = enabled;
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

  /// Injects active chain proxies into the target profile YAML file
  static Future<void> applyToProfile(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return;

      var content = await file.readAsString();
      if (content.trim().isEmpty) return;

      // 1. Remove any previous injected chain proxy block
      content = removeInjectedBlock(content);

      // 2. Filter enabled valid chain proxies
      final activeChains = _items.where((e) => e.enabled && e.hop1.isNotEmpty && e.hop2.isNotEmpty).toList();
      if (activeChains.isEmpty) {
        await _atomicWrite(file, content);
        return;
      }

      // 3. Build the Relay groups YAML block
      final StringBuffer sb = StringBuffer();
      sb.writeln(_kTagBegin);
      for (var chain in activeChains) {
        sb.writeln("  - name: ${_escapeYamlString(chain.name)}");
        sb.writeln("    type: relay");
        sb.writeln("    proxies:");
        sb.writeln("      - ${_escapeYamlString(chain.hop1)}");
        sb.writeln("      - ${_escapeYamlString(chain.hop2)}");
      }
      sb.writeln("$_kTagEnd\n");

      final blockStr = sb.toString();

      // 4. Locate proxy-groups: in content
      final pgRegExp = RegExp(r'''^(?:["']?proxy-groups["']?)\s*:\s*$''', multiLine: true);
      final match = pgRegExp.firstMatch(content);

      if (match != null) {
        // Insert right after 'proxy-groups:'
        final insertPos = match.end;
        content = "${content.substring(0, insertPos)}\n$blockStr${content.substring(insertPos)}";
      } else {
        // Append proxy-groups: with the block
        content = "${content.trimRight()}\n\nproxy-groups:\n$blockStr";
      }

      await _atomicWrite(file, content);
    } catch (e) {
      Log.w("ChainProxyManager.applyToProfile error: $e");
    }
  }

  /// Removes the WMIMO chain proxy block from a YAML string cleanly
  static String removeInjectedBlock(String content) {
    final pattern = RegExp(
      r'[ \t]*' + RegExp.escape(_kTagBegin) + r'[\s\S]*?' + RegExp.escape(_kTagEnd) + r'\n?',
      multiLine: true,
    );
    return content.replaceAll(pattern, '');
  }

  /// Applies chain proxies to current active profile and reloads Mihomo if active
  static Future<void> applyToCurrentAndReload() async {
    final current = ProfileManager.getCurrent();
    if (current == null) return;
    final dir = await PathUtils.profilesDir();
    final filePath = path.join(dir, current.id);
    await applyToProfile(filePath);

    final isVpnStarted = await VPNService.getStarted();
    if (isVpnStarted) {
      try {
        await VPNService.reload(const Duration(seconds: 3), smooth: true);
      } catch (e) {
        Log.w("ChainProxyManager.reload error: $e");
      }
    }
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
