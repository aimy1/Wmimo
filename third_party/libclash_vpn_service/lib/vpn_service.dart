import 'dart:async';
import 'dart:convert';
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
        'base_dir': base_dir,
        'work_dir': work_dir,
        'cache_dir': cache_dir,
        'core_path': core_path,
        'core_path_patch_final': core_path_patch_final,
        'secret': secret,
        'log_path': log_path,
        'err_path': err_path,
      };
  void fromJson(Map<String, dynamic> json) {}
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
  static Future<bool> isRunAsAdmin() async => false;
  static Future<void> firewallAddApp(String path, String name) async {}
  static Future<void> firewallAddPorts(List<int> ports, String name) async {}
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
    final candidates = [
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
    }

    String profileContent = "";
    if (profileFile.isNotEmpty && File(profileFile).existsSync()) {
      try {
        profileContent = await File(profileFile).readAsString();
      } catch (_) {}
    }

    if (profileContent.isEmpty) {
      if (_savedConfig?.core_path_patch_final != null &&
          File(_savedConfig!.core_path_patch_final).existsSync()) {
        return _savedConfig!.core_path_patch_final;
      }
      return "";
    }

    final port = _savedConfig?.control_port ?? 9090;
    final secret = _savedConfig?.secret ?? "";

    final header = '''
mixed-port: 7890
allow-lan: true
mode: rule
log-level: info
external-controller: 127.0.0.1:$port
secret: "$secret"

''';

    // Filter out conflicting top-level keys
    final filteredLines = profileContent.split('\n').where((line) {
      final trimmed = line.trim();
      return !trimmed.startsWith('external-controller:') &&
          !trimmed.startsWith('secret:') &&
          !trimmed.startsWith('mixed-port:') &&
          !trimmed.startsWith('allow-lan:') &&
          !trimmed.startsWith('mode:') &&
          !trimmed.startsWith('log-level:') &&
          !trimmed.startsWith('port:');
    }).join('\n');

    final baseDir = _savedConfig?.base_dir.isNotEmpty == true
        ? _savedConfig!.base_dir
        : Directory.current.path;
    final runtimePath = "$baseDir/runtime_active_config.yaml";
    try {
      await File(runtimePath).writeAsString(header + filteredLines, flush: true);
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
    if (_savedConfig?.work_dir.isNotEmpty == true && Directory(_savedConfig!.work_dir).existsSync()) {
      workDir = _savedConfig!.work_dir;
    } else if (_savedConfig?.base_dir.isNotEmpty == true && Directory(_savedConfig!.base_dir).existsSync()) {
      workDir = _savedConfig!.base_dir;
    } else {
      try {
        final appSupport = await getApplicationSupportDirectory();
        workDir = appSupport.path;
      } catch (_) {
        workDir = File(coreExe).parent.path;
      }
    }

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
        try {
          final client = HttpClient()
            ..connectionTimeout = const Duration(milliseconds: 400);
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
        await Future.delayed(const Duration(milliseconds: 250));
      }

      if (!ready) {
        final errorDetail = errBuffer.toString().trim().isNotEmpty
            ? errBuffer.toString().trim()
            : outBuffer.toString().trim();
        await stop();
        return VpnServiceWaitResult(
          type: VpnServiceWaitType.timeout,
          err: VpnServiceResultError(
            504,
            errorDetail.isNotEmpty
                ? "核心启动失败: $errorDetail"
                : "等待核心启动超时 (REST API 未响应)",
          ),
        );
      }

      // Start Real-time Traffic Listener
      _startTrafficMonitor(port, secret);

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
    if (_coreProcess != null) {
      try {
        _coreProcess?.kill(ProcessSignal.sigterm);
      } catch (_) {
        _coreProcess?.kill();
      }
      _coreProcess = null;
    }
    if (Platform.isWindows) {
      await cleanSystemProxy();
    }
    _state = FlutterVpnServiceState.disconnected;
    for (var l in _listeners) {
      l(_state, {});
    }
  }

  static Future<void> setAlwaysOn(bool enable) async {}
  static Future<String?> setExcludeFromRecents(bool enable) async => null;

  static Future<void> setSystemProxy(dynamic options) async {
    if (Platform.isWindows) {
      String host = "127.0.0.1";
      int port = 7890;
      String bypass = "<local>;localhost;127.*;10.*;172.16.*;192.168.*";

      try {
        if (options != null) {
          host = options.host?.toString() ?? host;
          port = options.port is int
              ? options.port
              : (int.tryParse(options.port.toString()) ?? port);
          if (options.bypassDomain?.isNotEmpty == true) {
            bypass = "$bypass;${options.bypassDomain}";
          }
        }
      } catch (_) {}

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
    }
  }

  static Future<void> cleanSystemProxy() async {
    if (Platform.isWindows) {
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
    }
    return false;
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
  }) async {}
  static Future<void> autoStartDelete(String name) async {}
  static Future<bool> autoStartIsActive(String name) async => false;

  static void onStateChanged(
      void Function(FlutterVpnServiceState, Map<String, String>) callback) {
    _listeners.add(callback);
  }
}
