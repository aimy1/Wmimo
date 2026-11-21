import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  late final Map<String, ClashProxiesNode> _nodeLookup;
  late final List<ClashProxiesNode> _concreteNodes;

  @override
  void initState() {
    super.initState();
    _nodeLookup = {for (final n in widget.availableNodes) n.name: n};
    _concreteNodes = widget.availableNodes
        .where((n) => !ClashProtocolType.isGroupType(n.type))
        .toList();

    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');

    if (item != null && item.hops.length >= 2) {
      _hops = List<String>.from(item.hops);
    } else {
      final firstEntry = widget.availableNodes.isNotEmpty
          ? widget.availableNodes.first.name
          : '';
      final firstExit = _concreteNodes
          .firstWhere(
            (n) => n.name != firstEntry,
            orElse: () => _concreteNodes.isNotEmpty
                ? _concreteNodes.first
                : (widget.availableNodes.length > 1
                    ? widget.availableNodes[1]
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

  String _roleLabel(int index, Translations tcontext) {
    if (index == 0) return tcontext.chain_proxy.hop_entry;
    if (index == _hops.length - 1) {
      return tcontext.chain_proxy.hop_exit(index: index + 1);
    }
    return tcontext.chain_proxy.hop_transit(index: index + 1);
  }

  MaterialColor _roleColor(int index) {
    if (index == 0) return Colors.blue;
    if (index == _hops.length - 1) return Colors.green;
    return Colors.purple;
  }

  Future<String?> _pickNodeForIndex(int index) async {
    final tcontext = Translations.of(context);
    final isEntry = index == 0;
    final candidates = isEntry ? widget.availableNodes : _concreteNodes;
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

    final hint = isEntry
        ? tcontext.chain_proxy.picker_entry_hint
        : tcontext.chain_proxy.picker_node_only_hint;

    return showDialog<String>(
      context: context,
      builder: (ctx) => _ChainNodePickerDialog(
        title: title,
        hint: hint,
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
    final picked = await showDialog<String>(
      context: context,
      builder: (ctx) => _ChainNodePickerDialog(
        title: tcontext.chain_proxy.add_transit_hop,
        hint: tcontext.chain_proxy.picker_node_only_hint,
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
    HapticFeedback.selectionClick();
    setState(() {
      final tmp = _hops[indexA];
      _hops[indexA] = _hops[indexB];
      _hops[indexB] = tmp;
      _generateDefaultName();
    });
  }

  void _onReorderHops(int oldIndex, int newIndex) {
    setState(() {
      final moved = _hops.removeAt(oldIndex);
      _hops.insert(newIndex, moved);
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
    final groupNames = widget.availableNodes
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
    final mediaSize = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor:
          isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : ThemeDefine.kColorGreyLight,
          width: 0.9,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
          maxHeight: mediaSize.height * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Dialog Header
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 12, 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.account_tree_rounded,
                      color: ThemeDefine.kColorBlue,
                      size: 19,
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
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
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
                                ThemeDefine.kColorBlue.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Beta",
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: ThemeDefine.kColorBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: isDark
                  ? ThemeDefine.kColorDarkBorder
                  : const Color(0xFFE2E8F0),
            ),

            // 2. Scrollable Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Name Input Section
                    Text(
                      tcontext.chain_proxy.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface
                            .withValues(alpha: 0.72),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: isDark
                            ? ThemeDefine.kColorDarkInner
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: isDark
                              ? ThemeDefine.kColorDarkBorder
                              : const Color(0xFFCBD5E1),
                          width: 0.8,
                        ),
                      ),
                      child: TextField(
                        controller: _nameController,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          fontFamilyFallback:
                              Platform.isWindows ? const ['Emoji'] : null,
                        ),
                        decoration: InputDecoration(
                          hintText: tcontext.chain_proxy.name_hint,
                          hintStyle: TextStyle(
                            fontSize: 12.5,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.4),
                          ),
                          prefixIcon: const Icon(
                            Icons.tag_rounded,
                            size: 17,
                            color: ThemeDefine.kColorBlue,
                          ),
                          suffixIcon: Tooltip(
                            message: tcontext.chain_proxy.reset_name,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _generateDefaultName(force: true);
                                });
                              },
                              child: const Icon(
                                Icons.auto_fix_high_rounded,
                                size: 18,
                                color: ThemeDefine.kColorBlue,
                              ),
                            ),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 11,
                          ),
                        ),
                        onChanged: (_) => _customName = true,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Adaptive Multi-hop Topology Preview Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? ThemeDefine.kColorDarkInner
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
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
                          Row(
                            children: [
                              const Icon(
                                Icons.hub_outlined,
                                size: 15,
                                color: ThemeDefine.kColorBlue,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                tcontext.chain_proxy.preview,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: ThemeDefine.kColorBlue
                                      .withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  tcontext.chain_proxy.hop_count_badge(
                                    count: _hops.length,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: ThemeDefine.kColorBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 5,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              _buildTopologyBadge(
                                "📱 ${tcontext.chain_proxy.local_device}",
                                Colors.grey,
                                isDark,
                              ),
                              for (int i = 0; i < _hops.length; i++) ...[
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 13,
                                  color: Colors.grey,
                                ),
                                _buildTopologyBadge(
                                  _hops[i].isNotEmpty
                                      ? _formatCleanHopLabel(_hops[i])
                                      : (i == 0
                                          ? tcontext.chain_proxy.hop1_placeholder
                                          : tcontext
                                              .chain_proxy.hop2_placeholder),
                                  _roleColor(i),
                                  isDark,
                                ),
                              ],
                              const Icon(
                                Icons.arrow_forward_rounded,
                                size: 13,
                                color: Colors.grey,
                              ),
                              _buildTopologyBadge(
                                "🌐 ${tcontext.chain_proxy.internet}",
                                Colors.orange,
                                isDark,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Hop Sequence Header + Add Transit Button
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            tcontext.chain_proxy.hops_label,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.72),
                            ),
                          ),
                        ),
                        if (_hops.length < _kMaxHops)
                          FilledButton.tonalIcon(
                            onPressed: _addTransitHop,
                            icon: const Icon(
                              Icons.add_circle_outline_rounded,
                              size: 15,
                            ),
                            label: Text(
                              tcontext.chain_proxy.add_transit_hop,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: ThemeDefine.kColorBlue
                                  .withValues(alpha: isDark ? 0.18 : 0.1),
                              foregroundColor: ThemeDefine.kColorBlue,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Reorderable Hop Cards
                    ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      buildDefaultDragHandles: false,
                      itemCount: _hops.length,
                      onReorderItem: _onReorderHops,
                      itemBuilder: (context, index) {
                        final hopName = _hops[index];
                        final cleanName =
                            NodeRegionHelper.getDisplayNameWithoutFlag(hopName);
                        final flag = hopName.isNotEmpty
                            ? NodeRegionHelper.getFlag(hopName)
                            : "🔗";
                        final nodeObj = _nodeLookup[hopName];
                        final isGroup = nodeObj != null &&
                            ClashProtocolType.isGroupType(nodeObj.type);
                        final invalidGroupInExit = index > 0 && isGroup;
                        final missingNode =
                            hopName.isNotEmpty && nodeObj == null;
                        final hasHopIssue = invalidGroupInExit || missingNode;
                        final roleColor = _roleColor(index);
                        final delay =
                            widget.liveDelays[hopName] ?? nodeObj?.delay;

                        return Column(
                          key: ValueKey("hop_slot_${index}_$hopName"),
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? ThemeDefine.kColorDarkInner
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: hasHopIssue
                                      ? ThemeDefine.kColorAmber
                                          .withValues(alpha: 0.7)
                                      : (isDark
                                          ? ThemeDefine.kColorDarkBorder
                                          : const Color(0xFFE2E8F0)),
                                  width: hasHopIssue ? 1.2 : 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  ReorderableDragStartListener(
                                    index: index,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Icon(
                                        Icons.drag_indicator_rounded,
                                        size: 19,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.38),
                                      ),
                                    ),
                                  ),
                                  // Step Number Circle
                                  Container(
                                    width: 24,
                                    height: 24,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: hasHopIssue
                                          ? ThemeDefine.kColorAmber
                                          : roleColor.withValues(
                                              alpha: isDark ? 0.25 : 0.14,
                                            ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Text(
                                      "${index + 1}",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: hasHopIssue
                                            ? Colors.white
                                            : roleColor[isDark ? 200 : 700],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        final picked =
                                            await _pickNodeForIndex(index);
                                        if (picked != null && mounted) {
                                          setState(() {
                                            _hops[index] = picked;
                                            _generateDefaultName();
                                          });
                                        }
                                      },
                                      borderRadius: BorderRadius.circular(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 6,
                                                  vertical: 1.5,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: roleColor.withValues(
                                                    alpha:
                                                        isDark ? 0.22 : 0.12,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  _roleLabel(index, tcontext),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                    color: roleColor[
                                                        isDark ? 300 : 700],
                                                  ),
                                                ),
                                              ),
                                              if (nodeObj != null &&
                                                  nodeObj.type.isNotEmpty) ...[
                                                const SizedBox(width: 6),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 5,
                                                    vertical: 1,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: isDark
                                                        ? Colors.white10
                                                        : const Color(
                                                            0xFFF1F5F9,
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      4,
                                                    ),
                                                  ),
                                                  child: Text(
                                                    nodeObj.type.toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 9.5,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: theme
                                                          .colorScheme.onSurface
                                                          .withValues(
                                                        alpha: 0.65,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                              if (delay != null &&
                                                  delay > 0) ...[
                                                const SizedBox(width: 6),
                                                Text(
                                                  "$delay ms",
                                                  style: TextStyle(
                                                    fontSize: 10.5,
                                                    fontFamily: 'monospace',
                                                    fontWeight: FontWeight.w700,
                                                    color: delay < 800
                                                        ? ThemeDefine
                                                            .kColorGreenBright
                                                        : ThemeDefine
                                                            .kColorAmber,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          Row(
                                            children: [
                                              Text(
                                                flag,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamilyFallback:
                                                      Platform.isWindows
                                                          ? const ['Emoji']
                                                          : null,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                child: Text(
                                                  hopName.isNotEmpty
                                                      ? (cleanName.isNotEmpty
                                                          ? cleanName
                                                          : hopName)
                                                      : tcontext.chain_proxy
                                                          .select_node,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w600,
                                                    color: hopName.isEmpty
                                                        ? Colors.grey
                                                        : (hasHopIssue
                                                            ? ThemeDefine
                                                                .kColorAmber
                                                            : null),
                                                    fontFamilyFallback:
                                                        Platform.isWindows
                                                            ? const ['Emoji']
                                                            : null,
                                                  ),
                                                ),
                                              ),
                                              const Icon(
                                                Icons.unfold_more_rounded,
                                                size: 17,
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                          if (invalidGroupInExit)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 4,
                                              ),
                                              child: Text(
                                                tcontext.chain_proxy
                                                    .hop_group_not_exit_warning,
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color:
                                                      ThemeDefine.kColorAmber,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_hops.length > 2)
                                    IconButton(
                                      tooltip: tcontext.chain_proxy.remove_hop,
                                      icon: const Icon(
                                        Icons.remove_circle_outline_rounded,
                                        size: 19,
                                        color: ThemeDefine.kColorRed,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _hops.removeAt(index);
                                          _generateDefaultName();
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),

                            // Adjacent Hop Swap Connector
                            if (index < _hops.length - 1)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.south_rounded,
                                      size: 14,
                                      color: Colors.grey.withValues(alpha: 0.6),
                                    ),
                                    const SizedBox(width: 8),
                                    InkWell(
                                      onTap: () => _swapHops(index, index + 1),
                                      borderRadius: BorderRadius.circular(14),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 3.5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ThemeDefine.kColorBlue
                                              .withValues(
                                            alpha: isDark ? 0.16 : 0.08,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(14),
                                          border: Border.all(
                                            color: ThemeDefine.kColorBlue
                                                .withValues(alpha: 0.25),
                                            width: 0.7,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.swap_vert_rounded,
                                              size: 14,
                                              color: ThemeDefine.kColorBlue,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              tcontext.chain_proxy.swap_hops,
                                              style: const TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w700,
                                                color: ThemeDefine.kColorBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            Divider(
              height: 1,
              color: isDark
                  ? ThemeDefine.kColorDarkBorder
                  : const Color(0xFFE2E8F0),
            ),
            // 3. Footer Action Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(tcontext.meta.cancel),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeDefine.kColorBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    onPressed: _onSave,
                    icon: const Icon(Icons.check_rounded, size: 18),
                    label: Text(
                      tcontext.meta.save,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopologyBadge(String text, MaterialColor color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      constraints: const BoxConstraints(maxWidth: 210),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.7,
        ),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color[isDark ? 300 : 700],
          fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
        ),
      ),
    );
  }
}

class _ChainNodePickerDialog extends StatefulWidget {
  final String title;
  final String hint;
  final List<ClashProxiesNode> nodes;
  final Map<String, int?> liveDelays;
  final String? currentSelected;
  final Set<String> disabledNodes;

  const _ChainNodePickerDialog({
    required this.title,
    required this.hint,
    required this.nodes,
    required this.liveDelays,
    required this.currentSelected,
    required this.disabledNodes,
  });

  @override
  State<_ChainNodePickerDialog> createState() => _ChainNodePickerDialogState();
}

class _ChainNodePickerDialogState extends State<_ChainNodePickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRegionCode = NodeRegion.all.code;
  late final List<RegionNodeSummary> _regions;

  @override
  void initState() {
    super.initState();
    _regions = NodeRegionHelper.extractAvailableRegions(widget.nodes);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ClashProxiesNode> _filteredNodes() {
    final query = _searchController.text.trim().toLowerCase();
    return widget.nodes.where((n) {
      if (_selectedRegionCode != NodeRegion.all.code) {
        if (NodeRegionHelper.getRegion(n.name).code != _selectedRegionCode) {
          return false;
        }
      }
      if (query.isNotEmpty) {
        final matchName = n.name.toLowerCase().contains(query);
        final matchType = n.type.toLowerCase().contains(query);
        if (!matchName && !matchType) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isZh = Localizations.localeOf(context).languageCode.startsWith('zh');
    final mediaSize = MediaQuery.of(context).size;
    final filtered = _filteredNodes();

    return Dialog(
      backgroundColor:
          isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : ThemeDefine.kColorGreyLight,
          width: 0.9,
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: mediaSize.height * 0.82,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Text(
                widget.hint,
                style: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 10),
              WmimoSearchBar(
                controller: _searchController,
                hintText: tcontext.meta.searchProxies,
                badgeText: _searchController.text.trim().isNotEmpty
                    ? '${filtered.length}'
                    : null,
                onChanged: (_) => setState(() {}),
                onClear: () {
                  _searchController.clear();
                  setState(() {});
                },
              ),
              if (_regions.length > 2) ...[
                const SizedBox(height: 10),
                SizedBox(
                  height: 32,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _regions.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, idx) {
                      final summary = _regions[idx];
                      final selected =
                          _selectedRegionCode == summary.region.code;
                      final label =
                          summary.region.code == NodeRegion.all.code
                              ? "${summary.region.flag} ${tcontext.chain_proxy.all_nodes} (${summary.count})"
                              : "${summary.region.flag} ${summary.region.getDisplayName(isZh)} (${summary.count})";
                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setState(
                            () => _selectedRegionCode = summary.region.code,
                          );
                        },
                        child: AnimatedContainer(
                          duration: ThemeDefine.durationMicro,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: selected
                                ? ThemeDefine.kColorBlue
                                : (isDark
                                    ? ThemeDefine.kColorDarkInner
                                    : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: selected
                                  ? ThemeDefine.kColorBlue
                                  : (isDark
                                      ? ThemeDefine.kColorDarkBorder
                                      : const Color(0xFFE2E8F0)),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: selected
                                  ? Colors.white
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.8),
                              fontFamilyFallback: Platform.isWindows
                                  ? const ['Emoji']
                                  : null,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Text(
                          tcontext.chain_proxy.empty_tip,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (context, index) {
                          final node = filtered[index];
                          final isSelected =
                              node.name == widget.currentSelected;
                          final isDisabled =
                              widget.disabledNodes.contains(node.name);
                          final isGroup =
                              ClashProtocolType.isGroupType(node.type);
                          final delay =
                              widget.liveDelays[node.name] ?? node.delay;
                          final flag = NodeRegionHelper.getFlag(node.name);
                          final cleanName =
                              NodeRegionHelper.getDisplayNameWithoutFlag(
                            node.name,
                          );

                          return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: isDisabled
                                ? null
                                : () => Navigator.pop(context, node.name),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 9,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? ThemeDefine.kColorBlue.withValues(
                                        alpha: isDark ? 0.18 : 0.08,
                                      )
                                    : (isDark
                                        ? ThemeDefine.kColorDarkInner
                                        : const Color(0xFFF8FAFC)),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: isSelected
                                      ? ThemeDefine.kColorBlue
                                          .withValues(alpha: 0.6)
                                      : (isDark
                                          ? ThemeDefine.kColorDarkBorder
                                          : const Color(0xFFE2E8F0)),
                                  width: isSelected ? 1.2 : 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    flag,
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontFamilyFallback: Platform.isWindows
                                          ? const ['Emoji']
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cleanName.isNotEmpty
                                              ? cleanName
                                              : node.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: isSelected
                                                ? FontWeight.w700
                                                : FontWeight.w600,
                                            color: isDisabled
                                                ? Colors.grey
                                                : (isSelected
                                                    ? ThemeDefine.kColorBlue
                                                    : null),
                                            fontFamilyFallback:
                                                Platform.isWindows
                                                    ? const ['Emoji']
                                                    : null,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                                vertical: 1,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isGroup
                                                    ? Colors.purple.withValues(
                                                        alpha: isDark
                                                            ? 0.22
                                                            : 0.12,
                                                      )
                                                    : (isDark
                                                        ? Colors.white10
                                                        : const Color(
                                                            0xFFE2E8F0,
                                                          )),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                node.type.toUpperCase(),
                                                style: TextStyle(
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: isGroup
                                                      ? Colors.purple[
                                                          isDark ? 200 : 700]
                                                      : theme
                                                          .colorScheme.onSurface
                                                          .withValues(
                                                          alpha: 0.65,
                                                        ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (delay != null && delay > 0) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: (delay < 800
                                                ? ThemeDefine.kColorGreenBright
                                                : ThemeDefine.kColorAmber)
                                            .withValues(alpha: 0.14),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        "$delay ms",
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontFamily: 'monospace',
                                          fontWeight: FontWeight.w700,
                                          color: delay < 800
                                              ? ThemeDefine.kColorGreenBright
                                              : ThemeDefine.kColorAmber,
                                        ),
                                      ),
                                    ),
                                  ],
                                  if (isSelected) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: ThemeDefine.kColorBlue,
                                      size: 19,
                                    ),
                                  ] else if (isDisabled) ...[
                                    const SizedBox(width: 6),
                                    const Icon(
                                      Icons.block_rounded,
                                      color: Colors.grey,
                                      size: 16,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
