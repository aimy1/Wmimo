import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';

class HomeCardsManagerSheet extends StatefulWidget {
  const HomeCardsManagerSheet({super.key});

  static Future<void> show(BuildContext context) {
    HapticFeedback.selectionClick();
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const HomeCardsManagerSheet(),
    );
  }

  @override
  State<HomeCardsManagerSheet> createState() => _HomeCardsManagerSheetState();
}

class _HomeCardsManagerSheetState extends State<HomeCardsManagerSheet> {
  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final ui = SettingManager.getConfig().ui;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
        maxWidth: 560,
      ),
      margin: EdgeInsets.only(
        left: MediaQuery.of(context).size.width > 600
            ? (MediaQuery.of(context).size.width - 560) / 2
            : 0,
        right: MediaQuery.of(context).size.width > 600
            ? (MediaQuery.of(context).size.width - 560) / 2
            : 0,
      ),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF475569)
                      : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.dashboard_customize_outlined,
                      size: 20,
                      color: ThemeDefine.kColorBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tcontext.meta.homeCardsManage,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          tcontext.meta.homeCardsManageTips,
                          style: TextStyle(
                            fontSize: 11.5,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
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
            const Divider(height: 1, thickness: 0.8),
            // Switch List
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  children: [
                    _buildSwitchTile(
                      icon: Icons.ssid_chart_rounded,
                      iconColor: ThemeDefine.kColorAmber,
                      title: tcontext.meta.cardTrafficChart,
                      value: ui.showTrafficChart,
                      onChanged: (val) {
                        setState(() => ui.showTrafficChart = val);
                        _saveAndNotify();
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.wifi_tethering_rounded,
                      iconColor: ThemeDefine.kColorBlue,
                      title: tcontext.meta.cardWebsiteTest,
                      value: ui.showWebsiteTest,
                      onChanged: (val) {
                        setState(() => ui.showWebsiteTest = val);
                        _saveAndNotify();
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.public_rounded,
                      iconColor: const Color(0xFF06B6D4),
                      title: tcontext.meta.cardIpInfo,
                      value: ui.showIpInfo,
                      onChanged: (val) {
                        setState(() => ui.showIpInfo = val);
                        _saveAndNotify();
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.donut_large_rounded,
                      iconColor: ThemeDefine.kColorGreenBright,
                      title: tcontext.meta.cardSubscription,
                      value: ui.showSubscription,
                      onChanged: (val) {
                        setState(() => ui.showSubscription = val);
                        _saveAndNotify();
                      },
                    ),
                    _buildSwitchTile(
                      icon: Icons.grid_view_rounded,
                      iconColor: const Color(0xFF8B5CF6),
                      title: tcontext.meta.cardQuickActions,
                      value: ui.showQuickActions,
                      onChanged: (val) {
                        setState(() => ui.showQuickActions = val);
                        _saveAndNotify();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Divider(
                        height: 1,
                        thickness: 0.8,
                        color: theme.dividerColor.withValues(alpha: 0.3),
                      ),
                    ),
                    _buildSwitchTile(
                      icon: Icons.splitscreen_rounded,
                      iconColor: const Color(0xFF64748B),
                      title: tcontext.meta.sideBySideLayout,
                      subtitle: tcontext.meta.sideBySideLayoutTips,
                      value: ui.sideBySideLayout,
                      onChanged: (val) {
                        setState(() => ui.sideBySideLayout = val);
                        _saveAndNotify(notifySideBySide: true);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Reset to default button
                    Center(
                      child: TextButton.icon(
                        icon: const Icon(Icons.refresh_rounded, size: 16),
                        label: Text(tcontext.meta.resetDefaultCards),
                        style: TextButton.styleFrom(
                          foregroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            ui.showTrafficChart = true;
                            ui.showWebsiteTest = true;
                            ui.showIpInfo = true;
                            ui.showSubscription = true;
                            ui.showQuickActions = true;
                            ui.sideBySideLayout = true;
                          });
                          _saveAndNotify(notifySideBySide: true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isDark
            ? ThemeDefine.kColorDarkInner
            : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
        leading: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              )
            : null,
        trailing: Transform.scale(
          scale: 0.82,
          child: Switch.adaptive(
            value: value,
            activeTrackColor: ThemeDefine.kColorGreenBright,
            activeThumbColor: Colors.white,
            onChanged: (v) {
              HapticFeedback.lightImpact();
              onChanged(v);
            },
          ),
        ),
        onTap: () {
          HapticFeedback.lightImpact();
          onChanged(!value);
        },
      ),
    );
  }

  void _saveAndNotify({bool notifySideBySide = false}) {
    SettingManager.save();
    SettingManager.notifyHomeCardsChanged();
    if (notifySideBySide) {
      SettingManager.notifySideBySideLayoutChanged();
    }
  }
}
