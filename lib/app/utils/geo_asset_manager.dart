import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/path_utils.dart';

class GeoAssetInfo {
  final String fileName;
  final String displayName;
  final String displayNameZh;
  final String description;
  final String descriptionZh;
  final String filePath;
  final int sizeBytes;
  final DateTime? modifiedTime;
  final bool exists;

  const GeoAssetInfo({
    required this.fileName,
    required this.displayName,
    this.displayNameZh = '',
    required this.description,
    this.descriptionZh = '',
    required this.filePath,
    required this.sizeBytes,
    this.modifiedTime,
    required this.exists,
  });

  String getLocalizedName(bool isZh) =>
      (isZh && displayNameZh.isNotEmpty) ? displayNameZh : displayName;

  String getLocalizedDescription(bool isZh) =>
      (isZh && descriptionZh.isNotEmpty) ? descriptionZh : description;

  String get formattedSize => getFormattedSize(false);

  String getFormattedSize(bool isZh) {
    if (!exists || sizeBytes <= 0) {
      return isZh ? "未安装" : "Not Installed";
    }
    if (sizeBytes < 1024) return "$sizeBytes B";
    if (sizeBytes < 1024 * 1024) {
      return "${(sizeBytes / 1024).toStringAsFixed(1)} KB";
    }
    return "${(sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  String get formattedModifiedTime => getFormattedModifiedTime(false);

  String getFormattedModifiedTime(bool isZh) {
    if (modifiedTime == null) return isZh ? "从未更新" : "Never";
    return "${modifiedTime!.year}-${modifiedTime!.month.toString().padLeft(2, '0')}-${modifiedTime!.day.toString().padLeft(2, '0')} "
        "${modifiedTime!.hour.toString().padLeft(2, '0')}:${modifiedTime!.minute.toString().padLeft(2, '0')}";
  }
}

class GeoCdnSource {
  final String id;
  final String name;
  final String nameZh;
  final String description;
  final String descriptionZh;

  const GeoCdnSource({
    required this.id,
    required this.name,
    this.nameZh = '',
    required this.description,
    this.descriptionZh = '',
  });

  String getLocalizedName(bool isZh) =>
      (isZh && nameZh.isNotEmpty) ? nameZh : name;

  String getLocalizedDescription(bool isZh) =>
      (isZh && descriptionZh.isNotEmpty) ? descriptionZh : description;
}

class GeoAssetManager {
  static const List<String> managedFiles = [
    "geosite.dat",
    "geoip.dat",
    "country.mmdb",
    "ASN.mmdb",
  ];

  static const List<GeoCdnSource> cdnSources = [
    GeoCdnSource(
      id: "jsdelivr",
      name: "jsDelivr CDN (Fast)",
      nameZh: "jsDelivr 全球加速 CDN（推荐）",
      description:
          "Accelerated global CDN, highly recommended for China & APAC",
      descriptionZh: "Cloudflare 边缘节点加速，适合中国大陆与亚太网络直连下载",
    ),
    GeoCdnSource(
      id: "fastgit",
      name: "FastGit Mirror (CN)",
      nameZh: "GitHub 高速镜像源（国内直连）",
      description: "Direct reverse-proxy mirror for GitHub releases",
      descriptionZh: "针对 GitHub Releases 的反向代理镜像，免代理直连下载",
    ),
    GeoCdnSource(
      id: "github",
      name: "GitHub Official",
      nameZh: "GitHub 官方源（MetaCubeX）",
      description: "Official MetaCubeX releases repository",
      descriptionZh: "MetaCubeX 官方发布仓库，需具备国际网络或开启代理",
    ),
  ];

  static String getDownloadUrl(String fileName, String sourceId) {
    switch (sourceId) {
      case "jsdelivr":
        if (fileName == "ASN.mmdb") {
          return "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/GeoLite2-ASN.mmdb";
        }
        return "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/$fileName";
      case "fastgit":
        if (fileName == "ASN.mmdb") {
          return "https://ghfast.top/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb";
        }
        return "https://ghfast.top/https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/$fileName";
      case "github":
      default:
        if (fileName == "ASN.mmdb") {
          return "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb";
        }
        return "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/$fileName";
    }
  }

