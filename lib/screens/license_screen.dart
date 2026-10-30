import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class LicensePackageGroup {
  final String packageName;
  final List<LicenseEntry> entries;

  const LicensePackageGroup({
    required this.packageName,
    required this.entries,
  });

  int get licenseCount => entries.length;
}

class LicenseScreen extends StatefulWidget {
  final String? applicationName;
  final String? applicationVersion;
  final String? applicationLegalese;
  final List<LicensePackageGroup>? initialPackages;

  const LicenseScreen({
    super.key,
    this.applicationName,
    this.applicationVersion,
    this.applicationLegalese,
    this.initialPackages,
  });

  static RouteSettings routSettings() {
    return const RouteSettings(name: 'LicenseScreen');
  }

  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _packageScrollController = ScrollController();
  final ScrollController _detailScrollController = ScrollController();

  List<LicensePackageGroup> _allPackages = [];
  List<LicensePackageGroup> _filteredPackages = [];
  String? _selectedPackageName;
  bool _isLoading = true;
  bool _copiedFeedback = false;
  Timer? _copyResetTimer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    if (widget.initialPackages != null) {
      _allPackages = List<LicensePackageGroup>.from(widget.initialPackages!);
      _filteredPackages = _allPackages;
      if (_filteredPackages.isNotEmpty) {
        _selectedPackageName = _filteredPackages.first.packageName;
      }
      _isLoading = false;
    } else {
      _loadLicenses();
    }
  }

  @override
  void dispose() {
    _copyResetTimer?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _packageScrollController.dispose();
    _detailScrollController.dispose();
    super.dispose();
  }

  Future<void> _loadLicenses() async {
    final Map<String, List<LicenseEntry>> packageMap =
        <String, List<LicenseEntry>>{};

    try {
      await for (final LicenseEntry entry in LicenseRegistry.licenses) {
        for (final String pkg in entry.packages) {
          packageMap.putIfAbsent(pkg, () => <LicenseEntry>[]).add(entry);
        }
      }
    } catch (_) {}

    final List<LicensePackageGroup> groups = packageMap.entries
        .map(
          (e) => LicensePackageGroup(
            packageName: e.key,
            entries: e.value,
          ),
        )
        .toList()
      ..sort(
        (a, b) => a.packageName.toLowerCase().compareTo(
              b.packageName.toLowerCase(),
            ),
      );

    if (!mounted) return;
    setState(() {
      _allPackages = groups;
      _applyFilter(_searchController.text);
      _isLoading = false;
    });
  }

  void _onSearchChanged() {
    if (!mounted) return;
    setState(() {
      _applyFilter(_searchController.text);
    });
  }

  void _applyFilter(String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) {
      _filteredPackages = _allPackages;
    } else {
      _filteredPackages = _allPackages
          .where((pkg) => pkg.packageName.toLowerCase().contains(query))
          .toList();
    }

    if (_filteredPackages.isEmpty) {
      _selectedPackageName = null;
    } else if (_selectedPackageName == null ||
        !_filteredPackages.any((p) => p.packageName == _selectedPackageName)) {
      _selectedPackageName = _filteredPackages.first.packageName;
    }
  }

  LicensePackageGroup? get _selectedGroup {
    if (_selectedPackageName == null) return null;
    for (final group in _filteredPackages) {
      if (group.packageName == _selectedPackageName) {
        return group;
      }
    }
    return _filteredPackages.isNotEmpty ? _filteredPackages.first : null;
  }

  void _selectPackage(String packageName, {required bool isNarrow}) {
    HapticFeedback.selectionClick();
    setState(() {
      _selectedPackageName = packageName;
      _copiedFeedback = false;
    });
    if (_detailScrollController.hasClients) {
      _detailScrollController.jumpTo(0);
    }
    if (isNarrow) {
      final group = _selectedGroup;
      if (group != null) {
        _showNarrowPackageDetailSheet(context, group);
      }
    }
  }

  Future<void> _copySelectedLicense(LicensePackageGroup group) async {
    HapticFeedback.selectionClick();
    final buffer = StringBuffer();
    buffer.writeln('Package: ${group.packageName}');
    buffer.writeln('Licenses: ${group.licenseCount}');
    buffer.writeln('=' * 48);

    for (var i = 0; i < group.entries.length; i++) {
      if (i > 0) {
        buffer.writeln('\n${'-' * 48}\n');
      }
      for (final paragraph in group.entries[i].paragraphs) {
        buffer.writeln(paragraph.text);
        buffer.writeln();
      }
    }

    await Clipboard.setData(ClipboardData(text: buffer.toString().trimRight()));
    if (!mounted) return;
    setState(() {
      _copiedFeedback = true;
    });
    _copyResetTimer?.cancel();
    _copyResetTimer = Timer(const Duration(milliseconds: 1600), () {
      if (mounted) {
        setState(() {
          _copiedFeedback = false;
        });
      }
    });
  }

  void _showNarrowPackageDetailSheet(
    BuildContext context,
    LicensePackageGroup group,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor:
          isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: SizedBox(
            height: MediaQuery.of(sheetCtx).size.height * 0.82,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: _buildDetailContent(sheetCtx, group, isDark: isDark),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedGroup = _selectedGroup;

    return Scaffold(
      appBar: WmimoAppBar(
        title: tcontext.meta.openSourceLicense,
        badge: _isLoading
            ? null
            : Container(
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
                  '${_filteredPackages.length}/${_allPackages.length}',
                  style: const TextStyle(
                    color: ThemeDefine.kColorBlue,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
        actions: [
          if (selectedGroup != null)
            IconButton(
              tooltip: MaterialLocalizations.of(context).copyButtonLabel,
              onPressed: () => _copySelectedLicense(selectedGroup),
              icon: Icon(
                _copiedFeedback
                    ? Icons.check_rounded
                    : Icons.content_copy_rounded,
                size: 18,
                color: _copiedFeedback ? ThemeDefine.kColorGreenBright : null,
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
          child: Column(
            children: [
              _buildAppSummaryCard(context, isDark),
              const SizedBox(height: 12),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isNarrow = constraints.maxWidth < 640;
                    if (isNarrow) {
                      return _buildPackageDirectoryCard(
                        context,
                        isDark: isDark,
                        isNarrow: true,
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 280,
                          child: _buildPackageDirectoryCard(
                            context,
                            isDark: isDark,
                            isNarrow: false,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDetailCard(
                            context,
                            selectedGroup: selectedGroup,
                            isDark: isDark,
                          ),
                        ),
                      ],
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

  Widget _buildAppSummaryCard(BuildContext context, bool isDark) {
    final theme = Theme.of(context);
    final appName = widget.applicationName ?? AppUtils.getName();
    final appVersion =
        widget.applicationVersion ?? AppUtils.getFormattedVersion();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color:
            isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: Image.asset(
                  'assets/images/app_icon_256.png',
                  width: 44,
                  height: 44,
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                  errorBuilder: (_, __, ___) => Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: ThemeDefine.kColorBlue,
                      size: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        appName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: isDark ? 0.1 : 0.06,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          appVersion,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.72),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'GNU General Public License v3.0 (GPL-3.0-or-later)',
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              _buildScopeBadge(
                context,
                label: 'Wmimo',
                license: 'GPL-3.0',
                accent: ThemeDefine.kColorBlue,
                isDark: isDark,
              ),
              _buildScopeBadge(
                context,
                label: 'Mihomo Core',
                license: 'GPL-3.0',
                accent: ThemeDefine.kColorGreenBright,
                isDark: isDark,
              ),
              _buildScopeBadge(
                context,
                label: 'Rust Crates',
                license: 'MIT / Apache-2.0',
                accent: ThemeDefine.kColorAmber,
                isDark: isDark,
              ),
              _buildScopeBadge(
                context,
                label: 'Third-Party',
                license: 'BSD / MIT / Apache-2.0',
                accent: const Color(0xFF8B5CF6),
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScopeBadge(
    BuildContext context, {
    required String label,
    required String license,
    required Color accent,
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkInner : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : const Color(0xFFE2E8F0),
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
              color: accent,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11.5,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.62),
            ),
          ),
          Text(
            license,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageDirectoryCard(
    BuildContext context, {
    required bool isDark,
    required bool isNarrow,
  }) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color:
            isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
            child: WmimoSearchBar(
              controller: _searchController,
              hintText: tcontext.meta.search,
              badgeText:
                  '${_filteredPackages.length}/${_allPackages.length}',
            ),
          ),
          Divider(
            height: 1,
            thickness: 0.8,
            color: isDark
                ? ThemeDefine.kColorDarkBorder
                : const Color(0xFFE2E8F0),
          ),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    ),
                  )
                : _filteredPackages.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 32,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.35),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                tcontext.meta.noFilterResults,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _packageScrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        itemCount: _filteredPackages.length,
                        itemBuilder: (context, index) {
                          final pkg = _filteredPackages[index];
                          final isSelected = !isNarrow &&
                              pkg.packageName == _selectedPackageName;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => _selectPackage(
                                  pkg.packageName,
                                  isNarrow: isNarrow,
                                ),
                                child: AnimatedContainer(
                                  duration: ThemeDefine.durationMicro,
                                  curve: ThemeDefine.kCurveStandard,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 9,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? ThemeDefine.kColorBlue.withValues(
                                            alpha: isDark ? 0.16 : 0.10,
                                          )
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? ThemeDefine.kColorBlue.withValues(
                                              alpha: isDark ? 0.45 : 0.35,
                                            )
                                          : Colors.transparent,
                                      width: 0.9,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      AnimatedContainer(
                                        duration: ThemeDefine.durationMicro,
                                        width: 3,
                                        height: isSelected ? 16 : 0,
                                        margin: EdgeInsets.only(
                                          right: isSelected ? 8 : 0,
                                        ),
                                        decoration: BoxDecoration(
                                          color: ThemeDefine.kColorBlue,
                                          borderRadius:
                                              BorderRadius.circular(2),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          pkg.packageName,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.w500,
                                            color: isSelected
                                                ? ThemeDefine.kColorBlue
                                                : theme.colorScheme.onSurface
                                                    .withValues(alpha: 0.88),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? ThemeDefine.kColorBlue
                                                  .withValues(
                                                  alpha: isDark ? 0.25 : 0.16,
                                                )
                                              : theme.colorScheme.onSurface
                                                  .withValues(
                                                  alpha: isDark ? 0.08 : 0.05,
                                                ),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${pkg.licenseCount}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? ThemeDefine.kColorBlue
                                                : theme.colorScheme.onSurface
                                                    .withValues(alpha: 0.55),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context, {
    required LicensePackageGroup? selectedGroup,
    required bool isDark,
  }) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color:
            isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: _isLoading
          ? const Center(
              child: SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 2.4),
              ),
            )
          : selectedGroup == null
              ? Center(
                  child: Text(
                    tcontext.meta.noFilterResults,
                    style: TextStyle(
                      fontSize: 13.5,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                )
              : AnimatedSwitcher(
                  duration: ThemeDefine.durationMicro,
                  switchInCurve: ThemeDefine.kCurveStandard,
                  switchOutCurve: ThemeDefine.kCurveStandard,
                  child: KeyedSubtree(
                    key: ValueKey<String>(selectedGroup.packageName),
                    child: _buildDetailContent(
                      context,
                      selectedGroup,
                      isDark: isDark,
                    ),
                  ),
                ),
    );
  }

  Widget _buildDetailContent(
    BuildContext context,
    LicensePackageGroup group, {
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final localizations = MaterialLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: ThemeDefine.kColorBlue.withValues(
                  alpha: isDark ? 0.16 : 0.10,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.inventory_2_outlined,
                size: 19,
                color: ThemeDefine.kColorBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.packageName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    localizations.licensesPackageDetailText(group.licenseCount),
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.58),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Tooltip(
              message: localizations.copyButtonLabel,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => _copySelectedLicense(group),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: _copiedFeedback
                        ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.15)
                        : (isDark
                            ? ThemeDefine.kColorDarkElevated
                            : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _copiedFeedback
                          ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.4)
                          : (isDark
                              ? ThemeDefine.kColorDarkBorder
                              : const Color(0xFFE2E8F0)),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _copiedFeedback
                            ? Icons.check_rounded
                            : Icons.content_copy_rounded,
                        size: 14,
                        color: _copiedFeedback
                            ? ThemeDefine.kColorGreenBright
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.78),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        localizations.copyButtonLabel,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _copiedFeedback
                              ? ThemeDefine.kColorGreenBright
                              : theme.colorScheme.onSurface
                                  .withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(
          height: 1,
          thickness: 0.8,
          color:
              isDark ? ThemeDefine.kColorDarkBorder : const Color(0xFFE2E8F0),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: SelectionArea(
            child: ListView.separated(
              controller: _detailScrollController,
              itemCount: group.entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final entry = group.entries[index];
                final paragraphs = entry.paragraphs.toList();
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
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
                      if (group.entries.length > 1) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: ThemeDefine.kColorBlue.withValues(
                              alpha: isDark ? 0.16 : 0.10,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'License #${index + 1}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: ThemeDefine.kColorBlue,
                            ),
                          ),
                        ),
                      ],
                      for (var pIndex = 0;
                          pIndex < paragraphs.length;
                          pIndex++) ...[
                        if (pIndex > 0) const SizedBox(height: 10),
                        _buildLicenseParagraph(
                          context,
                          paragraphs[pIndex],
                          isDark: isDark,
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLicenseParagraph(
    BuildContext context,
    LicenseParagraph paragraph, {
    required bool isDark,
  }) {
    final theme = Theme.of(context);
    final isCentered = paragraph.indent == LicenseParagraph.centeredIndent;
    final leftIndent =
        paragraph.indent > 0 ? paragraph.indent * 16.0 : 0.0;

    return Padding(
      padding: EdgeInsets.only(left: leftIndent),
      child: Align(
        alignment: isCentered ? Alignment.center : Alignment.centerLeft,
        child: Text(
          paragraph.text,
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
          style: TextStyle(
            fontSize: 12.8,
            height: 1.58,
            fontWeight: isCentered ? FontWeight.w600 : FontWeight.w400,
            color: theme.colorScheme.onSurface.withValues(
              alpha: isCentered ? 0.92 : 0.82,
            ),
          ),
        ),
      ),
    );
  }
}
