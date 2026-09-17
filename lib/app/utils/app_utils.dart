import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:wmimo/generated/build_time.dart' as build_time;

abstract final class AppUtils {
  static String? _cachedPackageVersion;

  static const String kDefaultFallbackVersion = "1.1.3.1426";

  static Future<String> getPackgetVersion() async {
    if (_cachedPackageVersion != null && _cachedPackageVersion!.isNotEmpty) {
      return _cachedPackageVersion!;
    }
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.version.isNotEmpty) {
        if (packageInfo.buildNumber.isNotEmpty) {
          _cachedPackageVersion =
              "${packageInfo.version}.${packageInfo.buildNumber}";
        } else {
          _cachedPackageVersion = packageInfo.version;
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
    return "1.19.31";
  }
}
