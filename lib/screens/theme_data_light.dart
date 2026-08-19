import 'package:wmimo/screens/theme_define.dart';
import 'package:flutter/material.dart';

class ThemeDataLight {
  static const Color mainColor = ThemeDefine.kColorLightCard;
  static const Color mainBgColor = ThemeDefine.kColorLightBg;
  static ThemeData theme(BuildContext context) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: ThemeDefine.kColorBlue,
      primary: ThemeDefine.kColorBlue,
      brightness: Brightness.light,
      surface: mainBgColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      platform: TargetPlatform.iOS,
      scaffoldBackgroundColor: scheme.surface,
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(
            color: Color(0xFFE2E8F0),
            width: 0.8,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFF1F5F9),
        thickness: 0.8,
        space: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: Colors.white,
        filled: true,
        labelStyle: TextStyle(color: Color(0xFF94A3B8)),
        floatingLabelStyle: TextStyle(color: ThemeDefine.kColorBlue),
        helperStyle: TextStyle(color: Color(0xFF94A3B8)),
        hintStyle: TextStyle(color: Color(0xFF94A3B8)),
        errorStyle: TextStyle(color: ThemeDefine.kColorRed),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE2E8F0)),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeDefine.kColorBlue, width: 1.5),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 4),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.resolveWith((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.focused)) {
              return ThemeDefine.kColorBlueDark;
            }
            if (states.contains(WidgetState.selected)) {
              return ThemeDefine.kColorBlueLight;
            }
            return ThemeDefine.kColorBlue;
          }),
          foregroundColor: WidgetStateProperty.all(Colors.white),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.all(Colors.white),
        checkColor: WidgetStateProperty.all(ThemeDefine.kColorGreenBright),
        overlayColor: WidgetStateProperty.all(Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(strokeWidth: 2.5),
    );
  }
}
