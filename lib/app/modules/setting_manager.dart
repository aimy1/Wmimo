// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/utils/app_registry_utils.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/convert_utils.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/text_field.dart';

import 'package:path/path.dart' as path;
import 'package:win32_registry/win32_registry.dart';

const List<String> ProxyBypassDoaminsDefault = [
  "127.0.0.1",
  "localhost",
  "*.local",
  "10.*",
  "172.16.*",
  "192.168.*",
];

class SettingConfigItemUI {
  String theme = ThemeDefine.kThemeLight;
  bool autoOrientation = maybeTv();
  bool disableFontScaler = false;
  bool hideAfterLaunch = false;
  bool tvMode = maybeTv();
  bool perAppHideSystemApp = true;
  bool perAppHideAppIcon = false;
  bool delayTestSort = false;
  bool sideBySideLayout = true;
  bool enableAnimations = true;
  bool showTrafficChart = true;
  bool showWebsiteTest = true;
  bool showIpInfo = true;
  bool showSubscription = true;
  bool showQuickActions = true;
  bool collapseTrafficChart = false;
  bool collapseWebsiteTest = false;
  bool collapseIpInfo = false;
  bool collapseSubscription = false;
  bool collapseQuickActions = false;
  Map<String, dynamic> toJson() => {
    'theme': theme,
    'auto_orientation': autoOrientation,
    'disable_font_scaler': disableFontScaler,
    'hide_after_launch': hideAfterLaunch,
    'tv_mode': tvMode,
    'perapp_hide_system_app': perAppHideSystemApp,
    'perapp_hide_app_icon': perAppHideAppIcon,
    'delay_test_sort': delayTestSort,
    'side_by_side_layout': sideBySideLayout,
    'enable_animations': enableAnimations,
    'show_traffic_chart': showTrafficChart,
    'show_website_test': showWebsiteTest,
    'show_ip_info': showIpInfo,
    'show_subscription': showSubscription,
    'show_quick_actions': showQuickActions,
    'collapse_traffic_chart': collapseTrafficChart,
    'collapse_website_test': collapseWebsiteTest,
    'collapse_ip_info': collapseIpInfo,
    'collapse_subscription': collapseSubscription,
    'collapse_quick_actions': collapseQuickActions,
  };
  void fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    theme = (map["theme"] as String?)?.trim().toLowerCase() ?? "";
    autoOrientation = map["auto_orientation"] ?? maybeTv();
    disableFontScaler = map["disable_font_scaler"] ?? false;
    hideAfterLaunch = map["hide_after_launch"] ?? false;
    perAppHideSystemApp = map["perapp_hide_system_app"] ?? true;
    perAppHideAppIcon = map["perapp_hide_app_icon"] ?? false;
    delayTestSort = map["delay_test_sort"] ?? false;
    sideBySideLayout = map["side_by_side_layout"] ?? true;
    enableAnimations = map["enable_animations"] ?? true;
    ThemeDefine.enableAnimations = enableAnimations;
    showTrafficChart = map["show_traffic_chart"] ?? true;
    showWebsiteTest = map["show_website_test"] ?? true;
    showIpInfo = map["show_ip_info"] ?? true;
    showSubscription = map["show_subscription"] ?? true;
    showQuickActions = map["show_quick_actions"] ?? true;
    collapseTrafficChart = map["collapse_traffic_chart"] ?? false;
    collapseWebsiteTest = map["collapse_website_test"] ?? false;
    collapseIpInfo = map["collapse_ip_info"] ?? false;
    collapseSubscription = map["collapse_subscription"] ?? false;
    collapseQuickActions = map["collapse_quick_actions"] ?? false;
    if (Platform.isAndroid) {
      tvMode = map["tv_mode"] ?? maybeTv();
      TextFieldEx.popupEdit = tvMode;
    }

