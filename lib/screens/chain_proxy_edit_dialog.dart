import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/modules/chain_proxy_manager.dart';
import 'package:wmimo/app/utils/node_region_helper.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class ChainProxyEditDialog extends StatefulWidget {
  final ChainProxyItem? initialItem;
  final List<ClashProxiesNode> availableNodes;
  final Map<String, int?> liveDelays;

  const ChainProxyEditDialog({
    super.key,
    this.initialItem,
    required this.availableNodes,
    this.liveDelays = const {},
  });

  static Future<ChainProxyItem?> show(
    BuildContext context, {
    ChainProxyItem? initialItem,
    required List<ClashProxiesNode> availableNodes,
    Map<String, int?> liveDelays = const {},
  }) {
    return showDialog<ChainProxyItem>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ChainProxyEditDialog(
        initialItem: initialItem,
        availableNodes: availableNodes,
        liveDelays: liveDelays,
      ),
    );
  }

  @override
  State<ChainProxyEditDialog> createState() => _ChainProxyEditDialogState();
}

class _ChainProxyEditDialogState extends State<ChainProxyEditDialog> {
  static const int _kMaxHops = 5;

  late TextEditingController _nameController;
  late List<String> _hops;
  bool _customName = false;

  late final List<ClashProxiesNode> _cleanCandidates;
  late final Map<String, ClashProxiesNode> _nodeLookup;
  late final List<ClashProxiesNode> _concreteNodes;

  @override
  void initState() {
    super.initState();
    _cleanCandidates = widget.availableNodes
        .where((n) => !ChainProxyManager.isGeneratedChainNodeName(n.name))
        .toList();
    _nodeLookup = {for (final n in _cleanCandidates) n.name: n};
    _concreteNodes = _cleanCandidates
        .where((n) => !ClashProtocolType.isGroupType(n.type))
        .toList();

    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');

    if (item != null && item.hops.length >= 2) {
      _hops = List<String>.from(item.hops);
    } else {
      // Smart pre-selection: skip airport dummy info nodes and prefer nodes with live positive latency
      final validEntries = _cleanCandidates
          .where((n) => !ChainProxyManager.isInformationalDummyNodeName(n.name))
          .toList();
      final entryPool =
          validEntries.isNotEmpty ? validEntries : _cleanCandidates;
      final firstEntry = entryPool.isNotEmpty ? entryPool.first.name : '';

      final validExits = _concreteNodes
          .where(
            (n) =>
                n.name != firstEntry &&
                !ChainProxyManager.isInformationalDummyNodeName(n.name),
          )
          .toList();
      final exitPool = validExits.isNotEmpty ? validExits : _concreteNodes;
      final firstExit = exitPool
          .firstWhere(
            (n) => n.name != firstEntry,
            orElse: () => exitPool.isNotEmpty
                ? exitPool.first
                : (_cleanCandidates.length > 1
                    ? _cleanCandidates[1]
                    : ClashProxiesNode()),
          )
          .name;
      _hops = [firstEntry, firstExit];
    }

    if (item != null && item.name.isNotEmpty) {
      _customName = true;
    } else {
      _generateDefaultName();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  static String _formatCleanHopLabel(String rawName) {
    final trimmed = rawName.trim();
    if (trimmed.isEmpty) return '';
    final flag = NodeRegionHelper.getFlag(trimmed);
    final clean = NodeRegionHelper.getDisplayNameWithoutFlag(trimmed);
    return clean.isNotEmpty ? "$flag $clean" : trimmed;
  }

  void _generateDefaultName({bool force = false}) {
    if (_customName && !force) return;
    final nonEmpty = _hops
        .where((h) => h.trim().isNotEmpty)
        .map(_formatCleanHopLabel)
        .toList();
    if (nonEmpty.length >= 2) {
      _nameController.text = "🔗 ${nonEmpty.join(' ➔ ')}";
      if (force) {
        _customName = false;
      }
    }
  }

  int? _estimateTotalDelay() {
    int sum = 0;
    int counted = 0;
    for (final hop in _hops) {
      final d = widget.liveDelays[hop] ?? _nodeLookup[hop]?.delay;
      if (d != null && d > 0) {
        sum += d;
        counted++;
      }
    }
    return counted > 0 ? sum : null;
  }

  String _roleLabel(int index, Translations tcontext) {
    if (index == 0) return tcontext.chain_proxy.hop1;
    if (index == _hops.length - 1) {
      return _hops.length == 2
          ? tcontext.chain_proxy.hop2
          : tcontext.chain_proxy.hop_exit(index: index + 1);
    }
    return tcontext.chain_proxy.hop_transit(index: index + 1);
  }

  MaterialColor _roleColor(int index) {
    if (index == 0) return Colors.blue;
    if (index == _hops.length - 1) return Colors.green;
    return Colors.purple;
  }

  IconData _roleIcon(int index) {
    if (index == 0) return Icons.vpn_key_rounded;
    if (index == _hops.length - 1) return Icons.public_rounded;
    return Icons.alt_route_rounded;
  }

  Future<String?> _pickNodeForIndex(int index) async {
    final tcontext = Translations.of(context);
    final isEntry = index == 0;
    final candidates = isEntry ? _cleanCandidates : _concreteNodes;
    final currentVal = _hops[index];
    final otherSelected = <String>{
      for (int i = 0; i < _hops.length; i++)
        if (i != index && _hops[i].isNotEmpty) _hops[i],
    };

    final title = isEntry
        ? tcontext.chain_proxy.hop1_select_title
        : (index == _hops.length - 1
            ? tcontext.chain_proxy.hop2_select_title
            : tcontext.chain_proxy.hop_transit(index: index + 1));

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _ChainNodePickerSheet(
        title: title,
        nodes: candidates,
        liveDelays: widget.liveDelays,
        currentSelected: currentVal,
        disabledNodes: otherSelected,
      ),
    );
  }

  Future<void> _addTransitHop() async {
    if (_hops.length >= _kMaxHops) return;
    final tcontext = Translations.of(context);
    final otherSelected = _hops.where((h) => h.isNotEmpty).toSet();
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _ChainNodePickerSheet(
        title: tcontext.chain_proxy.add_transit_hop,
        nodes: _concreteNodes,
        liveDelays: widget.liveDelays,
        currentSelected: null,
        disabledNodes: otherSelected,
      ),
    );
    if (picked != null && picked.isNotEmpty && mounted) {
      setState(() {
        _hops.insert(_hops.length - 1, picked);
        _generateDefaultName();
      });
    }
  }

