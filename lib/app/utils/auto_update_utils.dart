// ignore_for_file: empty_catches, no_leading_underscores_for_local_identifiers

import 'dart:convert';
import 'dart:io';

import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/remote_config.dart';
import 'package:wmimo/app/modules/remote_config_manager.dart';
import 'package:wmimo/app/runtime/return_result.dart';
import 'package:wmimo/app/utils/app_url_utils.dart';
import 'package:wmimo/app/utils/http_utils.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/url_launcher_utils.dart';
import 'package:tuple/tuple.dart';

class AutoupdateItem {
  String platform = "";

  List<String> channels = [];

  List<String> abis = [];
  String version = "";
  String url = "";
  String sha256 = "";
  List<String> updateChannel = []; //stable, beta

  void fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    platform = map["platform"] ?? "";

    var _channels = map["channels"] ?? [];
    for (var i in _channels) {
      channels.add(i as String);
    }

    var _abis = map["abis"] ?? [];
    for (var i in _abis) {
      abis.add(i as String);
    }
    version = map["version"] ?? "";
    url = map["url"] ?? "";
    sha256 = map["sha256"] ?? "";
    var _versionChannel = map["version_channel"] ?? [];
    for (var i in _versionChannel) {
      updateChannel.add(i as String);
    }
  }
}

abstract final class AutoupdateUtils {
  static Future<ReturnResult<List<AutoupdateItem>>> getAutoupdate(
    bool withQueryParams,
  ) async {
    String url = RemoteConfigManager.getConfig().autoUpdate;
    if (withQueryParams) {
      String queryParams = await AppUrlUtils.getQueryParamsForUrl(bodyLen: "1");
      url = UrlLauncherUtils.reorganizationUrl(url, queryParams) ?? url;
    }

    ReturnResult<Tuple2<int, String>>? response;
    List<int?> ports = await VPNService.getPortsByPrefer(true);
    for (var port in ports) {
      response = await HttpUtils.httpGetRequest(
        url,
        port,
        null,
        const Duration(seconds: 10),
        null,
        null,
      );
      if (response.error == null) {
        break;
      }
    }
    List<AutoupdateItem> items = [];
    if (response != null && response.error == null && response.data != null && response.data!.item2.isNotEmpty) {
      try {
        var decodedResponse = jsonDecode(response.data!.item2);
        if (decodedResponse is List) {
          for (var i in decodedResponse) {
            AutoupdateItem item = AutoupdateItem();
            item.fromJson(i);
            if (item.platform == Platform.operatingSystem) {
              items.add(item);
            }
          }
        }
      } catch (err) {
        Log.i('AutoupdateUtils getAutoupdate exception ${err.toString()}');
      }
    }

    if (items.isNotEmpty) {
      return ReturnResult(data: items);
    }

    // Fallback to GitHub Releases if primary remote config failed or returned empty
    Log.i('AutoupdateUtils: primary remote config unavailable or empty, trying GitHub Releases fallback...');
    items = await _fetchFromGitHub(ports);
    if (items.isNotEmpty) {
      return ReturnResult(data: items);
    }

    return ReturnResult(
      error: response?.error ?? ReturnResultError("No update information available"),
    );
  }

  static Future<List<AutoupdateItem>> _fetchFromGitHub(List<int?> ports) async {
    // 1. Try GitHub Releases API
    for (var port in ports) {
      try {
        final ghResponse = await HttpUtils.httpGetRequest(
          "https://api.github.com/repos/aimy1/Wmimo/releases/latest",
          port,
          {"Accept": "application/vnd.github.v3+json", "User-Agent": "WmimoApp"},
          const Duration(seconds: 8),
          "WmimoApp",
          null,
          checkStatuscode: false,
        );
        if (ghResponse.error == null && ghResponse.data != null) {
          final statusCode = ghResponse.data!.item1;
          final body = ghResponse.data!.item2;
          if (statusCode == 200 && body.isNotEmpty) {
            final parsed = _parseGithubReleaseJson(body);
            if (parsed.isNotEmpty) {
              return parsed;
            }
          }
        }
      } catch (_) {}
    }

    // 2. Try GitHub latest release redirect
    for (var port in ports) {
      try {
        final headRes = await HttpUtils.httpHeadRequest(
          Uri.parse("https://github.com/aimy1/Wmimo/releases/latest"),
          port,
          "WmimoApp",
          false,
          const Duration(seconds: 8),
        );
        if (headRes.error == null && headRes.data != null) {
          final location = headRes.data!.item2.value(HttpHeaders.locationHeader);
          if (location != null && location.contains("/tag/")) {
            final tag = location.split("/tag/").last.trim();
            final parsed = _buildStandardReleaseItems(tag);
            if (parsed.isNotEmpty) {
              return parsed;
            }
          }
        }
      } catch (_) {}
    }

    return [];
  }

