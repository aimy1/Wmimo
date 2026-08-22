import 'dart:async';
import 'dart:convert';
import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'state.dart';

enum VpnServiceWaitType {
  done,
  timeout,
  error,
}

class VpnServiceResultError {
  final int code;
  final String message;
  VpnServiceResultError(this.code, this.message);
}

class VpnServiceWaitResult {
  final VpnServiceWaitType type;
  final VpnServiceResultError? err;
  VpnServiceWaitResult({this.type = VpnServiceWaitType.done, this.err});
}

class VpnServiceConfig {
  int control_port = 9090;
  int mixed_port = 7890;
  String mode = "rule";
  String base_dir = "";
  String work_dir = "";
  String cache_dir = "";
  String core_path = "";
  String core_path_patch = "";
  String core_path_patch_final = "";
  String core_path_script = "";
  String log_level = "info";
  String log_path = "";
  String err_path = "";
  String id = "";
  String version = "";
  String name = "";
  String secret = "";
  String install_refer = "";
  bool prepare = false;
  String profile_path = "";
  String config_file_path = "";
  bool tun_mode = false;
  bool wake_lock = false;
  bool auto_connect_at_boot = false;
  bool include_all_networks = false;
  bool exclude_local_networks = false;
  bool exclude_cellular_services = false;
  bool exclude_apns = false;
  bool exclude_device_communication = false;
  bool enforce_routes = false;
  bool auto_route_use_sub_ranges_by_default = false;

  Map<String, dynamic> toJson() => {
        'control_port': control_port,
        'mixed_port': mixed_port,
        'mode': mode,
        'base_dir': base_dir,
        'work_dir': work_dir,
        'cache_dir': cache_dir,
        'core_path': core_path,
        'core_path_patch_final': core_path_patch_final,
        'secret': secret,
        'log_path': log_path,
        'err_path': err_path,
        'tun_mode': tun_mode,
      };
  void fromJson(Map<String, dynamic> json) {
    if (json['control_port'] != null) control_port = json['control_port'];
    if (json['mixed_port'] != null) mixed_port = json['mixed_port'];
    if (json['mode'] != null) mode = json['mode'];
    if (json['base_dir'] != null) base_dir = json['base_dir'];
    if (json['work_dir'] != null) work_dir = json['work_dir'];
    if (json['cache_dir'] != null) cache_dir = json['cache_dir'];
    if (json['core_path'] != null) core_path = json['core_path'];
    if (json['core_path_patch_final'] != null) core_path_patch_final = json['core_path_patch_final'];
    if (json['secret'] != null) secret = json['secret'];
    if (json['log_path'] != null) log_path = json['log_path'];
    if (json['err_path'] != null) err_path = json['err_path'];
    if (json['tun_mode'] != null) tun_mode = json['tun_mode'];
  }
}

// WinINet FFI Bindings for instant Windows proxy refresh
typedef _InternetSetOptionC = ffi.Int32 Function(
  ffi.Pointer<ffi.Void> hInternet,
  ffi.Uint32 dwOption,
  ffi.Pointer<ffi.Void> lpBuffer,
  ffi.Uint32 dwBufferLength,
);
typedef _InternetSetOptionDart = int Function(
  ffi.Pointer<ffi.Void> hInternet,
  int dwOption,
  ffi.Pointer<ffi.Void> lpBuffer,
  int dwBufferLength,
);

void _refreshWinINetSettings() {
  if (Platform.isWindows) {
    try {
      final wininet = ffi.DynamicLibrary.open('wininet.dll');
      final _InternetSetOptionDart internetSetOption = wininet
          .lookup<ffi.NativeFunction<_InternetSetOptionC>>('InternetSetOptionW')
          .asFunction();
      // INTERNET_OPTION_SETTINGS_CHANGED = 39
      // INTERNET_OPTION_REFRESH = 37
      internetSetOption(ffi.nullptr, 39, ffi.nullptr, 0);
      internetSetOption(ffi.nullptr, 37, ffi.nullptr, 0);
    } catch (_) {}
  }
}

class FlutterVpnService {
  static FlutterVpnServiceState _state = FlutterVpnServiceState.disconnected;
  static final List<void Function(FlutterVpnServiceState, Map<String, String>)> _listeners = [];
  static Process? _coreProcess;
  static VpnServiceConfig? _savedConfig;
  static String? _savedTunnelServicePath;
  static String? _savedConfigFilePath;

  static Future<FlutterVpnServiceState> get currentState async => _state;

  static Future<String> getSystemVersion() async => "1.0.0";
  static Future<String> getABIs() async => "[arm64-v8a, armeabi-v7a, x86_64]";