    switch (theme) {
      case "dark":
        theme = ThemeDefine.kThemeDark;
        break;

      case "light":
        theme = ThemeDefine.kThemeLight;
        break;

      case "system":
        theme = ThemeDefine.kThemeSystem;
        break;

      default:
        theme = ThemeDefine.kThemeLight;
        break;
    }
  }

  static SettingConfigItemUI fromJsonStatic(Map<String, dynamic>? map) {
    SettingConfigItemUI config = SettingConfigItemUI();
    config.fromJson(map);
    return config;
  }

  static bool maybeTv() {
    if (Platform.isAndroid) {
      final abis = VPNService.getABIs();
      if (abis.length == 1 &&
          (abis.contains("armeabi") || abis.contains("x86"))) {
        return true;
      }
    }
    return false;
  }
}

class SettingConfigItemWebDev {
  String url = "";
  String user = "";
  String password = "";

  Map<String, dynamic> toJson() {
    Map<String, dynamic> ret = {'url': url, 'user': user, 'password': password};
    return ret;
  }

  void fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    url = map["url"] ?? "";
    user = map["user"] ?? "";
    password = map["password"] ?? "";
  }

  static SettingConfigItemWebDev fromJsonStatic(Map<String, dynamic>? map) {
    SettingConfigItemWebDev config = SettingConfigItemWebDev();
    config.fromJson(map);
    return config;
  }
}

class SettingConfigItemWindowState {
  double? width;
  double? height;
  double? x;
  double? y;
  bool isMaximized = false;

  bool get isValid =>
      width != null &&
      height != null &&
      width! >= 360 &&
      height! >= 480;

  Map<String, dynamic> toJson() => {
    if (width != null) 'width': width,
    if (height != null) 'height': height,
    if (x != null) 'x': x,
    if (y != null) 'y': y,
    'is_maximized': isMaximized,
  };

  void fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }
    if (map['width'] is num) {
      width = (map['width'] as num).toDouble();
    }
    if (map['height'] is num) {
      height = (map['height'] as num).toDouble();
    }
    if (map['x'] is num) {
      x = (map['x'] as num).toDouble();
    }
    if (map['y'] is num) {
      y = (map['y'] as num).toDouble();
    }
    if (map['is_maximized'] is bool) {
      isMaximized = map['is_maximized'] as bool;
    }
  }

  static SettingConfigItemWindowState fromJsonStatic(Map<String, dynamic>? map) {
    SettingConfigItemWindowState config = SettingConfigItemWindowState();
    config.fromJson(map);
    return config;
  }
}

class SettingConfig {
  static const String kDefaultBoardUrl = "https://board.zash.run.place/";
  static const int kDefaultBoardPort = 7066;
  static const String kDefaultDelayTestUrl =
      "https://www.gstatic.com/generate_204";
  String languageTag = "";
  SettingConfigItemUI ui = SettingConfigItemUI();
  SettingConfigItemWebDev webdav = SettingConfigItemWebDev();
  SettingConfigItemWindowState window = SettingConfigItemWindowState();
  bool devMode = false;
  bool alwayOn = false;
  String logLevel = bool.fromEnvironment("dart.vm.product")
      ? "warning"
      : "info"; //trace, debug, info, warning, error
  String autoUpdateChannel = "stable"; //stable, beta
  bool autoDownloadUpdatePkg = true;
  bool autoConnectAfterLaunch = true;
  bool autoSetSystemProxy = getAutoSetSystemProxyDefault();
  List<String> systemProxyBypassDomain = ProxyBypassDoaminsDefault.toList();
  String _userAgent = "";
  bool boardOnline = false;
  String boardUrl = kDefaultBoardUrl;
  int boardLocalPort = kDefaultBoardPort;
  String delayTestUrl = kDefaultDelayTestUrl;
  int delayTestTimeout = 5000;
  bool hideDockIcon = false; //macos
  bool showTrayTraffic = false; //macos
  bool excludeFromRecent = false; //android
  bool wakeLock = false; //android
  bool autoConnectAtBoot = false; //android
  bool hideVpn = false; //ios
  List<Map<String, dynamic>>? websiteTestTargets;

