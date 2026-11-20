// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/package_manager_android.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';

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
  bool _applying = false;
  bool _hasAppListPermission = true;
  bool _needPermission = false;

  final List<PackageInfoEx> _applicationInfoList = [];
  final _searchController = TextEditingController();
  List<PackageInfoEx> _searchedData = [];
  String _selectedCategory = 'all'; // 'all', 'user', 'system', 'selected'
  Timer? _loadingTimeoutTimer;

  late bool _initialEnable;
  late bool _initialWhitelist;
  late Set<String> _initialPackages;

  static const List<Map<String, String>> _commonProxyPresets = [
    {'name': 'Telegram', 'pkg': 'org.telegram.messenger'},
    {'name': 'Telegram Plus', 'pkg': 'org.telegram.plus'},
    {'name': 'YouTube', 'pkg': 'com.google.android.youtube'},
    {'name': 'Google Chrome', 'pkg': 'com.android.chrome'},
    {'name': 'Google Play 商店', 'pkg': 'com.android.vending'},
    {'name': 'Google 基础服务', 'pkg': 'com.google.android.gms'},
    {'name': 'Twitter / X', 'pkg': 'com.twitter.android'},
    {'name': 'Instagram', 'pkg': 'com.instagram.android'},
    {'name': 'WhatsApp', 'pkg': 'com.whatsapp'},
    {'name': 'Discord', 'pkg': 'com.discord'},
    {'name': 'GitHub', 'pkg': 'com.github.android'},
    {'name': 'TikTok', 'pkg': 'com.zhiliaoapp.musically'},
    {'name': 'Spotify', 'pkg': 'com.spotify.music'},
    {'name': 'Netflix', 'pkg': 'com.netflix.mediaclient'},
    {'name': 'Facebook', 'pkg': 'com.facebook.katana'},
    {'name': 'Reddit', 'pkg': 'com.reddit.frontpage'},
  ];

  @override
  void initState() {
    super.initState();
    _captureInitialSnapshot();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        getInstalledPackages();
      }
    });
  }

  @override
  void dispose() {
    _loadingTimeoutTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _searchController.dispose();
    ClashSettingManager.save();
    SettingManager.save();
    super.dispose();
  }

  void _captureInitialSnapshot() {
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    _initialEnable = perapp.Enable == true;
    _initialWhitelist = perapp.WhiteList == true;
    _initialPackages = (perapp.PackageIds ?? const []).toSet();
  }

  bool get _isDirty {
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    final currEnable = perapp.Enable == true;
    final currWhitelist = perapp.WhiteList == true;
    final currPackages = (perapp.PackageIds ?? const []).toSet();
    return currEnable != _initialEnable ||
        currWhitelist != _initialWhitelist ||
        !setEquals(currPackages, _initialPackages);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && (!_hasAppListPermission || _needPermission)) {
      getInstalledPackages();
    }
  }

  bool _isSystemApp(PackageInfoEx app) {
    return app.info.applicationInfo != null &&
        (app.info.applicationInfo!.flags &
                PackageManagerAndroid.kAndroidFlagSystem !=
            0);
  }

  bool _isRemovedApp(PackageInfoEx app) =>
      app.name == PackageManagerAndroid.kRemoved;

  int _getSelectedCount() {
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    return perapp.PackageIds?.length ?? 0;
  }

  int _getRemovedSelectedCount() {
    final removedSet = _applicationInfoList
        .where(_isRemovedApp)
        .map((e) => e.info.packageName)
        .whereType<String>()
        .toSet();
    final selected = ClashSettingManager.getConfig().Extension!.Tun.perApp.PackageIds ?? [];
    return selected.where(removedSet.contains).length;
  }

  void _applyFilter() {
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    final search = _searchController.text.trim().toLowerCase();
    final selectedSet = perapp.PackageIds?.toSet() ?? {};

    _searchedData = _applicationInfoList.where((app) {
      if (_selectedCategory == 'user' && (_isSystemApp(app) || _isRemovedApp(app))) {
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
        final name = app.name.toLowerCase();
        final pkgName = (app.info.packageName ?? "").toLowerCase();
        if (!name.contains(search) && !pkgName.contains(search)) {
          return false;
        }
      }
      return true;
    }).toList();

    setState(() {});
  }

  void _selectAllCurrent() {
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    perapp.PackageIds ??= [];
    for (final app in _searchedData) {
      if (_isRemovedApp(app)) continue;
      final pkg = app.info.packageName;
      if (pkg != null && pkg.isNotEmpty && !perapp.PackageIds!.contains(pkg)) {
        perapp.PackageIds!.add(pkg);
      }
    }
    ClashSettingManager.save();
    _applyFilter();
  }

  void _deselectAllCurrent() {
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
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
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    perapp.PackageIds ??= [];
    final currentSelected = perapp.PackageIds!.toSet();
    for (final app in _searchedData) {
      if (_isRemovedApp(app)) continue;
      final pkg = app.info.packageName;
      if (pkg != null && pkg.isNotEmpty) {
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

  void _cleanupRemovedPackages() {
    final removedSet = _applicationInfoList
        .where(_isRemovedApp)
        .map((e) => e.info.packageName)
        .whereType<String>()
        .toSet();
    if (removedSet.isEmpty) return;

    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    perapp.PackageIds?.removeWhere(removedSet.contains);
    _applicationInfoList.removeWhere(_isRemovedApp);
    ClashSettingManager.save();
    _applyFilter();
  }

  Future<void> _applyRulesLive({bool showFeedback = true}) async {
    if (_applying) return;
    setState(() => _applying = true);
    try {
      await ClashSettingManager.save();
      final applied = await VPNService.updateAndroidPerApp();
      if (!applied && await VPNService.getStarted()) {
        VpnActionHandler.vpnReconnect?.call("perapp", false);
      }
      _captureInitialSnapshot();
      if (showFeedback && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("分应用代理规则已平滑生效"),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _applying = false);
      }
    }
  }

  Future<void> _applyIfConnectedOnExit() async {
    if (_isDirty && await VPNService.getStarted()) {
      await _applyRulesLive(showFeedback: false);
    }
  }

  Future<void> getInstalledPackages() async {
    _loadingTimeoutTimer?.cancel();
    _loadingTimeoutTimer = Timer(const Duration(milliseconds: 3500), () {
      if (mounted && _loading) {
        setState(() {
          _loading = false;
          if (_applicationInfoList.isEmpty) {
            _needPermission = true;
          }
        });
      }
    });

    _applicationInfoList.clear();
    _searchedData.clear();
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    _loading = true;
    setState(() {});
    try {
      _hasAppListPermission = await PackageManagerAndroid.hasAppListPermission();
      final packages = await PackageManagerAndroid.getInstalledPackages(
        onValid: (PackageInfo info) => info.packageName != AppUtils.getId(),
      );

      _loadingTimeoutTimer?.cancel();
      if (!mounted) return;

      _needPermission = packages.isEmpty;
      if (_needPermission) {
        if (perapp.PackageIds != null && perapp.PackageIds!.isNotEmpty) {
          for (final papp in perapp.PackageIds!) {
            final info = PackageInfoEx()
              ..info = PackageInfoImpl(papp)
              ..name = papp
              ..icon = null;
            _applicationInfoList.add(info);
          }
          _selectedCategory = 'all';
          _applyFilter();
        }
        return;
      }

      final List<PackageInfoEx> notExists = [];
      final List<PackageInfoEx> added = [];
      final List<PackageInfoEx> notAdded = [];
      final Set<String> exists = {};

      for (final app in packages) {
        final pkg = app.info.packageName;
        if (pkg == null || pkg.isEmpty) continue;
        exists.add(pkg);
        if (perapp.PackageIds != null && perapp.PackageIds!.contains(pkg)) {
          added.add(app);
        } else {
          notAdded.add(app);
        }
      }

      if (perapp.PackageIds != null) {
        for (final papp in perapp.PackageIds!) {
          if (!exists.contains(papp)) {
            final info = PackageInfoEx()
              ..info = PackageInfoImpl(papp)
              ..name = PackageManagerAndroid.kRemoved
              ..icon = null;
            notExists.add(info);
          }
        }
      }

      notExists.sort(PackageManagerAndroid.sortByName);
      added.sort(PackageManagerAndroid.sortByName);
      notAdded.sort(PackageManagerAndroid.sortByName);
      _applicationInfoList
        ..addAll(notExists)
        ..addAll(added)
        ..addAll(notAdded);

      _applyFilter();
    } catch (_) {
      // ignore
    } finally {
      _loadingTimeoutTimer?.cancel();
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

  Future<void> _openSystemPermissionSettings() async {
    try {
      const platform = MethodChannel('com.wmimo.app/native_helper');
      await platform.invokeMethod('openAppSettings');
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;

    final allCount = _applicationInfoList.length;
    final userCount = _applicationInfoList
        .where((a) => !_isSystemApp(a) && !_isRemovedApp(a))
        .length;
    final systemCount = _applicationInfoList.where(_isSystemApp).length;
    final selectedCount = _getSelectedCount();
    final removedCount = _getRemovedSelectedCount();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          unawaited(_applyIfConnectedOnExit());
        }
      },
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
        body: SafeArea(
          child: Column(
            children: [
              // Compact Top Navigation Bar with always-accessible Presets & Manual Add
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 10, 4, 4),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        tcontext.PerAppAndroidScreen.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: tcontext.PerAppAndroidScreen.presetApps,
                      icon: const Icon(Icons.auto_awesome_outlined, size: 21),
                      onPressed: _showPresetAppsDialog,
                    ),
                    IconButton(
                      tooltip: tcontext.PerAppAndroidScreen.manualAddPackage,
                      icon: const Icon(Icons.add_circle_outline_rounded, size: 21),
                      onPressed: _showManualAddDialog,
                    ),
                    IconButton(
                      tooltip: tcontext.meta.more,
                      icon: const Icon(Icons.more_vert_outlined, size: 22),
                      onPressed: onTapMore,
                    ),
                  ],
                ),
              ),

              // Unified Compact Control Card (Enable + Whitelist/Blacklist Segmented Switch)
              _buildCompactControlCard(context, perapp.Enable == true, perapp.WhiteList == true, selectedCount),

              // Live VPN Sync Prompt when dirty and connected
              ValueListenableBuilder<VpnUiStatus>(
                valueListenable: VpnActionHandler.uiStatus,
                builder: (context, status, _) {
                  if (!status.isConnected || !_isDirty) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16, 4, 16, 2),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.18 : 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: ThemeDefine.kColorBlue.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sync_rounded, size: 16, color: ThemeDefine.kColorBlue),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            "分流规则已变更，应用后立即生效",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ),
                        TextButton(
                          onPressed: _applying ? null : () => _applyRulesLive(),
                          style: TextButton.styleFrom(
                            backgroundColor: ThemeDefine.kColorBlue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                          ),
                          child: Text(
                            _applying ? "..." : "立即应用",
                            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Non-blocking partial permission warning banner when launcher apps are shown
              if (!_needPermission && !_hasAppListPermission)
                Container(
                  margin: const EdgeInsets.fromLTRB(16, 4, 16, 2),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: isDark ? 0.16 : 0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.orange.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, size: 16, color: Colors.orange),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          "读取应用列表权限受限，当前仅展示部分可见应用",
                          style: TextStyle(fontSize: 11.5, color: Colors.orange),
                        ),
                      ),
                      TextButton(
                        onPressed: _openSystemPermissionSettings,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text("去授权", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),

              // Search Bar
              Container(
                margin: const EdgeInsets.fromLTRB(16, 6, 16, 4),
                height: 38,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262629) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                    width: 0.8,
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onChanged: (_) => _applyFilter(),
                  textAlignVertical: TextAlignVertical.center,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    prefixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                    hintText: "${tcontext.meta.search} (应用名 / 包名)",
                    hintStyle: TextStyle(
                      fontSize: 12.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              _searchController.clear();
                              _applyFilter();
                            },
                            child: Icon(
                              Icons.cancel_rounded,
                              size: 17,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                            ),
                          )
                        : null,
                    suffixIconConstraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                ),
              ),

              // Category Filter Chips
              SizedBox(
                height: 38,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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

              // Compact Batch Action Row
              _buildActionShortcuts(context, selectedCount, removedCount),

              // Application list or full permission guide
              Expanded(
                child: _needPermission
                    ? createNeedPermission(
                        context,
                        tcontext.permission.request(p: tcontext.permission.appQuery),
                        _openSystemPermissionSettings,
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

  Widget _buildCompactControlCard(
    BuildContext context,
    bool enabled,
    bool isWhitelist,
    int selectedCount,
  ) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF262629) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.apps_rounded,
                size: 18,
                color: enabled ? ThemeDefine.kColorBlue : Colors.grey,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  tcontext.meta.enable,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
              Switch.adaptive(
                value: enabled,
                activeThumbColor: Colors.white,
                activeTrackColor: ThemeDefine.kColorBlue,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (bool value) {
                  setState(() {
                    perapp.Enable = value;
                  });
                  ClashSettingManager.save();
                },
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: _buildModeSegment(
                    context: context,
                    selected: isWhitelist,
                    activeColor: ThemeDefine.kColorBlue,
                    icon: Icons.playlist_add_check_circle_rounded,
                    title: tcontext.meta.proxySelectedMode,
                    subtitle: tcontext.meta.proxySelectedModeDesc,
                    onTap: () {
                      setState(() => perapp.WhiteList = true);
                      ClashSettingManager.save();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildModeSegment(
                    context: context,
                    selected: !isWhitelist,
                    activeColor: ThemeDefine.kColorGreenBright,
                    icon: Icons.remove_circle_outline_rounded,
                    title: tcontext.meta.bypassSelectedMode,
                    subtitle: tcontext.meta.bypassSelectedModeDesc,
                    onTap: () {
                      setState(() => perapp.WhiteList = false);
                      ClashSettingManager.save();
                    },
                  ),
                ),
              ],
            ),
            if (isWhitelist && selectedCount == 0)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, size: 13, color: Colors.orange),
                    const SizedBox(width: 5),
                    const Expanded(
                      child: Text(
                        "白名单为空时不会代理任何应用，请至少勾选 1 个应用",
                        style: TextStyle(fontSize: 11, color: Colors.orange),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeSegment({
    required BuildContext context,
    required bool selected,
    required Color activeColor,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: selected ? activeColor.withValues(alpha: 0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? activeColor : theme.dividerColor.withValues(alpha: 0.2),
            width: selected ? 1.4 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 15,
              color: selected ? activeColor : theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: selected ? FontWeight.bold : FontWeight.w500,
                      color: selected ? activeColor : theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
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

  Widget _buildFilterChip(String category, String label) {
    final theme = Theme.of(context);
    final isSelected = _selectedCategory == category;
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected
              ? ThemeDefine.kColorBlue
              : theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
      ),
      selected: isSelected,
      selectedColor: ThemeDefine.kColorBlue.withValues(alpha: 0.15),
      backgroundColor: theme.colorScheme.surface,
      visualDensity: VisualDensity.compact,
      side: BorderSide(
        color: isSelected
            ? ThemeDefine.kColorBlue
            : theme.dividerColor.withValues(alpha: 0.25),
        width: isSelected ? 1.2 : 0.8,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      showCheckmark: false,
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

  Widget _buildActionShortcuts(
    BuildContext context,
    int selectedCount,
    int removedCount,
  ) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        children: [
          Text(
            "${tcontext.meta.selectedOnly}: $selectedCount",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          if (removedCount > 0) ...[
            const SizedBox(width: 8),
            InkWell(
              onTap: _cleanupRemovedPackages,
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "清理 $removedCount 个失效项",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ],
          const Spacer(),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _searchedData.isEmpty ? null : _selectAllCurrent,
            child: Text(tcontext.meta.selectAll, style: const TextStyle(fontSize: 12)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: _searchedData.isEmpty ? null : _deselectAllCurrent,
            child: Text(tcontext.meta.deselectAll, style: const TextStyle(fontSize: 12)),
          ),
          TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
        return createWidget(_searchedData[index]);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const Divider(height: 1, thickness: 0.3);
      },
    );
  }

  Widget createWidget(PackageInfoEx current) {
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    final pkg = current.info.packageName ?? '';
    final isSelected = perapp.PackageIds != null && perapp.PackageIds!.contains(pkg);
    final isSystem = _isSystemApp(current);
    final isRemoved = _isRemovedApp(current);
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          perapp.PackageIds ??= [];
          if (!isSelected) {
            perapp.PackageIds!.add(pkg);
          } else {
            perapp.PackageIds!.remove(pkg);
          }
          ClashSettingManager.save();
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
          width: double.infinity,
          child: Row(
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: isRemoved
                    ? Icon(
                        Icons.delete_sweep_outlined,
                        size: 28,
                        color: Colors.redAccent.withValues(alpha: 0.7),
                      )
                    : FutureBuilder(
                        future: getInstalledPackageIcon(pkg),
                        builder: (BuildContext context, AsyncSnapshot<Image?> snapshot) {
                          if (!snapshot.hasData || snapshot.data == null) {
                            return Icon(
                              isSystem ? Icons.settings_applications_rounded : Icons.android_rounded,
                              size: 32,
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
                            isRemoved ? pkg : current.name,
                            style: TextStyle(
                              fontSize: ThemeConfig.kFontSizeGroupItem,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isRemoved ? theme.colorScheme.onSurface.withValues(alpha: 0.6) : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isRemoved) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              "已卸载",
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ] else if (isSystem) ...[
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
                    if (!isRemoved && current.name != pkg)
                      Text(
                        pkg,
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
                    if (!perapp.PackageIds!.contains(pkg)) {
                      perapp.PackageIds!.add(pkg);
                    }
                  } else {
                    perapp.PackageIds!.remove(pkg);
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

  void onTapMore() {
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    final tcontext = Translations.of(context);
    final removedCount = _getRemovedSelectedCount();

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
              final data = await Clipboard.getData("text/plain");
              if (data == null || data.text == null || data.text!.isEmpty) return;
              for (var app in data.text!.split("\n")) {
                app = app.trim();
                if (app.isNotEmpty && !perapp.PackageIds!.contains(app)) {
                  perapp.PackageIds!.add(app);
                }
              }
              ClashSettingManager.save();
              getInstalledPackages();
            } catch (err) {
              if (!mounted) return;
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
              if (perapp.PackageIds!.isEmpty) return;
              await Clipboard.setData(ClipboardData(text: perapp.PackageIds!.join("\n")));
            } catch (err) {
              if (!mounted) return;
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
        if (removedCount > 0)
          PopupMenuItem(
            value: 4,
            child: Text("清理失效包名 ($removedCount)"),
            onTap: _cleanupRemovedPackages,
          ),
      ],
    );
  }

  void _showManualAddDialog() {
    final tcontext = Translations.of(context);
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text(tcontext.PerAppAndroidScreen.manualAddPackage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tcontext.PerAppAndroidScreen.manualAddPackageHint,
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "例如：org.telegram.messenger\ncom.google.android.youtube",
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(tcontext.meta.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isNotEmpty) {
                  final parts = text.split(RegExp(r'[\s,\n;]+'));
                  final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
                  perapp.PackageIds ??= [];
                  int added = 0;
                  for (final p in parts) {
                    final clean = p.trim();
                    if (clean.isNotEmpty && !perapp.PackageIds!.contains(clean)) {
                      perapp.PackageIds!.add(clean);
                      added++;
                    }
                  }
                  if (added > 0) {
                    ClashSettingManager.save();
                    getInstalledPackages();
                  }
                }
                Navigator.pop(ctx);
              },
              child: Text(tcontext.meta.add),
            ),
          ],
        );
      },
    );
  }

  void _showPresetAppsDialog() {
    final tcontext = Translations.of(context);
    final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
    perapp.PackageIds ??= [];
    final selectedPkgs = perapp.PackageIds!.toSet();

    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(tcontext.PerAppAndroidScreen.quickAddPresets),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: _commonProxyPresets.map((preset) {
                      final pkg = preset['pkg']!;
                      final name = preset['name']!;
                      final isChecked = selectedPkgs.contains(pkg);
                      return CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        subtitle: Text(pkg, style: const TextStyle(fontSize: 11, color: Colors.grey)),
                        value: isChecked,
                        onChanged: (bool? val) {
                          setDialogState(() {
                            if (val == true) {
                              selectedPkgs.add(pkg);
                            } else {
                              selectedPkgs.remove(pkg);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(tcontext.meta.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    final target = ClashSettingManager.getConfig().Extension!.Tun.perApp;
                    target.PackageIds = selectedPkgs.toList();
                    ClashSettingManager.save();
                    Navigator.pop(ctx);
                    getInstalledPackages();
                  },
                  child: Text(tcontext.PerAppAndroidScreen.saveSelected),
                ),
              ],
            );
          },
        );
      },
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
    final selectedCount = _getSelectedCount();

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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              tcontext.PerAppAndroidScreen.permissionRestrictedTip,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.45,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor.withValues(alpha: 0.1)),
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
                    "• 小米 / HyperOS / MIUI：点击下方【前往系统权限设置页】直达安全中心，开启「获取应用列表」权限。\n"
                    "• 华为 / 荣耀：设置 -> 应用管理 -> Wmimo -> 权限，开启「读取已安装应用列表」。\n"
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.settings_outlined, size: 18),
                label: Text(tcontext.PerAppAndroidScreen.openSystemPermission),
                onPressed: onPermission,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                label: Text(tcontext.PerAppAndroidScreen.presetApps),
                onPressed: _showPresetAppsDialog,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.add_circle_outline, size: 18),
                label: Text(tcontext.PerAppAndroidScreen.manualAddPackage),
                onPressed: _showManualAddDialog,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.verified_user_outlined, size: 18),
                label: Text(tcontext.PerAppAndroidScreen.requestPermissionPopup),
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
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (selectedCount > 0)
                  Text(
                    "已配置 $selectedCount 个分流应用",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: ThemeDefine.kColorBlue,
                    ),
                  ),
                if (selectedCount > 0) const SizedBox(width: 16),
                TextButton.icon(
                  icon: const Icon(Icons.refresh_outlined, size: 16),
                  label: Text(tcontext.meta.refresh),
                  onPressed: () {
                    _needPermission = false;
                    onRefresh();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
