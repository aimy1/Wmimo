// ignore_for_file: empty_catches

import 'dart:io';

import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';
import 'package:libclash_vpn_service/state.dart';
import 'package:wmimo/app/clash/clash_config.dart';

class AppHotkeyManager {
  static bool _initialized = false;

  /// Primary modifier based on platform (Cmd on macOS, Ctrl on Windows/Linux)
  static HotKeyModifier get primaryModifier =>
      Platform.isMacOS ? HotKeyModifier.meta : HotKeyModifier.control;

  /// Secondary modifier (Shift across all desktop platforms)
  static HotKeyModifier get secondaryModifier => HotKeyModifier.shift;

  static List<HotKeyModifier> get defaultModifiers =>
      [primaryModifier, secondaryModifier];

  static final HotKey hotkeyToggleWindow = HotKey(
    key: PhysicalKeyboardKey.keyW,
    modifiers: defaultModifiers,
    scope: HotKeyScope.system,
  );

  static final HotKey hotkeyToggleProxy = HotKey(
    key: PhysicalKeyboardKey.keyC,
    modifiers: defaultModifiers,
    scope: HotKeyScope.system,
  );

  static final HotKey hotkeyToggleSystemProxy = HotKey(
    key: PhysicalKeyboardKey.keyS,
    modifiers: defaultModifiers,
    scope: HotKeyScope.system,
  );

  static final HotKey hotkeyCycleMode = HotKey(
    key: PhysicalKeyboardKey.keyM,
    modifiers: defaultModifiers,
    scope: HotKeyScope.system,
  );

  static Future<void> init() async {
    if (!PlatformUtils.isPC()) return;
    if (_initialized) return;
    _initialized = true;

    await registerAll();
  }

  static Future<void> registerAll() async {
    if (!PlatformUtils.isPC()) return;

    try {
      await hotKeyManager.unregisterAll();
    } catch (e) {
      Log.w("hotKeyManager unregisterAll error: $e");
    }

    final hotkeyConfig = SettingManager.getConfig().hotkeys;
    if (!hotkeyConfig.enabled) {
      _registerMacInAppClose();
      return;
    }

    // 1. Toggle Window
    if (hotkeyConfig.toggleWindow) {
      try {
        await hotKeyManager.register(
          hotkeyToggleWindow,
          keyDownHandler: (_) => toggleWindow(),
        );
      } catch (e) {
        Log.w("Failed to register hotkeyToggleWindow: $e");
      }
    }

    // 2. Toggle Proxy Connection
    if (hotkeyConfig.toggleProxy) {
      try {
        await hotKeyManager.register(
          hotkeyToggleProxy,
          keyDownHandler: (_) => toggleProxy(),
        );
      } catch (e) {
        Log.w("Failed to register hotkeyToggleProxy: $e");
      }
    }

    // 3. Toggle System Proxy
    if (hotkeyConfig.toggleSystemProxy) {
      try {
        await hotKeyManager.register(
          hotkeyToggleSystemProxy,
          keyDownHandler: (_) => toggleSystemProxy(),
        );
      } catch (e) {
        Log.w("Failed to register hotkeyToggleSystemProxy: $e");
      }
    }

    // 4. Cycle Proxy Mode (Rule -> Global -> Direct -> Rule)
    if (hotkeyConfig.cycleProxyMode) {
      try {
        await hotKeyManager.register(
          hotkeyCycleMode,
          keyDownHandler: (_) => cycleProxyMode(),
        );
      } catch (e) {
        Log.w("Failed to register hotkeyCycleMode: $e");
      }
    }

    _registerMacInAppClose();
  }

  static void _registerMacInAppClose() {
    if (Platform.isMacOS) {
      try {
        final macClose = HotKey(
          key: PhysicalKeyboardKey.keyW,
          modifiers: [HotKeyModifier.meta],
          scope: HotKeyScope.inapp,
        );
        hotKeyManager.register(
          macClose,
          keyDownHandler: (_) {
            windowManager.hide();
          },
        );
      } catch (_) {}
    }
  }

  static Future<void> toggleWindow() async {
    if (!PlatformUtils.isPC()) return;
    try {
      final isVisible = await windowManager.isVisible();
      final isMinimized = await windowManager.isMinimized();
      if (isVisible && !isMinimized) {
        final isFocused = await windowManager.isFocused();
        if (isFocused) {
          await windowManager.hide();
        } else {
          await windowManager.show();
          await windowManager.focus();
        }
      } else {
        await windowManager.show();
        if (isMinimized) {
          await windowManager.restore();
        }
        await windowManager.focus();
      }
    } catch (e) {
      Log.w("toggleWindow error: $e");
    }
  }

  static Future<void> toggleProxy() async {
    try {
      final uiState = VpnActionHandler.uiStatus.value.state;
      if (uiState == FlutterVpnServiceState.connected) {
        VpnActionHandler.vpnDisconnect?.call("hotkey", false);
      } else if (uiState == FlutterVpnServiceState.disconnected) {
        VpnActionHandler.vpnConnect?.call("hotkey", false);
      }
    } catch (e) {
      Log.w("toggleProxy error: $e");
    }
  }

  static Future<void> toggleSystemProxy() async {
    if (!PlatformUtils.isPC()) return;
    try {
      final cur = SettingManager.getConfig().autoSetSystemProxy;
      final next = !cur;
      SettingManager.getConfig().autoSetSystemProxy = next;
      await SettingManager.save();
      await VPNService.setSystemProxy(next);
    } catch (e) {
      Log.w("toggleSystemProxy error: $e");
    }
  }

  static Future<void> cycleProxyMode() async {
    try {
      final currentMode = ClashSettingManager.getConfigsMode();
      final nextMode = getNextProxyMode(currentMode);
      await ClashSettingManager.setConfigsMode(nextMode);
    } catch (e) {
      Log.w("cycleProxyMode error: $e");
    }
  }

  static ClashConfigsMode getNextProxyMode(ClashConfigsMode currentMode) {
    if (currentMode == ClashConfigsMode.rule) {
      return ClashConfigsMode.global;
    } else if (currentMode == ClashConfigsMode.global) {
      return ClashConfigsMode.direct;
    } else {
      return ClashConfigsMode.rule;
    }
  }

  static Future<void> dispose() async {
    if (!PlatformUtils.isPC()) return;
    try {
      await hotKeyManager.unregisterAll();
    } catch (_) {}
  }
}