  static Future<List<GeoAssetInfo>> getAssetsInfo() async {
    final homePath = await PathUtils.profileDir();
    const List<Map<String, String>> definitions = [
      {
        "fileName": "geosite.dat",
        "displayName": "GeoSite Database",
        "displayNameZh": "GeoSite 域名分流数据库",
        "description":
            "Domain name ruleset and category mappings (MetaCubeX)",
        "descriptionZh": "提供 GEOSITE 域名分类与国内外站点精准分流映射",
      },
      {
        "fileName": "geoip.dat",
        "displayName": "GeoIP Database",
        "displayNameZh": "GeoIP 路由分流数据库",
        "description": "IP geolocation and country resolution data",
        "descriptionZh": "提供 GEOIP 规则匹配所需的全球 IP 地址段归属数据",
      },
      {
        "fileName": "country.mmdb",
        "displayName": "GeoLite2 Country (MMDB)",
        "displayNameZh": "GeoLite2 国家地理位置库 (MMDB)",
        "description":
            "MaxMind GeoLite2 country lookup database for core DNS & routing",
        "descriptionZh": "Mihomo 核心内置 DNS 防污染与目标 IP 国家快速查询必用库",
      },
      {
        "fileName": "ASN.mmdb",
        "displayName": "GeoLite2 ASN Database",
        "displayNameZh": "GeoLite2 ASN 自治系统数据库",
        "description": "Autonomous System Number (ASN) carrier database",
        "descriptionZh": "识别目标 IP 所属运营商与自治系统号（支持 IP-ASN 分流规则）",
      },
    ];

    final List<GeoAssetInfo> result = [];
    for (final def in definitions) {
      final fileName = def["fileName"]!;
      final f = File(path.join(homePath, fileName));
      final bool exists = await f.exists();
      int size = 0;
      DateTime? mod;
      if (exists) {
        try {
          final stat = await f.stat();
          size = stat.size;
          mod = stat.modified;
        } catch (_) {}
      }
      result.add(
        GeoAssetInfo(
          fileName: fileName,
          displayName: def["displayName"]!,
          displayNameZh: def["displayNameZh"]!,
          description: def["description"]!,
          descriptionZh: def["descriptionZh"]!,
          filePath: f.path,
          sizeBytes: size,
          modifiedTime: mod,
          exists: exists,
        ),
      );
    }
    return result;
  }

  static List<String> getCandidateUrls(String fileName, String preferredSourceId) {
    final targetName = fileName == "ASN.mmdb" ? "GeoLite2-ASN.mmdb" : fileName;
    final orderedIds = <String>[
      preferredSourceId,
      for (final s in cdnSources)
        if (s.id != preferredSourceId) s.id,
    ];
    final urls = <String>[];
    for (final id in orderedIds) {
      final u = getDownloadUrl(fileName, id);
      if (!urls.contains(u)) {
        urls.add(u);
      }
      if (id == "jsdelivr") {
        final fastlyUrl =
            "https://fastly.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/$targetName";
        if (!urls.contains(fastlyUrl)) {
          urls.add(fastlyUrl);
        }
      }
    }
    return urls;
  }

  static bool _ensuringCoreFiles = false;

  /// Silently ensures essential geo files (`geoip.dat`, `geosite.dat`, `country.mmdb`)
  /// exist in the profile directory by downloading missing files in the background.
  static Future<void> ensureCoreGeoFiles() async {
    if (_ensuringCoreFiles) return;
    _ensuringCoreFiles = true;
    try {
      final homePath = await PathUtils.profileDir();
      for (final fileName in const ["geoip.dat", "geosite.dat", "country.mmdb"]) {
        final f = File(path.join(homePath, fileName));
        bool needsDownload = !await f.exists();
        if (!needsDownload) {
          try {
            final len = await f.length();
            if (len <= 0) needsDownload = true;
          } catch (_) {}
        }
        if (needsDownload) {
          await downloadAsset(fileName, sourceId: "jsdelivr");
        }
      }
    } catch (e) {
      Log.w("GeoAssetManager.ensureCoreGeoFiles error: $e");
    } finally {
      _ensuringCoreFiles = false;
    }
  }

