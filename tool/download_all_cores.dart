import 'dart:io';
import 'package:archive/archive.dart';

const String kVersion = 'v1.19.30';
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

Future<void> main() async {
  print('Starting multi-platform Mihomo core downloader ($kVersion)...');
  final client = HttpClient();
  client.connectionTimeout = const Duration(seconds: 30);

  for (final entry in targets.entries) {
    final url = entry.key;
    final destinations = entry.value;

    print('\n[Downloading] $url');
    try {
      final request = await client.getUrl(Uri.parse(url));
      request.followRedirects = true;
      final response = await request.close();

      if (response.statusCode != 200 && response.statusCode != 302) {
        print('  Failed: HTTP ${response.statusCode}');
        continue;
      }

      final bytes = await response.fold<List<int>>([], (prev, element) => prev..addAll(element));
      print('  Downloaded ${bytes.length} bytes.');

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
    } catch (e) {
      print('  Error downloading $url: $e');
    }
  }

  // Download Wintun DLL for Windows TUN mode
  try {
    print('\n[Downloading] Wintun 0.14.1 for Windows TUN mode...');
    final req = await client.getUrl(Uri.parse('https://www.wintun.net/builds/wintun-0.14.1.zip'));
    final resp = await req.close();
    if (resp.statusCode == 200) {
      final bytes = await resp.fold<List<int>>([], (prev, element) => prev..addAll(element));
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

  client.close();
  print('\nAll core downloads completed successfully!');
}
