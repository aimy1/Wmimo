import 'dart:io';

import 'package:flutter/material.dart';

class ThemeConfig {
  static const double kListItemHeight = 58;
  static const double kListItemHeight2 = 48;
  static const double kGroupItemHeight = 48;
  static const double kCardRadius = 18.0;

  static const double kFontSizeTitle = 19;
  static const FontWeight kFontWeightTitle = FontWeight.w700;

  static const double kFontSizeListItem = 15.5;
  static const FontWeight kFontWeightListItem = FontWeight.w600;

  static const double kFontSizeListSubItem = 13.0;
  static const FontWeight kFontWeightListSubItem = FontWeight.w400;

  static double kFontSizeGroupItem = (Platform.isAndroid || Platform.isIOS)
      ? 15
      : 14;
  static const FontWeight kFontWeightGroupItem = FontWeight.w400;
}
