import 'dart:async';
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

  Map<String, dynamic> toJson() => {};
  void fromJson(Map<String, dynamic> json) {}
}

class FlutterVpnService {
  static FlutterVpnServiceState _state = FlutterVpnServiceState.disconnected;
  static final List<void Function(FlutterVpnServiceState, Map<String, String>)> _listeners = [];

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
  static Future<VpnServiceWaitResult> start(Duration timeout) async {
    _state = FlutterVpnServiceState.connected;
    for (var l in _listeners) { l(_state, {}); }
    return VpnServiceWaitResult();
  }
  static Future<VpnServiceWaitResult> restart(Duration timeout) async {
    _state = FlutterVpnServiceState.connected;
    for (var l in _listeners) { l(_state, {}); }
    return VpnServiceWaitResult();
  }
  static Future<void> stop() async {
    _state = FlutterVpnServiceState.disconnected;
    for (var l in _listeners) { l(_state, {}); }
  }
  static Future<void> setAlwaysOn(bool enable) async {}
  static Future<String?> setExcludeFromRecents(bool enable) async => null;
  static Future<void> setSystemProxy(dynamic options) async {}
  static Future<void> cleanSystemProxy() async {}
  static Future<bool> getSystemProxyEnable(dynamic options) async => false;
  static Future<void> prepareConfig({
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
  }) async {}
  static Future<String> clashiApiConnections(bool full) async => "{}";
  static Future<String> clashiApiTraffic() async => "{\"up\": 0, \"down\": 0}";
  static Future<void> autoStartCreate(
    dynamic name,
    dynamic exec, {
    dynamic processArgs,
    dynamic runElevated,
  }) async {}
  static Future<void> autoStartDelete(String name) async {}
  static Future<bool> autoStartIsActive(String name) async => false;

  static void onStateChanged(void Function(FlutterVpnServiceState, Map<String, String>) callback) {
    _listeners.add(callback);
  }
}