  static List<AutoupdateItem> _parseGithubReleaseJson(String jsonStr) {
    List<AutoupdateItem> list = [];
    try {
      final map = jsonDecode(jsonStr);
      if (map is! Map<String, dynamic>) return list;
      String tagName = map["tag_name"] ?? "";
      String version = tagName.replaceFirst(RegExp(r'^[vV]'), '');
      if (version.isEmpty) return list;

      final assets = map["assets"];
      if (assets is List) {
        for (var asset in assets) {
          if (asset is! Map<String, dynamic>) continue;
          String name = (asset["name"] ?? "").toString().toLowerCase();
          String downloadUrl = asset["browser_download_url"] ?? "";
          if (downloadUrl.isEmpty) continue;

          AutoupdateItem item = AutoupdateItem();
          item.version = version;
          item.url = downloadUrl;
          item.updateChannel = ["stable", "beta"];

          if (name.endsWith(".exe") && (name.contains("windows") || name.contains("setup"))) {
            item.platform = "windows";
            if (name.contains("arm64")) {
              item.abis = ["arm64", "aarch64"];
            } else {
              item.abis = ["x86_64", "x64", "*"];
            }
            item.channels = ["*"];
            list.add(item);
          } else if (name.endsWith(".apk") && name.contains("android")) {
            item.platform = "android";
            if (name.contains("arm64-v8a")) {
              item.abis = ["arm64-v8a"];
            } else if (name.contains("armeabi-v7a")) {
              item.abis = ["armeabi-v7a"];
            } else if (name.contains("x86_64")) {
              item.abis = ["x86_64"];
            } else {
              item.abis = ["*"];
            }
            item.channels = ["*"];
            list.add(item);
          } else if (name.endsWith(".dmg") && (name.contains("macos") || name.contains("mac"))) {
            item.platform = "macos";
            item.abis = ["*"];
            item.channels = ["*"];
            list.add(item);
          } else if (name.endsWith(".deb") && name.contains("linux")) {
            item.platform = "linux";
            item.abis = ["*"];
            item.channels = ["deb", "*"];
            list.add(item);
          } else if (name.endsWith(".rpm") && name.contains("linux")) {
            item.platform = "linux";
            item.abis = ["*"];
            item.channels = ["rpm", "*"];
            list.add(item);
          } else if (name.endsWith(".appimage") && name.contains("linux")) {
            item.platform = "linux";
            item.abis = ["*"];
            item.channels = ["appimage", "*"];
            list.add(item);
          }
        }
      }

      if (list.isEmpty) {
        return _buildStandardReleaseItems(tagName);
      }
    } catch (err) {
      Log.i('AutoupdateUtils _parseGithubReleaseJson exception ${err.toString()}');
    }
    return list.where((e) => e.platform == Platform.operatingSystem).toList();
  }

  static List<AutoupdateItem> _buildStandardReleaseItems(String tag) {
    final version = tag.replaceFirst(RegExp(r'^[vV]'), '');
    final cleanTag = tag.startsWith('v') ? tag : 'v$tag';
    final baseUrl = "https://github.com/aimy1/Wmimo/releases/download/$cleanTag";

    final items = [
      AutoupdateItem()
        ..platform = "windows"
        ..version = version
        ..abis = ["x86_64", "x64", "*"]
        ..channels = ["*"]
        ..updateChannel = ["stable", "beta"]
        ..url = "$baseUrl/Wmimo-Windows-x64-Setup-$cleanTag.exe",
      AutoupdateItem()
        ..platform = "windows"
        ..version = version
        ..abis = ["arm64", "aarch64"]
        ..channels = ["*"]
        ..updateChannel = ["stable", "beta"]
        ..url = "$baseUrl/Wmimo-Windows-arm64-Setup-$cleanTag.exe",
      AutoupdateItem()
        ..platform = "android"
        ..version = version
        ..abis = ["arm64-v8a"]
        ..channels = ["*"]
        ..updateChannel = ["stable", "beta"]
        ..url = "$baseUrl/Wmimo-Android-arm64-v8a-$cleanTag.apk",
      AutoupdateItem()
        ..platform = "android"
        ..version = version
        ..abis = ["*"]
        ..channels = ["*"]
        ..updateChannel = ["stable", "beta"]
        ..url = "$baseUrl/Wmimo-Android-universal-$cleanTag.apk",
      AutoupdateItem()
        ..platform = "linux"
        ..version = version
        ..abis = ["*"]
        ..channels = ["deb", "*"]
        ..updateChannel = ["stable", "beta"]
        ..url = "$baseUrl/Wmimo-Linux-x64-$cleanTag.deb",
      AutoupdateItem()
        ..platform = "linux"
        ..version = version
        ..abis = ["*"]
        ..channels = ["rpm", "*"]
        ..updateChannel = ["stable", "beta"]
        ..url = "$baseUrl/Wmimo-Linux-x64-$cleanTag.rpm",
      AutoupdateItem()
        ..platform = "linux"
        ..version = version
        ..abis = ["*"]
        ..channels = ["appimage", "*"]
        ..updateChannel = ["stable", "beta"]
        ..url = "$baseUrl/Wmimo-Linux-x64-$cleanTag.AppImage",
      AutoupdateItem()
        ..platform = "macos"
        ..version = version
        ..abis = ["*"]
        ..channels = ["*"]
        ..updateChannel = ["stable", "beta"]
        ..url = "$baseUrl/Wmimo-MacOS-x64-$cleanTag.dmg",
    ];

    return items.where((e) => e.platform == Platform.operatingSystem).toList();
  }

  static Future<ReturnResult<RemoteConfig>> getRemoteConfig() async {
    RemoteConfig rc = RemoteConfig();
    String url = RemoteConfigManager.getConfig().config;
    late ReturnResult<Tuple2<int, String>> response;
    List<int?> ports = await VPNService.getPortsByPrefer(true);
    for (var port in ports) {
      response = await HttpUtils.httpGetRequest(
        url,
        port,
        null,
        const Duration(seconds: 10),
        null,
        null,
      );
      if (response.error == null) {
        break;
      }
    }

    if (response.error != null) {
      return ReturnResult(error: response.error);
    }
    try {
      if (response.data!.item2.isNotEmpty) {
        var decodedResponse = jsonDecode(response.data!.item2);
        rc.fromJson(decodedResponse);
      }
    } catch (err) {
      Log.i('AutoupdateUtils getRemoteConfig exception ${err.toString()}');
    }
    return ReturnResult(data: rc);
  }
}