  void _swapHops(int indexA, int indexB) {
    if (indexA < 0 ||
        indexB < 0 ||
        indexA >= _hops.length ||
        indexB >= _hops.length) {
      return;
    }
    setState(() {
      final tmp = _hops[indexA];
      _hops[indexA] = _hops[indexB];
      _hops[indexB] = tmp;
      _generateDefaultName();
    });
  }

  void _onSave() {
    final tcontext = Translations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      DialogUtils.showAlertDialog(
        context,
        tcontext.chain_proxy.name_empty_warning,
      );
      return;
    }

    final proxyNames = _concreteNodes.map((n) => n.name).toSet();
    final groupNames = _cleanCandidates
        .where((n) => ClashProtocolType.isGroupType(n.type))
        .map((n) => n.name)
        .toSet();

    final candidate = ChainProxyItem(
      id: widget.initialItem?.id,
      name: name,
      hops: _hops,
      enabled: widget.initialItem?.enabled ?? true,
      delay: widget.initialItem?.delay,
    );

    final validation = ChainProxyManager.validateItem(
      candidate,
      proxyNames: proxyNames,
      groupNames: groupNames,
    );

    if (!validation.isValid) {
      String message = tcontext.chain_proxy.node_missing_warning;
      if (validation.issues.contains(ChainValidationIssue.emptyHop)) {
        message = _hops.first.trim().isEmpty
            ? tcontext.chain_proxy.hop1_empty_warning
            : tcontext.chain_proxy.hop2_empty_warning;
      } else if (validation.issues
          .contains(ChainValidationIssue.duplicateHops)) {
        message = tcontext.chain_proxy.hop_duplicate_warning;
      } else if (validation.issues
          .contains(ChainValidationIssue.groupInNonEntryHop)) {
        message = tcontext.chain_proxy.hop_group_not_exit_warning;
      }
      DialogUtils.showAlertDialog(context, message);
      return;
    }

