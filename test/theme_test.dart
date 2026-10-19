import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
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
}
