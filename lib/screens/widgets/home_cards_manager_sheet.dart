import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';

class HomeCardsManagerSheet extends StatefulWidget {
  final bool isDialog;

  const HomeCardsManagerSheet({
    super.key,
    this.isDialog = false,
  });

  static Future<void> show(BuildContext context) {
    HapticFeedback.selectionClick();
    final isDesktop = Platform.isWindows || Platform.isMacOS || Platform.isLinux;
    if (isDesktop) {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        routeSettings: const RouteSettings(name: "HomeCardsManagerDialog"),
        builder: (dialogCtx) => const HomeCardsManagerSheet(isDialog: true),
      );
    }
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      routeSettings: const RouteSettings(name: "HomeCardsManagerSheet"),
      builder: (sheetCtx) => const HomeCardsManagerSheet(isDialog: false),
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

    final cardBg = isDark ? ThemeDefine.kColorDarkCard : Colors.white;

    if (widget.isDialog) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: 480,
          constraints: BoxConstraints(
            maxWidth: 480,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: isDark ? 0.25 : 0.12),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, isDark, theme, tcontext),
              const Divider(height: 1, thickness: 0.8),
              _buildQuickActionsRow(context, isDark, theme, tcontext, ui),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  child: _buildTilesList(context, isDark, theme, tcontext, ui),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Mobile Bottom Sheet
    return Align(
      alignment: Alignment.bottomCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 520,
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.15),
                blurRadius: 24,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 4),
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
                _buildHeader(context, isDark, theme, tcontext),
                const Divider(height: 1, thickness: 0.8),
                _buildQuickActionsRow(context, isDark, theme, tcontext, ui),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                    child: _buildTilesList(context, isDark, theme, tcontext, ui),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isDark,
    ThemeData theme,
    Translations tcontext,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 14, 12, 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
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
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
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
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
            icon: const Icon(Icons.close_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsRow(
    BuildContext context,
    bool isDark,
    ThemeData theme,
    Translations tcontext,
    SettingConfigItemUI ui,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildQuickPill(
              icon: Icons.unfold_less_rounded,
              label: tcontext.meta.collapseAllCards,
              onTap: _collapseAll,
            ),
            const SizedBox(width: 8),
            _buildQuickPill(
              icon: Icons.unfold_more_rounded,
              label: tcontext.meta.expandAllCards,
              onTap: _expandAll,
            ),
            const SizedBox(width: 12),
            _buildQuickPill(
              icon: Icons.refresh_rounded,
              label: tcontext.meta.resetDefaultCards,
              onTap: _resetDefaults,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTilesList(
    BuildContext context,
    bool isDark,
    ThemeData theme,
    Translations tcontext,
    SettingConfigItemUI ui,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
      ],
    );
  }

  Widget _buildQuickPill({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: isDark ? 0.2 : 0.1),
              width: 0.8,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 13.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
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

    final bgColor = isDark ? ThemeDefine.kColorDarkInner : const Color(0xFFF8FAFC);
    final borderColor = theme.dividerColor.withValues(alpha: isDark ? 0.25 : 0.12);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 0.8),
        ),
        clipBehavior: Clip.antiAlias,
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
      ),
    );
  }

  void _collapseAll() {
    HapticFeedback.lightImpact();
    final ui = SettingManager.getConfig().ui;
    setState(() {
      ui.collapseTrafficChart = true;
      ui.collapseWebsiteTest = true;
      ui.collapseIpInfo = true;
      ui.collapseSubscription = true;
      ui.collapseQuickActions = true;
    });
    _saveAndNotify();
  }

  void _expandAll() {
    HapticFeedback.lightImpact();
    final ui = SettingManager.getConfig().ui;
    setState(() {
      ui.collapseTrafficChart = false;
      ui.collapseWebsiteTest = false;
      ui.collapseIpInfo = false;
      ui.collapseSubscription = false;
      ui.collapseQuickActions = false;
    });
    _saveAndNotify();
  }

  void _resetDefaults() {
    HapticFeedback.lightImpact();
    final ui = SettingManager.getConfig().ui;
    setState(() {
      ui.showTrafficChart = true;
      ui.showWebsiteTest = true;
      ui.showIpInfo = true;
      ui.showSubscription = true;
      ui.showQuickActions = true;
      ui.collapseTrafficChart = false;
      ui.collapseWebsiteTest = false;
      ui.collapseIpInfo = false;
      ui.collapseSubscription = false;
      ui.collapseQuickActions = false;
    });
    _saveAndNotify();
  }

  void _saveAndNotify() {
    SettingManager.save();
    SettingManager.notifyHomeCardsChanged();
  }
}
