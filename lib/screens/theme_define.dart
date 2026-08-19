import 'package:flutter/material.dart';

class ThemeDefine {
  // Brand Accents
  static const kColorBlue = Color(0xFF00BCDF);
  static const kColorBlueLight = Color(0xFF38BDF8);
  static const kColorBlueDark = Color(0xFF0284C7);
  
  // Neutral Colors
  static const kColorGrey = Color(0xFF94A3B8);
  static const kColorGreyLight = Color(0xFFE2E8F0);
  
  // Status Colors
  static const kColorGreenBright = Color(0xFF10B981);
  static const kColorAmber = Color(0xFFF59E0B);
  static const kColorRed = Color(0xFFEF4444);

  // Backgrounds
  static const kColorLightBg = Color(0xFFF8FAFC);
  static const kColorLightCard = Color(0xFFFFFFFF);
  static const kColorDarkBg = Color(0xFF0B0F19);
  static const kColorDarkCard = Color(0xFF151D2E);
  static const kColorDarkBorder = Color(0xFF1E293B);

  static const String kThemeSystem = "system";
  static const String kThemeLight = "light";
  static const String kThemeDark = "dark";

  static const BorderRadius kBorderRadius = BorderRadius.all(
    Radius.circular(18),
  );
  static const BorderRadius kCardBorderRadius = BorderRadius.all(
    Radius.circular(18),
  );
  static const BorderRadius kButtonBorderRadius = BorderRadius.all(
    Radius.circular(12),
  );
}
