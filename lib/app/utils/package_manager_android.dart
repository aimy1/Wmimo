import 'dart:io';

import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wmimo/app/utils/log.dart';

class PackageInfoImpl extends PackageInfo {
  PackageInfoImpl(String packageName, {int flags = 0})
      : super(
          packageName: packageName,
          applicationInfo: ApplicationInfoImpl(packageName, flags: flags),
          installLocation: AndroidInstallLocation.unspecified,
        );
}

class ApplicationInfoImpl extends ApplicationInfo {
  ApplicationInfoImpl(String packageName, {int flags = 0})
      : super(
          compatibleWidthLimitDp: 0,
          dataDir: null,
          descriptionRes: 0,
          enabled: true,
          flags: flags,
          largestWidthLimitDp: 0,
          processName: packageName,
          publicSourceDir: null,
          requiresSmallestWidthDp: 0,
          sourceDir: null,
          theme: 0,
          uiOptions: 0,
          uid: 0,
          targetSdkVersion: 0,
          packageItemInfo: {'packageName': packageName},
        );
}

class PackageInfoFromApplicationInfo extends PackageInfo {
  PackageInfoFromApplicationInfo(ApplicationInfo applicationInfo)
      : super(
          applicationInfo: applicationInfo,
          packageName: applicationInfo.packageName,
          installLocation: AndroidInstallLocation.unspecified,
        );
}

class PackageInfoEx {
  late PackageInfo info;
  String name = "";
  Image? icon;
}

class PackageManagerAndroid {
  static const int kAndroidFlagSystem = 1;
  static const kRemoved = "[removed]";
  static AndroidPackageManager? _pkgMgr;
  static final Map<String, String> _appNameCache = {};
  static final Map<String, Image> _appIconCache = {};

  static Future<List<PackageInfoEx>> getInstalledPackages({
    bool Function(PackageInfo)? onValid,
  }) async {
    if (!Platform.isAndroid) {
      return [];
    }

    // 1. High-Performance Native Single-Call (bypasses TransactionTooLargeException & loop overhead)
    try {
      const platform = MethodChannel('com.wmimo.app/native_helper');
      final List<dynamic>? rawList = await platform
          .invokeMethod<List<dynamic>>('getInstalledAppList')
          .timeout(const Duration(seconds: 15));
      if (rawList != null && rawList.isNotEmpty) {
        List<PackageInfoEx> packages = [];
        for (var item in rawList) {
          if (item is Map) {
            final pkg = item['packageName']?.toString() ?? '';
            if (pkg.isEmpty) continue;
            final name = item['name']?.toString() ?? pkg;
            final isSystem = item['isSystem'] == true;
            final flags =
                (item['flags'] as num?)?.toInt() ?? (isSystem ? 1 : 0);

            final appInfo = PackageInfoImpl(pkg, flags: flags);
            if (onValid != null && !onValid(appInfo)) {
              continue;
            }

            PackageInfoEx info = PackageInfoEx();
            info.info = appInfo;
            info.name = name;
            _appNameCache[pkg] = name;
            packages.add(info);
          }
        }
        if (packages.isNotEmpty) {
          return packages;
        }
      }
    } catch (e) {
      Log.w("PackageManagerAndroid: native getInstalledAppList fallback: $e");
    }

    // 2. Fallback: android_package_manager plugin without PMFlag.getMetaData
    _pkgMgr ??= AndroidPackageManager();
    try {
      List<PackageInfo>? packageInfos;
      try {
        packageInfos = await _pkgMgr!.getInstalledPackages(
          flags: PackageInfoFlags({}),
        ).timeout(const Duration(seconds: 8));
      } catch (_) {
        packageInfos = await _getInstalledPackagesFallback()
            .timeout(const Duration(seconds: 8), onTimeout: () => null);
      }

      return await _buildPackageInfoList(packageInfos, onValid: onValid);
    } catch (e) {
      Log.w("PackageManagerAndroid: getInstalledPackages error: $e");
    }
    return [];
  }

