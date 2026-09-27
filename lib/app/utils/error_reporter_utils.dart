import 'dart:io';

abstract final class ErrorReporterUtils {
  static void Function()? _callback;
  static bool _reporting = false;
  static int _lastReportTimestamp = 0;

  static void register(void Function()? callback) {
    _callback = callback;
  }

  static bool tryReportNoSpace(String err) {
    bool noSpace = false;
    if (Platform.isWindows) {
      if (err.contains("errno = 112")) {
        noSpace = true;
      }
    } else {
      if (err.contains("No space left on device")) {
        noSpace = true;
      }
    }
    if (!noSpace) {
      return false;
    }
    final now = DateTime.now().millisecondsSinceEpoch;
    // Debounce to at most once every 10 seconds to prevent dialog flooding
    if (now - _lastReportTimestamp < 10000) {
      return noSpace;
    }
    if (_reporting) {
      return noSpace;
    }
    _reporting = true;
    _lastReportTimestamp = now;
    try {
      if (_callback != null) {
        _callback!();
      }
    } finally {
      Future.delayed(const Duration(seconds: 5), () {
        _reporting = false;
      });
    }
    return noSpace;
  }
}
