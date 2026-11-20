import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wmimo/app/modules/auto_update_manager.dart';
import 'package:wmimo/app/modules/chain_proxy_manager.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/about_screen.dart';
import 'package:wmimo/screens/chain_proxy_screen.dart';
import 'package:wmimo/screens/geo_assets_screen.dart';
import 'package:wmimo/screens/group_helper.dart';
import 'package:wmimo/screens/hotkey_settings_screen.dart';
import 'package:wmimo/screens/logs_screen.dart';
import 'package:wmimo/screens/net_check_screen.dart';
import 'package:wmimo/screens/perapp_android_screen.dart';
import 'package:wmimo/screens/profiles_patch_board_screen.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static RouteSettings routSettings() {
    return const RouteSettings(name: 'SettingsScreen');
  }

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    AutoUpdateManager.onEventCheck.add(_onRefresh);
    ChainProxyManager.onChainProxiesChanged.add(_onRefresh);
  }

  @override
  void dispose() {
    AutoUpdateManager.onEventCheck.remove(_onRefresh);
    ChainProxyManager.onChainProxiesChanged.remove(_onRefresh);
    super.dispose();
  }

  void _onRefresh() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6, top: 2),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyle(
            fontSize: ThemeConfig.kFontSizeListItem,
            fontWeight: ThemeConfig.kFontWeightListItem,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? trailingText,
    Widget? badge,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      leading: Icon(
        icon,
        size: 22,
        color: theme.colorScheme.primary,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (badge != null) ...[
            badge,
            const SizedBox(width: 6),
          ],
          if (trailingText != null && trailingText.isNotEmpty) ...[
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 140),
              child: Text(
                trailingText,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            const SizedBox(width: 4),
          ],
          const Icon(Icons.keyboard_arrow_right, size: 20),
        ],
      ),
      minVerticalPadding: 15,
      onTap: onTap,
    );
  }

  Widget _buildUpdateNotificationBanner(
    BuildContext context,
    AutoUpdateCheckVersion versionCheck,
    Translations tcontext,
  ) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          await GroupHelper.newVersionUpdate(context);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0C243B), const Color(0xFF132F4C)]
                  : [const Color(0xFFE0F2FE), const Color(0xFFF0F9FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.5 : 0.65),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.2 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.25 : 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_active_rounded,
                  color: ThemeDefine.kColorBlue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tcontext.meta.hasNewVersion(p: versionCheck.version),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tcontext.VersionUpdateScreen.versionReady(p: versionCheck.version),
                      style: TextStyle(
                        fontSize: 12.5,
                        color: isDark
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeDefine.kColorBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () async {
                  await GroupHelper.newVersionUpdate(context);
                },
                child: Text(
                  tcontext.VersionUpdateScreen.update,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final versionCheck = AutoUpdateManager.getVersionCheck();
    final tcontext = Translations.of(context);
    final isPC = PlatformUtils.isPC();
    final isAndroid = Platform.isAndroid;
    final activeChains = ChainProxyManager.enabledCount;
    final currentPatch = ProfilePatchManager.getCurrent();
    final patchName = currentPatch.getShowName(context);

    final perapp = ClashSettingManager.getConfig().Extension?.Tun.perApp;
    final perappEnabled = perapp?.Enable == true;
    final perappCount = perapp?.PackageIds?.length ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (versionCheck.newVersion) ...[
          _buildUpdateNotificationBanner(context, versionCheck, tcontext),
          const SizedBox(height: 12),
        ],

        // Group 1: 常规与内核（含平台差异化核心入口：PC 快捷键 / Android 分应用代理）
        _buildSectionHeader(context, tcontext.meta.sectionGeneral),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                _buildSettingsRow(
                  context: context,
                  icon: Icons.tune_rounded,
                  title: tcontext.meta.settingApp,
                  badge: versionCheck.newVersion
                      ? Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3B30),
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                  onTap: () async {
                    await GroupHelper.showAppSettings(context);
                    if (mounted) setState(() {});
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                _buildSettingsRow(
                  context: context,
                  icon: Icons.settings_suggest_rounded,
                  title: tcontext.meta.settingCore,
                  onTap: () async {
                    await GroupHelper.showClashSettings(context);
                    if (mounted) setState(() {});
                  },
                ),
                if (isPC) ...[
                  const Divider(height: 1, thickness: 0.8),
                  _buildSettingsRow(
                    context: context,
                    icon: Icons.keyboard_rounded,
                    title: tcontext.hotkeys.title,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: HotkeySettingsScreen.routSettings(),
                          builder: (context) => const HotkeySettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
                if (isAndroid) ...[
                  const Divider(height: 1, thickness: 0.8),
                  _buildSettingsRow(
                    context: context,
                    icon: Icons.apps_rounded,
                    title: tcontext.PerAppAndroidScreen.title,
                    trailingText: perappEnabled
                        ? "${tcontext.meta.enable} ($perappCount)"
                        : tcontext.meta.disable,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          settings: PerAppAndroidScreen.routSettings(),
                          builder: (context) => const PerAppAndroidScreen(),
                        ),
                      );
                      if (mounted) setState(() {});
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Group 2: 规则、链式与诊断（上浮原深埋的规则、Geo 与诊断入口）
        _buildSectionHeader(context, tcontext.meta.sectionRoutingTools),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                _buildSettingsRow(
                  context: context,
                  icon: Icons.link_rounded,
                  title: "${tcontext.chain_proxy.title} (Beta)",
                  trailingText: activeChains > 0
                      ? tcontext.chain_proxy.active_count(
                          active: activeChains,
                          total: ChainProxyManager.items.length,
                        )
                      : null,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: ChainProxyScreen.routSettings(),
                        builder: (context) => const ChainProxyScreen(),
                      ),
                    );
                    if (mounted) setState(() {});
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                _buildSettingsRow(
                  context: context,
                  icon: Icons.layers_outlined,
                  title: tcontext.meta.profilePatches,
                  trailingText: patchName,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: ProfilesPatchBoardScreen.routSettings(),
                        builder: (context) => ProfilesPatchBoardScreen(),
                      ),
                    );
                    if (mounted) setState(() {});
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                _buildSettingsRow(
                  context: context,
                  icon: Icons.alt_route_rounded,
                  title: tcontext.meta.diversionTemplates,
                  onTap: () async {
                    await GroupHelper.showClashSettingsDiversionTemplates(context);
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                _buildSettingsRow(
                  context: context,
                  icon: Icons.public_rounded,
                  title: tcontext.dns.geoAssetsTitle,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: GeoAssetsScreen.routSettings(),
                        builder: (context) => const GeoAssetsScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                _buildSettingsRow(
                  context: context,
                  icon: Icons.health_and_safety_outlined,
                  title: tcontext.meta.networkDiagnostics,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: NetCheckScreen.routSettings(),
                        builder: (context) => const NetCheckScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                _buildSettingsRow(
                  context: context,
                  icon: Icons.terminal_rounded,
                  title: tcontext.meta.coreLog,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: LogsScreen.routSettings(),
                        builder: (context) => const LogsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Group 3: 数据与同步
        _buildSectionHeader(context, tcontext.meta.sectionData),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                _buildSettingsRow(
                  context: context,
                  icon: Icons.cloud_sync_outlined,
                  title: tcontext.meta.backupAndSync,
                  onTap: () async {
                    await GroupHelper.showBackupAndSync(context);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Group 4: 帮助与关于（移除与关于页重复的 joinUs，集中于此）
        _buildSectionHeader(context, tcontext.meta.sectionSupport),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                _buildSettingsRow(
                  context: context,
                  icon: Icons.help_outline_rounded,
                  title: tcontext.meta.help,
                  onTap: () async {
                    await GroupHelper.showHelp(context);
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                _buildSettingsRow(
                  context: context,
                  icon: Icons.info_outline_rounded,
                  title: tcontext.meta.about,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: AboutScreen.routSettings(),
                        builder: (context) => const AboutScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