  static Future<List<PackageInfo>?> _getInstalledPackagesFallback() async {
    final applications = await _pkgMgr!.getInstalledApplications(
      flags: ApplicationInfoFlags({}),
    );
    if (applications == null) {
      return null;
    }

    return applications
        .where((app) => app.packageName != null)
        .map(
          (app) => PackageInfoFromApplicationInfo(
            app.packageName == null ? ApplicationInfoImpl("") : app,
          ),
        )
        .toList();
  }

  static Future<List<PackageInfoEx>> _buildPackageInfoList(
    List<PackageInfo>? packageInfos, {
    bool Function(PackageInfo)? onValid,
  }) async {
    if (packageInfos == null || packageInfos.isEmpty) {
      return [];
    }

    List<PackageInfoEx> packages = [];
    for (var app in packageInfos) {
      final pkg = app.packageName;
      if (pkg == null || pkg.isEmpty) {
        continue;
      }
      if (onValid != null && !onValid(app)) {
        continue;
      }
      PackageInfoEx info = PackageInfoEx();
      info.info = app;
      info.name = _appNameCache[pkg] ?? pkg;
      if (info.name.contains("{") &&
          info.name.contains(":") &&
          info.name.contains("\"")) {
        continue;
      }

      packages.add(info);
    }

    // Lazily resolve display names in parallel chunks for cached apps
    _resolveNamesInBackground(packages);

    return packages;
  }

  static void _resolveNamesInBackground(List<PackageInfoEx> packages) {
    Future.microtask(() async {
      for (var app in packages) {
        final pkg = app.info.packageName;
        if (pkg != null && !_appNameCache.containsKey(pkg)) {
          final label = await getAppName(pkg);
          if (label.isNotEmpty) {
            _appNameCache[pkg] = label;
            app.name = label;
          }
        }
      }
    });
  }

  static Future<Image?> getInstalledPackageIcon(
    List<PackageInfoEx> packages,
    String packageName, {
    int size = 96,
  }) async {
    for (var app in packages) {
      if (app.info.packageName == packageName) {
        if (app.icon != null) {
          return app.icon;
        }
        if (app.name == PackageManagerAndroid.kRemoved) {
          return null;
        }
        Image? image = await getAppIcon(app.info.packageName, size: size);
        app.icon = image;
        return app.icon;
      }
    }
    return null;
  }

  static int sortByName(PackageInfoEx a, PackageInfoEx b) {
    return a.name.compareTo(b.name);
  }

  static Future<String> getAppName(String? packageName) async {
    if (packageName == null || packageName.isEmpty) {
      return "";
    }
    if (_appNameCache.containsKey(packageName)) {
      return _appNameCache[packageName]!;
    }
    if (_pkgMgr == null) {
      return packageName;
    }
    try {
      final label =
          await _pkgMgr!.getApplicationLabel(packageName: packageName) ?? "";
      if (label.isNotEmpty) {
        _appNameCache[packageName] = label;
        return label;
      }
    } catch (_) {}
    return packageName;
  }

  static Future<Image?> getAppIcon(String? packageName, {int size = 96}) async {
    if (packageName == null || packageName.isEmpty) {
      return null;
    }
    if (_appIconCache.containsKey(packageName)) {
      return _appIconCache[packageName];
    }
    // 1. Fast Native Icon Lookup
    try {
      const platform = MethodChannel('com.wmimo.app/native_helper');
      final Uint8List? bytes = await platform
          .invokeMethod<Uint8List>(
            'getAppIcon',
            {'packageName': packageName},
          )
          .timeout(const Duration(seconds: 2));
      if (bytes != null && bytes.isNotEmpty) {
        final img = Image.memory(
          bytes,
          cacheHeight: size,
          cacheWidth: size,
          gaplessPlayback: true,
        );
        _appIconCache[packageName] = img;
        return img;
      }
    } catch (_) {}

    // 2. Plugin Fallback
    if (_pkgMgr != null) {
      try {
        var data = await _pkgMgr!
            .getApplicationIcon(
              packageName: packageName,
              format: BitmapCompressFormat.png,
            )
            .timeout(const Duration(seconds: 2));
        if (data != null) {
          final img = Image.memory(
            data,
            cacheHeight: size,
            cacheWidth: size,
            gaplessPlayback: true,
          );
          _appIconCache[packageName] = img;
          return img;
        }
      } catch (_) {}
    }
    return null;
  }
}
