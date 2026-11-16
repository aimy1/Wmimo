import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_hotkey_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class HotkeySettingsScreen extends StatefulWidget {
  const HotkeySettingsScreen({super.key});

  static RouteSettings routSettings() {
    return const RouteSettings(name: "HotkeySettingsScreen");
  }

  @override
  State<HotkeySettingsScreen> createState() => _HotkeySettingsScreenState();
}

class _HotkeySettingsScreenState extends State<HotkeySettingsScreen> {
  SettingConfig get _config => SettingManager.getConfig();
  SettingConfigItemHotkeys get _hotkeys => _config.hotkeys;

  Future<void> _updateSettings() async {
    await SettingManager.save();
    await AppHotkeyManager.registerAll();
    if (mounted) setState(() {});
  }

  Future<void> _resetToDefaults() async {
    _hotkeys.enabled = true;
    _hotkeys.toggleWindow = true;
    _hotkeys.toggleProxy = true;
    _hotkeys.toggleSystemProxy = true;
    _hotkeys.cycleProxyMode = true;
    await _updateSettings();
  }

  Widget _buildKeyBadge(String text, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF232D3F) : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? const Color(0xFF38455A) : const Color(0xFFCBD5E1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: Platform.isMacOS ? '.SF Pro Text' : 'monospace',
          color: isDark ? Colors.white : const Color(0xFF1E293B),
        ),
      ),
    );
  }

  Widget _buildShortcutBadges(List<String> keys, bool isDark) {
    final List<Widget> children = [];
    for (int i = 0; i < keys.length; i++) {
      children.add(_buildKeyBadge(keys[i], isDark));
      if (i < keys.length - 1) {
        children.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              "+",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
        );
      }
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    );
  }

  Widget _buildCard({
    required Widget child,
    required bool isDark,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF161F30) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.black.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildHotkeyRow({
    required String title,
    String? subtitle,
    required List<String> shortcutKeys,
    required bool value,
    required ValueChanged<bool> onChanged,
    required bool isDark,
    required bool isMasterEnabled,
  }) {
    return _buildCard(
      isDark: isDark,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isMasterEnabled
                        ? (isDark ? Colors.white : Colors.black87)
                        : (isDark ? Colors.grey[600] : Colors.grey[400]),
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                _buildShortcutBadges(shortcutKeys, isDark),
              ],
            ),
          ),
          Switch.adaptive(
            value: isMasterEnabled && value,
            activeThumbColor: Colors.white,
            activeTrackColor: ThemeDefine.kColorBlue,
            onChanged: isMasterEnabled
                ? (v) {
                    onChanged(v);
                    _updateSettings();
                  }
                : null,
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

    final primaryKey = Platform.isMacOS ? "⌘" : "Ctrl";
    final shiftKey = Platform.isMacOS ? "⇧" : "Shift";

    return Scaffold(
      appBar: WmimoAppBar(
        title: Text(tcontext.hotkeys.title),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          // Master switch card
          _buildCard(
            isDark: isDark,
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: ThemeDefine.kColorBlue.withValues(
                      alpha: isDark ? 0.25 : 0.12,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_outlined,
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
                        tcontext.hotkeys.enableGlobal,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tcontext.hotkeys.enableGlobalTip,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Switch.adaptive(
                  value: _hotkeys.enabled,
                  activeThumbColor: Colors.white,
                  activeTrackColor: ThemeDefine.kColorBlue,
                  onChanged: (v) {
                    _hotkeys.enabled = v;
                    _updateSettings();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(
              tcontext.hotkeys.shortcutsList,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),

          // 1. Toggle Window
          _buildHotkeyRow(
            title: tcontext.hotkeys.toggleWindow,
            subtitle: tcontext.hotkeys.toggleWindowTip,
            shortcutKeys: [primaryKey, shiftKey, "W"],
            value: _hotkeys.toggleWindow,
            onChanged: (v) => _hotkeys.toggleWindow = v,
            isDark: isDark,
            isMasterEnabled: _hotkeys.enabled,
          ),

          // 2. Toggle Proxy Connection
          _buildHotkeyRow(
            title: tcontext.hotkeys.toggleProxy,
            subtitle: tcontext.hotkeys.toggleProxyTip,
            shortcutKeys: [primaryKey, shiftKey, "C"],
            value: _hotkeys.toggleProxy,
            onChanged: (v) => _hotkeys.toggleProxy = v,
            isDark: isDark,
            isMasterEnabled: _hotkeys.enabled,
          ),

          // 3. Toggle System Proxy
          _buildHotkeyRow(
            title: tcontext.hotkeys.toggleSystemProxy,
            subtitle: tcontext.hotkeys.toggleSystemProxyTip,
            shortcutKeys: [primaryKey, shiftKey, "S"],
            value: _hotkeys.toggleSystemProxy,
            onChanged: (v) => _hotkeys.toggleSystemProxy = v,
            isDark: isDark,
            isMasterEnabled: _hotkeys.enabled,
          ),

          // 4. Cycle Proxy Mode
          _buildHotkeyRow(
            title: tcontext.hotkeys.cycleMode,
            subtitle: tcontext.hotkeys.cycleModeTip,
            shortcutKeys: [primaryKey, shiftKey, "M"],
            value: _hotkeys.cycleProxyMode,
            onChanged: (v) => _hotkeys.cycleProxyMode = v,
            isDark: isDark,
            isMasterEnabled: _hotkeys.enabled,
          ),

          const SizedBox(height: 16),
          // Reset to defaults button
          Center(
            child: TextButton.icon(
              onPressed: _resetToDefaults,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(tcontext.hotkeys.resetDefault),
              style: TextButton.styleFrom(
                foregroundColor: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
