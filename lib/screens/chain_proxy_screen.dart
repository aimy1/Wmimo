// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
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
        if (ClashProtocolType.isGroupType(n.type)) {
          gNames.add(n.name);
        } else {
          pNames.add(n.name);
        }
      }

      _availableNodes = filtered;
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
      final switchedGroup = await ChainProxyManager.activateChainInPrimaryGroup(item.name);
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
            child: TextButton.icon(
              onPressed: () => _createOrEdit(),
              icon: const Icon(Icons.add_rounded, size: 19),
              label: Text(
                tcontext.chain_proxy.add,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                foregroundColor: ThemeDefine.kColorBlue,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              ),
            ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              children: [
                // Info & Status Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.14 : 0.07),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.22),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.hub_rounded, color: ThemeDefine.kColorBlue, size: 18),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: ThemeDefine.kColorBlue.withValues(alpha: 0.16),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              "Beta",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: ThemeDefine.kColorBlue,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tcontext.chain_proxy.active_count(
                                active: activeCount,
                                total: items.length,
                              ),
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? Colors.blue[200] : const Color(0xFF1E3A8A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tcontext.chain_proxy.desc,
                        style: TextStyle(
                          fontSize: 12.5,
                          height: 1.45,
                          color: isDark ? Colors.blue[100] : const Color(0xFF1E3A8A),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Empty state or List of cards
                if (items.isEmpty)
                  _buildEmptyState(theme, isDark, tcontext)
                else
                  ...items.map((item) => _buildChainCard(item, theme, isDark, tcontext)),
              ],
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, bool isDark, Translations tcontext) {
    return Container(
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.03) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ThemeDefine.kColorBlue.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.link_off_rounded, size: 36, color: ThemeDefine.kColorBlue),
          ),
          const SizedBox(height: 16),
          Text(
            tcontext.chain_proxy.empty_tip,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeDefine.kColorBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () => _createOrEdit(),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(tcontext.chain_proxy.add),
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
    final hasInvalidGroup = validation.issues.contains(ChainValidationIssue.groupInNonEntryHop);
    final hasMissingNode = validation.issues.contains(ChainValidationIssue.missingHop) ||
        validation.issues.contains(ChainValidationIssue.emptyHop);
    final isTesting = _testingIds.contains(item.id);
    final isActivating = _activatingIds.contains(item.id);
    final isCurrentSelected = item.enabled && _activePrimarySelected == item.name;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isCurrentSelected
              ? ThemeDefine.kColorBlue
              : (isDark ? Colors.white12 : const Color(0xFFE2E8F0)),
          width: isCurrentSelected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Title + Hop Badge + Switch
            Row(
              children: [
                Icon(
                  Icons.link_rounded,
                  color: item.enabled ? ThemeDefine.kColorBlue : Colors.grey,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: item.enabled ? null : theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.18 : 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    tcontext.chain_proxy.hop_count_badge(count: item.hops.length),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: ThemeDefine.kColorBlue,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Switch.adaptive(
                  value: item.enabled,
                  activeThumbColor: Colors.white,
                  activeTrackColor: ThemeDefine.kColorBlue,
                  onChanged: (val) async {
                    await ChainProxyManager.toggle(item.id, val);
                    await _refreshLiveStates();
                    if (mounted) setState(() {});
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Multi-Hop Stepped Topology Flow
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Wrap(
                spacing: 6,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (int i = 0; i < item.hops.length; i++) ...[
                    if (i > 0)
                      const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey),
                    _buildHopStepChip(
                      stepNum: i + 1,
                      total: item.hops.length,
                      nodeName: item.hops[i],
                      hasIssue: validation.missingHopIndices.contains(i) ||
                          validation.invalidGroupHopIndices.contains(i),
                      isDark: isDark,
                    ),
                  ],
                ],
              ),
            ),

            if (hasMissingNode || hasInvalidGroup) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 15, color: Colors.orange),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hasInvalidGroup
                          ? tcontext.chain_proxy.hop_group_not_exit_warning
                          : tcontext.chain_proxy.node_missing_warning,
                      style: const TextStyle(fontSize: 11.5, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 6),

            // Bottom Actions: Latency Ping, Use Now, Edit, Delete
            Row(
              children: [
                InkWell(
                  onTap: () => _testLatency(item),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isTesting)
                          const SizedBox(
                            width: 13,
                            height: 13,
                            child: CircularProgressIndicator(strokeWidth: 1.8),
                          )
                        else
                          const Icon(Icons.bolt_rounded, size: 16, color: ThemeDefine.kColorBlue),
                        const SizedBox(width: 4),
                        Text(
                          item.delay == null
                              ? tcontext.chain_proxy.test_latency
                              : (item.delay! < 0 ? "Timeout" : "${item.delay} ms"),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: item.delay == null
                                ? ThemeDefine.kColorBlue
                                : (item.delay! < 0
                                    ? Colors.red
                                    : (item.delay! < 800
                                        ? ThemeDefine.kColorGreenBright
                                        : Colors.amber)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                if (validation.isValid)
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: TextButton.icon(
                      onPressed: isActivating ? null : () => _useChainNow(item),
                      icon: isActivating
                          ? const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(strokeWidth: 1.5),
                            )
                          : Icon(
                              isCurrentSelected ? Icons.check_circle_rounded : Icons.play_arrow_rounded,
                              size: 16,
                            ),
                      label: Text(
                        tcontext.chain_proxy.use_now,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      style: TextButton.styleFrom(
                        foregroundColor: isCurrentSelected
                            ? ThemeDefine.kColorGreenBright
                            : ThemeDefine.kColorBlue,
                        backgroundColor: (isCurrentSelected
                                ? ThemeDefine.kColorGreenBright
                                : ThemeDefine.kColorBlue)
                            .withValues(alpha: isDark ? 0.16 : 0.08),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  tooltip: tcontext.chain_proxy.edit,
                  onPressed: () => _createOrEdit(initialItem: item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                  tooltip: tcontext.chain_proxy.delete,
                  onPressed: () => _deleteItem(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHopStepChip({
    required int stepNum,
    required int total,
    required String nodeName,
    required bool hasIssue,
    required bool isDark,
  }) {
    final MaterialColor accent = stepNum == 1
        ? Colors.blue
        : (stepNum == total ? Colors.green : Colors.purple);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      constraints: const BoxConstraints(maxWidth: 260),
      decoration: BoxDecoration(
        color: hasIssue
            ? Colors.orange.withValues(alpha: 0.14)
            : accent.withValues(alpha: isDark ? 0.18 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: hasIssue
              ? Colors.orange.withValues(alpha: 0.6)
              : accent.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 16,
            height: 16,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: hasIssue ? Colors.orange : accent,
              shape: BoxShape.circle,
            ),
            child: Text(
              "$stepNum",
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Text(
            NodeRegionHelper.getFlag(nodeName),
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              nodeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: hasIssue ? Colors.orange : null,
                fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
