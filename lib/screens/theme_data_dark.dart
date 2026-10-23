import 'package:wmimo/screens/theme_define.dart';
import 'package:flutter/material.dart';

class ThemeDataDark {
  static const Color mainColor = ThemeDefine.kColorDarkCard;
  static const Color mainBgColor = ThemeDefine.kColorDarkBg;

  static ThemeData theme(BuildContext context) {
    final ColorScheme scheme = ColorScheme.fromSeed(
      seedColor: ThemeDefine.kColorBlue,
      primary: ThemeDefine.kColorBlue,
      brightness: Brightness.dark,
      surface: mainBgColor,
    ).copyWith(
      surface: ThemeDefine.kColorDarkBg,
      surfaceDim: const Color(0xFF0D0D0E),
      surfaceBright: const Color(0xFF2C2C2E),
      surfaceContainerLowest: const Color(0xFF0E0E10),
      surfaceContainerLow: ThemeDefine.kColorDarkSidebar,
      surfaceContainer: ThemeDefine.kColorDarkCard,
      surfaceContainerHigh: ThemeDefine.kColorDarkElevated,
      surfaceContainerHighest: const Color(0xFF323236),
      onSurface: const Color(0xFFF2F2F7),
      onSurfaceVariant: const Color(0xFF98989D),
      outline: const Color(0xFF3A3A3C),
      outlineVariant: ThemeDefine.kColorDarkBorder,
      surfaceTint: Colors.transparent,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      platform: TargetPlatform.iOS,
      scaffoldBackgroundColor: ThemeDefine.kColorDarkBg,
      canvasColor: ThemeDefine.kColorDarkCard,
      cardColor: ThemeDefine.kColorDarkCard,
      dividerColor: ThemeDefine.kColorDarkBorder,
      appBarTheme: const AppBarTheme(
        backgroundColor: ThemeDefine.kColorDarkBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: ThemeDefine.kColorDarkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(
            color: ThemeDefine.kColorDarkBorder,
            width: 0.8,
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ThemeDefine.kColorDarkCard,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(
            color: ThemeDefine.kColorDarkBorder,
            width: 0.8,
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: ThemeDefine.kColorDarkElevated,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
            color: ThemeDefine.kColorDarkBorder,
            width: 0.8,
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: ThemeDefine.kColorDarkBorder,
        thickness: 0.8,
        space: 1,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: ThemeDefine.kColorDarkCard,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: ThemeDefine.kColorDarkInner,
        filled: true,
        labelStyle: TextStyle(color: Color(0xFF98989D)),
        floatingLabelStyle: TextStyle(color: ThemeDefine.kColorBlue),
        helperStyle: TextStyle(color: Color(0xFF98989D)),
        hintStyle: TextStyle(color: Color(0xFF8E8E93)),
        errorStyle: TextStyle(color: ThemeDefine.kColorRed),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeDefine.kColorDarkBorder),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ThemeDefine.kColorDarkBorder),
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
        fillColor: WidgetStateProperty.all(ThemeDefine.kColorDarkElevated),
        checkColor: WidgetStateProperty.all(ThemeDefine.kColorGreenBright),
        overlayColor: WidgetStateProperty.all(Colors.grey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 60,
        backgroundColor: ThemeDefine.kColorDarkSidebar,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: ThemeDefine.kColorBlue.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: ThemeDefine.kColorBlue, size: 22);
          }
          return const IconThemeData(color: Color(0xFF8E8E93), size: 22);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: ThemeDefine.kColorBlue,
            );
          }
          return const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Color(0xFF98989D),
          );
        }),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(strokeWidth: 2.5),
    );
  }
}
