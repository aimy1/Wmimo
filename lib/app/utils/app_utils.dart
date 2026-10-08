import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:wmimo/generated/build_time.dart' as build_time;

abstract final class AppUtils {
  static String? _cachedPackageVersion;

  static const String kDefaultFallbackVersion = "1.2.1.1503";

  static Future<String> getPackgetVersion() async {
    if (_cachedPackageVersion != null && _cachedPackageVersion!.isNotEmpty) {
      return _cachedPackageVersion!;
    }
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.version.isNotEmpty) {
        String ver = packageInfo.version.trim();
        if (ver.startsWith('v') || ver.startsWith('V')) {
          ver = ver.substring(1);
        }
        if (ver.contains('+')) {
          ver = ver.replaceAll('+', '.');
        }
        if (packageInfo.buildNumber.isNotEmpty &&
            !ver.endsWith('.${packageInfo.buildNumber}')) {
          _cachedPackageVersion = "$ver.${packageInfo.buildNumber}";
        } else {
          _cachedPackageVersion = ver;
        }
        return _cachedPackageVersion!;
      }
    } catch (_) {}
    return getBuildinVersion();
  }

  static String getName() {
    return "Wmimo";
  }

  static String getReleaseVersion() {
    List<String> v = getBuildinVersion().split(".");
    return "${v[0]}.${v.length > 1 ? v[1] : '0'}.${v.length > 2 ? v[2] : '0'}+${v.length > 3 ? v[3] : '0'}";
  }

  static String getNextBuildinVersion() {
    List<String> v = getBuildinVersion().split(".");
    int buildNum = v.length > 3 ? (int.tryParse(v[3]) ?? 0) : 0;
    return "${v[0]}.${v.length > 1 ? v[1] : '0'}.${v.length > 2 ? v[2] : '0'}.${buildNum + 1}";
  }

  static String getBuildinVersion() {
    return _cachedPackageVersion ?? kDefaultFallbackVersion;
  }

  /// Unified display version with 4-part dot notation, e.g. "v1.2.1.1503" or "1.2.1.1503"
  static String getFormattedVersion({bool withV = true}) {
    String v = getBuildinVersion().trim();
    if (v.startsWith('v') || v.startsWith('V')) {
      v = v.substring(1);
    }
    if (v.contains('+')) {
      v = v.replaceAll('+', '.');
    }
    return withV ? 'v$v' : v;
  }

  static DateTime getBuildinVersionDate() {
    return build_time.buildDateTime;
  }

  static String getId() {
    return "com.wmimo.app";
  }

  static String getGroupId() {
    return "group.com.wmimo.app";
  }

  static String getBundleId(bool systemExtension) {
    if (Platform.isIOS || Platform.isMacOS) {
      if (Platform.isMacOS && systemExtension) {
        return "com.wmimo.app.wmimoServiceSE";
      }
      return "com.wmimo.app.wmimoService";
    }
    return "";
  }

  static String getControlKind() {
    return "com.wmimo.app.widget.ControlCenterToggle";
  }

  static String getICloudContainerId() {
    return "iCloud.com.wmimo.app";
  }

  static String getCoreVersion() {
    return "1.19.32";
  }
}
