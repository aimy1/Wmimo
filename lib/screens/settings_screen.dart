import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/modules/auto_update_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/about_screen.dart';
import 'package:wmimo/screens/group_helper.dart';
import 'package:wmimo/screens/logs_screen.dart';
import 'package:wmimo/screens/qrcode_screen.dart';
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
    AutoUpdateManager.onEventCheck.add(_onAutoUpdateCheck);
    SettingManager.onAnimationsChanged.add(_onAnimationsChanged);
  }

  @override
  void dispose() {
    AutoUpdateManager.onEventCheck.remove(_onAutoUpdateCheck);
    SettingManager.onAnimationsChanged.remove(_onAnimationsChanged);
    super.dispose();
  }

  void _onAutoUpdateCheck() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onAnimationsChanged() {
    if (mounted) {
      setState(() {});
    }
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
                  ? [
                      const Color(0xFF0C243B),
                      const Color(0xFF132F4C),
                    ]
                  : [
                      const Color(0xFFE0F2FE),
                      const Color(0xFFF0F9FF),
                    ],
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
    AutoUpdateCheckVersion versionCheck = AutoUpdateManager.getVersionCheck();
    final tcontext = Translations.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        if (versionCheck.newVersion) ...[
          _buildUpdateNotificationBanner(context, versionCheck, tcontext),
          const SizedBox(height: 12),
        ],
        // Group 1: 核心与配置
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    tcontext.meta.settingApp,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(
                    Icons.tune_rounded,
                    size: 22,
                    color: primaryColor,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (versionCheck.newVersion) ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFF3B30),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      const Icon(Icons.keyboard_arrow_right, size: 20),
                    ],
                  ),
                  minVerticalPadding: 16,
                  onTap: () async {
                    await GroupHelper.showAppSettings(context);
                    if (mounted) {
                      setState(() {});
                    }
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                ListTile(
                  title: Text(
                    tcontext.meta.uiAnimations,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    tcontext.meta.uiAnimationsTips,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.55),
                    ),
                  ),
                  leading: Icon(
                    Icons.animation_rounded,
                    size: 22,
                    color: primaryColor,
                  ),
                  trailing: Transform.scale(
                    scale: 0.86,
                    child: Switch.adaptive(
                      value: SettingManager.getConfig().ui.enableAnimations,
                      activeThumbColor: Colors.white,
                      activeTrackColor: ThemeDefine.kColorGreenBright,
                      onChanged: (bool value) async {
                        HapticFeedback.selectionClick();
                        final ui = SettingManager.getConfig().ui;
                        ui.enableAnimations = value;
                        await SettingManager.save();
                        SettingManager.notifyAnimationsChanged();
                      },
                    ),
                  ),
                  minVerticalPadding: 14,
                  onTap: () async {
                    HapticFeedback.selectionClick();
                    final ui = SettingManager.getConfig().ui;
                    ui.enableAnimations = !ui.enableAnimations;
                    await SettingManager.save();
                    SettingManager.notifyAnimationsChanged();
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                ListTile(
                  title: Text(
                    tcontext.meta.settingCore,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(
                    Icons.settings_suggest_rounded,
                    size: 22,
                    color: primaryColor,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
                  minVerticalPadding: 16,
                  onTap: () async {
                    await GroupHelper.showClashSettings(context);
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                ListTile(
                  title: Text(
                    tcontext.meta.coreLog,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(
                    Icons.terminal_rounded,
                    size: 22,
                    color: primaryColor,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
                  minVerticalPadding: 16,
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
        const SizedBox(height: 12),

        // Group 2: 数据与同步
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    tcontext.meta.backupAndSync,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(
                    Icons.cloud_sync_outlined,
                    size: 22,
                    color: primaryColor,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
                  minVerticalPadding: 16,
                  onTap: () async {
                    GroupHelper.showBackupAndSync(context);
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Group 3: 帮助与关于
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    tcontext.meta.help,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(
                    Icons.help_outline_rounded,
                    size: 22,
                    color: primaryColor,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
                  minVerticalPadding: 16,
                  onTap: () async {
                    await GroupHelper.showHelp(context);
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                ListTile(
                  title: Text(
                    tcontext.meta.joinUs,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(
                    Icons.groups_outlined,
                    size: 22,
                    color: primaryColor,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
                  minVerticalPadding: 16,
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: QrcodeScreen.routSettings(),
                        builder: (context) => QrcodeScreen(
                          title: tcontext.meta.joinUs,
                          content: "https://t.me/wmimoapp",
                        ),
                      ),
                    );
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                ListTile(
                  title: Text(
                    tcontext.meta.about,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  leading: Icon(
                    Icons.info_outline_rounded,
                    size: 22,
                    color: primaryColor,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
                  minVerticalPadding: 16,
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
