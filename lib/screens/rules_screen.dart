// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';

class RulesScreen extends StatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "RulesScreen");
  }

  const RulesScreen({super.key});

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> with AfterLayoutMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _loading = false;
  String _searchKeyword = "";
  String _selectedType = "ALL";
  List<Map<String, dynamic>> _rules = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchKeyword = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _fetchRules();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchRules() async {
    if (mounted) {
      setState(() {
        _loading = true;
      });
    }

    final started = await VPNService.getStarted();
    if (started) {
      final result = await ClashHttpApi.getRules();
      if (result.data != null && result.data!.isNotEmpty) {
        if (mounted) {
          setState(() {
            _rules = result.data!;
            _loading = false;
          });
        }
        return;
      }
    }

    // Fallback: load directly from active profile YAML
    final profileRules = await ProxyNodeLoader.loadCurrentProfileRules();
    if (!mounted) return;

    setState(() {
      _rules = profileRules;
      _loading = false;
    });
  }

  List<Map<String, dynamic>> get _filteredRules {
    return _rules.where((r) {
      final type = (r['type'] ?? "").toString();
      final payload = (r['payload'] ?? "").toString();
      final proxy = (r['proxy'] ?? "").toString();

      if (_selectedType != "ALL") {
        if (!type.toUpperCase().contains(_selectedType.toUpperCase())) {
          return false;
        }
      }

      if (_searchKeyword.isEmpty) return true;

      return type.toLowerCase().contains(_searchKeyword) ||
          payload.toLowerCase().contains(_searchKeyword) ||
          proxy.toLowerCase().contains(_searchKeyword);
    }).toList();
  }

  Color _getRuleTypeColor(String type) {
    final upper = type.toUpperCase();
    if (upper.contains("DOMAIN")) {
      return ThemeDefine.kColorBlue;
    } else if (upper.contains("IP") || upper.contains("CIDR")) {
      return Colors.purpleAccent;
    } else if (upper.contains("GEO")) {
      return Colors.teal;
    } else if (upper.contains("RULE-SET") || upper.contains("RULE_SET")) {
      return Colors.indigoAccent;
    } else if (upper.contains("MATCH")) {
      return Colors.orange;
    }
    return Colors.blueGrey;
  }

  Color _getProxyColor(String proxy) {
    final upper = proxy.toUpperCase();
    if (upper == "DIRECT") {
      return ThemeDefine.kColorGreenBright;
    } else if (upper == "REJECT") {
      return Colors.redAccent;
    }
    return ThemeDefine.kColorBlue;
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = _filteredRules;

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            children: [
              // Header
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
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            tcontext.meta.rules,
                            style: const TextStyle(
                              fontWeight: ThemeConfig.kFontWeightTitle,
                              fontSize: ThemeConfig.kFontSizeTitle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeDefine.kColorBlue.withValues(
                                alpha: isDark ? 0.25 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${filtered.length}/${_rules.length}",
                              style: const TextStyle(
                                color: ThemeDefine.kColorBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Tooltip(
                      message: tcontext.meta.refresh,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _fetchRules,
                        child: SizedBox(
                          width: 36,
                          height: 30,
                          child: _loading
                              ? const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : const Icon(Icons.refresh, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Search bar and type filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: tcontext.meta.searchRules,
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 9),
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildTypeChip("ALL"),
                          const SizedBox(width: 6),
                          _buildTypeChip("DOMAIN"),
                          const SizedBox(width: 6),
                          _buildTypeChip("IP-CIDR"),
                          const SizedBox(width: 6),
                          _buildTypeChip("GEOIP"),
                          const SizedBox(width: 6),
                          _buildTypeChip("RULE-SET"),
                          const SizedBox(width: 6),
                          _buildTypeChip("MATCH"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Rules list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.alt_route_rounded,
                              size: 52,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _rules.isEmpty
                                  ? tcontext.meta.none
                                  : tcontext.meta.noFilterResults,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final rule = filtered[index];
                          return _buildRuleItem(rule, index + 1);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeChip(String type) {
    final isSelected = _selectedType == type;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isSelected
          ? ThemeDefine.kColorBlue
          : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            _selectedType = type;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            type,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRuleItem(Map<String, dynamic> rule, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final type = (rule['type'] ?? "").toString();
    final payload = (rule['payload'] ?? "").toString();
    final proxy = (rule['proxy'] ?? "").toString();
    final typeColor = _getRuleTypeColor(type);
    final proxyColor = _getProxyColor(proxy);

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151D2E) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Index badge
          Text(
            "#$index",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
            ),
          ),
          const SizedBox(width: 8),
          // Rule type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: typeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              type,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: typeColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Rule Payload
          Expanded(
            child: Text(
              payload.isNotEmpty ? payload : "(none)",
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                fontFamily: 'monospace',
                color: payload.isNotEmpty
                    ? null
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          // Destination Proxy
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: proxyColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              proxy,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: proxyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
