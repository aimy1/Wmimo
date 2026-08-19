import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

  static String _resolveCorePath() {
    if (_savedTunnelServicePath != null &&
        _savedTunnelServicePath!.isNotEmpty &&
        File(_savedTunnelServicePath!).existsSync()) {
      return _savedTunnelServicePath!;
    }
    final currentDir = Directory.current.path;
    final exeName = Platform.isWindows ? "wmimoService.exe" : "wmimoService";
    final candidates = [
      '$currentDir/$exeName',
      '$currentDir/bind/windows/core/$exeName',
      '$currentDir/build/windows/x64/runner/Release/$exeName',
      '$currentDir/mihomo.exe',
      '$currentDir/clash.exe',
    ];
    for (var path in candidates) {
      if (File(path).existsSync()) {
        return path;
      }
    }
    return _savedTunnelServicePath ?? exeName;
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
    final coreExe = _resolveCorePath();
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

    final workDir = (_savedConfig?.work_dir.isNotEmpty == true &&
            Directory(_savedConfig!.work_dir).existsSync())
        ? _savedConfig!.work_dir
        : File(coreExe).parent.path;

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
