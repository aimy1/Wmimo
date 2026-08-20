// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:libclash_vpn_service/state.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
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
  bool _sortByDelay = false;
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

  Future<void> _fetchProxies() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    final started = await VPNService.getStarted();
    _isVpnStarted = started;

    if (started) {
      final result = await ClashHttpApi.getProxies();
      if (result.data != null && result.data!.isNotEmpty) {
        final groups = result.data!.where((n) {
          return ClashProtocolType.isGroupType(n.type);
        }).toList();

        bool hasActualGroups = groups.any((g) =>
            g.name != "GLOBAL" ||
            g.all.any((m) => m != "DIRECT" && m != "REJECT"));

        if (groups.isNotEmpty && hasActualGroups) {
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

    final prev = group.now;
    setState(() {
      group.now = node.name;
    });

    if (_isVpnStarted) {
      final err = await ClashHttpApi.setProxiesNode(group.name, node.name);
      if (err != null && mounted) {
        final tcontext = Translations.of(context);
        setState(() {
          group.now = prev;
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tcontext.meta.switchNodeFailed(p: err.message)),
            duration: const Duration(seconds: 3),
          ),
        );
        return;
      }
      try {
        if (group.name != "GLOBAL") {
          await ClashHttpApi.setProxiesNode("GLOBAL", node.name);
        }
      } catch (_) {}
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
    }

    if (_nodesTesting.contains(node.name)) return;
    setState(() {
      _nodesTesting.add(node.name);
    });
    try {
      final res = await ClashHttpApi.getDelay(
        node.name,
        url: SettingManager.getConfig().delayTestUrl,
      );
      if (mounted) {
        setState(() {
          if (res.data != null && res.data! > 0) {
            node.delay = res.data;
          } else {
            node.delay = -1; // -1 represents Error / Failed
          }
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          node.delay = -1;
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
    }

    final nodeMap = {for (var n in _allNodes) n.name: n};
    final nodesToTest = group.all
        .map((name) => nodeMap[name])
        .whereType<ClashProxiesNode>()
        .where((n) => !ClashProtocolType.isGroupType(n.type))
        .toList();

    if (nodesToTest.isEmpty) return;

    for (var node in nodesToTest) {
      _nodesTesting.add(node.name);
    }
    setState(() {});

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
        final node = nodesToTest[nextIndex++];
        try {
          final res = await ClashHttpApi.getDelay(
            node.name,
            url: SettingManager.getConfig().delayTestUrl,
          );
          if (res.data != null && res.data! > 0) {
            node.delay = res.data;
          } else {
            node.delay = -1;
          }
        } catch (_) {
          node.delay = -1;
        } finally {
          _nodesTesting.remove(node.name);
          scheduleUiUpdate();
        }
      }
    }

    final workerCount = nodesToTest.length < 6 ? nodesToTest.length : 6;
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
    }

    final groups = _getProxyGroups();
    final Set<String> testedNames = {};
    final List<ClashProxiesNode> allUniqueLeafNodes = [];

    for (var g in groups) {
      final nodes = _getNodesForGroup(g);
      for (var n in nodes) {
        if (!ClashProtocolType.isGroupType(n.type) && !testedNames.contains(n.name)) {
          testedNames.add(n.name);
          allUniqueLeafNodes.add(n);
        }
      }
    }

    if (allUniqueLeafNodes.isEmpty) return;

    for (var node in allUniqueLeafNodes) {
      _nodesTesting.add(node.name);
    }
    setState(() {});

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
        if (nextIndex >= allUniqueLeafNodes.length) break;
        final node = allUniqueLeafNodes[nextIndex++];
        try {
          final res = await ClashHttpApi.getDelay(
            node.name,
            url: SettingManager.getConfig().delayTestUrl,
          );
          if (res.data != null && res.data! > 0) {
            node.delay = res.data;
          } else {
            node.delay = -1;
          }
        } catch (_) {
          node.delay = -1;
        } finally {
          _nodesTesting.remove(node.name);
          scheduleUiUpdate();
        }
      }
    }

    final workerCount = allUniqueLeafNodes.length < 6 ? allUniqueLeafNodes.length : 6;
    final workers = List.generate(workerCount, (_) => worker());
    await Future.wait(workers);

    updateDebounce?.cancel();
    if (mounted) {
      setState(() {});
    }
  }

  List<ClashProxiesNode> _getProxyGroups() {
    return _allNodes.where((n) {
      return ClashProtocolType.isGroupType(n.type) && !n.hidden;
    }).toList();
  }

  bool _isGroupExpandedByDefault(ClashProxiesNode group, int index) {
    if (_groupExpanded.containsKey(group.name)) {
      return _groupExpanded[group.name]!;
    }
    if (_currentMode == "global") {
      return group.name.toUpperCase() == "GLOBAL" || index == 0;
    }
    // In rule mode: only expand the primary/first selector group by default; fold all other secondary groups
    if (index == 0) return true;
    final lower = group.name.toLowerCase();
    if (lower == "proxies" || lower == "proxy" || lower == "节点选择" || lower == "手动选择" || lower == "select") {
      return true;
    }
    return false;
  }

  List<ClashProxiesNode> _getNodesForGroup(ClashProxiesNode group) {
    final nodeMap = {for (var n in _allNodes) n.name: n};
    List<ClashProxiesNode> list = group.all
        .map((name) => nodeMap[name] ?? (ClashProxiesNode()..name = name))
        .toList();

    if (_searchKeyword.isNotEmpty) {
      list = list.where((n) => n.name.toLowerCase().contains(_searchKeyword)).toList();
    }

    if (_sortByDelay) {
      list.sort((a, b) {
        final aDelay = a.delay ?? 99999;
        final bDelay = b.delay ?? 99999;
        final aVal = aDelay <= 0 ? 99998 : aDelay;
        final bVal = bDelay <= 0 ? 99998 : bDelay;
        return aVal.compareTo(bVal);
      });
    }

    return list;
  }

  static String getFlagEmoji(String name) {
    final upper = name.toUpperCase();
    if (name.contains("香港") || upper.contains("HK") || upper.contains("HONG KONG")) return "🇭🇰";
    if (name.contains("日本") || upper.contains("JP") || upper.contains("JAPAN") || name.contains("东京") || name.contains("大阪")) return "🇯🇵";
    if (name.contains("新加坡") || name.contains("狮城") || upper.contains("SG") || upper.contains("SINGAPORE")) return "🇸🇬";
    if (name.contains("台湾") || name.contains("台北") || upper.contains("TW") || upper.contains("TAIWAN")) return "🇹🇼";
    if (name.contains("美国") || upper.contains("US") || upper.contains("USA") || name.contains("美") || upper.contains("UNITED STATES")) return "🇺🇸";
    if (name.contains("韩国") || name.contains("首尔") || upper.contains("KR") || upper.contains("KOREA")) return "🇰🇷";
    if (name.contains("英国") || name.contains("伦敦") || upper.contains("UK") || upper.contains("GB") || upper.contains("BRITAIN")) return "🇬🇧";
    if (name.contains("德国") || name.contains("法兰克福") || upper.contains("DE") || upper.contains("GERMANY")) return "🇩🇪";
    if (name.contains("法国") || name.contains("巴黎") || upper.contains("FR") || upper.contains("FRANCE")) return "🇫🇷";
    if (name.contains("加拿大") || upper.contains("CA") || upper.contains("CANADA")) return "🇨🇦";
    if (name.contains("澳大利亚") || name.contains("悉尼") || upper.contains("AU") || upper.contains("AUSTRALIA")) return "🇦🇺";
    if (name.contains("俄罗斯") || name.contains("莫斯科") || upper.contains("RU") || upper.contains("RUSSIA")) return "🇷🇺";
    if (name.contains("印度") || upper.contains("IN") || upper.contains("INDIA")) return "🇮🇳";
    if (name.contains("印尼") || name.contains("雅加达") || upper.contains("ID") || upper.contains("INDONESIA")) return "🇮🇩";
    if (name.contains("泰国") || name.contains("曼谷") || upper.contains("TH") || upper.contains("THAILAND")) return "🇹🇭";
    if (name.contains("荷兰") || upper.contains("NL") || upper.contains("NETHERLANDS")) return "🇳🇱";
    if (name.contains("菲律宾") || upper.contains("PH") || upper.contains("PHILIPPINES")) return "🇵🇭";
    if (name.contains("越南") || upper.contains("VN") || upper.contains("VIETNAM")) return "🇻🇳";
    if (name.contains("马来西亚") || upper.contains("MY") || upper.contains("MALAYSIA")) return "🇲🇾";
    if (name.contains("土耳其") || upper.contains("TR") || upper.contains("TURKEY")) return "🇹🇷";
    if (name.contains("阿根廷") || upper.contains("AR") || upper.contains("ARGENTINA")) return "🇦🇷";
    if (name.contains("巴西") || upper.contains("BR") || upper.contains("BRAZIL")) return "🇧🇷";
    if (name.contains("自动") || upper.contains("AUTO") || upper.contains("URL-TEST")) return "⚡";
    if (name.contains("故障") || upper.contains("FALLBACK")) return "🛡️";
    if (name.contains("直连") || upper.contains("DIRECT")) return "🎯";
    if (name.contains("拒绝") || upper.contains("REJECT")) return "🚫";
    return "🌐";
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final groups = _getProxyGroups();

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
                    const SizedBox(width: 8),

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

                    // Sort button
                    Tooltip(
                      message: tcontext.meta.sort,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _sortByDelay = !_sortByDelay;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _sortByDelay
                                ? ThemeDefine.kColorBlue.withValues(alpha: 0.2)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.sort_rounded,
                            size: 20,
                            color: _sortByDelay ? ThemeDefine.kColorBlue : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Latency Test All button
                    Tooltip(
                      message: tcontext.meta.latencyTest,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _nodesTesting.isNotEmpty ? null : _testAllDelay,
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

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      hintText: tcontext.meta.search,
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
              const SizedBox(height: 10),

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
                    message: tcontext.meta.speedTestGroup,
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

    // Latency text and color (Clash Verge style)
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
      if (node.delay! < 600) {
        delayColor = ThemeDefine.kColorGreenBright;
      } else if (node.delay! < 1200) {
        delayColor = Colors.amber;
      } else {
        delayColor = Colors.redAccent;
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
                              node.type,
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
