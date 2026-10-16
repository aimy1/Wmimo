import 'dart:async';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/utils/log.dart';

class CoreWatchdog {
  static bool _userWantsConnected = false;
  static bool _isWatchdogEnabled = true;
  static Timer? _watchdogTimer;
  static int _consecutiveCrashes = 0;
  static const int _maxRetries = 3;

  static void setUserConnected(bool connected) {
    _userWantsConnected = connected;
    if (!connected) {
      _consecutiveCrashes = 0;
    }
  }

  static bool getUserWantsConnected() => _userWantsConnected;

  static void init() {
    _watchdogTimer?.cancel();
    _watchdogTimer = Timer.periodic(const Duration(seconds: 4), (timer) async {
      if (!_isWatchdogEnabled || !_userWantsConnected) return;
      if (VPNService.isOperating) return;

      final isRunning = await VPNService.getStarted();
      if (!isRunning && _userWantsConnected) {
        if (_consecutiveCrashes >= _maxRetries) {
          Log.w("CoreWatchdog: Max crash recovery retries reached ($_maxRetries), stopping auto-recovery");
          _userWantsConnected = false;
          return;
        }

        _consecutiveCrashes++;
        Log.w("CoreWatchdog: Detected unexpected core termination! Auto-recovering (attempt $_consecutiveCrashes/$_maxRetries)...");
        try {
          await VPNService.start(const Duration(seconds: 20));
        } catch (e) {
          Log.e("CoreWatchdog: Recovery attempt failed: $e");
        }
      } else if (isRunning) {
        _consecutiveCrashes = 0;
      }
    });
    Log.i("CoreWatchdog: Initialized core watchdog service");
  }

  static void setWatchdogEnabled(bool enabled) {
    _isWatchdogEnabled = enabled;
  }

  static bool get isWatchdogEnabled => _isWatchdogEnabled;

  static void destroy() {
    _watchdogTimer?.cancel();
    _watchdogTimer = null;
  }
}
