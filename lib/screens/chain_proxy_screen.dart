// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/chain_proxy_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/node_region_helper.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/chain_proxy_edit_dialog.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class ChainProxyScreen extends StatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "ChainProxyScreen");
  }

  const ChainProxyScreen({super.key});

  @override
  State<ChainProxyScreen> createState() => _ChainProxyScreenState();
}

class _ChainProxyScreenState extends State<ChainProxyScreen> {
  List<ClashProxiesNode> _availableNodes = [];
  Map<String, ClashProxiesNode> _nodeMap = {};
  Set<String> _proxyNames = {};
  Set<String> _groupNames = {};
  Map<String, int?> _liveDelays = {};
  String? _activePrimarySelected;

  final Set<String> _testingIds = {};
  final Set<String> _activatingIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    ChainProxyManager.onChainProxiesChanged.add(_onDataChanged);
    _loadData();
  }

  @override
  void dispose() {
    ChainProxyManager.onChainProxiesChanged.remove(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final nodes = await ProxyNodeLoader.loadCurrentProfileNodes();
      final List<ClashProxiesNode> filtered = [];
      final Map<String, ClashProxiesNode> nodeMap = {};
      final Set<String> pNames = {};
      final Set<String> gNames = {};

      for (final n in nodes) {
        final upper = n.name.toUpperCase();
        if (upper == "DIRECT" ||
            upper == "REJECT" ||
            upper == "REJECT-DROP" ||
            upper == "GLOBAL" ||
            upper == "PASS") {
          continue;
        }
        filtered.add(n);
        nodeMap[n.name] = n;
        if (ClashProtocolType.isGroupType(n.type)) {
          gNames.add(n.name);
        } else {
          pNames.add(n.name);
        }
      }

      _availableNodes = filtered;
      _nodeMap = nodeMap;
      _proxyNames = pNames;
      _groupNames = gNames;

      await _refreshLiveStates();
    } catch (_) {}

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _refreshLiveStates() async {
    final isStarted = await VPNService.getStarted();
    if (!isStarted) {
      _liveDelays = {};
      _activePrimarySelected = null;
      return;
    }

    try {
      final res = await ClashHttpApi.getProxies();
      if (res.error == null && res.data != null) {
        final Map<String, int?> delays = {};
        final List<ClashProxiesNode> groups = [];
        for (final node in res.data!) {
          if (node.delay != null && node.delay! > 0) {
            delays[node.name] = node.delay;
          }
          if (ClashProtocolType.isGroupType(node.type)) {
            groups.add(node);
          }
        }
        _liveDelays = delays;
        final primary = ClashHttpApi.findPrimaryRuleGroup(groups);
        _activePrimarySelected = primary?.now;
      }
    } catch (_) {}
  }

  Future<void> _testLatency(ChainProxyItem item) async {
    if (_testingIds.contains(item.id)) return;
    final tcontext = Translations.of(context);

    if (!item.enabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tcontext.chain_proxy.enable_before_test),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _testingIds.add(item.id));

    final isStarted = await VPNService.getStarted();
    if (!isStarted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tcontext.meta.profileNeedActive),
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() => _testingIds.remove(item.id));
      return;
    }

    final setting = SettingManager.getConfig();
    try {
      final res = await ClashHttpApi.getDelay(
        item.name,
        url: setting.delayTestUrl,
        timeout: Duration(milliseconds: setting.delayTestTimeout),
      );
      final delay = (res.data != null && res.data! > 0) ? res.data : -1;
      ChainProxyManager.updateDelay(item.id, delay);
    } catch (_) {
      ChainProxyManager.updateDelay(item.id, -1);
    } finally {
      if (mounted) {
        setState(() => _testingIds.remove(item.id));
      }
    }
  }

  Future<void> _useChainNow(ChainProxyItem item) async {
    if (_activatingIds.contains(item.id)) return;
    final tcontext = Translations.of(context);

    if (!item.enabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tcontext.chain_proxy.enable_before_use),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    final isStarted = await VPNService.getStarted();
    if (!isStarted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tcontext.meta.profileNeedActive),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _activatingIds.add(item.id));
    try {
      final switchedGroup =
          await ChainProxyManager.activateChainInPrimaryGroup(item.name);
      await _refreshLiveStates();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              switchedGroup != null
                  ? tcontext.chain_proxy.switched_to_chain(
                      group: switchedGroup,
                      name: item.name,
                    )
                  : tcontext.chain_proxy.node_missing_warning,
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _activatingIds.remove(item.id));
      }
    }
  }

  Future<void> _createOrEdit({ChainProxyItem? initialItem}) async {
    final result = await ChainProxyEditDialog.show(
      context,
      initialItem: initialItem,
      availableNodes: _availableNodes,
      liveDelays: _liveDelays,
    );
    if (result != null) {
      await ChainProxyManager.addOrUpdate(result);
      await _refreshLiveStates();
      if (mounted) {
        setState(() {});
        final tcontext = Translations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tcontext.chain_proxy.save_success),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _deleteItem(ChainProxyItem item) async {
    final tcontext = Translations.of(context);
    final confirm = await DialogUtils.showConfirmDialog(
      context,
      tcontext.chain_proxy.delete_confirm,
    );
    if (confirm == true) {
      await ChainProxyManager.delete(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final items = ChainProxyManager.items;
    final activeCount = ChainProxyManager.enabledCount;

    return Scaffold(
      appBar: WmimoAppBar(
        title: "${tcontext.chain_proxy.title} (Beta)",
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilledButton.tonalIcon(
              onPressed: () => _createOrEdit(),
              icon: const Icon(Icons.add_rounded, size: 17),
              label: Text(
                tcontext.chain_proxy.add,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: FilledButton.styleFrom(
                backgroundColor:
                    ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.2 : 0.12),
                foregroundColor: ThemeDefine.kColorBlue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: const Size(0, 34),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
              children: [
                _buildOverviewBanner(theme, isDark, tcontext, activeCount, items.length),
                const SizedBox(height: 14),
                if (items.isEmpty)
                  _buildEmptyState(theme, isDark, tcontext)
                else
                  ...items.map(
                    (item) => _buildChainCard(item, theme, isDark, tcontext),
                  ),
              ],
            ),
    );
  }

  Widget _buildOverviewBanner(
    ThemeData theme,
    bool isDark,
    Translations tcontext,
    int activeCount,
    int totalCount,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.3 : 0.22),
          width: 0.9,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.14 : 0.07),
            isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: ThemeDefine.kColorBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.account_tree_rounded,
                  color: ThemeDefine.kColorBlue,
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  tcontext.chain_proxy.title,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                decoration: BoxDecoration(
                  color: activeCount > 0
                      ? ThemeDefine.kColorGreenBright
                          .withValues(alpha: isDark ? 0.18 : 0.12)
                      : (isDark
                          ? Colors.white.withValues(alpha: 0.07)
                          : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: activeCount > 0
                        ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.35)
                        : Colors.transparent,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activeCount > 0
                            ? ThemeDefine.kColorGreenBright
                            : ThemeDefine.kColorGrey,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      tcontext.chain_proxy.active_count(
                        active: activeCount,
                        total: totalCount,
                      ),
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: activeCount > 0
                            ? ThemeDefine.kColorGreenBright
                            : (isDark ? Colors.white70 : const Color(0xFF475569)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            tcontext.chain_proxy.desc,
            style: TextStyle(
              fontSize: 12,
              height: 1.45,
              color: isDark ? Colors.white70 : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(
    ThemeData theme,
    bool isDark,
    Translations tcontext,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(vertical: 42, horizontal: 24),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : ThemeDefine.kColorGreyLight,
          width: 0.8,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: ThemeDefine.kColorBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.route_rounded,
              size: 32,
              color: ThemeDefine.kColorBlue,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            tcontext.chain_proxy.empty_tip,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeDefine.kColorBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: ThemeDefine.kButtonBorderRadius,
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            ),
            onPressed: () => _createOrEdit(),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(
              tcontext.chain_proxy.add,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChainCard(
    ChainProxyItem item,
    ThemeData theme,
    bool isDark,
    Translations tcontext,
  ) {
    final validation = ChainProxyManager.validateItem(
      item,
      proxyNames: _proxyNames,
      groupNames: _groupNames,
    );
    final hasInvalidGroup =
        validation.issues.contains(ChainValidationIssue.groupInNonEntryHop);
    final hasMissingNode =
        validation.issues.contains(ChainValidationIssue.missingHop) ||
            validation.issues.contains(ChainValidationIssue.emptyHop);
    final hasIssue = hasInvalidGroup || hasMissingNode;
    final isTesting = _testingIds.contains(item.id);
    final isActivating = _activatingIds.contains(item.id);
    final isCurrentSelected =
        item.enabled && _activePrimarySelected == item.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: isCurrentSelected
              ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.75)
              : (hasIssue
                  ? ThemeDefine.kColorAmber.withValues(alpha: 0.6)
                  : (item.enabled
                      ? ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.35 : 0.25)
                      : (isDark
                          ? ThemeDefine.kColorDarkBorder
                          : ThemeDefine.kColorGreyLight))),
          width: isCurrentSelected ? 1.4 : 0.9,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Row: Icon + Name + Hop Count Badge + Switch
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (isCurrentSelected
                            ? ThemeDefine.kColorGreenBright
                            : (item.enabled
                                ? ThemeDefine.kColorBlue
                                : ThemeDefine.kColorGrey))
                        .withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isCurrentSelected
                        ? Icons.verified_rounded
                        : Icons.link_rounded,
                    color: isCurrentSelected
                        ? ThemeDefine.kColorGreenBright
                        : (item.enabled
                            ? ThemeDefine.kColorBlue
                            : ThemeDefine.kColorGrey),
                    size: 19,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: item.enabled
                              ? theme.colorScheme.onSurface
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                          fontFamilyFallback:
                              Platform.isWindows ? const ['Emoji'] : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1.5,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeDefine.kColorBlue
                                  .withValues(alpha: isDark ? 0.18 : 0.1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              tcontext.chain_proxy.hop_count_badge(
                                count: item.hops.length,
                              ),
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: ThemeDefine.kColorBlue,
                              ),
                            ),
                          ),
                          if (isCurrentSelected) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: ThemeDefine.kColorGreenBright
                                    .withValues(alpha: isDark ? 0.2 : 0.12),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                tcontext.meta.connected,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: ThemeDefine.kColorGreenBright,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                SizedBox(
                  height: 30,
                  child: Transform.scale(
                    scale: 0.84,
                    alignment: Alignment.centerRight,
                    child: Switch.adaptive(
                      value: item.enabled,
                      activeThumbColor: Colors.white,
                      activeTrackColor: ThemeDefine.kColorBlue,
                      onChanged: (val) async {
                        HapticFeedback.selectionClick();
                        await ChainProxyManager.toggle(item.id, val);
                        await _refreshLiveStates();
                        if (mounted) setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Multi-Hop Pipeline Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? ThemeDefine.kColorDarkInner
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: isDark
                      ? ThemeDefine.kColorDarkBorder
                      : const Color(0xFFE2E8F0),
                  width: 0.8,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < item.hops.length; i++) ...[
                    if (i > 0)
                      Padding(
                        padding: const EdgeInsets.only(left: 11, top: 3, bottom: 3),
                        child: Row(
                          children: [
                            Container(
                              width: 1.5,
                              height: 10,
                              color: isDark
                                  ? Colors.white24
                                  : const Color(0xFFCBD5E1),
                            ),
                            const SizedBox(width: 6),
                            Icon(
                              Icons.south_rounded,
                              size: 11,
                              color: isDark
                                  ? Colors.white38
                                  : const Color(0xFF94A3B8),
                            ),
                          ],
                        ),
                      ),
                    _buildHopPipelineRow(
                      stepNum: i + 1,
                      total: item.hops.length,
                      nodeName: item.hops[i],
                      hasIssue: validation.missingHopIndices.contains(i) ||
                          validation.invalidGroupHopIndices.contains(i),
                      isDark: isDark,
                      theme: theme,
                      tcontext: tcontext,
                    ),
                  ],
                ],
              ),
            ),

            // 3. Validation Warning Banner
            if (hasIssue) ...[
              const SizedBox(height: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: ThemeDefine.kColorAmber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(9),
                  border: Border.all(
                    color: ThemeDefine.kColorAmber.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 16,
                      color: ThemeDefine.kColorAmber,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        hasInvalidGroup
                            ? tcontext.chain_proxy.hop_group_not_exit_warning
                            : tcontext.chain_proxy.node_missing_warning,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: ThemeDefine.kColorAmber,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: isDark
                  ? ThemeDefine.kColorDarkBorder
                  : const Color(0xFFE2E8F0),
            ),
            const SizedBox(height: 10),

            // 4. Bottom Action Bar
            Row(
              children: [
                // Latency Test Pill
                InkWell(
                  onTap: () => _testLatency(item),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5.5,
                    ),
                    decoration: BoxDecoration(
                      color: (item.delay == null
                              ? ThemeDefine.kColorBlue
                              : (item.delay! < 0
                                  ? ThemeDefine.kColorRed
                                  : (item.delay! < 800
                                      ? ThemeDefine.kColorGreenBright
                                      : ThemeDefine.kColorAmber)))
                          .withValues(alpha: isDark ? 0.15 : 0.09),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isTesting)
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              color: ThemeDefine.kColorBlue,
                            ),
                          )
                        else
                          Icon(
                            Icons.bolt_rounded,
                            size: 15,
                            color: item.delay == null
                                ? ThemeDefine.kColorBlue
                                : (item.delay! < 0
                                    ? ThemeDefine.kColorRed
                                    : (item.delay! < 800
                                        ? ThemeDefine.kColorGreenBright
                                        : ThemeDefine.kColorAmber)),
                          ),
                        const SizedBox(width: 4),
                        Text(
                          item.delay == null
                              ? tcontext.chain_proxy.test_latency
                              : (item.delay! < 0
                                  ? "Timeout"
                                  : "${item.delay} ms"),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: item.delay == null
                                ? ThemeDefine.kColorBlue
                                : (item.delay! < 0
                                    ? ThemeDefine.kColorRed
                                    : (item.delay! < 800
                                        ? ThemeDefine.kColorGreenBright
                                        : ThemeDefine.kColorAmber)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                if (validation.isValid) ...[
                  TextButton.icon(
                    onPressed: isActivating ? null : () => _useChainNow(item),
                    icon: isActivating
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 1.6),
                          )
                        : Icon(
                            isCurrentSelected
                                ? Icons.check_circle_rounded
                                : Icons.play_arrow_rounded,
                            size: 15,
                          ),
                    label: Text(
                      tcontext.chain_proxy.use_now,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: isCurrentSelected
                          ? ThemeDefine.kColorGreenBright
                          : ThemeDefine.kColorBlue,
                      backgroundColor: (isCurrentSelected
                              ? ThemeDefine.kColorGreenBright
                              : ThemeDefine.kColorBlue)
                          .withValues(alpha: isDark ? 0.16 : 0.09),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5.5,
                      ),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                _buildCardIconButton(
                  icon: Icons.edit_outlined,
                  tooltip: tcontext.chain_proxy.edit,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                  isDark: isDark,
                  onTap: () => _createOrEdit(initialItem: item),
                ),
                const SizedBox(width: 6),
                _buildCardIconButton(
                  icon: Icons.delete_outline_rounded,
                  tooltip: tcontext.chain_proxy.delete,
                  color: ThemeDefine.kColorRed,
                  isDark: isDark,
                  onTap: () => _deleteItem(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardIconButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.06)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }

  Widget _buildHopPipelineRow({
    required int stepNum,
    required int total,
    required String nodeName,
    required bool hasIssue,
    required bool isDark,
    required ThemeData theme,
    required Translations tcontext,
  }) {
    final MaterialColor accent = stepNum == 1
        ? Colors.blue
        : (stepNum == total ? Colors.green : Colors.purple);
    final roleText = stepNum == 1
        ? tcontext.chain_proxy.hop_entry
        : (stepNum == total
            ? tcontext.chain_proxy.hop_exit(index: stepNum)
            : tcontext.chain_proxy.hop_transit(index: stepNum));
    final cleanName = NodeRegionHelper.getDisplayNameWithoutFlag(nodeName);
    final flag = NodeRegionHelper.getFlag(nodeName);
    final nodeObj = _nodeMap[nodeName];
    final liveDelay = _liveDelays[nodeName] ?? nodeObj?.delay;

    return Row(
      children: [
        // Step Number Circle
        Container(
          width: 22,
          height: 22,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: hasIssue
                ? ThemeDefine.kColorAmber
                : accent.withValues(alpha: isDark ? 0.25 : 0.14),
            shape: BoxShape.circle,
            border: Border.all(
              color: hasIssue
                  ? ThemeDefine.kColorAmber
                  : accent.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Text(
            "$stepNum",
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              color: hasIssue ? Colors.white : accent[isDark ? 200 : 700],
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Role Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: hasIssue
                ? ThemeDefine.kColorAmber.withValues(alpha: 0.15)
                : accent.withValues(alpha: isDark ? 0.18 : 0.1),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Text(
            roleText.split(' ').first,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: hasIssue
                  ? ThemeDefine.kColorAmber
                  : accent[isDark ? 300 : 700],
            ),
          ),
        ),
        const SizedBox(width: 7),
        // Flag + Clean Node Name (no duplicate flag)
        Text(
          flag,
          style: TextStyle(
            fontSize: 13.5,
            fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            cleanName.isNotEmpty ? cleanName : nodeName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: hasIssue
                  ? ThemeDefine.kColorAmber
                  : theme.colorScheme.onSurface,
              fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
            ),
          ),
        ),
        if (nodeObj != null && nodeObj.type.isNotEmpty) ...[
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.07)
                  : const Color(0xFFE2E8F0).withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              nodeObj.type.toUpperCase(),
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ),
        ],
        if (liveDelay != null && liveDelay > 0) ...[
          const SizedBox(width: 6),
          Text(
            "${liveDelay}ms",
            style: TextStyle(
              fontSize: 10.5,
              fontFamily: 'monospace',
              fontWeight: FontWeight.w700,
              color: liveDelay < 800
                  ? ThemeDefine.kColorGreenBright
                  : ThemeDefine.kColorAmber,
            ),
          ),
        ],
      ],
    );
  }
}
