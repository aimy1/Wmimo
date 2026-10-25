// ignore_for_file: unused_catch_stack

import 'package:android_package_manager/android_package_manager.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/package_manager_android.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/group_item_creator.dart';
import 'package:wmimo/screens/group_item_options.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:wmimo/screens/widgets/text_field.dart';

class PerAppAndroidScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "PerAppAndroidScreen");
  }

  const PerAppAndroidScreen({super.key});

  @override
  State<PerAppAndroidScreen> createState() => _PerAppAndroidScreenState();
}

class _PerAppAndroidScreenState
    extends LasyRenderingState<PerAppAndroidScreen>
    with WidgetsBindingObserver {
  bool _loading = true;
  final List<PackageInfoEx> _applicationInfoList = [];
  final _searchController = TextEditingController();
  List<PackageInfoEx> _searchedData = [];
  bool _needPermission = false;
  bool _hasAutoRequestedPermission = false;
  String _selectedCategory = 'all'; // 'all', 'user', 'system', 'selected'

  @override
  void initState() {
    _loading = true;
    WidgetsBinding.instance.addObserver(this);
    getInstalledPackages();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    ClashSettingManager.save();
    SettingManager.save();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _needPermission) {
      getInstalledPackages();
    }
  }

  bool _isSystemApp(PackageInfoEx app) {
    return app.info.applicationInfo != null &&
        (app.info.applicationInfo!.flags &
                PackageManagerAndroid.kAndroidFlagSystem !=
            0);
  }

  int _getSelectedCount() {
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    return perapp.PackageIds?.length ?? 0;
  }

  void _applyFilter() {
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    final search = _searchController.text.trim().toLowerCase();
    final selectedSet = perapp.PackageIds?.toSet() ?? {};

    _searchedData = _applicationInfoList.where((app) {
      if (_selectedCategory == 'user' && _isSystemApp(app)) {
        return false;
      }
      if (_selectedCategory == 'system' && !_isSystemApp(app)) {
        return false;
      }
      if (_selectedCategory == 'selected' &&
          !selectedSet.contains(app.info.packageName)) {
        return false;
      }

      if (search.isNotEmpty) {
        String name = app.name.toLowerCase();
        String pkgName = (app.info.packageName ?? "").toLowerCase();
        if (!name.contains(search) && !pkgName.contains(search)) {
          return false;
        }
      }
      return true;
    }).toList();

    setState(() {});
  }

  void _loadSearch(String? textVal) {
    _applyFilter();
  }

  void _clearSearch() {
    _searchController.clear();
    _applyFilter();
  }

  void _selectAllCurrent() {
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    perapp.PackageIds ??= [];
    for (var app in _searchedData) {
      final pkg = app.info.packageName;
      if (pkg != null && !perapp.PackageIds!.contains(pkg)) {
        perapp.PackageIds!.add(pkg);
      }
    }
    ClashSettingManager.save();
    _applyFilter();
  }

  void _deselectAllCurrent() {
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    perapp.PackageIds ??= [];
    final toRemove = _searchedData
        .map((e) => e.info.packageName)
        .whereType<String>()
        .toSet();
    perapp.PackageIds!.removeWhere((pkg) => toRemove.contains(pkg));
    ClashSettingManager.save();
    _applyFilter();
  }

  void _invertSelectionCurrent() {
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    perapp.PackageIds ??= [];
    final currentSelected = perapp.PackageIds!.toSet();
    for (var app in _searchedData) {
      final pkg = app.info.packageName;
      if (pkg != null) {
        if (currentSelected.contains(pkg)) {
          perapp.PackageIds!.remove(pkg);
        } else {
          perapp.PackageIds!.add(pkg);
        }
      }
    }
    ClashSettingManager.save();
    _applyFilter();
  }

  Future<void> getInstalledPackages() async {
    _applicationInfoList.clear();
    _searchedData.clear();
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    _loading = true;
    setState(() {});
    try {
      var packages = await PackageManagerAndroid.getInstalledPackages(
        onValid: (PackageInfo info) {
          if (info.packageName == AppUtils.getId()) {
            return false;
          }
          return true;
        },
      );

      // If empty on Android, automatically request system permission once
      if (packages.isEmpty && !_hasAutoRequestedPermission) {
        _hasAutoRequestedPermission = true;
        try {
          final granted = await PackageManagerAndroid.requestAppListPermission();
          if (granted) {
            packages = await PackageManagerAndroid.getInstalledPackages(
              onValid: (PackageInfo info) => info.packageName != AppUtils.getId(),
            );
          }
        } catch (_) {}
      }

      if (!mounted) {
        return;
      }
      _needPermission = packages.isEmpty;
      if (_needPermission) {
        return;
      }
      List<PackageInfoEx> notExists = [];
      List<PackageInfoEx> added = [];
      List<PackageInfoEx> notAdded = [];
      Set<String> exists = {};

      for (var app in packages) {
        final pkg = app.info.packageName;
        if (pkg == null || pkg.isEmpty) continue;
        exists.add(pkg);
        if (perapp.PackageIds != null &&
            perapp.PackageIds!.contains(pkg)) {
          added.add(app);
        } else {
          notAdded.add(app);
        }
      }
      if (perapp.PackageIds != null) {
        for (var papp in perapp.PackageIds!) {
          if (!exists.contains(papp)) {
            PackageInfoEx info = PackageInfoEx();
            info.info = PackageInfoImpl(papp);
            info.name = PackageManagerAndroid.kRemoved;
            info.icon = null;

            notExists.add(info);
          }
        }
      }

      notExists.sort(PackageManagerAndroid.sortByName);
      added.sort(PackageManagerAndroid.sortByName);
      notAdded.sort(PackageManagerAndroid.sortByName);
      _applicationInfoList.addAll(notExists);
      _applicationInfoList.addAll(added);
      _applicationInfoList.addAll(notAdded);

      _selectedCategory = 'all';

      _applyFilter();
    } catch (_) {
      // ignore
    } finally {
      _loading = false;
      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<Image?> getInstalledPackageIcon(String packageName) async {
    if (SettingManager.getConfig().ui.perAppHideAppIcon) {
      return null;
    }
    return PackageManagerAndroid.getInstalledPackageIcon(
      _applicationInfoList,
      packageName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;

    final allCount = _applicationInfoList.length;
    final userCount = _applicationInfoList.where((a) => !_isSystemApp(a)).length;
    final systemCount = _applicationInfoList.where((a) => _isSystemApp(a)).length;
    final selectedCount = _getSelectedCount();

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            children: [
              // Top Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 44,
                        height: 36,
                        child: Icon(Icons.arrow_back_ios_outlined, size: 22),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tcontext.PerAppAndroidScreen.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: onTapMore,
                      child: Tooltip(
                        message: tcontext.meta.more,
                        child: const SizedBox(
                          width: 44,
                          height: 36,
                          child: Icon(Icons.more_vert_outlined, size: 26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Enable switch options
              FutureBuilder(
                future: getGroupOptions(),
                builder: (BuildContext context, AsyncSnapshot<List<GroupItem>> snapshot) {
                  List<GroupItem> data = snapshot.hasData ? snapshot.data! : [];
                  return Column(
                    children: GroupItemCreator.createGroups(context, data),
                  );
                },
              ),

              // Dual-mode selector card (Whitelist / Blacklist)
              if (perapp.Enable == true) ...[
                _buildModeSelector(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        size: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          tcontext.meta.coreSettingTips,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 42,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                  borderRadius: ThemeDefine.kBorderRadius,
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                    width: 0.8,
                  ),
                ),
                child: TextFieldEx(
                  controller: _searchController,
                  textInputAction: TextInputAction.done,
                  onChanged: _loadSearch,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    icon: Icon(
                      Icons.search_outlined,
                      size: 20,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    hintText: tcontext.meta.search,
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.clear_outlined, size: 18),
                            onPressed: _clearSearch,
                          )
                        : null,
                  ),
                ),
              ),

              // Category Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    _buildFilterChip("all", "${tcontext.meta.all} ($allCount)"),
                    const SizedBox(width: 8),
                    _buildFilterChip("user", "${tcontext.meta.userApps} ($userCount)"),
                    const SizedBox(width: 8),
                    _buildFilterChip("system", "${tcontext.meta.systemApps} ($systemCount)"),
                    const SizedBox(width: 8),
                    _buildFilterChip("selected", "${tcontext.meta.selectedOnly} ($selectedCount)"),
                  ],
                ),
              ),

              // Batch Action Shortcuts Row
              _buildActionShortcuts(context),

              const SizedBox(height: 4),

              // Application list view
              Expanded(
                child: _needPermission
                    ? createNeedPermission(
                        context,
                        tcontext.permission.request(
                          p: tcontext.permission.appQuery,
                        ),
                        () async {
                          try {
                            const platform = MethodChannel('com.wmimo.app/native_helper');
                            await platform.invokeMethod('openAppSettings');
                          } catch (_) {
                            AppSettings.openAppSettings(
                              type: AppSettingsType.settings,
                            );
                          }
                        },
                        () {
                          _needPermission = false;
                          getInstalledPackages();
                        },
                      )
                    : _loadListView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    final isWhitelist = perapp.WhiteList ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF262629) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.15),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Whitelist: Only Proxy Selected
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  perapp.WhiteList = true;
                });
                ClashSettingManager.save();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: isWhitelist
                      ? ThemeDefine.kColorBlue.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isWhitelist
                        ? ThemeDefine.kColorBlue
                        : theme.dividerColor.withValues(alpha: 0.2),
                    width: isWhitelist ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.playlist_add_check_circle_rounded,
                          size: 16,
                          color: isWhitelist
                              ? ThemeDefine.kColorBlue
                              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            tcontext.meta.proxySelectedMode,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isWhitelist ? FontWeight.bold : FontWeight.w500,
                              color: isWhitelist
                                  ? ThemeDefine.kColorBlue
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tcontext.meta.proxySelectedModeDesc,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Blacklist: Bypass Selected
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                setState(() {
                  perapp.WhiteList = false;
                });
                ClashSettingManager.save();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: !isWhitelist
                      ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: !isWhitelist
                        ? ThemeDefine.kColorGreenBright
                        : theme.dividerColor.withValues(alpha: 0.2),
                    width: !isWhitelist ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_circle_outline_rounded,
                          size: 16,
                          color: !isWhitelist
                              ? ThemeDefine.kColorGreenBright
                              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            tcontext.meta.bypassSelectedMode,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: !isWhitelist ? FontWeight.bold : FontWeight.w500,
                              color: !isWhitelist
                                  ? ThemeDefine.kColorGreenBright
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tcontext.meta.bypassSelectedModeDesc,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String category, String label) {
    final theme = Theme.of(context);
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? ThemeDefine.kColorBlue
              : theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      selected: isSelected,
      selectedColor: ThemeDefine.kColorBlue.withValues(alpha: 0.15),
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(
        color: isSelected
            ? ThemeDefine.kColorBlue
            : theme.dividerColor.withValues(alpha: 0.25),
        width: isSelected ? 1.2 : 0.8,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      onSelected: (val) {
        if (val) {
          setState(() {
            _selectedCategory = category;
            _applyFilter();
          });
        }
      },
    );
  }

  Widget _buildActionShortcuts(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Text(
            "${tcontext.meta.selectedOnly}: ${_getSelectedCount()}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _searchedData.isEmpty ? null : _selectAllCurrent,
            child: Text(tcontext.meta.selectAll, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 4),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _searchedData.isEmpty ? null : _deselectAllCurrent,
            child: Text(tcontext.meta.deselectAll, style: const TextStyle(fontSize: 12)),
          ),
          const SizedBox(width: 4),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _searchedData.isEmpty ? null : _invertSelectionCurrent,
            child: Text(tcontext.meta.invertSelection, style: const TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _loadListView() {
    if (_loading) {
      return const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: RepaintBoundary(child: CircularProgressIndicator(strokeWidth: 2.5)),
        ),
      );
    }
    if (_searchedData.isEmpty) {
      final theme = Theme.of(context);
      final tcontext = Translations.of(context);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 12),
            Text(
              tcontext.meta.search,
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: _searchedData.length,
      itemBuilder: (BuildContext context, int index) {
        PackageInfoEx current = _searchedData[index];
        return createWidget(current);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1, thickness: 0.3);
      },
    );
  }

  Widget createWidget(PackageInfoEx current) {
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    final isSelected = perapp.PackageIds != null &&
        perapp.PackageIds!.contains(current.info.packageName);
    final isSystem = _isSystemApp(current);
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          perapp.PackageIds ??= [];
          if (!isSelected) {
            perapp.PackageIds!.add(current.info.packageName!);
          } else {
            perapp.PackageIds!.remove(current.info.packageName!);
          }
          ClashSettingManager.save();
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(
                width: 44,
                height: 44,
                child: FutureBuilder(
                  future: getInstalledPackageIcon(current.info.packageName!),
                  builder: (BuildContext context, AsyncSnapshot<Image?> snapshot) {
                    if (!snapshot.hasData || snapshot.data == null) {
                      return Icon(
                        isSystem ? Icons.settings_applications_rounded : Icons.android_rounded,
                        size: 36,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      );
                    }
                    return snapshot.data!;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            current.name,
                            style: TextStyle(
                              fontSize: ThemeConfig.kFontSizeGroupItem,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSystem) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "SYS",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (current.name != current.info.packageName && current.info.packageName != null)
                      Text(
                        current.info.packageName!,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              Checkbox(
                value: isSelected,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (bool? value) {
                  perapp.PackageIds ??= [];
                  if (value == true) {
                    perapp.PackageIds!.add(current.info.packageName!);
                  } else {
                    perapp.PackageIds!.remove(current.info.packageName!);
                  }
                  ClashSettingManager.save();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<GroupItem>> getGroupOptions() async {
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    final tcontext = Translations.of(context);

    List<GroupItemOptions> options = [
      GroupItemOptions(
        switchOptions: GroupItemSwitchOptions(
          name: tcontext.meta.enable,
          switchValue: perapp.Enable,
          onSwitch: (bool value) async {
            perapp.Enable = value;
            ClashSettingManager.save();
            setState(() {});
          },
        ),
      ),
    ];

    return [GroupItem(options: options)];
  }

  void onTapMore() {
    var perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    final tcontext = Translations.of(context);
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1, 40, 10, 0),
      items: [
        PopupMenuItem(
          value: 1,
          child: Text(tcontext.meta.importFromClipboard),
          onTap: () async {
            perapp.PackageIds ??= [];
            try {
              ClipboardData? data = await Clipboard.getData("text/plain");
              if (data == null || data.text == null || data.text!.isEmpty) {
                return;
              }
              List<String> list = data.text!.split("\n");
              if (list.isEmpty) {
                return;
              }
              for (var app in list) {
                app = app.trim();
                if (app.isNotEmpty && !perapp.PackageIds!.contains(app)) {
                  perapp.PackageIds!.add(app);
                }
              }
              ClashSettingManager.save();
              _applyFilter();
            } catch (err) {
              if (!mounted) {
                return;
              }
              DialogUtils.showAlertDialog(
                context,
                err.toString(),
                showCopy: true,
                showFAQ: true,
                withVersion: true,
              );
            }
          },
        ),
        PopupMenuItem(
          value: 2,
          child: Text(tcontext.meta.exportToClipboard),
          onTap: () async {
            perapp.PackageIds ??= [];
            try {
              if (perapp.PackageIds!.isEmpty) {
                return;
              }
              String content = perapp.PackageIds!.join("\n");
              await Clipboard.setData(ClipboardData(text: content));
            } catch (err) {
              if (!mounted) {
                return;
              }
              DialogUtils.showAlertDialog(
                context,
                err.toString(),
                showCopy: true,
                showFAQ: true,
                withVersion: true,
              );
            }
          },
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            SettingManager.getConfig().ui.perAppHideAppIcon
                ? tcontext.meta.showAppIcon
                : tcontext.meta.hideAppIcon,
          ),
          onTap: () {
            final ui = SettingManager.getConfig().ui;
            ui.perAppHideAppIcon = !ui.perAppHideAppIcon;
            SettingManager.save();
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget createNeedPermission(
    BuildContext context,
    String text,
    Function() onPermission,
    Function() onRefresh,
  ) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.security_outlined,
                size: 44,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "当前系统限制了已安装软件列表的读取。请先点击下方「一键申请权限」弹出系统授权框；若系统未弹出，可点击「前往权限设置页」手动开启。",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),

            // Step guide container
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        "常见系统开启指引",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "• 小米 / HyperOS / MIUI：点击下方【前往权限设置页】直达，开启「获取应用列表」权限。\n"
                    "• 华为 / 荣耀：进入设置 -> 应用管理 -> Wmimo -> 权限，开启「读取已安装应用列表」。\n"
                    "• OPPO / vivo：在应用权限中开启「读取应用列表」。\n"
                    "• 开启权限后切回 Wmimo 即可自动加载，无需重复进入。",
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Button 1: Request permission system popup
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.verified_user_outlined, size: 18),
                label: const Text("一键申请权限 (弹出系统授权框)"),
                onPressed: () async {
                  try {
                    final granted = await PackageManagerAndroid.requestAppListPermission();
                    if (granted) {
                      _needPermission = false;
                      await getInstalledPackages();
                      return;
                    }
                  } catch (_) {}
                  await getInstalledPackages();
                },
              ),
            ),
            const SizedBox(height: 10),

            // Button 2: Jump to system permission settings
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.settings_outlined, size: 18),
                label: const Text("前往系统权限设置页 (手动开启)"),
                onPressed: () async {
                  try {
                    const platform = MethodChannel('com.wmimo.app/native_helper');
                    await platform.invokeMethod('openAppSettings');
                  } catch (_) {
                    AppSettings.openAppSettings(
                      type: AppSettingsType.settings,
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 8),

            // Button 3: Refresh
            TextButton.icon(
              icon: const Icon(Icons.refresh_outlined, size: 16),
              label: Text(tcontext.meta.refresh),
              onPressed: () async {
                _needPermission = false;
                onRefresh();
              },
            ),
          ],
        ),
      ),
    );
  }
}
