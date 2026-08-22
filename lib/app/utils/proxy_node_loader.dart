import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/subscription_converter.dart';

class ProxyNodeLoader {
  /// Load proxies and proxy groups from the currently active profile
  static Future<List<ClashProxiesNode>> loadCurrentProfileNodes() async {
    final current = ProfileManager.getCurrent();
    if (current == null) return [];
    return loadNodesFromProfile(current.id);
  }

  /// Load proxies and proxy groups from a specific profile ID
  static Future<List<ClashProxiesNode>> loadNodesFromProfile(String profileId) async {
    if (profileId.isEmpty) return [];

    try {
      final profilesDir = await PathUtils.profilesDir();
      final filePath = path.join(profilesDir, profileId);
      final file = File(filePath);

      if (!await file.exists()) {
        return [];
      }

      // Ensure profile has proxy-groups written into the file
      await ensureProfileHasProxyGroups(filePath);

      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      return parseProfileContent(content);
    } catch (_) {
      return [];
    }
  }

  /// Checks if the YAML profile file contains proxy-groups, and if not, generates and appends them
  static Future<void> ensureProfileHasProxyGroups(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return;

      var content = await file.readAsString();
      if (content.trim().isEmpty) return;

      // Automatically convert Base64 subscription or node URIs into valid Clash YAML
      final convertedYaml = SubscriptionConverter.convertToClashYaml(content);
      if (convertedYaml != content && SubscriptionConverter.isClashYaml(convertedYaml)) {
        content = convertedYaml;
        await file.writeAsString(content, flush: true);
      }

      content = content.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

      final proxiesList = extractProxiesList(content);
      if (proxiesList.isEmpty) return;

      final List<String> allProxyNames = [];
      for (var item in proxiesList) {
        final name = item['name']?.toString() ?? "";
        if (name.isNotEmpty) {
          allProxyNames.add(name);
        }
      }

      if (allProxyNames.isEmpty) return;

      final existingGroupsList = extractProxyGroupsList(content);
      bool hasValidGroups = existingGroupsList.isNotEmpty;

      // Extract referenced target groups from 'rules:'
      final Set<String> ruleTargets = extractRuleTargets(content);

      final Set<String> existingGroupNames = {};
      if (hasValidGroups) {
        for (var g in existingGroupsList) {
          if (g['name'] != null) {
            existingGroupNames.add(g['name'].toString());
          }
        }
      }

      // If proxy-groups already exists in the profile, do NOT append a duplicate proxy-groups section
      if (hasValidGroups) {
        return;
      }

      // Region nodes classification
      final hkNodes = _filterNodes(allProxyNames, ["香港", "HK", "HONG KONG"]);
      final jpNodes = _filterNodes(allProxyNames, ["日本", "JP", "JAPAN", "东京", "大阪"]);
      final sgNodes = _filterNodes(allProxyNames, ["新加坡", "SG", "SINGAPORE", "狮城"]);
      final twNodes = _filterNodes(allProxyNames, ["台湾", "TW", "TAIWAN", "台北"]);
      final usNodes = _filterNodes(allProxyNames, ["美国", "US", "USA", "UNITED STATES"]);
      final krNodes = _filterNodes(allProxyNames, ["韩国", "KR", "KOREA", "首尔"]);
      final gbNodes = _filterNodes(allProxyNames, ["英国", "UK", "GB", "UNITED KINGDOM", "LONDON"]);
      final deNodes = _filterNodes(allProxyNames, ["德国", "DE", "GERMANY", "FRANKFURT"]);
      final frNodes = _filterNodes(allProxyNames, ["法国", "FR", "FRANCE", "PARIS"]);
      final caNodes = _filterNodes(allProxyNames, ["加拿大", "CA", "CANADA"]);
      final auNodes = _filterNodes(allProxyNames, ["澳大利亚", "澳洲", "AU", "AUSTRALIA", "SYDNEY"]);
      final thNodes = _filterNodes(allProxyNames, ["泰国", "TH", "THAILAND", "BANGKOK"]);
      final idNodes = _filterNodes(allProxyNames, ["印尼", "ID", "INDONESIA", "JAKARTA"]);
      final trNodes = _filterNodes(allProxyNames, ["土耳其", "TR", "TURKEY", "ISTANBUL"]);

      final List<Map<String, dynamic>> synthesizedGroups = [];

      // Synthesize primary selector & region groups
      final List<String> primaryGroupMembers = ["自动选择", "故障转移", ...allProxyNames, "DIRECT"];
      synthesizedGroups.add({
        'name': '节点选择',
        'type': 'select',
        'proxies': primaryGroupMembers,
      });

      synthesizedGroups.add({
        'name': '自动选择',
        'type': 'url-test',
        'url': 'http://www.gstatic.com/generate_204',
        'interval': 300,
        'tolerance': 50,
        'proxies': List<String>.from(allProxyNames),
      });

      synthesizedGroups.add({
        'name': '故障转移',
        'type': 'fallback',
        'url': 'http://www.gstatic.com/generate_204',
        'interval': 300,
        'proxies': List<String>.from(allProxyNames),
      });

      _addRegionGroup(synthesizedGroups, '🇭🇰 香港节点', hkNodes);
      _addRegionGroup(synthesizedGroups, '🇯🇵 日本节点', jpNodes);
      _addRegionGroup(synthesizedGroups, '🇸🇬 新加坡节点', sgNodes);
      _addRegionGroup(synthesizedGroups, '🇹🇼 台湾节点', twNodes);
      _addRegionGroup(synthesizedGroups, '🇺🇸 美国节点', usNodes);
      _addRegionGroup(synthesizedGroups, '🇰🇷 韩国节点', krNodes);
      _addRegionGroup(synthesizedGroups, '🇬🇧 英国节点', gbNodes);
      _addRegionGroup(synthesizedGroups, '🇩🇪 德国节点', deNodes);
      _addRegionGroup(synthesizedGroups, '🇫🇷 法国节点', frNodes);
      _addRegionGroup(synthesizedGroups, '🇨🇦 加拿大节点', caNodes);
      _addRegionGroup(synthesizedGroups, '🇦🇺 澳大利亚节点', auNodes);
      _addRegionGroup(synthesizedGroups, '🇹🇭 泰国节点', thNodes);
      _addRegionGroup(synthesizedGroups, '🇮🇩 印尼节点', idNodes);
      _addRegionGroup(synthesizedGroups, '🇹🇷 土耳其节点', trNodes);

      // Add rule-referenced target groups (e.g. YouTube, Netflix, Telegram, AI, etc.)
      for (var target in ruleTargets) {
        if (!synthesizedGroups.any((g) => g['name'] == target)) {
          synthesizedGroups.add({
            'name': target,
            'type': 'select',
            'proxies': ['节点选择', '自动选择', 'DIRECT', 'REJECT', ...allProxyNames],
          });
        }
      }

      // Ensure GLOBAL group exists
      if (!synthesizedGroups.any((g) => g['name'] == "GLOBAL")) {
        synthesizedGroups.add({
          'name': 'GLOBAL',
          'type': 'select',
          'proxies': ['节点选择', '自动选择', '故障转移', ...allProxyNames, 'DIRECT'],
        });
      }

      if (synthesizedGroups.isEmpty) return;

      // Append generated proxy-groups to the file
      final yamlWriter = YamlWriter();
      String groupsYaml = yamlWriter.write({'proxy-groups': synthesizedGroups});

      // Append cleanly
      String newContent = content.trimRight() + "\n\n" + groupsYaml + "\n";
      await file.writeAsString(newContent, flush: true);
    } catch (_) {}
  }

  static List<String> _filterNodes(List<String> allNodes, List<String> keywords) {
    return allNodes.where((n) {
      final u = n.toUpperCase();
      for (var kw in keywords) {
        if (n.contains(kw) || u.contains(kw.toUpperCase())) {
          return true;
        }
      }
      return false;
    }).toList();
  }

  static void _addRegionGroup(List<Map<String, dynamic>> groups, String name, List<String> nodes) {
    if (nodes.isNotEmpty) {
      groups.add({
        'name': name,
        'type': 'url-test',
        'url': 'http://www.gstatic.com/generate_204',
        'interval': 300,
        'proxies': nodes,
      });
    }
  }

  /// Extract proxies section as a List of Maps safely
  static List<Map<String, dynamic>> extractProxiesList(String content) {
    try {
      final parsed = loadYaml(content);
      if (parsed is Map && parsed['proxies'] is List) {
        return (parsed['proxies'] as List)
            .whereType<Map>()
            .map((m) => Map<String, dynamic>.from(m))
            .toList();
      }
    } catch (_) {}

    final block = extractBlock(content, 'proxies');
    if (block.isNotEmpty) {
      try {
        final parsed = loadYaml('proxies:\n$block');
        if (parsed is Map && parsed['proxies'] is List) {
          return (parsed['proxies'] as List)
              .whereType<Map>()
              .map((m) => Map<String, dynamic>.from(m))
              .toList();
        }
      } catch (_) {}
    }

    // Direct node URIs extraction
    final nodes = SubscriptionConverter.parseAllNodes(content);
    if (nodes.isNotEmpty) return nodes;

    // Base64 decoded node URIs extraction
    final decoded = SubscriptionConverter.safeBase64Decode(content);
    if (decoded != null && decoded.isNotEmpty) {
      final decodedNodes = SubscriptionConverter.parseAllNodes(decoded);
      if (decodedNodes.isNotEmpty) return decodedNodes;
    }

    return [];
  }

  /// Extract proxy-groups section as a List of Maps safely
  static List<Map<String, dynamic>> extractProxyGroupsList(String content) {
    try {
      final parsed = loadYaml(content);
      if (parsed is Map && parsed['proxy-groups'] is List) {
        return (parsed['proxy-groups'] as List)
            .whereType<Map>()
            .map((m) => Map<String, dynamic>.from(m))
            .toList();
      }
    } catch (_) {}

    final block = extractBlock(content, 'proxy-groups');
    if (block.isEmpty) return [];

    try {
      final parsed = loadYaml('proxy-groups:\n$block');
      if (parsed is Map && parsed['proxy-groups'] is List) {
        return (parsed['proxy-groups'] as List)
            .whereType<Map>()
            .map((m) => Map<String, dynamic>.from(m))
            .toList();
      }
    } catch (_) {}

    return [];
  }

  /// Extract a named top-level section block from YAML string
  static String extractBlock(String content, String sectionName) {
    final lines = content.split('\n');
    bool inSection = false;
    final blockLines = <String>[];
    final sectionHeader = RegExp('^\\s*$sectionName\\s*:', caseSensitive: false);
    final topLevelHeader = RegExp('^[a-zA-Z0-9_-]+\\s*:');

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) {
        if (inSection) blockLines.add(line);
        continue;
      }

      if (!inSection) {
        if (sectionHeader.hasMatch(line) && !line.startsWith(' ') && !line.startsWith('\t')) {
          inSection = true;
        }
      } else {
        // A new section only begins if the line is unindented and matches top-level key
        if (!line.startsWith(' ') && !line.startsWith('\t') && !line.startsWith('-')) {
          if (topLevelHeader.hasMatch(line) && !sectionHeader.hasMatch(line)) {
            break;
          }
        }
        blockLines.add(line);
      }
    }
    return blockLines.join('\n');
  }

  /// Extract all target proxy group names from 'rules:' section
  static Set<String> extractRuleTargets(String content) {
    final targets = <String>{};
    final lines = content.split('\n');
    bool inRules = false;
    final ruleHeader = RegExp('^\\s*rules\\s*:', caseSensitive: false);
    final topLevelHeader = RegExp('^[a-zA-Z0-9_-]+\\s*:');

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

      if (!inRules) {
        if (ruleHeader.hasMatch(line) && !line.startsWith(' ') && !line.startsWith('\t')) {
          inRules = true;
        }
      } else {
        if (!line.startsWith(' ') && !line.startsWith('\t') && !line.startsWith('-')) {
          if (topLevelHeader.hasMatch(line) && !ruleHeader.hasMatch(line)) {
            break;
          }
        }
        if (trimmed.startsWith('-')) {
          var ruleBody = trimmed.substring(1).trim();
          if ((ruleBody.startsWith("'") && ruleBody.endsWith("'")) ||
              (ruleBody.startsWith('"') && ruleBody.endsWith('"'))) {
            ruleBody = ruleBody.substring(1, ruleBody.length - 1);
          }
          final parts = ruleBody.split(',');
          if (parts.length >= 2) {
            var target = parts[parts.length - 1].trim();
            if (target.toUpperCase() == "NO-RESOLVE" && parts.length >= 3) {
              target = parts[parts.length - 2].trim();
            }
            final upper = target.toUpperCase();
            if (upper != "DIRECT" &&
                upper != "REJECT" &&
                upper != "REJECT-DROP" &&
                upper != "PASS" &&
                !target.contains("🎯Direct")) {
              targets.add(target);
            }
          }
        }
      }
    }
    return targets;
  }

  /// Parse YAML or JSON content to extract ClashProxiesNode items
  static List<ClashProxiesNode> parseProfileContent(String rawContent) {
    var content = SubscriptionConverter.convertToClashYaml(rawContent);
    content = content.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
    final List<ClashProxiesNode> result = [];
    final List<String> allProxyNames = [];

    // 1. Parse 'proxies' (individual nodes)
    final proxiesList = extractProxiesList(content);
    for (var item in proxiesList) {
      final name = item['name']?.toString() ?? "";
      final type = item['type']?.toString() ?? "Shadowsocks";
      if (name.isNotEmpty) {
        allProxyNames.add(name);
        final node = ClashProxiesNode()
          ..name = name
          ..type = type
          ..delay = null;
        result.add(node);
      }
    }

    // 2. Parse 'proxy-groups' (groups)
    final groupsList = extractProxyGroupsList(content);
    bool hasGroups = groupsList.isNotEmpty;
    for (var item in groupsList) {
      final name = item['name']?.toString() ?? "";
      final rawType = item['type']?.toString() ?? "Selector";
      final icon = item['icon']?.toString() ?? "";
      final proxies = item['proxies'];
      List<String> allMembers = [];
      if (proxies is List) {
        allMembers = proxies.map((e) => e.toString()).toList();
      }

      String normalizedType = rawType;
      final lowerType = rawType.toLowerCase().replaceAll('-', '').replaceAll('_', '');
      if (lowerType == "select" || lowerType == "selector") {
        normalizedType = "Selector";
      } else if (lowerType == "urltest") {
        normalizedType = "URLTest";
      } else if (lowerType == "loadbalance") {
        normalizedType = "LoadBalance";
      } else if (lowerType == "fallback") {
        normalizedType = "Fallback";
      } else if (lowerType == "relay") {
        normalizedType = "Relay";
      }

      if (name.isNotEmpty) {
        final group = ClashProxiesNode()
          ..name = name
          ..type = normalizedType
          ..icon = icon
          ..all = allMembers
          ..now = allMembers.isNotEmpty ? allMembers.first : ""
          ..delay = null;
        result.add(group);
      }
    }

    // 3. Fallback: If no groups in raw content, synthesize standard groups
    if (!hasGroups && allProxyNames.isNotEmpty) {
      final selectGroup = ClashProxiesNode()
        ..name = "节点选择"
        ..type = "Selector"
        ..all = [...allProxyNames, "DIRECT"]
        ..now = allProxyNames.first
        ..delay = null;

      final autoGroup = ClashProxiesNode()
        ..name = "自动选择"
        ..type = "URLTest"
        ..all = List.from(allProxyNames)
        ..now = allProxyNames.first
        ..delay = null;

      final fallbackGroup = ClashProxiesNode()
        ..name = "故障转移"
        ..type = "Fallback"
        ..all = List.from(allProxyNames)
        ..now = allProxyNames.first
        ..delay = null;

      final globalGroup = ClashProxiesNode()
        ..name = "GLOBAL"
        ..type = "Selector"
        ..all = ["节点选择", "自动选择", "故障转移", ...allProxyNames, "DIRECT"]
        ..now = "节点选择"
        ..delay = null;

      result.insertAll(0, [selectGroup, autoGroup, fallbackGroup, globalGroup]);
    }

    // 4. Ensure DIRECT and REJECT node stubs exist
    if (!result.any((n) => n.name == "DIRECT")) {
      result.add(ClashProxiesNode()..name = "DIRECT"..type = "Direct");
    }
    if (!result.any((n) => n.name == "REJECT")) {
      result.add(ClashProxiesNode()..name = "REJECT"..type = "Reject");
    }

    return result;
  }

  static Future<List<Map<String, dynamic>>> loadCurrentProfileRules() async {
    try {
      final currentProfile = ProfileManager.getCurrent();
      if (currentProfile == null) return [];
      final profilesDir = await PathUtils.profilesDir();
      final filePath = path.join(profilesDir, currentProfile.id);
      final file = File(filePath);
      if (!await file.exists()) return [];
      final content = await file.readAsString();

      final block = extractBlock(content, 'rules');
      if (block.isEmpty) return [];

      final lines = block.split('\n');
      final List<Map<String, dynamic>> rulesList = [];
      for (var line in lines) {
        var trimmed = line.trim();
        if (trimmed.startsWith('-')) {
          trimmed = trimmed.substring(1).trim();
        }
        if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
        final parts = trimmed.split(',');
        if (parts.length >= 3) {
          rulesList.add({
            'type': parts[0].trim(),
            'payload': parts[1].trim(),
            'proxy': parts[2].trim(),
          });
        } else if (parts.length == 2) {
          rulesList.add({
            'type': parts[0].trim(),
            'payload': '',
            'proxy': parts[1].trim(),
          });
        }
      }
      return rulesList;
    } catch (_) {
      return [];
    }
  }
}
