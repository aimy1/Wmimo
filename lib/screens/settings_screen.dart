import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/auto_update_manager.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/about_screen.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/group_helper.dart';
import 'package:wmimo/screens/language_settings_screen.dart';
import 'package:wmimo/screens/logs_screen.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/themes.dart';
import 'package:libclash_vpn_service/state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> items,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title Header
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: isDark ? 0.2 : 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, size: 15, color: iconColor),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          // Section Container Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.35),
                width: 0.8,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) => items[index],
                separatorBuilder: (_, __) => Divider(
                  height: 1,
                  thickness: 0.7,
                  color: theme.dividerColor.withValues(alpha: 0.25),
                ),
                itemCount: items.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final setting = SettingManager.getConfig();
    final clashSetting = ClashSettingManager.getConfig();
    final versionCheck = AutoUpdateManager.getVersionCheck();

    // 1. General & System Settings
    final generalItems = [
      // System Proxy Switch
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.security_rounded, color: Color(0xFF3B82F6), size: 20),
        ),
        title: Text(
          tcontext.meta.autoSetSystemProxy,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          isDark ? "自动设置 Windows 系统代理" : "自动设置系统代理",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: Switch(
          value: setting.autoSetSystemProxy,
          onChanged: (val) async {
            setState(() {
              setting.autoSetSystemProxy = val;
            });
            SettingManager.save();
            await VPNService.setSystemProxy(val);
          },
        ),
      ),
      // Auto Connect on Launch
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.power_settings_new_rounded, color: Color(0xFF10B981), size: 20),
        ),
        title: Text(
          tcontext.meta.autoConnectAfterLaunch,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "应用启动后自动连接代理内核",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: Switch(
          value: setting.autoConnectAfterLaunch,
          onChanged: (val) {
            setState(() {
              setting.autoConnectAfterLaunch = val;
            });
            SettingManager.save();
          },
        ),
      ),
      // Silent Start / Hide after launch on Windows
      if (Platform.isWindows)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: isDark ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.visibility_off_outlined, color: Color(0xFF8B5CF6), size: 20),
          ),
          title: Text(
            tcontext.meta.hideAfterLaunch,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            "启动后最小化至系统托盘",
            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
          ),
          trailing: Switch(
            value: setting.ui.hideAfterLaunch,
            onChanged: (val) {
              setState(() {
                setting.ui.hideAfterLaunch = val;
              });
              SettingManager.save();
            },
          ),
        ),
      // Theme Mode Selector
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.palette_outlined, color: Color(0xFFF59E0B), size: 20),
        ),
        title: Text(
          tcontext.meta.theme,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          setting.ui.theme == ThemeDefine.kThemeDark
              ? "深色主题"
              : setting.ui.theme == ThemeDefine.kThemeLight
                  ? "浅色主题"
                  : "跟随系统",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: [ThemeDefine.kThemeLight, ThemeDefine.kThemeDark, ThemeDefine.kThemeSystem]
                      .contains(setting.ui.theme)
                  ? setting.ui.theme
                  : ThemeDefine.kThemeSystem,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              items: const [
                DropdownMenuItem(value: ThemeDefine.kThemeLight, child: Text("浅色模式")),
                DropdownMenuItem(value: ThemeDefine.kThemeDark, child: Text("深色模式")),
                DropdownMenuItem(value: ThemeDefine.kThemeSystem, child: Text("跟随系统")),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    setting.ui.theme = val;
                  });
                  Provider.of<Themes>(context, listen: false).setTheme(val, true);
                  SettingManager.save();
                }
              },
            ),
          ),
        ),
      ),
      // Language Selector
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF06B6D4).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.language_outlined, color: Color(0xFF06B6D4), size: 20),
        ),
        title: Text(
          tcontext.meta.language,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          tcontext.locales[setting.languageTag] ?? "简体中文",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              settings: LanguageSettingsScreen.routSettings(),
              builder: (context) => const LanguageSettingsScreen(canPop: true, canGoBack: true),
            ),
          );
          setState(() {});
        },
      ),
    ];

    // 2. Core & Network Settings
    final coreMode = clashSetting.Mode ?? ClashConfigsMode.rule.name;
    final coreItems = [
      // Clash Mode Selector (Rule / Global / Direct)
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.alt_route_rounded, color: Color(0xFF6366F1), size: 20),
        ),
        title: const Text(
          "分流模式 (Mode)",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          coreMode == ClashConfigsMode.rule.name
              ? "规则分流 (推荐)"
              : coreMode == ClashConfigsMode.global.name
                  ? "全局代理"
                  : "直接连接",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: "rule", label: Text("规则", style: TextStyle(fontSize: 11))),
            ButtonSegment(value: "global", label: Text("全局", style: TextStyle(fontSize: 11))),
            ButtonSegment(value: "direct", label: Text("直连", style: TextStyle(fontSize: 11))),
          ],
          selected: {coreMode.toLowerCase()},
          style: ButtonStyle(
            visualDensity: VisualDensity.compact,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 6, vertical: 2)),
          ),
          onSelectionChanged: (newSelection) async {
            final modeStr = newSelection.first;
            final targetMode = ClashConfigsMode.values.firstWhere(
              (e) => e.name.toLowerCase() == modeStr.toLowerCase(),
              orElse: () => ClashConfigsMode.rule,
            );
            setState(() {
              clashSetting.Mode = targetMode.name;
            });
            await ClashSettingManager.setConfigsMode(targetMode);
          },
        ),
      ),
      // Mixed Port (7890)
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFEC4899).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.numbers_rounded, color: Color(0xFFEC4899), size: 20),
        ),
        title: const Text(
          "混合代理端口 (Mixed Port)",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "HTTP / SOCKS5 共享入站端口",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "${ClashSettingManager.getMixedPort()}",
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
        onTap: () async {
          await GroupHelper.showClashSettings(context);
          setState(() {});
        },
      ),
      // External Controller Port (9090)
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF14B8A6).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.api_rounded, color: Color(0xFF14B8A6), size: 20),
        ),
        title: const Text(
          "RESTful 控制端口",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "外部 API 控制及 Web 控制台端口",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)).withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            "${ClashSettingManager.getControlPort()}",
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          ),
        ),
        onTap: () async {
          await GroupHelper.showClashSettings(context);
          setState(() {});
        },
      ),
      // Advanced Core Settings button
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.settings_suggest_rounded, color: Color(0xFF3B82F6), size: 20),
        ),
        title: Text(
          tcontext.meta.settingCore,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "DNS、TUN 网卡、分流模板与高级参数",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: () async {
          await GroupHelper.showClashSettings(context);
          setState(() {});
        },
      ),
    ];

    // 3. Data & Sync Settings
    final dataItems = [
      // Backup & Sync
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF0EA5E9).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.cloud_sync_outlined, color: Color(0xFF0EA5E9), size: 20),
        ),
        title: Text(
          tcontext.meta.backupAndSync,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "WebDAV 云同步与本地数据备份",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: () {
          GroupHelper.showBackupAndSync(context);
        },
      ),
      // Core Logs Jump
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF64748B).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.terminal_rounded, color: Color(0xFF64748B), size: 20),
        ),
        title: Text(
          tcontext.meta.coreLog,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "实时捕获核心标准输出与诊断日志",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
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
    ];

    // 4. About & Maintenance
    final aboutItems = [
      // Check Updates
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.system_update_alt_rounded, color: Color(0xFF10B981), size: 20),
        ),
        title: Text(
          versionCheck.newVersion
              ? tcontext.meta.hasNewVersion(p: versionCheck.version)
              : "检查更新",
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "当前版本: ${AppUtils.getReleaseVersion()} (Mihomo Alpha Core)",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: versionCheck.newVersion
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "可升级",
                  style: TextStyle(color: Colors.amber, fontSize: 11, fontWeight: FontWeight.w700),
                ),
              )
            : const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: () {
          GroupHelper.newVersionUpdate(context);
        },
      ),
      // Help
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.help_outline_rounded, color: Color(0xFFF59E0B), size: 20),
        ),
        title: Text(
          tcontext.meta.help,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "常见问题与配置说明",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
        onTap: () async {
          await GroupHelper.showHelp(context);
        },
      ),
      // About Wmimo
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.info_outline_rounded, color: Color(0xFF3B82F6), size: 20),
        ),
        title: Text(
          tcontext.meta.about,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          "Wmimo 项目与开源许可",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20),
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
      // Reset Settings (Red action)
      ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: isDark ? 0.2 : 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.restart_alt_rounded, color: Colors.red, size: 20),
        ),
        title: const Text(
          "恢复默认设置",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.red),
        ),
        subtitle: Text(
          "清除所有自定义偏好并重置为初始配置",
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.red, size: 20),
        onTap: () async {
          final confirm = await DialogUtils.showConfirmDialog(
            context,
            "确定要将所有设置恢复为默认值吗？此操作无法撤销。",
          );
          if (confirm == true) {
            SettingManager.reset();
            if (context.mounted) {
              Provider.of<Themes>(context, listen: false).setTheme(setting.ui.theme, true);
              setState(() {});
            }
          }
        },
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionCard(
          context: context,
          title: "常规与界面",
          icon: Icons.tune_rounded,
          iconColor: const Color(0xFF3B82F6),
          items: generalItems,
        ),
        _buildSectionCard(
          context: context,
          title: "内核与网络",
          icon: Icons.alt_route_rounded,
          iconColor: const Color(0xFF6366F1),
          items: coreItems,
        ),
        _buildSectionCard(
          context: context,
          title: "数据与维护",
          icon: Icons.cloud_sync_outlined,
          iconColor: const Color(0xFF0EA5E9),
          items: dataItems,
        ),
        _buildSectionCard(
          context: context,
          title: "关于与支持",
          icon: Icons.info_outline_rounded,
          iconColor: const Color(0xFF10B981),
          items: aboutItems,
        ),
      ],
    );
  }
}
