import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/path_utils.dart';

class GeoAssetInfo {
  final String fileName;
  final String displayName;
  final String description;
  final String filePath;
  final int sizeBytes;
  final DateTime? modifiedTime;
  final bool exists;

  const GeoAssetInfo({
    required this.fileName,
    required this.displayName,
    required this.description,
    required this.filePath,
    required this.sizeBytes,
    this.modifiedTime,
    required this.exists,
  });

  String get formattedSize {
    if (!exists || sizeBytes <= 0) return "Not Installed";
    if (sizeBytes < 1024) return "$sizeBytes B";
    if (sizeBytes < 1024 * 1024) return "${(sizeBytes / 1024).toStringAsFixed(1)} KB";
    return "${(sizeBytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  String get formattedModifiedTime {
    if (modifiedTime == null) return "Never";
    return "${modifiedTime!.year}-${modifiedTime!.month.toString().padLeft(2, '0')}-${modifiedTime!.day.toString().padLeft(2, '0')} "
        "${modifiedTime!.hour.toString().padLeft(2, '0')}:${modifiedTime!.minute.toString().padLeft(2, '0')}";
  }
}

class GeoCdnSource {
  final String id;
  final String name;
  final String description;

  const GeoCdnSource({
    required this.id,
    required this.name,
    required this.description,
  });
}

class GeoAssetManager {
  static const List<GeoCdnSource> cdnSources = [
    GeoCdnSource(
      id: "jsdelivr",
      name: "jsDelivr CDN (Fast)",
      description: "Accelerated global CDN, highly recommended for China & APAC",
    ),
    GeoCdnSource(
      id: "fastgit",
      name: "FastGit Mirror (CN)",
      description: "Direct reverse-proxy mirror for GitHub releases",
    ),
    GeoCdnSource(
      id: "github",
      name: "GitHub Official",
      description: "Official MetaCubeX releases repository",
    ),
  ];

  static String getDownloadUrl(String fileName, String sourceId) {
    switch (sourceId) {
      case "jsdelivr":
        if (fileName == "ASN.mmdb") {
          return "https://testingcf.jsdelivr.net/gh/MetaCubeX/meta-rules-dat@release/country.mmdb";
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
    final List<Map<String, String>> definitions = [
      {
        "fileName": "geosite.dat",
        "displayName": "GeoSite Database",
        "description": "Domain name ruleset and category mappings (MetaCubeX)",
      },
      {
        "fileName": "geoip.dat",
        "displayName": "GeoIP Database",
        "description": "IP geolocation and country resolution data",
      },
      {
        "fileName": "ASN.mmdb",
        "displayName": "ASN Database",
        "description": "Autonomous System Number (ASN) database",
      },
    ];

    List<GeoAssetInfo> result = [];
    for (final def in definitions) {
      final fileName = def["fileName"]!;
      final f = File(path.join(homePath, fileName));
      bool exists = await f.exists();
      int size = 0;
      DateTime? mod;
      if (exists) {
        try {
          final stat = await f.stat();
          size = stat.size;
          mod = stat.modified;
        } catch (_) {}
      }
      result.add(GeoAssetInfo(
        fileName: fileName,
        displayName: def["displayName"]!,
        description: def["description"]!,
        filePath: f.path,
        sizeBytes: size,
        modifiedTime: mod,
        exists: exists,
      ));
    }
    return result;
  }

  static Future<bool> downloadAsset(
    String fileName, {
    String sourceId = "jsdelivr",
    void Function(double progress)? onProgress,
  }) async {
    final homePath = await PathUtils.profileDir();
    final targetFile = File(path.join(homePath, fileName));
    final tempFile = File(path.join(homePath, "$fileName.tmp"));
    final url = getDownloadUrl(fileName, sourceId);

    try {
      Log.i("GeoAssetManager: Downloading $fileName from $url");
      final request = http.Request('GET', Uri.parse(url));
      request.headers['User-Agent'] = 'Mozilla/5.0 Wmimo-GeoDownloader';
      final response = await http.Client().send(request);

      if (response.statusCode != 200) {
        Log.w("GeoAssetManager: Download failed with status ${response.statusCode}");
        return false;
      }

      final contentLength = response.contentLength ?? 0;
      int receivedBytes = 0;
      final sink = tempFile.openWrite();

      await for (final chunk in response.stream) {
        sink.add(chunk);
        receivedBytes += chunk.length;
        if (contentLength > 0 && onProgress != null) {
          onProgress(receivedBytes / contentLength);
        }
      }
      await sink.flush();
      await sink.close();

      // Download complete: replace target file atomically
      if (await targetFile.exists()) {
        await targetFile.delete();
      }
      await tempFile.rename(targetFile.path);
      Log.i("GeoAssetManager: Successfully updated $fileName (${targetFile.path})");
      return true;
    } catch (e) {
      Log.w("GeoAssetManager: Exception while downloading $fileName: $e");
      if (await tempFile.exists()) {
        try {
          await tempFile.delete();
        } catch (_) {}
      }
      return false;
    }
  }

  static Future<Map<String, bool>> updateAll({
    String sourceId = "jsdelivr",
    void Function(String fileName, double progress)? onProgress,
  }) async {
    final assets = ["geosite.dat", "geoip.dat", "ASN.mmdb"];
    Map<String, bool> results = {};
    for (final asset in assets) {
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
