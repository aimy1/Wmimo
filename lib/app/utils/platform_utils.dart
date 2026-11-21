
import 'dart:io';

class PlatformUtils {
  static const String windows = "windows";
  static const String android = "android";
  static const String ios = "ios";
  static const String macos = "macos";
  static const String linux = "linux";
  static bool isPC() {
    return Platform.isLinux || Platform.isMacOS || Platform.isWindows;
  }

  static bool isMobile() {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Returns the detected Linux package format: 'pacman', 'deb', 'rpm', or 'appimage'.
  static String getLinuxPackageType({String? channelName}) {
    if (!Platform.isLinux) return "";
    String channel = channelName ??
        const String.fromEnvironment('PACKAGE_TARGET', defaultValue: '');
    if (channel.isEmpty) {
      channel = const String.fromEnvironment('CHANNEL', defaultValue: '');
    }
    if (channel.isEmpty) {
      channel = Platform.environment['PACKAGE_TARGET'] ??
          Platform.environment['CHANNEL'] ??
          "";
    }
    final lower = channel.toLowerCase();
    if (lower.contains("pacman") || lower.contains("arch")) {
      return "pacman";
    }
    if (lower.contains("deb")) {
      return "deb";
    }
    if (lower.contains("rpm")) {
      return "rpm";
    }
    if (lower.contains("appimage")) {
      return "appimage";
    }
    if (Platform.environment['APPIMAGE'] != null) {
      return "appimage";
    }
    if (File('/usr/bin/pacman').existsSync() ||
        File('/etc/arch-release').existsSync()) {
      return "pacman";
    }
    if (File('/usr/bin/dpkg').existsSync() ||
        File('/etc/debian_version').existsSync()) {
      return "deb";
    }
    if (File('/usr/bin/rpm').existsSync() ||
        File('/etc/redhat-release').existsSync() ||
        File('/etc/fedora-release').existsSync()) {
      return "rpm";
    }
    return "appimage";
  }
}
