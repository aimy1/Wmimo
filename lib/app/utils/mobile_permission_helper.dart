import 'dart:io';
import 'package:flutter/services.dart';
import 'package:wmimo/app/utils/log.dart';

abstract final class MobilePermissionHelper {
  static const MethodChannel _channel = MethodChannel('com.wmimo.app/native_helper');
  static bool _hasRequestedInitial = false;

  /// Request essential permissions on mobile startup
  static Future<void> requestInitialPermissions() async {
    if (!Platform.isAndroid && !Platform.isIOS) return;
    if (_hasRequestedInitial) return;
    _hasRequestedInitial = true;

    try {
      if (Platform.isAndroid) {
        // Request Notification permission for foreground VPN service on Android 13+
        await requestNotificationPermission();
      }
    } catch (err) {
      Log.w("requestInitialPermissions exception: $err");
    }
  }

  /// Check and request Android VpnService prepare permission
  /// Returns true if granted / prepared, false if user rejected
  static Future<bool> requestVpnPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool? granted = await _channel.invokeMethod<bool>('requestVpnPermission');
      return granted ?? true;
    } catch (err) {
      Log.w("requestVpnPermission exception: $err");
      return true;
    }
  }

  /// Check if Android VPN permission has already been granted
  static Future<bool> checkVpnPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool? granted = await _channel.invokeMethod<bool>('checkVpnPermission');
      return granted ?? true;
    } catch (err) {
      Log.w("checkVpnPermission exception: $err");
      return true;
    }
  }

  /// Request POST_NOTIFICATIONS permission on Android 13+ (API 33+)
  static Future<bool> requestNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool? granted = await _channel.invokeMethod<bool>('requestNotificationPermission');
      return granted ?? true;
    } catch (err) {
      Log.w("requestNotificationPermission exception: $err");
      return true;
    }
  }

  /// Check POST_NOTIFICATIONS permission
  static Future<bool> checkNotificationPermission() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool? granted = await _channel.invokeMethod<bool>('checkNotificationPermission');
      return granted ?? true;
    } catch (err) {
      Log.w("checkNotificationPermission exception: $err");
      return true;
    }
  }

  /// Request ignoring battery optimizations so VPN service is not killed in background
  static Future<bool> requestIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool? granted = await _channel.invokeMethod<bool>('requestIgnoreBatteryOptimizations');
      return granted ?? true;
    } catch (err) {
      Log.w("requestIgnoreBatteryOptimizations exception: $err");
      return true;
    }
  }

  /// Check if battery optimizations are already ignored
  static Future<bool> checkIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    try {
      final bool? granted = await _channel.invokeMethod<bool>('checkIgnoreBatteryOptimizations');
      return granted ?? true;
    } catch (err) {
      Log.w("checkIgnoreBatteryOptimizations exception: $err");
      return true;
    }
  }
}
