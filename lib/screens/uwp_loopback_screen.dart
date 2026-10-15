// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:wmimo/app/utils/uwp_loopback_helper.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';

class UwpLoopbackScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "UwpLoopbackScreen");
  }

  const UwpLoopbackScreen({super.key});

  @override
  State<UwpLoopbackScreen> createState() => _UwpLoopbackScreenState();
}

class _UwpLoopbackScreenState extends LasyRenderingState<UwpLoopbackScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UwpAppInfo> _allApps = [];
  bool _loading = true;
  bool _applying = false;
  String _filterType = "all"; // all, common, exempt, not_exempt
  String _searchKeyword = "";

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    setState(() => _loading = true);
    final apps = await UwpLoopbackHelper.loadInstalledUwpApps();
    if (!mounted) return;
    setState(() {
      _allApps = apps;
      _loading = false;
    });
  }

  Future<void> _applyExemptions() async {
    setState(() => _applying = true);
    final tcontext = Translations.of(context);
    final targetSids = _allApps.where((a) => a.isExempt).map((a) => a.sid).toSet();
    final ok = await UwpLoopbackHelper.applyExemptions(
      allApps: _allApps,
      targetExemptSids: targetSids,
    );
    if (!mounted) return;
    setState(() => _applying = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(ok ? tcontext.meta.uwpApplySuccess : tcontext.meta.errorPrompt),
        backgroundColor: ok ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorRed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _exemptAllCommon() {
    setState(() {
      for (var app in _allApps) {
        if (app.isCommon) {
          app.isExempt = true;
        }
      }
    });
  }

  void _selectAll(bool select) {
    final currentFiltered = _getFilteredApps();
    setState(() {
      for (var app in currentFiltered) {
        app.isExempt = select;
      }
    });
  }

  List<UwpAppInfo> _getFilteredApps() {
    var list = _allApps;
    if (_filterType == "common") {
      list = list.where((a) => a.isCommon).toList();
    } else if (_filterType == "exempt") {
      list = list.where((a) => a.isExempt).toList();
    } else if (_filterType == "not_exempt") {
      list = list.where((a) => !a.isExempt).toList();
    }

    if (_searchKeyword.isNotEmpty) {
      final kw = _searchKeyword.toLowerCase();
      list = list.where((a) {
        return a.displayName.toLowerCase().contains(kw) ||
            a.moniker.toLowerCase().contains(kw) ||
            a.sid.toLowerCase().contains(kw);
      }).toList();
    }
    return list;
  }

  IconData _getAppIcon(UwpAppInfo app) {
    final lower = app.moniker.toLowerCase();
    if (lower.contains('store')) return Icons.shopping_bag_rounded;
    if (lower.contains('xbox') || lower.contains('game')) return Icons.sports_esports_rounded;
    if (lower.contains('edge')) return Icons.public_rounded;
    if (lower.contains('terminal')) return Icons.terminal_rounded;
    if (lower.contains('outlook') || lower.contains('mail')) return Icons.mail_rounded;
    if (lower.contains('photos')) return Icons.photo_rounded;
    if (lower.contains('calculator')) return Icons.calculate_rounded;
    return Icons.window_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tcontext = Translations.of(context);
    final filtered = _getFilteredApps();

    final totalCount = _allApps.length;
    final commonCount = _allApps.where((a) => a.isCommon).length;
    final exemptCount = _allApps.where((a) => a.isExempt).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tcontext.meta.uwpLoopback,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        actions: [
          IconButton(
            tooltip: tcontext.meta.refresh,
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loading ? null : _loadApps,
          ),
          TextButton.icon(
            onPressed: (_loading || _applying) ? null : _applyExemptions,
            icon: _applying
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.check_circle_rounded, size: 18),
            label: Text(tcontext.meta.save),
            style: TextButton.styleFrom(
              foregroundColor: ThemeDefine.kColorGreenBright,
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.2),
                  width: 0.8,
                ),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "${tcontext.meta.search} (App / Moniker)",
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 18,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  suffixIcon: _searchKeyword.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchKeyword = "");
                          },
                          child: const Icon(Icons.clear, size: 16),
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                style: const TextStyle(fontSize: 13),
                onChanged: (val) => setState(() => _searchKeyword = val.trim()),
              ),
            ),
          ),

          // Filter Segment Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _buildFilterChip("all", "${tcontext.meta.all} ($totalCount)"),
                const SizedBox(width: 6),
                _buildFilterChip("common", "${tcontext.meta.common} ($commonCount)"),
                const SizedBox(width: 6),
                _buildFilterChip("exempt", "${tcontext.meta.exempted} ($exemptCount)"),
                const SizedBox(width: 6),
                _buildFilterChip("not_exempt", "${tcontext.meta.notExempted} (${totalCount - exemptCount})"),
              ],
            ),
          ),

          // Action Shortcuts Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      side: BorderSide(color: ThemeDefine.kColorBlue.withValues(alpha: 0.5)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    icon: const Icon(Icons.auto_awesome_rounded, size: 16, color: ThemeDefine.kColorBlue),
                    label: Text(
                      tcontext.meta.uwpExemptAllCommon,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: ThemeDefine.kColorBlue),
                      overflow: TextOverflow.ellipsis,
                    ),
                    onPressed: _loading ? null : _exemptAllCommon,
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _loading ? null : () => _selectAll(true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(tcontext.meta.selectAll, style: const TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _loading ? null : () => _selectAll(false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(tcontext.meta.deselectAll, style: const TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // App List
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : filtered.isEmpty
                    ? Center(
                        child: Text(
                          tcontext.meta.noFilterResults,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) => const Divider(height: 1, indent: 64),
                        itemBuilder: (context, index) {
                          final app = filtered[index];
                          return CheckboxListTile(
                            secondary: Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: app.isExempt
                                    ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.15)
                                    : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getAppIcon(app),
                                size: 20,
                                color: app.isExempt
                                    ? ThemeDefine.kColorGreenBright
                                    : (isDark ? Colors.white70 : Colors.black87),
                              ),
                            ),
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    app.displayName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: app.isCommon ? FontWeight.bold : FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (app.isCommon) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      tcontext.meta.common,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: ThemeDefine.kColorBlue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Text(
                              app.moniker,
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            value: app.isExempt,
                            activeColor: ThemeDefine.kColorGreenBright,
                            onChanged: (val) {
                              setState(() {
                                app.isExempt = val ?? false;
                              });
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String type, String label) {
    final theme = Theme.of(context);
    final isSelected = _filterType == type;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => setState(() => _filterType = type),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected
              ? ThemeDefine.kColorBlue.withValues(alpha: 0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? ThemeDefine.kColorBlue
                : theme.dividerColor.withValues(alpha: 0.4),
            width: 0.8,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? ThemeDefine.kColorBlue : null,
          ),
        ),
      ),
    );
  }
}
