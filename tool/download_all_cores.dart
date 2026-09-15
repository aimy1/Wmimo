import 'dart:async';
import 'dart:io';
import 'package:archive/archive.dart';

const String kVersion = 'v1.19.31';
const String kBaseUrl = 'https://github.com/MetaCubeX/mihomo/releases/download/$kVersion';

final Map<String, List<String>> targets = {
  // Windows
  '$kBaseUrl/mihomo-windows-amd64-$kVersion.zip': [
    'bind/windows/core/wmimoService.exe',
    'build/windows/x64/runner/Release/wmimoService.exe',
  ],
  '$kBaseUrl/mihomo-windows-arm64-$kVersion.zip': [
    'bind/windows/core_arm64/wmimoService.exe',
  ],
  // Android
  '$kBaseUrl/mihomo-android-arm64-v8-$kVersion.gz': [
    'android/app/src/main/jniLibs/arm64-v8a/libwmimoService.so',
    'assets/core/android/arm64-v8a/wmimoService',
  ],
  '$kBaseUrl/mihomo-android-armv7-$kVersion.gz': [
    'android/app/src/main/jniLibs/armeabi-v7a/libwmimoService.so',
    'assets/core/android/armeabi-v7a/wmimoService',
  ],
  '$kBaseUrl/mihomo-android-amd64-$kVersion.gz': [
    'android/app/src/main/jniLibs/x86_64/libwmimoService.so',
    'assets/core/android/x86_64/wmimoService',
  ],
  // Linux
  '$kBaseUrl/mihomo-linux-amd64-$kVersion.gz': [
    'bind/linux/core/wmimoService',
    'assets/core/linux/wmimoService',
  ],
  // macOS
  '$kBaseUrl/mihomo-darwin-arm64-$kVersion.gz': [
    'bind/macos/core/wmimoService_arm64',
    'assets/core/macos/wmimoService_arm64',
  ],
  '$kBaseUrl/mihomo-darwin-amd64-$kVersion.gz': [
    'bind/macos/core/wmimoService_amd64',
    'assets/core/macos/wmimoService_amd64',
    'bind/macos/core/wmimoService',
    'assets/core/macos/wmimoService',
  ],
};

List<String> getUrlCandidates(String originalUrl) {
  return [
    originalUrl,
    'https://gh-proxy.com/$originalUrl',
    'https://ghproxy.net/$originalUrl',
    'https://github.moeyy.xyz/$originalUrl',
  ];
}

Future<List<int>?> downloadBytes(HttpClient client, String originalUrl) async {
  final candidates = getUrlCandidates(originalUrl);
  final tempFile = File('${Directory.systemTemp.path}/mihomo_temp_${DateTime.now().millisecondsSinceEpoch}');

  for (final url in candidates) {
    try {
      print('  Attempting (via curl): $url');
      final result = await Process.run('curl.exe', [
        '-L',
        '-f',
        '-s',
        '-S',
        '--connect-timeout',
        '15',
        '--retry',
        '2',
        '-o',
        tempFile.path,
        url,
      ]);

      if (result.exitCode == 0 && tempFile.existsSync() && tempFile.lengthSync() > 1024) {
        final bytes = tempFile.readAsBytesSync();
        try {
          tempFile.deleteSync();
        } catch (_) {}
        print('  -> Downloaded ${bytes.length} bytes successfully via curl.');
        return bytes;
      } else {
        print('  -> curl returned code ${result.exitCode}: ${result.stderr}');
      }
    } catch (e) {
      print('  -> curl error: $e, trying HttpClient...');
    }

    try {
      print('  Attempting (via HttpClient): $url');
      final request = await client.getUrl(Uri.parse(url)).timeout(const Duration(seconds: 15));
      request.followRedirects = true;
      request.headers.set(HttpHeaders.userAgentHeader, 'Mozilla/5.0 (Windows NT 10.0; Win64; x64)');
      final response = await request.close().timeout(const Duration(seconds: 25));

      if (response.statusCode == 200) {
        final bytes = await response.fold<List<int>>([], (prev, element) => prev..addAll(element)).timeout(const Duration(seconds: 120));
        if (bytes.isNotEmpty) {
          print('  -> Downloaded ${bytes.length} bytes successfully.');
          return bytes;
        }
      } else {
        print('  -> HTTP status ${response.statusCode}');
      }
    } catch (e) {
      print('  -> HttpClient failed: $e');
    }
  }
  return null;
}

