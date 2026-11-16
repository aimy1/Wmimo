import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wmimo/app/modules/chain_proxy_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_define.dart';

class ChainProxyEditDialog extends StatefulWidget {
  final ChainProxyItem? initialItem;
  final List<String> availableNodes;

  const ChainProxyEditDialog({
    super.key,
    this.initialItem,
    required this.availableNodes,
  });

  static Future<ChainProxyItem?> show(
    BuildContext context, {
    ChainProxyItem? initialItem,
    required List<String> availableNodes,
  }) {
    return showDialog<ChainProxyItem>(
      context: context,
      barrierDismissible: true,
      builder: (context) => ChainProxyEditDialog(
        initialItem: initialItem,
        availableNodes: availableNodes,
      ),
    );
  }

  @override
  State<ChainProxyEditDialog> createState() => _ChainProxyEditDialogState();
}

class _ChainProxyEditDialogState extends State<ChainProxyEditDialog> {
  late TextEditingController _nameController;
  String? _selectedHop1;
  String? _selectedHop2;
  bool _customName = false;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(text: item?.name ?? '');
    _selectedHop1 = item?.hop1.isNotEmpty == true && widget.availableNodes.contains(item!.hop1)
        ? item.hop1
        : (widget.availableNodes.isNotEmpty ? widget.availableNodes.first : null);

    _selectedHop2 = item?.hop2.isNotEmpty == true && widget.availableNodes.contains(item!.hop2)
        ? item.hop2
        : (widget.availableNodes.length > 1 ? widget.availableNodes[1] : null);

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

  void _generateDefaultName() {
    if (_customName) return;
    if (_selectedHop1 != null && _selectedHop2 != null) {
      _nameController.text = "🔗 $_selectedHop1 ➔ $_selectedHop2";
    }
  }

  Future<String?> _showNodePicker(String title, String? currentSelected, String? excludeNode) async {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final searchController = TextEditingController();
    List<String> filteredList = widget.availableNodes.where((n) => n != excludeNode).toList();

    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: tcontext.meta.searchProxies,
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: isDark ? Colors.white24 : Colors.black12,
                          ),
                        ),
                        filled: true,
                        fillColor: isDark ? Colors.grey[900] : const Color(0xFFF1F5F9),
                      ),
                      onChanged: (query) {
                        setModalState(() {
                          filteredList = widget.availableNodes
                              .where((n) =>
                                  n != excludeNode &&
                                  n.toLowerCase().contains(query.trim().toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: filteredList.isEmpty
                          ? Center(
                              child: Text(
                                tcontext.chain_proxy.empty_tip,
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) {
                                final node = filteredList[index];
                                final isSelected = node == currentSelected;
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  title: Text(
                                    node,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                      color: isSelected ? ThemeDefine.kColorBlue : null,
                                      fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
                                    ),
                                  ),
                                  trailing: isSelected
                                      ? const Icon(Icons.check_circle_rounded, color: ThemeDefine.kColorBlue, size: 20)
                                      : null,
                                  onTap: () => Navigator.pop(ctx, node),
                                );
                              },
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

  void _onSave() {
    final tcontext = Translations.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      DialogUtils.showAlertDialog(context, tcontext.chain_proxy.name_empty_warning);
      return;
    }
    if (_selectedHop1 == null || _selectedHop1!.isEmpty) {
      DialogUtils.showAlertDialog(context, tcontext.chain_proxy.hop1_empty_warning);
      return;
    }
    if (_selectedHop2 == null || _selectedHop2!.isEmpty) {
      DialogUtils.showAlertDialog(context, tcontext.chain_proxy.hop2_empty_warning);
      return;
    }
    if (_selectedHop1 == _selectedHop2) {
      DialogUtils.showAlertDialog(context, tcontext.chain_proxy.hop_same_warning);
      return;
    }

    final item = ChainProxyItem(
      id: widget.initialItem?.id,
      name: name,
      hop1: _selectedHop1!,
      hop2: _selectedHop2!,
      enabled: widget.initialItem?.enabled ?? true,
      delay: widget.initialItem?.delay,
    );

    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.link_rounded, color: ThemeDefine.kColorBlue, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.initialItem == null
                          ? "${tcontext.chain_proxy.add} (Beta)"
                          : "${tcontext.chain_proxy.edit} (Beta)",
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: tcontext.chain_proxy.name,
                  hintText: tcontext.chain_proxy.name_hint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                ),
                onChanged: (_) => _customName = true,
              ),
              const SizedBox(height: 16),

              // Topology Diagram Preview Card
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
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
                        const Icon(Icons.hub_outlined, size: 16, color: ThemeDefine.kColorBlue),
                        const SizedBox(width: 6),
                        Text(
                          tcontext.chain_proxy.preview,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _buildTopologyBadge(tcontext.chain_proxy.local_device, Colors.grey, isDark),
                        const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey),
                        Expanded(
                          child: _buildTopologyBadge(
                            _selectedHop1 ?? tcontext.chain_proxy.hop1_placeholder,
                            Colors.blue,
                            isDark,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey),
                        Expanded(
                          child: _buildTopologyBadge(
                            _selectedHop2 ?? tcontext.chain_proxy.hop2_placeholder,
                            Colors.green,
                            isDark,
                          ),
                        ),
                        const Icon(Icons.arrow_forward_rounded, size: 14, color: Colors.grey),
                        _buildTopologyBadge(tcontext.chain_proxy.internet, Colors.orange, isDark),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Hop 1 Selector
              Text(
                tcontext.chain_proxy.hop1,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () async {
                  final selected = await _showNodePicker(
                    tcontext.chain_proxy.hop1_select_title,
                    _selectedHop1,
                    _selectedHop2,
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedHop1 = selected;
                      _generateDefaultName();
                    });
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? Colors.white24 : Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.vpn_key_rounded, size: 18, color: Colors.blue),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedHop1 ?? tcontext.chain_proxy.select_node,
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedHop1 == null ? Colors.grey : null,
                            fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Hop 2 Selector
              Text(
                tcontext.chain_proxy.hop2,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              InkWell(
                onTap: () async {
                  final selected = await _showNodePicker(
                    tcontext.chain_proxy.hop2_select_title,
                    _selectedHop2,
                    _selectedHop1,
                  );
                  if (selected != null) {
                    setState(() {
                      _selectedHop2 = selected;
                      _generateDefaultName();
                    });
                  }
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: isDark ? Colors.white24 : Colors.black26),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.public_rounded, size: 18, color: Colors.green),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _selectedHop2 ?? tcontext.chain_proxy.select_node,
                          style: TextStyle(
                            fontSize: 14,
                            color: _selectedHop2 == null ? Colors.grey : null,
                            fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Action Buttons
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