  Map<String, dynamic> toJson() => {
    'language_tag': languageTag,
    'ui': ui,
    'webdav': webdav,
    'alway_on': alwayOn,
    'log_level': logLevel,
    'auto_update_channel': autoUpdateChannel,
    'auto_download_udpate_pkg': autoDownloadUpdatePkg,
    'auto_connect_after_launch': autoConnectAfterLaunch,
    'auto_set_system_proxy': autoSetSystemProxy,
    'system_proxy_bypass_domain': systemProxyBypassDomain,
    'user_agent': _userAgent,
    'board_online': boardOnline,
    'board_url': boardUrl,
    'board_port': boardLocalPort,
    'delay_test_url': delayTestUrl,
    'delay_test_url_timeout': delayTestTimeout,
    'hide_dock_icon': hideDockIcon,
    'show_tray_traffic': showTrayTraffic,
    'exclude_from_recent': excludeFromRecent,
    'wake_lock': wakeLock,
    'auto_connect_at_boot': autoConnectAtBoot,
    'hide_vpn': hideVpn,
    'website_test_targets': websiteTestTargets,
    'window': window,
  };
  void fromJson(Map<String, dynamic>? map) {
    if (map == null) {
      return;
    }

    languageTag = map["language_tag"] ?? "";
    ui = SettingConfigItemUI.fromJsonStatic(map["ui"]);
    webdav = SettingConfigItemWebDev.fromJsonStatic(map["webdav"]);
    alwayOn = map["alway_on"] ?? false;
    logLevel =
        map["log_level"] ??
        (bool.fromEnvironment("dart.vm.product") ? "warning" : "info");
    autoUpdateChannel = map["auto_update_channel"] ?? "stable";
    if (autoUpdateChannel.isEmpty) {
      autoUpdateChannel = Random().nextInt(10) < 5 ? "beta" : "stable";
    }
    autoDownloadUpdatePkg = map["auto_download_udpate_pkg"] ?? true;
    autoConnectAfterLaunch = map["auto_connect_after_launch"] ?? true;
    autoSetSystemProxy =
        map["auto_set_system_proxy"] ?? getAutoSetSystemProxyDefault();
    systemProxyBypassDomain = ConvertUtils.getListStringFromDynamic(
      map["system_proxy_bypass_domain"],
      true,
      ProxyBypassDoaminsDefault.toList(),
    )!;

    _userAgent = map["user_agent"] ?? "";

    boardOnline = map["board_online"] ?? false;
    boardUrl = map["board_url"] ?? kDefaultBoardUrl;
    boardLocalPort = map["board_port"] ?? kDefaultBoardPort;
    delayTestUrl = map["delay_test_url"] ?? kDefaultDelayTestUrl;
    delayTestTimeout = map["delay_test_url_timeout"] ?? 5000;
    hideDockIcon = map["hide_dock_icon"] ?? false;
    showTrayTraffic = map["show_tray_traffic"] ?? false;
    excludeFromRecent = map["exclude_from_recent"] ?? false;
    wakeLock = map["wake_lock"] ?? false;
    autoConnectAtBoot = map["auto_connect_at_boot"] ?? false;
    hideVpn = map["hide_vpn"] ?? false;
    if (map["website_test_targets"] is List) {
      websiteTestTargets = (map["website_test_targets"] as List)
          .whereType<Map<String, dynamic>>()
          .toList();
    }
    window = SettingConfigItemWindowState.fromJsonStatic(map["window"]);
  }

  String userAgent() {
    if (_userAgent.isEmpty) {
      final coreVersion = AppUtils.getCoreVersion();
      return "ClashMeta/$coreVersion; mihomo/$coreVersion";
    }
    return _userAgent;
  }

  void setUserAgent(String ua) {
    _userAgent = ua;
  }

  static SettingConfig fromJsonStatic(Map<String, dynamic>? map) {
    SettingConfig config = SettingConfig();
    config.fromJson(map);
    return config;
  }