Future<void> main() async {
  print('Starting multi-platform Mihomo core downloader ($kVersion)...');
  final client = HttpClient();
  client.badCertificateCallback = (cert, host, port) => true;
  client.connectionTimeout = const Duration(seconds: 15);

  for (final entry in targets.entries) {
    final url = entry.key;
    final destinations = entry.value;

    // Check if all destination files already exist and have valid size
    bool allExist = true;
    for (final dest in destinations) {
      final f = File(dest);
      if (!f.existsSync() || f.lengthSync() < 1024 * 1024) {
        allExist = false;
        break;
      }
    }
    if (allExist) {
      print('\n[Skipping] Already downloaded: ${destinations.first}');
      continue;
    }

    print('\n[Downloading] $url');
    final bytes = await downloadBytes(client, url);
    if (bytes == null) {
      print('  Failed to download $url from all sources.');
      continue;
    }

    List<int>? binaryData;
    if (url.endsWith('.zip')) {
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        if (file.isFile && file.name.endsWith('.exe')) {
          binaryData = file.content as List<int>;
          break;
        }
      }
    } else if (url.endsWith('.gz')) {
      binaryData = gzip.decode(bytes);
    }

    if (binaryData == null || binaryData.isEmpty) {
      print('  Failed to extract binary data.');
      continue;
    }

    for (final dest in destinations) {
      final file = File(dest);
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }
      file.writeAsBytesSync(binaryData, flush: true);
      print('  -> Saved to $dest (${binaryData.length} bytes)');
    }
  }

  // Check Wintun DLL
  final wintun64 = File('bind/windows/core/wintun.dll');
  if (!wintun64.existsSync() || wintun64.lengthSync() < 100000) {
    try {
      print('\n[Downloading] Wintun 0.14.1 for Windows TUN mode...');
      final req = await client.getUrl(Uri.parse('https://www.wintun.net/builds/wintun-0.14.1.zip')).timeout(const Duration(seconds: 15));
      final resp = await req.close().timeout(const Duration(seconds: 25));
      if (resp.statusCode == 200) {
        final bytes = await resp.fold<List<int>>([], (prev, element) => prev..addAll(element)).timeout(const Duration(seconds: 30));
        final archive = ZipDecoder().decodeBytes(bytes);
        for (final file in archive) {
          if (file.isFile) {
            if (file.name == 'wintun/bin/amd64/wintun.dll') {
              final data = file.content as List<int>;
              for (final dest in [
                'bind/windows/core/wintun.dll',
                'build/windows/x64/runner/Release/wintun.dll',
              ]) {
                final f = File(dest);
                if (!f.parent.existsSync()) f.parent.createSync(recursive: true);
                f.writeAsBytesSync(data, flush: true);
                print('  -> Saved $dest (${data.length} bytes)');
              }
            } else if (file.name == 'wintun/bin/arm64/wintun.dll') {
              final data = file.content as List<int>;
              final f = File('bind/windows/core_arm64/wintun.dll');
              if (!f.parent.existsSync()) f.parent.createSync(recursive: true);
              f.writeAsBytesSync(data, flush: true);
              print('  -> Saved bind/windows/core_arm64/wintun.dll (${data.length} bytes)');
            }
          }
        }
      }
    } catch (e) {
      print('  Warning: Could not download wintun.dll: $e');
    }
  } else {
    print('\n[Skipping] Wintun DLL already installed.');
  }

  client.close();
  print('\nAll core downloads completed successfully!');
}
