import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:wmimo/generated/build_time.dart' as build_time;

abstract final class AppUtils {
  static String? _cachedPackageVersion;

  static Future<String> getPackgetVersion() async {
    if (_cachedPackageVersion != null) return _cachedPackageVersion!;
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _cachedPackageVersion = "${packageInfo.version}.${packageInfo.buildNumber}";
      return _cachedPackageVersion!;
    } catch (_) {
      return getBuildinVersion();
    }
  }

  static String getName() {
    return "Wmimo";
  }

  static String getReleaseVersion() {
    List<String> v = getBuildinVersion().split(".");
    return "${v[0]}.${v[1]}.${v[2]}+${v.length > 3 ? v[3] : '0'}";
  }

  static String getNextBuildinVersion() {
    List<String> v = getBuildinVersion().split(".");
    int buildNum = v.length > 3 ? (int.tryParse(v[3]) ?? 0) : 0;
    return "${v[0]}.${v[1]}.${v[2]}.${buildNum + 1}";
  }

  static String getBuildinVersion() {
    return _cachedPackageVersion ?? "1.0.31.1409";
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
    return "1.19.30";
  }
}