    Navigator.pop(context, candidate);
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final estimatedDelay = _estimateTotalDelay();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header (Original Clean Style)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.link_rounded,
                      color: ThemeDefine.kColorBlue,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.initialItem == null
                                ? tcontext.chain_proxy.add
                                : tcontext.chain_proxy.edit,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                ThemeDefine.kColorBlue.withValues(alpha: 0.14),
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
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name Input (Original OutlineInputBorder Style + Auto Reset)
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: tcontext.chain_proxy.name,
                  hintText: tcontext.chain_proxy.name_hint,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    tooltip: tcontext.chain_proxy.reset_name,
                    icon: const Icon(Icons.auto_fix_high_rounded, size: 18),
                    onPressed: () {
                      setState(() {
                        _generateDefaultName(force: true);
                      });
                    },
                  ),
                ),
                onChanged: (_) => _customName = true,
              ),
              const SizedBox(height: 16),

              // Topology Diagram Preview Card (Original Clean Horizontal Row)
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.hub_outlined,
                          size: 16,
                          color: ThemeDefine.kColorBlue,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          tcontext.chain_proxy.preview,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                        ),
                        const Spacer(),
                        if (estimatedDelay != null)
                          Text(
                            "~$estimatedDelay ms",
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: ThemeDefine.kColorGreenBright,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTopologyBadge(
                          tcontext.chain_proxy.local_device,
                          Colors.grey,
                          isDark,
                        ),
                        for (int i = 0; i < _hops.length; i++) ...[
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: _buildTopologyBadge(
                              _hops[i].isNotEmpty
                                  ? _formatCleanHopLabel(_hops[i])
                                  : (i == 0
                                      ? tcontext.chain_proxy.hop1_placeholder
                                      : tcontext.chain_proxy.hop2_placeholder),
                              _roleColor(i),
                              isDark,
                            ),
                          ),
                        ],
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: Colors.grey,
                        ),
                        _buildTopologyBadge(
                          tcontext.chain_proxy.internet,
                          Colors.orange,
                          isDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Hop Selectors (Original Clean Selector Boxes)
              for (int index = 0; index < _hops.length; index++) ...[
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _roleLabel(index, tcontext),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (_hops.length > 2)
                      InkWell(
                        borderRadius: BorderRadius.circular(6),
                        onTap: () {
                          setState(() {
                            _hops.removeAt(index);
                            _generateDefaultName();
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            tcontext.chain_proxy.remove_hop,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                InkWell(
                  onTap: () async {
                    final selected = await _pickNodeForIndex(index);
                    if (selected != null && mounted) {
                      setState(() {
                        _hops[index] = selected;
                        _generateDefaultName();
                      });
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark ? Colors.white24 : Colors.black26,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _roleIcon(index),
                          size: 18,
                          color: _roleColor(index),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _hops[index].isNotEmpty
                                ? _formatCleanHopLabel(_hops[index])
                                : tcontext.chain_proxy.select_node,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  _hops[index].isEmpty ? Colors.grey : null,
                              fontFamilyFallback:
                                  Platform.isWindows ? const ['Emoji'] : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if ((widget.liveDelays[_hops[index]] ??
                                    _nodeLookup[_hops[index]]?.delay) !=
                                null &&
                            (widget.liveDelays[_hops[index]] ??
                                    _nodeLookup[_hops[index]]!.delay!) >
                                0) ...[
                          Text(
                            "${widget.liveDelays[_hops[index]] ?? _nodeLookup[_hops[index]]!.delay} ms",
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: ThemeDefine.kColorGreenBright,
                            ),
                          ),
                          const SizedBox(width: 6),
                        ],
                        const Icon(Icons.arrow_drop_down, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
                if (index < _hops.length - 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => _swapHops(index, index + 1),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.swap_vert_rounded,
                                  size: 15,
                                  color: ThemeDefine.kColorBlue,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  tcontext.chain_proxy.swap_hops,
                                  style: const TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: ThemeDefine.kColorBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (index == _hops.length - 2 &&
                            _hops.length < _kMaxHops) ...[
                          const SizedBox(width: 12),
                          InkWell(
                            onTap: _addTransitHop,
                            borderRadius: BorderRadius.circular(12),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.add_circle_outline_rounded,
                                    size: 14,
                                    color: ThemeDefine.kColorBlue,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    tcontext.chain_proxy.add_transit_hop,
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      color: ThemeDefine.kColorBlue,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
              const SizedBox(height: 20),

              // Action Buttons (Original Clean Style)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(tcontext.meta.cancel),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeDefine.kColorBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    onPressed: _onSave,
                    child: Text(tcontext.meta.save),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopologyBadge(String text, MaterialColor color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color[isDark ? 300 : 700],
          fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
        ),
      ),
    );
  }
}

class _ChainNodePickerSheet extends StatefulWidget {
  final String title;
  final List<ClashProxiesNode> nodes;
  final Map<String, int?> liveDelays;
  final String? currentSelected;
  final Set<String> disabledNodes;

  const _ChainNodePickerSheet({
    required this.title,
    required this.nodes,
    required this.liveDelays,
    required this.currentSelected,
    required this.disabledNodes,
  });

  @override
  State<_ChainNodePickerSheet> createState() => _ChainNodePickerSheetState();
}

class _ChainNodePickerSheetState extends State<_ChainNodePickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  bool _sortByDelay = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ClashProxiesNode> _filteredNodes() {
    final query = _searchController.text.trim().toLowerCase();
    final list = widget.nodes.where((n) {
      if (widget.disabledNodes.contains(n.name)) return false;
      if (ChainProxyManager.isGeneratedChainNodeName(n.name)) return false;
      if (query.isNotEmpty) {
        return n.name.toLowerCase().contains(query) ||
            n.type.toLowerCase().contains(query);
      }
      return true;
    }).toList();

    if (_sortByDelay) {
      list.sort((a, b) {
        final dA = widget.liveDelays[a.name] ?? a.delay ?? 999999;
        final dB = widget.liveDelays[b.name] ?? b.delay ?? 999999;
        final sA = dA <= 0 ? 999999 : dA;
        final sB = dB <= 0 ? 999999 : dB;
        return sA.compareTo(sB);
      });
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final filteredList = _filteredNodes();

    return SafeArea(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.75,
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _sortByDelay = !_sortByDelay;
                    });
                  },
                  icon: Icon(
                    Icons.bolt_rounded,
                    size: 16,
                    color: _sortByDelay ? ThemeDefine.kColorBlue : Colors.grey,
                  ),
                  label: Text(
                    tcontext.meta.sortLatency,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          _sortByDelay ? ThemeDefine.kColorBlue : Colors.grey,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            WmimoSearchBar(
              controller: _searchController,
              hintText: tcontext.meta.searchProxies,
              onChanged: (_) => setState(() {}),
              onClear: () {
                _searchController.clear();
                setState(() {});
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filteredList.isEmpty
                  ? Center(
                      child: Text(
                        tcontext.chain_proxy.empty_tip,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final node = filteredList[index];
                        final isSelected =
                            node.name == widget.currentSelected;
                        final delay =
                            widget.liveDelays[node.name] ?? node.delay;
                        final label = _ChainProxyEditDialogState
                            ._formatCleanHopLabel(node.name);

                        return ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          title: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              color:
                                  isSelected ? ThemeDefine.kColorBlue : null,
                              fontFamilyFallback:
                                  Platform.isWindows ? const ['Emoji'] : null,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (delay != null && delay > 0)
                                Text(
                                  "$delay ms",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: delay < 800
                                        ? ThemeDefine.kColorGreenBright
                                        : Colors.amber,
                                  ),
                                ),
                              if (isSelected) ...[
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: ThemeDefine.kColorBlue,
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                          onTap: () => Navigator.pop(context, node.name),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
