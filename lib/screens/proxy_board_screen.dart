// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libclash_vpn_service/state.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/biz.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/node_region_helper.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/add_profile_by_url_screen.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';

class ProxyBoardScreen extends StatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "ProxyBoardScreen");
  }

  const ProxyBoardScreen({super.key});

  @override
  State<ProxyBoardScreen> createState() => _ProxyBoardScreenState();
}

class _ProxyBoardScreenState extends State<ProxyBoardScreen>
    with WidgetsBindingObserver, AfterLayoutMixin {
  final TextEditingController _searchController = TextEditingController();
  List<ClashProxiesNode> _allNodes = [];
  bool _loading = false;
  bool _isVpnStarted = false;
  String _searchKeyword = "";
  String _sortMode = "default"; // "default", "delay_asc", "name_asc", "region"
  bool _hideTimeoutNodes = false;
  String _selectedRegionCode = "ALL";
  LatencyTestTarget _activeLatencyTarget = LatencyTestTarget.defaultTarget;
  String _currentMode = "rule"; // rule, global, direct
  final Set<String> _nodesTesting = {};
  final Map<String, bool> _groupExpanded = {};

  @override
  void initState() {
    super.initState();
    _currentMode = ClashSettingManager.getConfigsMode().name.toLowerCase();
    if (_currentMode.isEmpty) _currentMode = "rule";

    _searchController.addListener(() {
      setState(() {
        _searchKeyword = _searchController.text.trim().toLowerCase();
      });
    });

    VPNService.onEventStateChanged.add(_onVpnStateChanged);
    ProfileManager.onEventCurrentChanged.add(_onProfileChanged);
    ProfileManager.onEventAdd.add(_onProfileChanged);
    ProfileManager.onEventUpdate.add(_onProfileUpdate);
    ProfileManager.onEventRemove.add(_onProfileChanged);
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    _isVpnStarted = await VPNService.getStarted();
    setState(() {});
    await _fetchProxies();
    await _fetchMode();
  }

  @override
  void dispose() {
    VPNService.onEventStateChanged.remove(_onVpnStateChanged);
    ProfileManager.onEventCurrentChanged.remove(_onProfileChanged);
    ProfileManager.onEventAdd.remove(_onProfileChanged);
    ProfileManager.onEventUpdate.remove(_onProfileUpdate);
    ProfileManager.onEventRemove.remove(_onProfileChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onProfileUpdate(String id, bool finish) async {
    if (finish && mounted) {
      await Future.delayed(const Duration(milliseconds: 200));
      await _fetchProxies();
    }
  }

  Future<void> _onVpnStateChanged(
    FlutterVpnServiceState state,
    Map<String, String> params,
  ) async {
    if (!mounted) return;
    _isVpnStarted = state == FlutterVpnServiceState.connected;
    await Future.delayed(const Duration(milliseconds: 300));
    await _fetchProxies();
  }

  Future<void> _onProfileChanged(String id) async {
    if (mounted) {
      await Future.delayed(const Duration(milliseconds: 200));
      await _fetchProxies();
    }
  }

  Future<void> _fetchMode() async {
    final res = await ClashHttpApi.getConfigs();
    if (res.data != null && res.data!.mode.isNotEmpty && mounted) {
      setState(() {
        _currentMode = res.data!.mode.toLowerCase();
      });
    }
  }

  static bool isRealLeafProxy(ClashProxiesNode n) {
    if (ClashProtocolType.isGroupType(n.type)) return false;
    final lowerType = n.type.toLowerCase().replaceAll('-', '').replaceAll('_', '').trim();
    if (lowerType == "direct" ||
        lowerType == "reject" ||
        lowerType == "rejectdrop" ||
        lowerType == "pass" ||
        lowerType == "passrule" ||
        lowerType == "compatible" ||
        lowerType == "dns") {
      return false;
    }
    final upperName = n.name.toUpperCase().trim();
    if (upperName == "DIRECT" ||
        upperName == "REJECT" ||
        upperName == "REJECT-DROP" ||
        upperName == "PASS" ||
        upperName == "PASS-RULE" ||
        upperName == "COMPATIBLE" ||
        upperName == "GLOBAL" ||
        upperName == "PROXY" ||
        upperName.startsWith("🎯")) {
      return false;
    }
    return true;
  }

  Future<void> _fetchProxies() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    // Keep existing delays so they don't get wiped upon fetching
    final existingDelays = <String, int?>{
      for (var n in _allNodes)
        if (n.delay != null) n.name: n.delay,
    };

    final started = await VPNService.getStarted();
    _isVpnStarted = started;

    if (started) {
      final result = await ClashHttpApi.getProxies();
      if (result.data != null && result.data!.isNotEmpty) {
        final groups = result.data!.where((n) {
          return ClashProtocolType.isGroupType(n.type);
        }).toList();

        // Check for actual leaf proxy nodes (excluding internal dummy stubs)
        final leafProxies = result.data!.where((n) => isRealLeafProxy(n)).toList();

        if (groups.isNotEmpty && leafProxies.isNotEmpty) {
          for (var n in result.data!) {
            if (n.delay == null && existingDelays.containsKey(n.name)) {
              n.delay = existingDelays[n.name];
            }
          }
          if (mounted) {
            setState(() {
              _allNodes = result.data!;
              _loading = false;
            });
          }
          return;
        }
      }
    }

    // Offline / Local profile fallback: load directly from active profile YAML/JSON
    final offlineNodes = await ProxyNodeLoader.loadCurrentProfileNodes();
    for (var n in offlineNodes) {
      if (n.delay == null && existingDelays.containsKey(n.name)) {
        n.delay = existingDelays[n.name];
      }
    }
    if (!mounted) return;

    setState(() {
      _allNodes = offlineNodes;
      _loading = false;
    });
  }

  Future<void> _changeMode(String mode) async {
    setState(() {
      _currentMode = mode;
    });
    ClashConfigsMode type = ClashConfigsMode.rule;
    if (mode == "global") type = ClashConfigsMode.global;
    if (mode == "direct") type = ClashConfigsMode.direct;
    await ClashSettingManager.setConfigsMode(type);
    await _fetchProxies();
  }

  Future<void> _selectNode(ClashProxiesNode group, ClashProxiesNode node) async {
    final lowerType = group.type.toLowerCase().replaceAll('-', '').replaceAll('_', '');
    final isSelector = lowerType == "selector" || lowerType == "select";

    if (!isSelector) {
      if (mounted) {
        final tcontext = Translations.of(context);
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              tcontext.meta.autoGroupTip(group: group.name, type: group.type),
            ),
            duration: const Duration(seconds: 3),
          ),
        );
      }
      return;
    }

    setState(() {
      group.now = node.name;
    });

    Biz.proxySelected(node.name);

    if (_isVpnStarted) {
      ClashHttpApi.setProxiesNode(group.name, node.name).then((err) {
        if (err != null) {
          ClashHttpApi.setProxiesNode("GLOBAL", node.name).then((err2) {
            if (err2 != null) {
              ClashHttpApi.setProxiesNode("Proxy", node.name);
            }
          });
        }
      }).catchError((_) {});

      if (group.name != "GLOBAL") {
        ClashHttpApi.setProxiesNode("GLOBAL", node.name).catchError((_) => null);
      }
    }

    if (mounted) {
      final tcontext = Translations.of(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tcontext.meta.nodeSelected(p: node.name)),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _testNodeDelay(ClashProxiesNode node) async {
    if (!_isVpnStarted) {
      final tcontext = Translations.of(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tcontext.meta.startingCoreAndTesting),
          duration: const Duration(seconds: 2),
        ),
      );
      VpnActionHandler.vpnConnect?.call("proxy_test", false);
      for (int i = 0; i < 15; i++) {
        await Future.delayed(const Duration(milliseconds: 300));
        final started = await VPNService.getStarted();
        if (started) {
          _isVpnStarted = true;
          break;
        }
      }
      if (!_isVpnStarted) return;
      await _fetchProxies();
    }

    if (_nodesTesting.contains(node.name)) return;
    setState(() {
      _nodesTesting.add(node.name);
    });
    final setting = SettingManager.getConfig();
    final testUrl = _activeLatencyTarget.url.isNotEmpty
        ? _activeLatencyTarget.url
        : setting.delayTestUrl;

    try {
      final res = await ClashHttpApi.getDelay(
        node.name,
        url: testUrl,
        timeout: Duration(milliseconds: setting.delayTestTimeout),
      );
      final testDelay = (res.data != null && res.data! > 0) ? res.data : -1;
      if (mounted) {
        setState(() {
          for (var n in _allNodes) {
            if (n.name == node.name) {
              n.delay = testDelay;
            }
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          for (var n in _allNodes) {
            if (n.name == node.name) {
              n.delay = -1;
            }
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _nodesTesting.remove(node.name);
        });
      }
    }
  }

  Future<void> _testGroupDelay(ClashProxiesNode group) async {
    if (!_isVpnStarted) {
      final tcontext = Translations.of(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tcontext.meta.startingCoreAndTesting),
          duration: const Duration(seconds: 2),
        ),
      );
      VpnActionHandler.vpnConnect?.call("proxy_test", false);
      for (int i = 0; i < 15; i++) {
        await Future.delayed(const Duration(milliseconds: 300));
        final started = await VPNService.getStarted();
        if (started) {
          _isVpnStarted = true;
          break;
        }
      }
      if (!_isVpnStarted) return;
      await _fetchProxies();
    }

    final nodeMap = {for (var n in _allNodes) n.name: n};
    final nodesToTest = <String>[];
    for (var name in group.all) {
      final n = nodeMap[name];
      if (n != null) {
        if (!ClashProtocolType.isGroupType(n.type)) {
          if (!nodesToTest.contains(n.name)) {
            nodesToTest.add(n.name);
          }
        } else {
          for (var subName in n.all) {
            final subNode = nodeMap[subName];
            if (subNode != null &&
                !ClashProtocolType.isGroupType(subNode.type) &&
                !nodesToTest.contains(subName)) {
              nodesToTest.add(subName);
            }
          }
        }
      }
    }

    if (nodesToTest.isEmpty) return;

    for (var name in nodesToTest) {
      _nodesTesting.add(name);
    }
    setState(() {});

    final setting = SettingManager.getConfig();
    final testUrl = _activeLatencyTarget.url.isNotEmpty
        ? _activeLatencyTarget.url
        : setting.delayTestUrl;

    Timer? updateDebounce;
    void scheduleUiUpdate() {
      if (updateDebounce?.isActive == true) return;
      updateDebounce = Timer(const Duration(milliseconds: 150), () {
        if (mounted) setState(() {});
      });
    }

    int nextIndex = 0;
    Future<void> worker() async {
      while (true) {
        if (nextIndex >= nodesToTest.length) break;
        final nodeName = nodesToTest[nextIndex++];
        try {
          final res = await ClashHttpApi.getDelay(
            nodeName,
            url: testUrl,
            timeout: Duration(milliseconds: setting.delayTestTimeout),
          );
          final testDelay = (res.data != null && res.data! > 0) ? res.data : -1;
          for (var n in _allNodes) {
            if (n.name == nodeName) {
              n.delay = testDelay;
            }
          }
        } catch (_) {
          for (var n in _allNodes) {
            if (n.name == nodeName) {
              n.delay = -1;
            }
          }
        } finally {
          _nodesTesting.remove(nodeName);
          scheduleUiUpdate();
        }
      }
    }

    final workerCount = nodesToTest.length < 8 ? nodesToTest.length : 8;
    final workers = List.generate(workerCount, (_) => worker());
    await Future.wait(workers);

    updateDebounce?.cancel();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _testAllDelay() async {
    if (!_isVpnStarted) {
      final tcontext = Translations.of(context);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tcontext.meta.startingCoreAndTesting),
          duration: const Duration(seconds: 2),
        ),
      );
      VpnActionHandler.vpnConnect?.call("proxy_test", false);
      for (int i = 0; i < 15; i++) {
        await Future.delayed(const Duration(milliseconds: 300));
        final started = await VPNService.getStarted();
        if (started) {
          _isVpnStarted = true;
          break;
        }
      }
      if (!_isVpnStarted) return;
      await _fetchProxies();
    }

    final groups = _getProxyGroups();
    final Set<String> testedNames = {};
    final List<String> allLeafNodeNames = [];

    for (var g in groups) {
      final nodes = _getNodesForGroup(g);
      for (var n in nodes) {
        if (isRealLeafProxy(n) && !testedNames.contains(n.name)) {
          testedNames.add(n.name);
          allLeafNodeNames.add(n.name);
        }
      }
    }

    for (var n in _allNodes) {
      if (isRealLeafProxy(n) && !testedNames.contains(n.name)) {
        testedNames.add(n.name);
        allLeafNodeNames.add(n.name);
      }
    }

    if (allLeafNodeNames.isEmpty) return;

    for (var name in allLeafNodeNames) {
      _nodesTesting.add(name);
    }
    setState(() {});

    final setting = SettingManager.getConfig();
    final testUrl = _activeLatencyTarget.url.isNotEmpty
        ? _activeLatencyTarget.url
        : setting.delayTestUrl;

    Timer? updateDebounce;
    void scheduleUiUpdate() {
      if (updateDebounce?.isActive == true) return;
      updateDebounce = Timer(const Duration(milliseconds: 150), () {
        if (mounted) setState(() {});
      });
    }

    int nextIndex = 0;
    Future<void> worker() async {
      while (true) {
        if (nextIndex >= allLeafNodeNames.length) break;
        final nodeName = allLeafNodeNames[nextIndex++];
        try {
          final res = await ClashHttpApi.getDelay(
            nodeName,
            url: testUrl,
            timeout: Duration(milliseconds: setting.delayTestTimeout),
          );
          final testDelay = (res.data != null && res.data! > 0) ? res.data : -1;
          for (var n in _allNodes) {
            if (n.name == nodeName) {
              n.delay = testDelay;
            }
          }
        } catch (_) {
          for (var n in _allNodes) {
            if (n.name == nodeName) {
              n.delay = -1;
            }
          }
        } finally {
          _nodesTesting.remove(nodeName);
          scheduleUiUpdate();
        }
      }
    }

    final workerCount = allLeafNodeNames.length < 8 ? allLeafNodeNames.length : 8;
    final workers = List.generate(workerCount, (_) => worker());
    await Future.wait(workers);

    updateDebounce?.cancel();
    if (mounted) {
      setState(() {});
    }
  }

  List<ClashProxiesNode> _getProxyGroups() {
    List<ClashProxiesNode> groups = _allNodes.where((n) {
      return ClashProtocolType.isGroupType(n.type) && !n.hidden;
    }).toList();

    final leafNodes = _allNodes.where((n) => isRealLeafProxy(n)).toList();

    // Check if existing groups contain actual leaf nodes
    bool hasLeafNodesInGroups = false;
    for (var g in groups) {
      if (g.name.toUpperCase() != "GLOBAL" &&
          g.all.any((name) => leafNodes.any((l) => l.name == name))) {
        hasLeafNodesInGroups = true;
        break;
      }
    }

    if (!hasLeafNodesInGroups && leafNodes.isNotEmpty) {
      final List<ClashProxiesNode> synthesizedGroups = [];

      // 1. 节点选择
      synthesizedGroups.add(
        ClashProxiesNode()
          ..name = "节点选择"
          ..type = "Selector"
          ..all = leafNodes.map((n) => n.name).toList()
          ..now = leafNodes.first.name,
      );

      // 2. 自动选择
      synthesizedGroups.add(
        ClashProxiesNode()
          ..name = "自动选择"
          ..type = "URLTest"
          ..all = leafNodes.map((n) => n.name).toList()
          ..now = leafNodes.first.name,
      );

      // 3. Regional groups (using NodeRegionHelper)
      final regions = <String, List<String>>{
        "🇭🇰 香港节点": [],
        "🇯🇵 日本节点": [],
        "🇸🇬 新加坡节点": [],
        "🇹🇼 台湾节点": [],
        "🇺🇸 美国节点": [],
        "🇰🇷 韩国节点": [],
      };

      for (var node in leafNodes) {
        final reg = NodeRegionHelper.getRegion(node.name);
        if (reg.code == "HK") {
          regions["🇭🇰 香港节点"]!.add(node.name);
        } else if (reg.code == "JP") {
          regions["🇯🇵 日本节点"]!.add(node.name);
        } else if (reg.code == "SG") {
          regions["🇸🇬 新加坡节点"]!.add(node.name);
        } else if (reg.code == "TW") {
          regions["🇹🇼 台湾节点"]!.add(node.name);
        } else if (reg.code == "US") {
          regions["🇺🇸 美国节点"]!.add(node.name);
        } else if (reg.code == "KR") {
          regions["🇰🇷 韩国节点"]!.add(node.name);
        }
      }

      regions.forEach((regionName, nodeNames) {
        if (nodeNames.isNotEmpty) {
          synthesizedGroups.add(
            ClashProxiesNode()
              ..name = regionName
              ..type = "Selector"
              ..all = nodeNames
              ..now = nodeNames.first,
          );
        }
      });

      final otherGroups = groups
          .where((g) => g.name != "Proxy" && g.name.toUpperCase() != "GLOBAL")
          .toList();
      groups = [...synthesizedGroups, ...otherGroups];
    }

    if (_currentMode == "global") {
      groups.sort((a, b) {
        if (a.name.toUpperCase() == "GLOBAL") return -1;
        if (b.name.toUpperCase() == "GLOBAL") return 1;
        return 0;
      });
    } else {
      groups.sort((a, b) {
        if (a.name.toUpperCase() == "GLOBAL") return 1;
        if (b.name.toUpperCase() == "GLOBAL") return -1;
        return 0;
      });
    }
    return groups;
  }

  bool _isGroupExpandedByDefault(ClashProxiesNode group, int index) {
    if (_groupExpanded.containsKey(group.name)) {
      return _groupExpanded[group.name]!;
    }
    // Default to true (expanded) so all nodes under all proxy groups are immediately visible
    return true;
  }

  List<ClashProxiesNode> _getNodesForGroup(ClashProxiesNode group) {
    final nodeMap = {for (var n in _allNodes) n.name: n};
    List<ClashProxiesNode> list = group.all
        .map((name) => nodeMap[name] ?? (ClashProxiesNode()..name = name))
        .where((n) {
          if (group.name.toUpperCase() == "GLOBAL") return true;
          return isRealLeafProxy(n) || ClashProtocolType.isGroupType(n.type);
        })
        .toList();

    // 1. Region filter
    if (_selectedRegionCode != "ALL") {
      list = list.where((n) {
        if (ClashProtocolType.isGroupType(n.type)) return true;
        final region = NodeRegionHelper.getRegion(n.name);
        return region.code == _selectedRegionCode;
      }).toList();
    }

    // 2. Hide timeout nodes filter
    if (_hideTimeoutNodes) {
      list = list.where((n) {
        if (ClashProtocolType.isGroupType(n.type)) return true;
        return n.delay == null || n.delay! >= 0;
      }).toList();
    }

    // 3. Search keyword filter
    if (_searchKeyword.isNotEmpty) {
      list = list.where((n) {
        final region = NodeRegionHelper.getRegion(n.name);
        return n.name.toLowerCase().contains(_searchKeyword) ||
            region.name.toLowerCase().contains(_searchKeyword) ||
            region.code.toLowerCase().contains(_searchKeyword) ||
            n.type.toLowerCase().contains(_searchKeyword);
      }).toList();
    }

    // 4. Sorting
    if (_sortMode == "delay_asc") {
      list.sort((a, b) {
        final aDelay = a.delay ?? 999999;
        final bDelay = b.delay ?? 999999;
        final aScore = aDelay < 0 ? 9999999 : (aDelay == 0 ? 999999 : aDelay);
        final bScore = bDelay < 0 ? 9999999 : (bDelay == 0 ? 999999 : bDelay);
        final cmp = aScore.compareTo(bScore);
        if (cmp != 0) return cmp;
        return a.name.compareTo(b.name);
      });
    } else if (_sortMode == "name_asc") {
      list.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortMode == "region") {
      list.sort((a, b) {
        final regA = NodeRegionHelper.getRegion(a.name).name;
        final regB = NodeRegionHelper.getRegion(b.name).name;
        final cmp = regA.compareTo(regB);
        if (cmp != 0) return cmp;
        return a.name.compareTo(b.name);
      });
    }

    return list;
  }

  static String getFlagEmoji(String name) => NodeRegionHelper.getFlag(name);

  void _showSortFilterBottomSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF151D2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Header
                    Row(
                      children: [
                        const Icon(Icons.tune_rounded, size: 20, color: ThemeDefine.kColorBlue),
                        const SizedBox(width: 8),
                        const Text(
                          "节点排序与过滤",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _sortMode = "default";
                              _hideTimeoutNodes = false;
                              _selectedRegionCode = "ALL";
                            });
                            setSheetState(() {});
                            Navigator.pop(context);
                          },
                          child: const Text("重置", style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                    const Divider(height: 16),

                    // Sort section
                    const Text(
                      "排序方式",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildSortOptionChip(
                          title: "默认排序",
                          icon: Icons.list_rounded,
                          mode: "default",
                          setSheetState: setSheetState,
                        ),
                        _buildSortOptionChip(
                          title: "延迟最低",
                          icon: Icons.bolt_rounded,
                          mode: "delay_asc",
                          setSheetState: setSheetState,
                        ),
                        _buildSortOptionChip(
                          title: "名称 A-Z",
                          icon: Icons.sort_by_alpha_rounded,
                          mode: "name_asc",
                          setSheetState: setSheetState,
                        ),
                        _buildSortOptionChip(
                          title: "国家地区",
                          icon: Icons.public_rounded,
                          mode: "region",
                          setSheetState: setSheetState,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Filter section
                    const Text(
                      "过滤选项",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: SwitchListTile(
                        title: const Text(
                          "隐藏超时与不可用节点",
                          style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w500),
                        ),
                        subtitle: const Text(
                          "自动过滤测速失败或连接超时的节点",
                          style: TextStyle(fontSize: 11.5, color: Colors.grey),
                        ),
                        value: _hideTimeoutNodes,
                        activeThumbColor: ThemeDefine.kColorBlue,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        onChanged: (val) {
                          setState(() {
                            _hideTimeoutNodes = val;
                          });
                          setSheetState(() {});
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Target Selector Shortcut
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.pop(context);
                        _showLatencyTargetBottomSheet();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.radar_rounded, size: 18, color: ThemeDefine.kColorBlue),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "当前测速目标场景",
                                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    "${_activeLatencyTarget.icon} ${_activeLatencyTarget.name} • ${_activeLatencyTarget.url}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortOptionChip({
    required String title,
    required IconData icon,
    required String mode,
    required StateSetter setSheetState,
  }) {
    final isSelected = _sortMode == mode;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        setState(() {
          _sortMode = mode;
        });
        setSheetState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeDefine.kColorBlue
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? ThemeDefine.kColorBlue : theme.dividerColor.withValues(alpha: 0.3),
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLatencyTargetBottomSheet() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final presets = LatencyTestTarget.presets;
    final customController = TextEditingController(
      text: _activeLatencyTarget.id == "custom" ? _activeLatencyTarget.url : "",
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF151D2E) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  20,
                  12,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Handle bar
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Header
                    Row(
                      children: [
                        const Icon(Icons.radar_rounded, size: 20, color: ThemeDefine.kColorBlue),
                        const SizedBox(width: 8),
                        const Text(
                          "测速目标场景切换",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "选择不同服务测试节点的真实可用性与连通延迟",
                      style: TextStyle(
                        fontSize: 11.5,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                    const Divider(height: 16),

                    // Preset target list
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: presets.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (context, idx) {
                          final target = presets[idx];
                          final isSelected = _activeLatencyTarget.id == target.id;

                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              setState(() {
                                _activeLatencyTarget = target;
                              });
                              setSheetState(() {});
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("已切换测速目标场景: ${target.name}"),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ThemeDefine.kColorBlue.withValues(alpha: 0.12)
                                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? ThemeDefine.kColorBlue
                                      : theme.dividerColor.withValues(alpha: 0.25),
                                  width: isSelected ? 1.2 : 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? ThemeDefine.kColorBlue
                                          : theme.colorScheme.onSurface.withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: Text(
                                        target.icon,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          target.name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                            color: isSelected ? ThemeDefine.kColorBlue : null,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          target.url,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Custom URL input
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _activeLatencyTarget.id == "custom"
                              ? ThemeDefine.kColorBlue
                              : theme.dividerColor.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.link_rounded, size: 18, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: customController,
                              decoration: const InputDecoration(
                                hintText: "自定义测速 URL (例如 http://...)",
                                hintStyle: TextStyle(fontSize: 12),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ThemeDefine.kColorBlue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                            ),
                            onPressed: () {
                              final text = customController.text.trim();
                              if (text.isNotEmpty && text.contains("://")) {
                                setState(() {
                                  _activeLatencyTarget = LatencyTestTarget(
                                    id: "custom",
                                    name: "自定义目标",
                                    nameEn: "Custom Target",
                                    icon: "🌐",
                                    url: text,
                                  );
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: const Text("使用", style: TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showNodeDetailDialog(ClashProxiesNode group, ClashProxiesNode node) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final region = NodeRegionHelper.getRegion(node.name);

    String delayInfo = "未测速";
    Color delayColor = Colors.grey;
    if (node.delay != null) {
      if (node.delay! < 0) {
        delayInfo = "超时 / 无法连接";
        delayColor = Colors.redAccent;
      } else if (node.delay! > 0) {
        delayInfo = "${node.delay} ms";
        if (node.delay! < 300) {
          delayColor = ThemeDefine.kColorGreenBright;
        } else if (node.delay! < 800) {
          delayColor = Colors.lightGreen;
        } else if (node.delay! < 1200) {
          delayColor = Colors.amber;
        } else {
          delayColor = Colors.orange;
        }
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF151D2E) : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          actionsPadding: const EdgeInsets.fromLTRB(14, 8, 14, 14),
          title: Row(
            children: [
              Text(region.flag, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  node.name,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(height: 12),
              _buildDetailRow("识别地区", "${region.flag} ${region.name} (${region.code})"),
              _buildDetailRow("节点协议", node.type.isEmpty ? "Unknown" : node.type.toUpperCase()),
              _buildDetailRow("当前延迟", delayInfo, valueColor: delayColor, isBold: true),
              _buildDetailRow("测速场景", "${_activeLatencyTarget.icon} ${_activeLatencyTarget.name}"),
              _buildDetailRow("所属分组", group.name),
              const Divider(height: 16),
            ],
          ),
          actions: [
            TextButton.icon(
              icon: const Icon(Icons.copy_rounded, size: 16),
              label: const Text("复制名称"),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: node.name));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("已复制节点名称"),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
            ),
            TextButton.icon(
              icon: const Icon(Icons.bolt_rounded, size: 16),
              label: const Text("单独测速"),
              onPressed: () {
                Navigator.pop(context);
                _testNodeDelay(node);
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeDefine.kColorBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(context);
                _selectNode(group, node);
              },
              child: const Text("选择此节点"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? valueColor, bool isBold = false}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionFilterBar(List<ClashProxiesNode> leafNodes) {
    if (leafNodes.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final regionSummaries = NodeRegionHelper.extractAvailableRegions(leafNodes);
    if (regionSummaries.length <= 1) return const SizedBox.shrink();

    return Container(
      height: 32,
      margin: const EdgeInsets.only(top: 8, bottom: 2),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: regionSummaries.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final summary = regionSummaries[index];
          final isSelected = _selectedRegionCode == summary.region.code;

          return InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              setState(() {
                if (_selectedRegionCode == summary.region.code) {
                  _selectedRegionCode = "ALL";
                } else {
                  _selectedRegionCode = summary.region.code;
                }
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? ThemeDefine.kColorBlue
                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected
                      ? ThemeDefine.kColorBlue
                      : theme.dividerColor.withValues(alpha: 0.25),
                  width: 0.8,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    summary.region.flag,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "${summary.region.name} (${summary.count})",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : theme.colorScheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final groups = _getProxyGroups();
    final leafNodes = _allNodes.where((n) => isRealLeafProxy(n)).toList();

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            children: [
              // Top Header Bar (Clash Verge Style)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (ModalRoute.of(context)?.canPop ?? false)
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 36,
                          height: 30,
                          child: Icon(Icons.arrow_back_ios_outlined, size: 22),
                        ),
                      ),
                    Text(
                      tcontext.meta.proxy,
                      style: const TextStyle(
                        fontWeight: ThemeConfig.kFontWeightTitle,
                        fontSize: ThemeConfig.kFontSizeTitle,
                      ),
                    ),
                    const Spacer(),

                    // Running Mode Switch: [ 规则 | 全局 | 直连 ]
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildModeButton("rule", tcontext.meta.rule),
                          _buildModeButton("global", tcontext.meta.global),
                          _buildModeButton("direct", tcontext.meta.direct),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),

                    // Toggle Collapse / Expand All button
                    Tooltip(
                      message: groups.any((g) => _isGroupExpandedByDefault(g, groups.indexOf(g)))
                          ? tcontext.meta.collapseAll
                          : tcontext.meta.expandAll,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          final anyExpanded = groups.any((g) => _isGroupExpandedByDefault(g, groups.indexOf(g)));
                          setState(() {
                            for (var g in groups) {
                              _groupExpanded[g.name] = !anyExpanded;
                            }
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            groups.any((g) => _isGroupExpandedByDefault(g, groups.indexOf(g)))
                                ? Icons.unfold_less_rounded
                                : Icons.unfold_more_rounded,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Sort & Filter button
                    Tooltip(
                      message: "排序与过滤",
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _showSortFilterBottomSheet,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: (_sortMode != "default" || _hideTimeoutNodes || _selectedRegionCode != "ALL")
                                ? ThemeDefine.kColorBlue.withValues(alpha: 0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                Icons.tune_rounded,
                                size: 20,
                                color: (_sortMode != "default" || _hideTimeoutNodes || _selectedRegionCode != "ALL")
                                    ? ThemeDefine.kColorBlue
                                    : null,
                              ),
                              if (_sortMode != "default" || _hideTimeoutNodes || _selectedRegionCode != "ALL")
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(
                                      color: ThemeDefine.kColorBlue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Latency Test All button
                    Tooltip(
                      message: "${tcontext.meta.latencyTest} (${_activeLatencyTarget.name})",
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _nodesTesting.isNotEmpty ? null : _testAllDelay,
                        onLongPress: _showLatencyTargetBottomSheet,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: _nodesTesting.isNotEmpty
                              ? Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(
                                        ThemeDefine.kColorBlue,
                                      ),
                                    ),
                                  ),
                                )
                              : const Icon(Icons.bolt_rounded, size: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Refresh button
                    Tooltip(
                      message: tcontext.meta.refresh,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _fetchProxies,
                        child: SizedBox(
                          width: 32,
                          height: 32,
                          child: _loading
                              ? const Center(
                                  child: SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : const Icon(Icons.refresh_rounded, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Search Bar + Target Selector Chip Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "${tcontext.meta.search} (节点/地区/协议)",
                            hintStyle: TextStyle(
                              fontSize: 12.5,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              size: 18,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            suffixIcon: _searchKeyword.isNotEmpty
                                ? InkWell(
                                    onTap: () => _searchController.clear(),
                                    child: const Icon(Icons.clear, size: 16),
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Test Target Selector Chip
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: _showLatencyTargetBottomSheet,
                      child: Container(
                        height: 36,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.25),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.radar_rounded,
                              size: 15,
                              color: ThemeDefine.kColorBlue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _activeLatencyTarget.name.replaceAll(RegExp(r'^[^\w\s\u4e00-\u9fa5]+'), '').trim(),
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Icon(
                              Icons.arrow_drop_down_rounded,
                              size: 18,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Region Filter Chips Bar
              _buildRegionFilterBar(leafNodes),
              const SizedBox(height: 6),

              // Offline Status Notice Banner (when VPN not connected but groups exist)
              if (!_isVpnStarted && groups.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.25),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cloud_off_rounded,
                        size: 18,
                        color: ThemeDefine.kColorBlue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          tcontext.meta.offlinePreviewPrompt,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.8)
                                : const Color(0xFF1E40AF),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeDefine.kColorBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        onPressed: () {
                          VpnActionHandler.vpnConnect?.call("proxy_page", false);
                        },
                        child: Text(
                          tcontext.meta.connect,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Proxy Groups & Node Cards Grid
              Expanded(
                child: groups.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.alt_route_rounded,
                              size: 52,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.25),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              ProfileManager.getProfiles().isEmpty
                                  ? tcontext.meta.noProfilesYet
                                  : tcontext.meta.noFilterResults,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeDefine.kColorBlue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              icon: Icon(
                                ProfileManager.getProfiles().isEmpty
                                    ? Icons.add_rounded
                                    : Icons.refresh_rounded,
                                size: 18,
                              ),
                              label: Text(
                                ProfileManager.getProfiles().isEmpty
                                    ? tcontext.meta.addProfile
                                    : tcontext.meta.refresh,
                              ),
                              onPressed: () async {
                                if (ProfileManager.getProfiles().isEmpty) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      settings:
                                          AddProfileByUrlScreen.routSettings(),
                                      builder: (context) =>
                                          const AddProfileByUrlScreen(),
                                    ),
                                  );
                                  await _fetchProxies();
                                } else {
                                  await _fetchProxies();
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          return _buildGroupSection(group, index);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeButton(String modeKey, String label) {
    final isSelected = _currentMode == modeKey;
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () => _changeMode(modeKey),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? ThemeDefine.kColorBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? Colors.white
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildGroupSection(ClashProxiesNode group, int index) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isExpanded = _isGroupExpandedByDefault(group, index);
    final nodes = _getNodesForGroup(group);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151D2E) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Group Header
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              setState(() {
                _groupExpanded[group.name] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Row(
                children: [
                  // Group Name
                  Text(
                    group.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Group Type Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (group.type.toLowerCase() == "selector" || group.type.toLowerCase() == "select")
                          ? ThemeDefine.kColorBlue.withValues(alpha: 0.15)
                          : Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      (group.type.toLowerCase() == "selector" || group.type.toLowerCase() == "select")
                          ? tcontext.meta.manualSelect
                          : "${group.type} ${tcontext.meta.autoSelect}",
                      style: TextStyle(
                        color: (group.type.toLowerCase() == "selector" || group.type.toLowerCase() == "select")
                            ? ThemeDefine.kColorBlue
                            : Colors.orange.shade700,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Currently Selected Node Badge
                  if (group.now.isNotEmpty)
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            getFlagEmoji(group.now),
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              group.now,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: ThemeDefine.kColorBlue,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    const Spacer(),

                  // Ping this group button
                  Tooltip(
                    message: "${tcontext.meta.speedTestGroup} (${_activeLatencyTarget.name})",
                    child: InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => _testGroupDelay(group),
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.bolt_rounded,
                          size: 18,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Node Count Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "${nodes.length}",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),

                  // Expand/Collapse Chevron
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ],
              ),
            ),
          ),

          // Nodes Grid (Clash Verge Card Grid)
          if (isExpanded && nodes.isNotEmpty) ...[
            const Divider(height: 1, thickness: 0.6),
            Padding(
              padding: const EdgeInsets.all(10),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive columns: 1 on small width, 2 on medium, 3 or 4 on desktop
                  int crossAxisCount = (constraints.maxWidth / 240).floor().clamp(1, 4);

                  return GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: nodes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisExtent: 46,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemBuilder: (context, nodeIndex) {
                      final node = nodes[nodeIndex];
                      final isSelected = group.now == node.name;
                      return _buildNodeCard(group, node, isSelected);
                    },
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNodeCard(ClashProxiesNode group, ClashProxiesNode node, bool isSelected) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isTesting = _nodesTesting.contains(node.name);
    final flag = getFlagEmoji(node.name);

    // Latency text and color (Clash Verge style with enhanced color tiers)
    Color delayColor = ThemeDefine.kColorGreenBright;
    String delayText = "";

    if (isTesting) {
      delayText = "...";
      delayColor = theme.colorScheme.onSurface.withValues(alpha: 0.4);
    } else if (node.delay == null || node.delay == 0) {
      delayText = "";
    } else if (node.delay! < 0) {
      delayText = "Error";
      delayColor = Colors.redAccent;
    } else {
      delayText = "${node.delay}";
      if (node.delay! < 300) {
        delayColor = ThemeDefine.kColorGreenBright;
      } else if (node.delay! < 800) {
        delayColor = Colors.lightGreen;
      } else if (node.delay! < 1200) {
        delayColor = Colors.amber;
      } else {
        delayColor = Colors.orange;
      }
    }

    return Material(
      color: isSelected
          ? (isDark
              ? const Color(0xFF1E3A8A).withValues(alpha: 0.45)
              : const Color(0xFFDBEAFE).withValues(alpha: 0.7))
          : (isDark
              ? const Color(0xFF0F172A).withValues(alpha: 0.6)
              : const Color(0xFFFFFFFF)),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => _selectNode(group, node),
        onLongPress: () => _showNodeDetailDialog(group, node),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? ThemeDefine.kColorBlue
                  : theme.dividerColor.withValues(alpha: 0.3),
              width: isSelected ? 1.5 : 0.8,
            ),
          ),
          child: Row(
            children: [
              // Flag emoji
              Text(
                flag,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 6),

              // Node Name & Protocol Tags
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      node.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? ThemeDefine.kColorBlue : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (node.type.isNotEmpty && node.type != ClashProtocolType.selector.name)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              node.type.toUpperCase(),
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          const SizedBox(width: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 0.5),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              "UDP",
                              style: TextStyle(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 4),

              // Latency Badge / Test Trigger
              InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () => _testNodeDelay(node),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: isTesting
                      ? const SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        )
                      : Text(
                          delayText,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
                            color: delayColor,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