  static bool getAutoSetSystemProxyDefault() {
    if (Platform.isWindows) {
      return true;
    }
    return false;
  }
}

class SettingManager {
  static final List<void Function()> onSideBySideLayoutChanged = [];
  static void notifySideBySideLayoutChanged() {
    for (final cb in onSideBySideLayoutChanged) {
      try {
        cb();
      } catch (_) {}
    }
  }

  static final List<void Function()> onHomeCardsChanged = [];
  static void notifyHomeCardsChanged() {
    for (final cb in onHomeCardsChanged) {
      try {
        cb();
      } catch (_) {}
    }
  }

  static final List<void Function()> onAnimationsChanged = [];
  static void notifyAnimationsChanged() {
    ThemeDefine.enableAnimations = _config.ui.enableAnimations;
    for (final cb in onAnimationsChanged) {
      try {
        cb();
      } catch (_) {}
    }
  }

  static bool _saving = false;
  static bool _hasPendingSave = false;
  static String _cachedSettingFilePath = "";
  static SettingConfig _config = SettingConfig();
  static Future<void> init({bool fromBackupRestore = false}) async {
    await load(fromBackupRestore: fromBackupRestore);
    bool needSave = await parseConfig();
    if (needSave) {
      await save();
    }
  }

  static Future<void> uninit() async {}
  static Future<void> reload() async {
    await load(fromBackupRestore: true);
  }

  static Future<bool> parseConfig() async {
    bool save = false;

    if (_config.languageTag.isEmpty) {
      if (Platform.isWindows) {
        try {
          final regKey = Registry.openPath(RegistryHive.currentUser, path: r'Software\Wmimo');
          final regLang = regKey.getValueAsString('LanguageTag');
          regKey.close();
          if (regLang != null && regLang.isNotEmpty) {
            _config.languageTag = regLang;
          }
        } catch (_) {}

        if (_config.languageTag.isEmpty) {
          try {
            final exeDir = File(Platform.resolvedExecutable).parent.path;
            final langFile = File(path.join(exeDir, 'installer_language.txt'));
            if (langFile.existsSync()) {
              final tag = langFile.readAsStringSync().trim();
              if (tag.isNotEmpty) {
                _config.languageTag = tag;
              }
            }
          } catch (_) {}
        }
      }
    }

    AppLocale matchedLocale = AppLocale.en;
    if (_config.languageTag.isNotEmpty) {
      for (var locale in AppLocale.values) {
        if (locale.languageTag == _config.languageTag) {
          matchedLocale = locale;
          break;
        }
      }
    } else {
      matchedLocale = AppLocaleUtils.findDeviceLocale();
    }

    _config.languageTag = matchedLocale.languageTag;
    save = true;
    var current = LocaleSettings.currentLocale;
    if (current != matchedLocale) {
      await LocaleSettings.setLocale(matchedLocale);
    }

    return save;
  }

  /// Reads and decodes JSON configuration from [filePath], automatically
  /// falling back to `$filePath.bak` or `$filePath.tmp` if the primary file
  /// was truncated or corrupted during an abrupt OS reboot/shutdown.
  static Future<Map<String, dynamic>?> readConfigMapWithFallback(
    String filePath,
  ) async {
    final candidates = <String>[
      filePath,
      '$filePath.bak',
      '$filePath.tmp',
    ];
    for (final candidate in candidates) {
      try {
        final file = File(candidate);
        if (!await file.exists()) {
          continue;
        }
        final content = (await file.readAsString()).trim();
        if (content.isEmpty) {
          continue;
        }
        final decoded = jsonDecode(content);
        if (decoded is Map<String, dynamic>) {
          if (candidate != filePath) {
            Log.w(
              "SettingManager.load recovered config from fallback $candidate",
            );
          }
          return decoded;
        }
      } catch (err) {
        Log.w("SettingManager.load exception $candidate ${err.toString()}");
      }
    }
    return null;
  }

