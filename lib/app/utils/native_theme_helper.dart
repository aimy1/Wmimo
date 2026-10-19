import 'dart:io';
import 'package:flutter/services.dart';

class NativeThemeHelper {
  static const MethodChannel _channel = MethodChannel('wmimo/native_theme');

  /// Synchronizes theme mode ('dark', 'light', or 'system') with the native platform runner.
  static Future<void> syncTheme(String theme) async {
    if (!Platform.isWindows) {
      return;
    }
    try {
      await _channel.invokeMethod('setAppTheme', {'theme': theme});
    } catch (_) {}
  }
}
