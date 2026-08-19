import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/utils/path_utils.dart';

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

      final content = await file.readAsString();
      if (content.trim().isEmpty) return [];

      return parseProfileContent(content);
    } catch (_) {
      return [];
    }
  }

  /// Parse YAML or JSON content to extract ClashProxiesNode items
  static List<ClashProxiesNode> parseProfileContent(String content) {
    dynamic doc;
    try {
      doc = loadYaml(content);
    } catch (_) {
      try {
        doc = jsonDecode(content);
      } catch (_) {
        return [];
      }
    }

    if (doc == null || doc is! Map) return [];

    final List<ClashProxiesNode> result = [];
    final List<String> allProxyNames = [];

    // 1. Parse 'proxies' (individual nodes)
    final rawProxies = doc['proxies'];
    if (rawProxies is List) {
      for (var item in rawProxies) {
        if (item is Map) {
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
      }
    }

    // 2. Parse 'proxy-groups' (groups)
    final rawGroups = doc['proxy-groups'];
    bool hasGroups = false;
    if (rawGroups is List && rawGroups.isNotEmpty) {
      for (var item in rawGroups) {
        if (item is Map) {
          final name = item['name']?.toString() ?? "";
          final type = item['type']?.toString() ?? "Selector";
          final icon = item['icon']?.toString() ?? "";
          final proxiesList = item['proxies'];
          List<String> allMembers = [];
          if (proxiesList is List) {
            allMembers = proxiesList.map((e) => e.toString()).toList();
          }

          if (name.isNotEmpty) {
            hasGroups = true;
            final group = ClashProxiesNode()
              ..name = name
              ..type = type
              ..icon = icon
              ..all = allMembers
              ..now = allMembers.isNotEmpty ? allMembers.first : ""
              ..delay = null;
            result.add(group);
          }
        }
      }
    }

    // 3. If no proxy-groups exist but we have proxies, auto-generate standard Clash groups
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
}
