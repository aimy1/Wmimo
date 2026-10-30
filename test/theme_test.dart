import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_registry_utils.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/themes.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

void main() {
  test('Theme serialization and deserialization', () {
    var config = SettingConfig();
    config.ui.theme = ThemeDefine.kThemeDark;
    var jsonMap = config.toJson();
    var jsonStr = jsonEncode(jsonMap);

    var decodedMap = jsonDecode(jsonStr);
    var restoredConfig = SettingConfig.fromJsonStatic(decodedMap);
    expect(restoredConfig.ui.theme, ThemeDefine.kThemeDark);
  });

  test('Theme system serialization and deserialization', () {
    var config = SettingConfig();
    config.ui.theme = ThemeDefine.kThemeSystem;
    var jsonMap = config.toJson();
    var jsonStr = jsonEncode(jsonMap);

    var decodedMap = jsonDecode(jsonStr);
    var restoredConfig = SettingConfig.fromJsonStatic(decodedMap);
    expect(restoredConfig.ui.theme, ThemeDefine.kThemeSystem);
  });

  test('Standard design tokens maintain hierarchy and backwards compatibility', () {
    expect(ThemeDefine.kRadiusLarge, 16.0);
    expect(ThemeDefine.kRadiusMedium, 12.0);
    expect(ThemeDefine.kRadiusSmall, 8.0);
    expect(ThemeDefine.kRadiusMicro, 4.0);
    expect(ThemeDefine.kCardBorderRadius, const BorderRadius.all(Radius.circular(16.0)));
    expect(ThemeDefine.kBorderRadius, const BorderRadius.all(Radius.circular(16.0)));
    expect(ThemeDefine.kButtonBorderRadius, const BorderRadius.all(Radius.circular(12.0)));
  });

  testWidgets('WmimoAppBar renders title, badge, actions and responds to theme', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          appBar: WmimoAppBar(
            title: 'Test Navigation',
            badge: const Text('Beta'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {},
              ),
            ],
          ),
          body: const SizedBox.shrink(),
        ),
      ),
    );

    expect(find.text('Test Navigation'), findsOneWidget);
    expect(find.text('Beta'), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  test('Themes notifies listeners and triggers syncTheme', () {
    final themes = Themes();
    bool listenerCalled = false;
    themes.addListener(() {
      listenerCalled = true;
    });

    themes.setTheme(ThemeDefine.kThemeDark, true);
    expect(themes.theme(), ThemeDefine.kThemeDark);
    expect(listenerCalled, isTrue);

    listenerCalled = false;
    themes.setTheme(ThemeDefine.kThemeLight, false);
    expect(themes.theme(), ThemeDefine.kThemeLight);
    expect(listenerCalled, isFalse);
  });

  test('Atomic config write and backup fallback recover dark theme if setting.json is truncated on reboot', () async {
    final tempDir = await Directory.systemTemp.createTemp('wmimo_theme_test_');
    try {
      final settingPath = '${tempDir.path}/setting.json';
      final config = SettingConfig();
      config.ui.theme = ThemeDefine.kThemeDark;
      final content = const JsonEncoder.withIndent('  ').convert(config.toJson());

      await SettingManager.writeConfigFileAtomic(settingPath, content);
      expect(File(settingPath).existsSync(), isTrue);
      expect(File('$settingPath.bak').existsSync(), isTrue);
      expect(File('$settingPath.tmp').existsSync(), isFalse);

      // Simulate abrupt OS reboot truncating setting.json to 0 bytes mid-write
      await File(settingPath).writeAsString('', flush: true);
      expect(await File(settingPath).length(), 0);

      final recoveredMap = await SettingManager.readConfigMapWithFallback(settingPath);
      expect(recoveredMap, isNotNull);
      final recoveredConfig = SettingConfig.fromJsonStatic(recoveredMap);
      expect(recoveredConfig.ui.theme, ThemeDefine.kThemeDark);

      // Simulate partial/corrupted JSON write during shutdown
      await File(settingPath).writeAsString('{"language_tag": "zh-CN", "ui": {"theme": "da', flush: true);
      final recoveredFromCorrupt = await SettingManager.readConfigMapWithFallback(settingPath);
      expect(recoveredFromCorrupt, isNotNull);
      expect(SettingConfig.fromJsonStatic(recoveredFromCorrupt).ui.theme, ThemeDefine.kThemeDark);
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  });

  test('Windows registry theme persistence round-trips dark theme', () {
    if (!Platform.isWindows) return;
    final previous = AppRegistryUtils.getTheme();
    try {
      AppRegistryUtils.saveTheme(ThemeDefine.kThemeDark);
      expect(AppRegistryUtils.getTheme(), ThemeDefine.kThemeDark);
    } finally {
      AppRegistryUtils.saveTheme(previous ?? ThemeDefine.kThemeDark);
    }
  });
}
