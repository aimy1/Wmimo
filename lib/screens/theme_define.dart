import 'package:flutter/material.dart';

class ThemeDefine {
  // Brand Accents
  static const kColorBlue = Color(0xFF00BCDF);
  static const kColorBlueLight = Color(0xFF38BDF8);
  static const kColorBlueDark = Color(0xFF0284C7);

  // Neutral Colors
  static const kColorGrey = Color(0xFF98989D);
  static const kColorGreyLight = Color(0xFFE2E8F0);

  // Status Colors
  static const kColorGreenBright = Color(0xFF10B981);
  static const kColorAmber = Color(0xFFF59E0B);
  static const kColorRed = Color(0xFFEF4444);

  // Backgrounds & Surfaces (Native Desktop Black / Neutral Dark Palette)
  static const kColorLightBg = Color(0xFFF8FAFC);
  static const kColorLightCard = Color(0xFFFFFFFF);
  static const kColorDarkBg = Color(0xFF121212);
  static const kColorDarkSidebar = Color(0xFF161618);
  static const kColorDarkInner = Color(0xFF141416);
  static const kColorDarkCard = Color(0xFF1C1C1E);
  static const kColorDarkElevated = Color(0xFF262629);
  static const kColorDarkBorder = Color(0xFF2C2C2E);

  static const String kThemeSystem = "system";
  static const String kThemeLight = "light";
  static const String kThemeDark = "dark";

  // 4-Tier Radius Hierarchy
  static const double kRadiusLarge = 16.0;
  static const double kRadiusMedium = 12.0;
  static const double kRadiusSmall = 8.0;
  static const double kRadiusMicro = 4.0;

  static const BorderRadius kBorderRadius = BorderRadius.all(
    Radius.circular(kRadiusLarge),
  );
  static const BorderRadius kCardBorderRadius = BorderRadius.all(
    Radius.circular(kRadiusLarge),
  );
  static const BorderRadius kButtonBorderRadius = BorderRadius.all(
    Radius.circular(kRadiusMedium),
  );

  // Unified Motion Tokens
  static const Duration kDurationMicro = Duration(milliseconds: 150);
  static const Duration kDurationState = Duration(milliseconds: 200);
  static const Duration kDurationView = Duration(milliseconds: 220);

  static const Curve kCurveStandard = Curves.easeOutCubic;
  static const Curve kCurveEmphasized = Curves.easeOutQuart;
  static const Curve kCurveView = Curves.fastOutSlowIn;
}