  static Future<bool> downloadAsset(
    String fileName, {
    String sourceId = "jsdelivr",
    void Function(double progress)? onProgress,
  }) async {
    final homePath = await PathUtils.profileDir();
    final targetFile = File(path.join(homePath, fileName));
    final tempFile = File(path.join(homePath, "$fileName.tmp"));
    final candidateUrls = getCandidateUrls(fileName, sourceId);

    bool vpnStarted = false;
    int mixedPort = 0;
    try {
      vpnStarted = await VPNService.getStarted();
      mixedPort = ClashSettingManager.getMixedPort();
    } catch (_) {}

    final proxyModes = <int?>[
      if (vpnStarted && mixedPort > 0) mixedPort,
      null,
    ];

    for (final url in candidateUrls) {
      for (final proxyPort in proxyModes) {
        final ok = await _tryDownloadFromUrl(
          fileName: fileName,
          url: url,
          targetFile: targetFile,
          tempFile: tempFile,
          proxyPort: proxyPort,
          onProgress: onProgress,
        );
        if (ok) {
          return true;
        }
      }
    }
    return false;
  }

  static Future<bool> _tryDownloadFromUrl({
    required String fileName,
    required String url,
    required File targetFile,
    required File tempFile,
    required int? proxyPort,
    void Function(double progress)? onProgress,
  }) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 20)
      ..idleTimeout = const Duration(seconds: 30);
    if (proxyPort != null && proxyPort > 0) {
      client.findProxy = (_) => "PROXY 127.0.0.1:$proxyPort; DIRECT";
    }
    IOSink? sink;

    try {
      Log.i(
        "GeoAssetManager: Downloading $fileName from $url (proxy: ${proxyPort ?? 'DIRECT'})",
      );
      final request = await client
          .getUrl(Uri.parse(url))
          .timeout(const Duration(seconds: 20));
      request.followRedirects = true;
      request.maxRedirects = 5;
      request.headers.set(
        HttpHeaders.userAgentHeader,
        'Mozilla/5.0 Wmimo-GeoDownloader',
      );
      request.headers.set(HttpHeaders.acceptHeader, '*/*');
      final response =
          await request.close().timeout(const Duration(seconds: 25));

      if (response.statusCode != 200) {
        Log.w(
          "GeoAssetManager: Download from $url failed with status ${response.statusCode}",
        );
        return false;
      }

      final contentLength = response.contentLength;
      int receivedBytes = 0;
      sink = tempFile.openWrite();

      await for (final chunk
          in response.timeout(const Duration(seconds: 45))) {
        sink.add(chunk);
        receivedBytes += chunk.length;
        if (contentLength > 0 && onProgress != null) {
          onProgress(receivedBytes / contentLength);
        }
      }
      await sink.flush();
      await sink.close();
      sink = null;

      if (receivedBytes <= 1024) {
        Log.w("GeoAssetManager: Downloaded invalid payload ($receivedBytes B) for $fileName");
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
        return false;
      }

      if (await targetFile.exists()) {
        await targetFile.delete();
      }
      await tempFile.rename(targetFile.path);
      Log.i(
        "GeoAssetManager: Successfully updated $fileName (${targetFile.path}, $receivedBytes bytes)",
      );
      return true;
    } catch (e) {
      Log.w("GeoAssetManager: Exception while downloading $fileName from $url: $e");
      try {
        await sink?.close();
      } catch (_) {}
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      return false;
    } finally {
      client.close(force: true);
    }
  }

  static Future<Map<String, bool>> updateAll({
    String sourceId = "jsdelivr",
    void Function(String fileName, double progress)? onProgress,
  }) async {
    final Map<String, bool> results = {};
    for (final asset in managedFiles) {
      final success = await downloadAsset(
        asset,
        sourceId: sourceId,
        onProgress: (p) => onProgress?.call(asset, p),
      );
      results[asset] = success;
    }
    return results;
  }
}