  static Future<bool> isRunAsAdmin() async {
    if (Platform.isWindows) {
      try {
        final res = await Process.run('net', ['session']);
        return res.exitCode == 0;
      } catch (_) {
        return false;
      }
    } else if (Platform.isLinux || Platform.isMacOS) {
      try {
        final res = await Process.run('id', ['-u']);
        return res.stdout.toString().trim() == '0';
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  static Future<void> firewallAddApp(String path, String name) async {
    if (Platform.isWindows && path.isNotEmpty && File(path).existsSync()) {
      try {
        await Process.run('netsh', [
          'advfirewall',
          'firewall',
          'add',
          'rule',
          'name=$name',
          'dir=in',
          'action=allow',
          'program=$path',
          'enable=yes',
        ]);
      } catch (_) {}
    }
  }

  static Future<void> firewallAddPorts(List<int> ports, String name) async {
    if (Platform.isWindows && ports.isNotEmpty) {
      try {
        final validPorts = ports.where((p) => p > 0).join(',');
        if (validPorts.isNotEmpty) {
          await Process.run('netsh', [
            'advfirewall',
            'firewall',
            'add',
            'rule',
            'name=$name',
            'dir=in',
            'action=allow',
            'protocol=TCP',
            'localport=$validPorts',
            'enable=yes',
          ]);
        }
      } catch (_) {}
    }
  }

  static Future<bool> isServiceAuthorized(String path) async => true;
  static Future<VpnServiceResultError?> authorizeService(String path, String password) async => null;
  static Future<VpnServiceResultError?> installService() async => null;
  static Future<VpnServiceResultError?> uninstallService() async => null;
  static Future<void> hideDockIcon(bool hide) async {}
  static Future<Directory?> getAppGroupDirectory(String identifier) async => null;

  static void prepareConfig({
    dynamic config,
    dynamic tunnelServicePath,
    dynamic configFilePath,
    dynamic systemExtension,
    dynamic bundleIdentifier,
    dynamic controlKind,
    dynamic uiServerAddress,
    dynamic uiLocalizedDescription,
    dynamic notifyTitle,
    dynamic notifyStop,
    dynamic notifyDescription,
    dynamic providerBundleIdentifier,
    dynamic excludePorts,
  }) {
    if (config is VpnServiceConfig) {
      _savedConfig = config;
    }
    if (tunnelServicePath is String) {
      _savedTunnelServicePath = tunnelServicePath;
    }
    if (configFilePath is String) {
      _savedConfigFilePath = configFilePath;
    }
  }

  static Future<String> _resolveCorePath() async {
    if (_savedTunnelServicePath != null &&
        _savedTunnelServicePath!.isNotEmpty &&
        File(_savedTunnelServicePath!).existsSync()) {
      return _savedTunnelServicePath!;
    }

    // Android: nativeLibraryDir is the ONLY location allowed for ELF execution on Android 10+
    if (Platform.isAndroid) {
      try {
        const platform = MethodChannel('com.wmimo.app/native_helper');
        final String? nativeLibPath = await platform.invokeMethod<String>('getNativeLibraryPath', {'libName': 'libwmimoService.so'});
        if (nativeLibPath != null && nativeLibPath.isNotEmpty && File(nativeLibPath).existsSync()) {
          return nativeLibPath;
        }
      } catch (_) {}

      try {
        const platform = MethodChannel('com.wmimo.app/native_helper');
        final String? nativeDir = await platform.invokeMethod<String>('getNativeLibraryDir');
        if (nativeDir != null && nativeDir.isNotEmpty) {
          final androidLibCandidates = [
            '$nativeDir/libwmimoService.so',
            '$nativeDir/libmihomo.so',
            '$nativeDir/libclash.so',
          ];
          for (final c in androidLibCandidates) {
            if (File(c).existsSync()) {
              return c;
            }
          }
          final dir = Directory(nativeDir);
          if (dir.existsSync()) {
            for (final f in dir.listSync()) {
              if (f is File && f.path.endsWith('.so') && (f.path.contains('wmimo') || f.path.contains('clash') || f.path.contains('mihomo'))) {
                return f.path;
              }
            }
          }
        }
      } catch (_) {}

      final fallbackAndroidPaths = [
        "/data/data/com.wmimo.app/lib/libwmimoService.so",
        "/data/user/0/com.wmimo.app/lib/libwmimoService.so",
      ];
      for (final p in fallbackAndroidPaths) {
        if (File(p).existsSync()) {
          return p;
        }
      }
    }

    final currentDir = Directory.current.path;
    final exeName = Platform.isWindows ? "wmimoService.exe" : "wmimoService";
    final exeDir = File(Platform.resolvedExecutable).parent.path;
    final candidates = [
      '$exeDir/$exeName',
      '$exeDir/data/$exeName',
      '$exeDir/lib/$exeName',
      '$currentDir/$exeName',
      '$currentDir/bind/windows/core/$exeName',
      '$currentDir/bind/linux/core/$exeName',
      '$currentDir/bind/macos/core/$exeName',
      '$currentDir/build/windows/x64/runner/Release/$exeName',
      '$currentDir/mihomo.exe',
      '$currentDir/clash.exe',
      '$currentDir/mihomo',
      '$currentDir/clash',
    ];

    if (Platform.environment['APPDIR'] != null) {
      candidates.insert(0, '${Platform.environment['APPDIR']}/usr/bin/$exeName');
    }

    // Check app support and documents directories (for desktop)
    try {
      final appSupport = await getApplicationSupportDirectory();
      candidates.insert(0, '${appSupport.path}/core/$exeName');
      candidates.insert(1, '${appSupport.path}/$exeName');
      final appDoc = await getApplicationDocumentsDirectory();
      candidates.insert(2, '${appDoc.path}/core/$exeName');
    } catch (_) {}

    for (var path in candidates) {
      if (File(path).existsSync()) {
        if (!Platform.isWindows) {
          try {
            await Process.run('chmod', ['755', path]);
          } catch (_) {}
        }
        return path;
      }
    }

    // Attempt to extract from Flutter assets
    try {
      final extracted = await _extractCoreFromAssets();
      if (extracted != null && File(extracted).existsSync()) {
        return extracted;
      }
    } catch (_) {}

    // Fallback: auto-download from MetaCubeX releases
    try {
      final downloaded = await _autoDownloadCore();
      if (downloaded != null && File(downloaded).existsSync()) {
        return downloaded;
      }
    } catch (_) {}

    return _savedTunnelServicePath ?? exeName;
  }

  static Future<String?> _extractCoreFromAssets() async {
    try {
      final exeName = Platform.isWindows ? "wmimoService.exe" : "wmimoService";
      final appSupport = await getApplicationSupportDirectory();
      final targetFile = File("${appSupport.path}/core/$exeName");
      if (!targetFile.parent.existsSync()) {
        targetFile.parent.createSync(recursive: true);
      }

      List<String> assetCandidates = [];
      if (Platform.isAndroid) {
        assetCandidates = [
          "assets/core/android/arm64-v8a/wmimoService",
          "assets/core/android/armeabi-v7a/wmimoService",
          "assets/core/android/x86_64/wmimoService",
        ];
      } else if (Platform.isLinux) {
        assetCandidates = ["assets/core/linux/wmimoService"];
      } else if (Platform.isMacOS) {
        assetCandidates = [
          "assets/core/macos/wmimoService",
          "assets/core/macos/wmimoService_arm64",
          "assets/core/macos/wmimoService_amd64",
        ];
      } else if (Platform.isWindows) {
        assetCandidates = ["assets/core/windows/wmimoService.exe"];
      }

      for (final asset in assetCandidates) {
        try {
          final data = await rootBundle.load(asset);
          if (data.lengthInBytes > 0) {
            final buffer = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
            await targetFile.writeAsBytes(buffer, flush: true);
            if (!Platform.isWindows) {
              try {
                await Process.run('chmod', ['755', targetFile.path]);
              } catch (_) {}
            }
            return targetFile.path;
          }
        } catch (_) {}
      }
    } catch (_) {}
    return null;
  }

  static Future<String?> _autoDownloadCore() async {
    try {
      final exeName = Platform.isWindows ? "wmimoService.exe" : "wmimoService";
      final appSupport = await getApplicationSupportDirectory();
      final targetFile = File("${appSupport.path}/core/$exeName");
      if (!targetFile.parent.existsSync()) {
        targetFile.parent.createSync(recursive: true);
      }

      const String kVersion = 'v1.19.30';
      const String kBaseUrl = 'https://github.com/MetaCubeX/mihomo/releases/download/$kVersion';

      String? url;
      if (Platform.isAndroid) {
        url = '$kBaseUrl/mihomo-android-arm64-v8-$kVersion.gz';
      } else if (Platform.isWindows) {
        url = '$kBaseUrl/mihomo-windows-amd64-$kVersion.zip';
      } else if (Platform.isLinux) {
        url = '$kBaseUrl/mihomo-linux-amd64-$kVersion.gz';
      } else if (Platform.isMacOS) {
        url = '$kBaseUrl/mihomo-darwin-arm64-$kVersion.gz';
      }

      if (url == null) return null;

      final client = HttpClient()..connectionTimeout = const Duration(seconds: 30);
      final req = await client.getUrl(Uri.parse(url));
      req.followRedirects = true;
      final resp = await req.close();
      if (resp.statusCode == 200) {
        final bytes = await resp.fold<List<int>>([], (prev, elem) => prev..addAll(elem));
        List<int>? decompressed;
        if (url.endsWith('.gz')) {
          decompressed = gzip.decode(bytes);
        }
        if (decompressed != null && decompressed.isNotEmpty) {
          await targetFile.writeAsBytes(decompressed, flush: true);
          if (!Platform.isWindows) {
            try {
              await Process.run('chmod', ['755', targetFile.path]);
            } catch (_) {}
          }
          return targetFile.path;
        }
      }
    } catch (_) {}
    return null;
  }

  static void _ensureWintunAvailable(String workDir, String coreExePath) {
    if (!Platform.isWindows) return;
    try {
      final currentDir = Directory.current.path;
      final candidateSources = [
        "$currentDir/bind/windows/core/wintun.dll",
        "$currentDir/wintun.dll",
        "${File(coreExePath).parent.path}/wintun.dll",
      ];

      File? sourceFile;
      for (final src in candidateSources) {
        if (File(src).existsSync()) {
          sourceFile = File(src);
          break;
        }
      }

      if (sourceFile != null && sourceFile.existsSync()) {
        final destDirs = [
          workDir,
          File(coreExePath).parent.path,
        ];
        for (final d in destDirs) {
          if (Directory(d).existsSync()) {
            final dest = File("$d/wintun.dll");
            if (!dest.existsSync()) {
              sourceFile.copySync(dest.path);
            }
          }
        }
      }
    } catch (_) {}
  }

  static Future<String> _resolveConfigFile() async {
    String profileFile = "";
    if (_savedConfig?.core_path != null &&
        _savedConfig!.core_path.isNotEmpty &&
        File(_savedConfig!.core_path).existsSync()) {
      profileFile = _savedConfig!.core_path;
    } else if (_savedConfigFilePath != null &&
        _savedConfigFilePath!.isNotEmpty &&
        File(_savedConfigFilePath!).existsSync()) {
      profileFile = _savedConfigFilePath!;
    } else if (_savedConfig?.core_path_patch_final != null &&
        _savedConfig!.core_path_patch_final.isNotEmpty &&
        File(_savedConfig!.core_path_patch_final).existsSync()) {
      profileFile = _savedConfig!.core_path_patch_final;
    }

    String profileContent = "";
    if (profileFile.isNotEmpty && File(profileFile).existsSync()) {
      try {
        profileContent = await File(profileFile).readAsString();
      } catch (_) {}
    }

    if (profileContent.isEmpty) {
      return profileFile;
    }

    final port = _savedConfig?.control_port ?? 9090;
    final mixedPort = _savedConfig?.mixed_port ?? 7890;
    final secret = _savedConfig?.secret ?? "";
    final mode = (_savedConfig?.mode.isNotEmpty == true) ? _savedConfig!.mode : "rule";
    final tunMode = _savedConfig?.tun_mode ?? false;

    // Header parameters matching Clash Verge standards
    var header = '''
mixed-port: $mixedPort
allow-lan: true
mode: $mode
log-level: info
external-controller: 127.0.0.1:$port
secret: "$secret"
ipv6: false
unified-delay: true
tcp-concurrent: true
find-process-mode: always
''';

    if (tunMode && !Platform.isAndroid) {
      header += '''
tun:
  enable: true
  stack: mixed
  dns-hijack:
    - "any:53"
    - "tcp://any:53"
  auto-route: true
  auto-detect-interface: true
  strict-route: false
''';
    }

    // Filter out conflicting top-level keys from raw subscription
    final overriddenTopLevelKeys = [
      'mixed-port',
      'allow-lan',
      'mode',
      'log-level',
      'external-controller',
      'secret',
      'ipv6',
      'unified-delay',
      'tcp-concurrent',
      'find-process-mode',
      'port',
      'socks-port',
      'redir-port',
      'tproxy-port',
      'interface-name',
      'routing-mark',
    ];

    bool inOverriddenBlock = false;
    final List<String> resultLines = [];
    final rawLines = profileContent.split('\n');

    for (int i = 0; i < rawLines.length; i++) {
      final rawLine = rawLines[i];
      final trimmed = rawLine.trim();

      // Check if entering a root block that we override completely (e.g. tun:)
      if (tunMode && (trimmed.startsWith('tun:') || trimmed.startsWith('tun-') || trimmed.startsWith('"tun":') || trimmed.startsWith("'tun':"))) {
        inOverriddenBlock = true;
        continue;
      }

      // If we are inside an overridden block and the line is indented, skip it
      if (inOverriddenBlock) {
        if (rawLine.startsWith(' ') || rawLine.startsWith('\t') || trimmed.isEmpty) {
          continue;
        } else {
          inOverriddenBlock = false;
        }
      }

      // Check if it's a top-level key that we override
      bool isOverridden = false;
      if (!rawLine.startsWith(' ') && !rawLine.startsWith('\t')) {
        for (final key in overriddenTopLevelKeys) {
          if (trimmed.startsWith('$key:') ||
              trimmed.startsWith('$key :') ||
              trimmed.startsWith('"$key":') ||
              trimmed.startsWith("'$key':") ||
              trimmed.startsWith('"$key" :') ||
              trimmed.startsWith("'$key' :")) {
            isOverridden = true;
            break;
          }
        }
      }

      if (isOverridden) {
        continue;
      }

      // Sanitize privileged port 53 binding on Android / Linux non-root if not in tun
      String processedLine = rawLine;
      if (!tunMode) {
        if (trimmed.startsWith('listen:') && trimmed.contains(':53')) {
          processedLine = rawLine.replaceAll(':53', ':1053');
        } else if (trimmed.startsWith('bind-address:') && trimmed.contains(':53')) {
          processedLine = rawLine.replaceAll(':53', ':1053');
        }
      }

      resultLines.add(processedLine);
    }

    var filteredLines = resultLines.join('\n');

    // Ensure fallback DNS with Fake-IP if not defined or if TUN is active
    if (!filteredLines.contains('dns:') && !filteredLines.contains('nameserver:')) {
      filteredLines += '''\n
dns:
  enable: true
  listen: 127.0.0.1:1053
  enhanced-mode: fake-ip
  fake-ip-range: 198.18.0.1/16
  nameserver:
    - 223.5.5.5
    - 119.29.29.29
    - 8.8.8.8
    - 1.1.1.1
  fallback:
    - 1.0.0.1
    - 8.8.4.4
''';
    }

    // Ensure fallback proxy-groups if not defined in subscription
    if (!filteredLines.contains('proxy-groups:') && !filteredLines.contains('"proxy-groups":')) {
      final List<String> proxyNames = [];
      final lines = filteredLines.split('\n');
      final nameRegex = RegExp(r'^\s*-\s*(?:name:\s*["'']?([^"''\n]+)["'']?|{[^}]*name:\s*["'']?([^,"''}\n]+))');
      for (var l in lines) {
        final match = nameRegex.firstMatch(l);
        if (match != null) {
          final n = (match.group(1) ?? match.group(2) ?? "").trim();
          final upperN = n.toUpperCase();
          if (n.isNotEmpty &&
              upperN != "DIRECT" &&
              upperN != "REJECT" &&
              upperN != "REJECT-DROP" &&
              upperN != "PASS" &&
              upperN != "PASS-RULE" &&
              upperN != "COMPATIBLE" &&
              upperN != "GLOBAL" &&
              upperN != "PROXY") {
            if (!proxyNames.contains(n)) {
              proxyNames.add(n);
            }
          }
        }
      }

      if (proxyNames.isNotEmpty) {
        final hkNodes = proxyNames.where((n) {
          final u = n.toUpperCase();
          return n.contains("香港") || u.contains("HK") || u.contains("HONG KONG");
        }).toList();
        final jpNodes = proxyNames.where((n) {
          final u = n.toUpperCase();
          return n.contains("日本") || u.contains("JP") || u.contains("JAPAN") || n.contains("东京") || n.contains("大阪");
        }).toList();
        final sgNodes = proxyNames.where((n) {
          final u = n.toUpperCase();
          return n.contains("新加坡") || u.contains("SG") || u.contains("SINGAPORE") || n.contains("狮城");
        }).toList();
        final twNodes = proxyNames.where((n) {
          final u = n.toUpperCase();
          return n.contains("台湾") || u.contains("TW") || u.contains("TAIWAN") || n.contains("台北");
        }).toList();
        final usNodes = proxyNames.where((n) {
          final u = n.toUpperCase();
          return n.contains("美国") || u.contains("US") || u.contains("USA") || n.contains("美") || u.contains("UNITED STATES");
        }).toList();
        final krNodes = proxyNames.where((n) {
          final u = n.toUpperCase();
          return n.contains("韩国") || u.contains("KR") || u.contains("KOREA") || n.contains("首尔");
        }).toList();

        final buf = StringBuffer('\nproxy-groups:\n');
        buf.writeln('  - name: 节点选择');
        buf.writeln('    type: select');
        buf.writeln('    proxies:');
        buf.writeln('      - 自动选择');
        buf.writeln('      - 故障转移');
        for (var p in proxyNames) {
          buf.writeln('      - "$p"');
        }
        buf.writeln('      - DIRECT');

        buf.writeln('  - name: 自动选择');
        buf.writeln('    type: url-test');
        buf.writeln('    url: http://www.gstatic.com/generate_204');
        buf.writeln('    interval: 300');
        buf.writeln('    proxies:');
        for (var p in proxyNames) {
          buf.writeln('      - "$p"');
        }

        buf.writeln('  - name: 故障转移');
        buf.writeln('    type: fallback');
        buf.writeln('    url: http://www.gstatic.com/generate_204');
        buf.writeln('    interval: 300');
        buf.writeln('    proxies:');
        for (var p in proxyNames) {
          buf.writeln('      - "$p"');
        }

        if (hkNodes.isNotEmpty) {
          buf.writeln('  - name: 🇭🇰 香港节点');
          buf.writeln('    type: select');
          buf.writeln('    proxies:');
          for (var p in hkNodes) {
            buf.writeln('      - "$p"');
          }
        }
        if (jpNodes.isNotEmpty) {
          buf.writeln('  - name: 🇯🇵 日本节点');
          buf.writeln('    type: select');
          buf.writeln('    proxies:');
          for (var p in jpNodes) {
            buf.writeln('      - "$p"');
          }
        }
        if (sgNodes.isNotEmpty) {
          buf.writeln('  - name: 🇸🇬 新加坡节点');
          buf.writeln('    type: select');
          buf.writeln('    proxies:');
          for (var p in sgNodes) {
            buf.writeln('      - "$p"');
          }
        }
        if (twNodes.isNotEmpty) {
          buf.writeln('  - name: 🇹🇼 台湾节点');
          buf.writeln('    type: select');
          buf.writeln('    proxies:');
          for (var p in twNodes) {
            buf.writeln('      - "$p"');
          }
        }
        if (usNodes.isNotEmpty) {
          buf.writeln('  - name: 🇺🇸 美国节点');
          buf.writeln('    type: select');
          buf.writeln('    proxies:');
          for (var p in usNodes) {
            buf.writeln('      - "$p"');
          }
        }
        if (krNodes.isNotEmpty) {
          buf.writeln('  - name: 🇰🇷 韩国节点');
          buf.writeln('    type: select');
          buf.writeln('    proxies:');
          for (var p in krNodes) {
            buf.writeln('      - "$p"');
          }
        }

        buf.writeln('  - name: GLOBAL');
        buf.writeln('    type: select');
        buf.writeln('    proxies:');
        buf.writeln('      - 节点选择');
        buf.writeln('      - 自动选择');
        buf.writeln('      - 故障转移');
        for (var p in proxyNames) {
          buf.writeln('      - "$p"');
        }
        buf.writeln('      - DIRECT');

        filteredLines += buf.toString();

        if (!filteredLines.contains('rules:') && !filteredLines.contains('"rules":')) {
          filteredLines += '''\n
rules:
  - MATCH,节点选择
''';
        }
      }
    }

    final baseDir = _savedConfig?.base_dir.isNotEmpty == true
        ? _savedConfig!.base_dir
        : Directory.current.path;
    try {
      if (!Directory(baseDir).existsSync()) {
        Directory(baseDir).createSync(recursive: true);
      }
    } catch (_) {}
    final runtimePath = "$baseDir/runtime_active_config.yaml";
    try {
      await File(runtimePath).writeAsString(header + '\n' + filteredLines, flush: true);
      return runtimePath;
    } catch (_) {
      return profileFile;
    }
  }

  // Real-time Traffic Monitoring
  static int _lastUp = 0;
  static int _lastDown = 0;
  static bool _trafficMonitoring = false;
  static StreamSubscription? _trafficSub;
  static HttpClient? _trafficClient;

  static void _startTrafficMonitor(int port, String secret) {
    _trafficMonitoring = true;
    _listenTraffic(port, secret);
  }

  static void _listenTraffic(int port, String secret) {
    if (!_trafficMonitoring) return;
    _trafficSub?.cancel();
    _trafficClient?.close(force: true);
    _trafficClient = HttpClient()..connectionTimeout = const Duration(seconds: 3);
    _trafficClient!.getUrl(Uri.parse("http://127.0.0.1:$port/traffic")).then((req) {
      if (secret.isNotEmpty) {
        req.headers.set('Authorization', 'Bearer $secret');
      }
      return req.close();
    }).then((resp) {
      _trafficSub = resp
          .transform(utf8.decoder)
          .transform(const LineSplitter())
          .listen((line) {
        try {
          if (line.trim().isNotEmpty) {
            final json = jsonDecode(line.trim());
            _lastUp = json['up'] ?? 0;
            _lastDown = json['down'] ?? 0;
          }
        } catch (_) {}
      }, onDone: () {
        if (_trafficMonitoring) {
          Future.delayed(const Duration(seconds: 1), () => _listenTraffic(port, secret));
        }
      }, onError: (_) {
        if (_trafficMonitoring) {
          Future.delayed(const Duration(seconds: 1), () => _listenTraffic(port, secret));
        }
      });
    }).catchError((_) {
      if (_trafficMonitoring) {
        Future.delayed(const Duration(seconds: 1), () => _listenTraffic(port, secret));
      }
    });
  }

  static void _stopTrafficMonitor() {
    _trafficMonitoring = false;
    _trafficSub?.cancel();
    _trafficSub = null;
    _trafficClient?.close(force: true);
    _trafficClient = null;
    _lastUp = 0;
    _lastDown = 0;
  }

  static Future<VpnServiceWaitResult> start(Duration timeout) async {
    final coreExe = await _resolveCorePath();
    final configFile = await _resolveConfigFile();

    if (!File(coreExe).existsSync()) {
      return VpnServiceWaitResult(
        type: VpnServiceWaitType.error,
        err: VpnServiceResultError(404, "Mihomo 内核执行文件未找到: $coreExe"),
      );
    }

    if (configFile.isEmpty || !File(configFile).existsSync()) {
      return VpnServiceWaitResult(
        type: VpnServiceWaitType.error,
        err: VpnServiceResultError(404, "配置文件未找到: $configFile"),
      );
    }

    await stop();

    String workDir = "";
    if (_savedConfig?.base_dir.isNotEmpty == true && Directory(_savedConfig!.base_dir).existsSync()) {
      workDir = _savedConfig!.base_dir;
    } else if (_savedConfig?.work_dir.isNotEmpty == true && Directory(_savedConfig!.work_dir).existsSync()) {
      workDir = _savedConfig!.work_dir;
    } else {
      try {
        final appSupport = await getApplicationSupportDirectory();
        workDir = appSupport.path;
      } catch (_) {
        workDir = File(coreExe).parent.path;
      }
    }

    _ensureWintunAvailable(workDir, coreExe);

    try {
      final args = ['-d', workDir, '-f', configFile];
      _coreProcess = await Process.start(coreExe, args, mode: ProcessStartMode.normal);

      final outBuffer = StringBuffer();
      final errBuffer = StringBuffer();
      final logFile = (_savedConfig?.log_path.isNotEmpty == true)
          ? File(_savedConfig!.log_path)
          : null;

      _coreProcess!.stdout.transform(utf8.decoder).listen((data) {
        outBuffer.write(data);
        if (logFile != null) {
          try {
            logFile.writeAsStringSync(data, mode: FileMode.append, flush: true);
          } catch (_) {}
        }
      });
      _coreProcess!.stderr.transform(utf8.decoder).listen((data) {
        errBuffer.write(data);
        if (logFile != null) {
          try {
            logFile.writeAsStringSync(data, mode: FileMode.append, flush: true);
          } catch (_) {}
        }
      });
      _coreProcess!.exitCode.then((code) {
        _coreProcess = null;
        _stopTrafficMonitor();
        _state = FlutterVpnServiceState.disconnected;
        for (var l in _listeners) {
          l(_state, {});
        }
      });

      final port = _savedConfig?.control_port ?? 9090;
      final secret = _savedConfig?.secret ?? "";
      bool ready = false;
      final stopwatch = Stopwatch()..start();

      while (stopwatch.elapsed < timeout) {
        if (_coreProcess == null) {
          break;
        }
        try {
          final client = HttpClient()
            ..connectionTimeout = const Duration(milliseconds: 200);
          final req = await client
              .getUrl(Uri.parse("http://127.0.0.1:$port/version"));
          if (secret.isNotEmpty) {
            req.headers.set('Authorization', 'Bearer $secret');
          }
          final resp = await req.close();
          if (resp.statusCode == 200) {
            ready = true;
            client.close();
            break;
          }
          client.close();
        } catch (_) {}
        await Future.delayed(const Duration(milliseconds: 100));
      }

      if (!ready) {
        final errorDetail = errBuffer.toString().trim().isNotEmpty
            ? errBuffer.toString().trim()
            : outBuffer.toString().trim();
        await stop();
        return VpnServiceWaitResult(
          type: VpnServiceWaitType.error,
          err: VpnServiceResultError(
            500,
            errorDetail.isNotEmpty
                ? "核心启动失败: $errorDetail"
                : "等待核心启动超时 (端口 $port 无响应)",
          ),
        );
      }

      // Start Real-time Traffic Listener
      _startTrafficMonitor(port, secret);

      if (Platform.isAndroid) {
        try {
          final mixedPort = _savedConfig?.mixed_port ?? 7890;
          const platform = MethodChannel('com.wmimo.app/native_helper');
          await platform.invokeMethod('startVpnService', {
            'mixedPort': mixedPort,
          });
        } catch (_) {}
      }

      _state = FlutterVpnServiceState.connected;
      for (var l in _listeners) {
        l(_state, {});
      }
      return VpnServiceWaitResult(type: VpnServiceWaitType.done);
    } catch (e) {
      return VpnServiceWaitResult(
        type: VpnServiceWaitType.error,
        err: VpnServiceResultError(500, "启动核心异常: $e"),
      );
    }
  }

  static Future<VpnServiceWaitResult> restart(Duration timeout) async {
    await stop();
    return await start(timeout);
  }

  static Future<void> stop() async {
    _stopTrafficMonitor();
    if (Platform.isAndroid) {
      try {
        const platform = MethodChannel('com.wmimo.app/native_helper');
        await platform.invokeMethod('stopVpnService');
      } catch (_) {}
    }
    if (_coreProcess != null) {
      try {
        _coreProcess?.kill(ProcessSignal.sigterm);
      } catch (_) {
        _coreProcess?.kill();
      }
      _coreProcess = null;
    }
    await cleanSystemProxy();
    _state = FlutterVpnServiceState.disconnected;
    for (var l in _listeners) {
      l(_state, {});
    }
  }

  static Future<void> setAlwaysOn(bool enable) async {}
  static Future<String?> setExcludeFromRecents(bool enable) async => null;

  static Future<void> setSystemProxy(dynamic options) async {
    String host = "127.0.0.1";
    int port = 7890;
    String bypass = "<local>;localhost;127.*;10.*;172.16.*;172.17.*;172.18.*;172.19.*;172.20.*;172.21.*;172.22.*;172.23.*;172.24.*;172.25.*;172.26.*;172.27.*;172.28.*;172.29.*;172.30.*;172.31.*;192.168.*";

    try {
      if (options != null) {
        host = options.host?.toString() ?? host;
        port = options.port is int
            ? options.port
            : (int.tryParse(options.port.toString()) ?? port);
        if (options.bypassDomain != null && options.bypassDomain.toString().isNotEmpty) {
          bypass = "$bypass;${options.bypassDomain}";
        }
      }
    } catch (_) {}

    if (Platform.isWindows) {
      try {
        await Process.run('reg', [
          'add',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
          '/v',
          'ProxyEnable',
          '/t',
          'REG_DWORD',
          '/d',
          '1',
          '/f'
        ]);
        await Process.run('reg', [
          'add',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
          '/v',
          'ProxyServer',
          '/t',
          'REG_SZ',
          '/d',
          '$host:$port',
          '/f'
        ]);
        await Process.run('reg', [
          'add',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
          '/v',
          'ProxyOverride',
          '/t',
          'REG_SZ',
          '/d',
          bypass,
          '/f'
        ]);
        _refreshWinINetSettings();
      } catch (_) {}
    } else if (Platform.isMacOS) {
      try {
        final services = await _getMacNetworkServices();
        for (final service in services) {
          await Process.run('networksetup', ['-setwebproxy', service, host, '$port']);
          await Process.run('networksetup', ['-setsecurewebproxy', service, host, '$port']);
          await Process.run('networksetup', ['-setsocksfirewallproxy', service, host, '$port']);
          final macBypass = ["localhost", "127.0.0.1", "192.168.0.0/16", "10.0.0.0/8", "172.16.0.0/12"];
          await Process.run('networksetup', ['-setproxybypassdomains', service, ...macBypass]);
          await Process.run('networksetup', ['-setwebproxystate', service, 'on']);
          await Process.run('networksetup', ['-setsecurewebproxystate', service, 'on']);
          await Process.run('networksetup', ['-setsocksfirewallproxystate', service, 'on']);
        }
      } catch (_) {}
    } else if (Platform.isLinux) {
      try {
        await Process.run('gsettings', ['set', 'org.gnome.system.proxy', 'mode', 'manual']);
        await Process.run('gsettings', ['set', 'org.gnome.system.proxy.http', 'host', host]);
        await Process.run('gsettings', ['set', 'org.gnome.system.proxy.http', 'port', '$port']);
        await Process.run('gsettings', ['set', 'org.gnome.system.proxy.https', 'host', host]);
        await Process.run('gsettings', ['set', 'org.gnome.system.proxy.https', 'port', '$port']);
        await Process.run('gsettings', ['set', 'org.gnome.system.proxy.socks', 'host', host]);
        await Process.run('gsettings', ['set', 'org.gnome.system.proxy.socks', 'port', '$port']);
        await Process.run('gsettings', [
          'set',
          'org.gnome.system.proxy',
          'ignore-hosts',
          "['localhost', '127.0.0.0/8', '::1', '10.0.0.0/8', '192.168.0.0/16', '172.16.0.0/12']"
        ]);
      } catch (_) {}

      // KDE Plasma support
      try {
        final kwrite = (await Process.run('which', ['kwriteconfig6'])).exitCode == 0 ? 'kwriteconfig6' : 'kwriteconfig5';
        await Process.run(kwrite, ['--file', 'kioslaverc', '--group', 'Proxy Settings', '--key', 'ProxyType', '1']);
        await Process.run(kwrite, ['--file', 'kioslaverc', '--group', 'Proxy Settings', '--key', 'httpProxy', 'http://$host:$port']);
        await Process.run(kwrite, ['--file', 'kioslaverc', '--group', 'Proxy Settings', '--key', 'httpsProxy', 'http://$host:$port']);
        await Process.run(kwrite, ['--file', 'kioslaverc', '--group', 'Proxy Settings', '--key', 'socksProxy', 'socks5://$host:$port']);
      } catch (_) {}
    }
  }

  static Future<void> cleanSystemProxy() async {
    if (Platform.isWindows) {
      try {
        await Process.run('reg', [
          'add',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
          '/v',
          'ProxyEnable',
          '/t',
          'REG_DWORD',
          '/d',
          '0',
          '/f'
        ]);
        _refreshWinINetSettings();
      } catch (_) {}
    } else if (Platform.isMacOS) {
      try {
        final services = await _getMacNetworkServices();
        for (final service in services) {
          await Process.run('networksetup', ['-setwebproxystate', service, 'off']);
          await Process.run('networksetup', ['-setsecurewebproxystate', service, 'off']);
          await Process.run('networksetup', ['-setsocksfirewallproxystate', service, 'off']);
        }
      } catch (_) {}
    } else if (Platform.isLinux) {
      try {
        await Process.run('gsettings', ['set', 'org.gnome.system.proxy', 'mode', 'none']);
      } catch (_) {}
      try {
        final kwrite = (await Process.run('which', ['kwriteconfig6'])).exitCode == 0 ? 'kwriteconfig6' : 'kwriteconfig5';
        await Process.run(kwrite, ['--file', 'kioslaverc', '--group', 'Proxy Settings', '--key', 'ProxyType', '0']);
      } catch (_) {}
    }
  }

  static Future<bool> getSystemProxyEnable(dynamic options) async {
    if (Platform.isWindows) {
      try {
        final result = await Process.run('reg', [
          'query',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings',
          '/v',
          'ProxyEnable'
        ]);
        if (result.stdout != null && result.stdout.toString().contains('0x1')) {
          return true;
        }
      } catch (_) {}
    } else if (Platform.isMacOS) {
      try {
        final services = await _getMacNetworkServices();
        for (final service in services) {
          final res = await Process.run('networksetup', ['-getwebproxy', service]);
          if (res.stdout != null && res.stdout.toString().contains('Enabled: Yes')) {
            return true;
          }
        }
      } catch (_) {}
    } else if (Platform.isLinux) {
      try {
        final res = await Process.run('gsettings', ['get', 'org.gnome.system.proxy', 'mode']);
        if (res.stdout != null && res.stdout.toString().contains('manual')) {
          return true;
        }
      } catch (_) {}
    }
    return false;
  }

  static Future<List<String>> _getMacNetworkServices() async {
    List<String> services = [];
    try {
      final res = await Process.run('networksetup', ['-listallnetworkservices']);
      if (res.exitCode == 0 && res.stdout != null) {
        final lines = res.stdout.toString().split('\n');
        for (var line in lines) {
          line = line.trim();
          if (line.isNotEmpty && !line.startsWith('*') && !line.contains('An asterisk')) {
            services.add(line);
          }
        }
      }
    } catch (_) {}
    if (services.isEmpty) {
      services = ['Wi-Fi', 'Ethernet'];
    }
    return services;
  }

  static Future<String> clashiApiConnections(bool full) async {
    final port = _savedConfig?.control_port ?? 9090;
    final secret = _savedConfig?.secret ?? "";
    try {
      final client = HttpClient()..connectionTimeout = const Duration(milliseconds: 600);
      final req = await client.getUrl(Uri.parse("http://127.0.0.1:$port/connections"));
      if (secret.isNotEmpty) {
        req.headers.set('Authorization', 'Bearer $secret');
      }
      final resp = await req.close();
      final body = await resp.transform(utf8.decoder).join();
      client.close();
      return body;
    } catch (_) {
      return "{}";
    }
  }

  static Future<String> clashiApiTraffic() async {
    return jsonEncode({"up": _lastUp, "down": _lastDown});
  }

  static Future<void> autoStartCreate(
    dynamic name,
    dynamic exec, {
    dynamic processArgs,
    dynamic runElevated,
  }) async {
    final taskName = name.toString();
    final execPath = exec.toString();
    if (Platform.isWindows) {
      try {
        final cmd = processArgs != null && processArgs.toString().isNotEmpty
            ? '"$execPath" $processArgs'
            : '"$execPath"';
        await Process.run('reg', [
          'add',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run',
          '/v',
          taskName,
          '/t',
          'REG_SZ',
          '/d',
          cmd,
          '/f',
        ]);
      } catch (_) {}
    }
  }

  static Future<void> autoStartDelete(String name) async {
    if (Platform.isWindows) {
      try {
        await Process.run('reg', [
          'delete',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run',
          '/v',
          name,
          '/f',
        ]);
      } catch (_) {}
    }
  }

  static Future<bool> autoStartIsActive(String name) async {
    if (Platform.isWindows) {
      try {
        final res = await Process.run('reg', [
          'query',
          r'HKCU\Software\Microsoft\Windows\CurrentVersion\Run',
          '/v',
          name,
        ]);
        return res.exitCode == 0 && res.stdout.toString().contains(name);
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  static void onStateChanged(
      void Function(FlutterVpnServiceState, Map<String, String>) callback) {
    _listeners.add(callback);
  }
}
