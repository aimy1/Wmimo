import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_hotkey_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SettingConfigItemHotkeys Model & Serialization', () {
    test('Default values are all enabled (true)', () {
      final hotkeys = SettingConfigItemHotkeys();
      expect(hotkeys.enabled, isTrue);
      expect(hotkeys.toggleWindow, isTrue);
      expect(hotkeys.toggleProxy, isTrue);
      expect(hotkeys.toggleSystemProxy, isTrue);
      expect(hotkeys.cycleProxyMode, isTrue);
    });

    test('toJson and fromJson correctly serialize and deserialize', () {
      final original = SettingConfigItemHotkeys(
        enabled: false,
        toggleWindow: false,
        toggleProxy: true,
        toggleSystemProxy: false,
        cycleProxyMode: true,
      );

      final json = original.toJson();
      expect(json['enabled'], isFalse);
      expect(json['toggle_window'], isFalse);
      expect(json['toggle_proxy'], isTrue);
      expect(json['toggle_system_proxy'], isFalse);
      expect(json['cycle_proxy_mode'], isTrue);

      final restored = SettingConfigItemHotkeys.fromJson(json);
      expect(restored.enabled, isFalse);
      expect(restored.toggleWindow, isFalse);
      expect(restored.toggleProxy, isTrue);
      expect(restored.toggleSystemProxy, isFalse);
      expect(restored.cycleProxyMode, isTrue);
    });

    test('fromJson handles null or empty map gracefully with defaults', () {
      final fromEmpty = SettingConfigItemHotkeys.fromJson({});
      expect(fromEmpty.enabled, isTrue);
      expect(fromEmpty.toggleWindow, isTrue);
      expect(fromEmpty.toggleProxy, isTrue);
      expect(fromEmpty.toggleSystemProxy, isTrue);
      expect(fromEmpty.cycleProxyMode, isTrue);
    });

    test('SettingConfig contains and persists hotkeys field', () {
      final setting = SettingConfig();
      expect(setting.hotkeys, isNotNull);
      expect(setting.hotkeys.enabled, isTrue);

      setting.hotkeys.toggleProxy = false;
      final encoded = jsonEncode(setting.toJson());
      final json = jsonDecode(encoded) as Map<String, dynamic>;
      expect(json['hotkeys'], isNotNull);
      expect(json['hotkeys']['toggle_proxy'], isFalse);

      final restored = SettingConfig.fromJson(json);
      expect(restored.hotkeys.toggleProxy, isFalse);
      expect(restored.hotkeys.cycleProxyMode, isTrue);
    });
  });

  group('AppHotkeyManager Proxy Mode Cycling & Key Definition', () {
    test('getNextProxyMode cycles correctly: rule -> global -> direct -> rule', () {
      expect(
        AppHotkeyManager.getNextProxyMode(ClashConfigsMode.rule),
        equals(ClashConfigsMode.global),
      );
      expect(
        AppHotkeyManager.getNextProxyMode(ClashConfigsMode.global),
        equals(ClashConfigsMode.direct),
      );
      expect(
        AppHotkeyManager.getNextProxyMode(ClashConfigsMode.direct),
        equals(ClashConfigsMode.rule),
      );
    });

    test('Platform modifier keys mapping', () {
      if (Platform.isMacOS) {
        expect(AppHotkeyManager.primaryModifier, equals(HotKeyModifier.meta));
      } else {
        expect(AppHotkeyManager.primaryModifier, equals(HotKeyModifier.control));
      }
      expect(AppHotkeyManager.secondaryModifier, equals(HotKeyModifier.shift));
      expect(
        AppHotkeyManager.defaultModifiers,
        containsAll([AppHotkeyManager.primaryModifier, HotKeyModifier.shift]),
      );
    });

    test('Hotkey instances configuration and system scope', () {
      expect(AppHotkeyManager.hotkeyToggleWindow.key, equals(PhysicalKeyboardKey.keyW));
      expect(AppHotkeyManager.hotkeyToggleWindow.scope, equals(HotKeyScope.system));

      expect(AppHotkeyManager.hotkeyToggleProxy.key, equals(PhysicalKeyboardKey.keyC));
      expect(AppHotkeyManager.hotkeyToggleProxy.scope, equals(HotKeyScope.system));

      expect(AppHotkeyManager.hotkeyToggleSystemProxy.key, equals(PhysicalKeyboardKey.keyS));
      expect(AppHotkeyManager.hotkeyToggleSystemProxy.scope, equals(HotKeyScope.system));

      expect(AppHotkeyManager.hotkeyCycleMode.key, equals(PhysicalKeyboardKey.keyM));
      expect(AppHotkeyManager.hotkeyCycleMode.scope, equals(HotKeyScope.system));
    });
  });
}