  /// Writes [content] atomically to [filePath] via a temporary file and
  /// maintains a `.bak` copy so abrupt power-off/reboot never leaves an
  /// empty or half-written `setting.json`.
  static Future<void> writeConfigFileAtomic(
    String filePath,
    String content,
  ) async {
    final tmpPath = '$filePath.tmp';
    final bakPath = '$filePath.bak';
    final tmpFile = File(tmpPath);
    await tmpFile.writeAsString(content, flush: true);
    try {
      await File(bakPath).writeAsString(content, flush: true);
    } catch (_) {}
    try {
      await tmpFile.rename(filePath);
    } catch (_) {
      await File(filePath).writeAsString(content, flush: true);
      try {
        if (await tmpFile.exists()) {
          await tmpFile.delete();
        }
      } catch (_) {}
    }
  }

  /// Synchronous counterpart to [writeConfigFileAtomic] for OS shutdown hooks.
  static void writeConfigFileAtomicSync(String filePath, String content) {
    final tmpPath = '$filePath.tmp';
    final bakPath = '$filePath.bak';
    final tmpFile = File(tmpPath);
    tmpFile.writeAsStringSync(content, flush: true);
    try {
      File(bakPath).writeAsStringSync(content, flush: true);
    } catch (_) {}
    try {
      tmpFile.renameSync(filePath);
    } catch (_) {
      File(filePath).writeAsStringSync(content, flush: true);
      try {
        if (tmpFile.existsSync()) {
          tmpFile.deleteSync();
        }
      } catch (_) {}
    }
  }

  static Future<void> load({bool fromBackupRestore = false}) async {
    String filePath = await PathUtils.settingFilePath();
    _cachedSettingFilePath = filePath;
    final config = await readConfigMapWithFallback(filePath);
    if (config != null) {
      _config.fromJson(config);
    }
    if (Platform.isWindows) {
      if (fromBackupRestore) {
        AppRegistryUtils.saveTheme(_config.ui.theme);
      } else {
        final regTheme = AppRegistryUtils.getTheme();
        if (regTheme != null && regTheme.isNotEmpty) {
          _config.ui.theme = regTheme;
        } else {
          AppRegistryUtils.saveTheme(_config.ui.theme);
        }
      }
    }
  }

  static Future<void> save() async {
    AppRegistryUtils.saveTheme(_config.ui.theme);
    if (_saving) {
      _hasPendingSave = true;
      return;
    }
    _saving = true;
    try {
      do {
        _hasPendingSave = false;
        String filePath = _cachedSettingFilePath.isNotEmpty
            ? _cachedSettingFilePath
            : await PathUtils.settingFilePath();
        _cachedSettingFilePath = filePath;
        const JsonEncoder encoder = JsonEncoder.withIndent('  ');
        String content = encoder.convert(_config.toJson());
        await writeConfigFileAtomic(filePath, content);
      } while (_hasPendingSave);
    } catch (err) {
      Log.w("SettingManager.save exception: ${err.toString()}");
    } finally {
      _saving = false;
    }
  }

  /// Synchronously persists settings and registry theme during OS shutdown/reboot.
  static void saveSync() {
    AppRegistryUtils.saveTheme(_config.ui.theme);
    if (_cachedSettingFilePath.isEmpty) {
      return;
    }
    try {
      const JsonEncoder encoder = JsonEncoder.withIndent('  ');
      String content = encoder.convert(_config.toJson());
      writeConfigFileAtomicSync(_cachedSettingFilePath, content);
    } catch (err) {
      Log.w("SettingManager.saveSync exception: ${err.toString()}");
    }
  }

  static void reset() {
    final languageTag = _config.languageTag;
    final window = _config.window;
    _config = SettingConfig();
    _config.languageTag = languageTag;
    _config.window = window;
    ThemeDefine.enableAnimations = _config.ui.enableAnimations;
    AppRegistryUtils.saveTheme(_config.ui.theme);
  }

  static SettingConfig getConfig() {
    return _config;
  }
}
