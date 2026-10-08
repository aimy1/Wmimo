import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/screens/theme_define.dart';

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
}
