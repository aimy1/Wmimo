// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/chain_proxy_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
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
  List<String> _availableNodes = [];
  final Set<String> _testingIds = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    ChainProxyManager.onChainProxiesChanged.add(_onDataChanged);
    _loadAvailableNodes();
  }

  @override
  void dispose() {
    ChainProxyManager.onChainProxiesChanged.remove(_onDataChanged);
    super.dispose();
  }

  void _onDataChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadAvailableNodes() async {
    setState(() => _loading = true);
    try {
      final nodes = await ProxyNodeLoader.loadCurrentProfileNodes();
      final List<String> nodeNames = [];
      for (var n in nodes) {
        final upper = n.name.toUpperCase();
        if (upper != "DIRECT" &&
            upper != "REJECT" &&
            upper != "REJECT-DROP" &&
            upper != "GLOBAL" &&
            upper != "PASS") {
          nodeNames.add(n.name);
        }
      }
      _availableNodes = nodeNames;
    } catch (_) {}
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _testLatency(ChainProxyItem item) async {
    if (_testingIds.contains(item.id)) return;
    setState(() => _testingIds.add(item.id));

    final isStarted = await VPNService.getStarted();
    if (!isStarted) {
      final tcontext = Translations.of(context);
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

  Future<void> _createOrEdit({ChainProxyItem? initialItem}) async {
    final result = await ChainProxyEditDialog.show(
      context,
      initialItem: initialItem,
      availableNodes: _availableNodes,
    );
    if (result != null) {
      await ChainProxyManager.addOrUpdate(result);
      if (mounted) {
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

    return Scaffold(
      appBar: WmimoAppBar(
        title: "${tcontext.chain_proxy.title} (Beta)",
        actions: [
          IconButton(
            tooltip: tcontext.chain_proxy.add,
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _createOrEdit(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: ThemeDefine.kColorBlue,
        foregroundColor: Colors.white,
        onPressed: () => _createOrEdit(),
        icon: const Icon(Icons.add_rounded),
        label: Text(tcontext.chain_proxy.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline_rounded, color: ThemeDefine.kColorBlue, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          tcontext.chain_proxy.desc,
                          style: TextStyle(
                            fontSize: 12.5,
                            height: 1.4,
                            color: isDark ? Colors.blue[100] : const Color(0xFF1E3A8A),
                          ),
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
      margin: const EdgeInsets.only(top: 40),
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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeDefine.kColorBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () => _createOrEdit(),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: Text(tcontext.chain_proxy.add),
          ),
        ],
      ),
    );
  }

  Widget _buildChainCard(ChainProxyItem item, ThemeData theme, bool isDark, Translations tcontext) {
    final hop1Exists = _availableNodes.contains(item.hop1);
    final hop2Exists = _availableNodes.contains(item.hop2);
    final hasMissingNode = !hop1Exists || !hop2Exists;
    final isTesting = _testingIds.contains(item.id);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
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
            // Top Row: Title + Status Switch
            Row(
              children: [
                const Icon(Icons.link_rounded, color: ThemeDefine.kColorBlue, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Switch.adaptive(
                  value: item.enabled,
                  activeThumbColor: Colors.white,
                  activeTrackColor: ThemeDefine.kColorBlue,
                  onChanged: (val) => ChainProxyManager.toggle(item.id, val),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Route Visualization
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.04) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.vpn_key_rounded, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.hop1,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: hop1Exists ? null : Colors.red,
                              fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.public_rounded, size: 14, color: Colors.green),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.hop2,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: hop2Exists ? null : Colors.red,
                              fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (hasMissingNode) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 14, color: Colors.orange),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      tcontext.chain_proxy.node_missing_warning,
                      style: const TextStyle(fontSize: 11.5, color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 4),

            // Bottom Actions: Latency Badge / Test & Edit / Delete
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Delay indicator & Test button
                InkWell(
                  onTap: () => _testLatency(item),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isTesting)
                          const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 1.5),
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

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
          ],
        ),
      ),
    );
  }
}
