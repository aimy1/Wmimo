// ignore_for_file: empty_catches, unused_catch_stack

import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';

import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/auto_update_manager.dart';
import 'package:wmimo/app/modules/biz.dart';
import 'package:wmimo/app/modules/board_provider_manager.dart';
import 'package:wmimo/app/modules/board_session_persistent_manager.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/remote_config_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_args.dart';
import 'package:wmimo/app/utils/app_lifecycle_state_notify.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/device_utils.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/move_to_background_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';
import 'package:wmimo/app/utils/system_scheme_utils.dart';
import 'package:wmimo/app/utils/windows_version_helper.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/home_screen.dart';
import 'package:wmimo/screens/launch_failed_screen.dart';
import 'package:wmimo/screens/theme_data_dark.dart';
import 'package:wmimo/screens/themes.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';
import 'package:wmimo/screens/widgets/routes.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:tray_manager/tray_manager.dart';
import 'package:libclash_vpn_service/vpn_service.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_single_instance/flutter_single_instance.dart';

List<String> processArgs = [];
StartFailedReason? startFailedReason;
String? startFailedReasonDesc;
bool linuxRotate180Fix = false;

void main(List<String> args) async {
  processArgs = args;
  linuxRotate180Fix =
      Platform.isLinux && Platform.environment["WMIMO_ROTATE_180"] == "1";
  WidgetsFlutterBinding.ensureInitialized();
  await LocaleSettings.useDeviceLocale();
  await VPNService.initABI();
  await RemoteConfigManager.init();
  await SettingManager.init();
  Log.setLevel(SettingManager.getConfig().logLevel);
  await BoardSessionPersistentManager.init();
  await BoardProviderManager.init();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await _ensureSingleInstanceOrExit();
  }

  await run(args);
}

Future<void> run(List<String> args) async {
  try {
    do {
      String profileDir = await PathUtils.profileDir();
      if (profileDir.isEmpty) {
        startFailedReason = StartFailedReason.invalidProfile;
        break;
      }
      await Log.init();
      String buildVersion = AppUtils.getBuildinVersion();
      String exePath = Platform.resolvedExecutable;
      Log.w(
        'launch $buildVersion $exePath, $args, ${Directory.current.absolute.path}, $profileDir',
      );
      String cache = await PathUtils.cacheDir();
      if (cache.isEmpty) {
        startFailedReason = StartFailedReason.invalidProfile;
        break;
      }
      String version = await AppUtils.getPackgetVersion();
      if (buildVersion != version) {
        startFailedReason = StartFailedReason.invalidVersion;
        break;
      }
      if (PlatformUtils.isPC()) {
        String baseExe = path.basename(exePath).toLowerCase();
        if (baseExe != PathUtils.getExeName().toLowerCase() &&
            baseExe != "wmimo.exe" &&
            baseExe != "wmimo") {
          startFailedReason = StartFailedReason.invalidProcess;
          break;
        }
      }
      const inProduction = bool.fromEnvironment("dart.vm.product");
      if (inProduction) {
        if (Platform.isMacOS) {
          if (!path.isWithin("/Applications", exePath)) {
            startFailedReason = StartFailedReason.invalidInstallPath;
            break;
          }
        }
      }
      if (Platform.isWindows) {
        var tmp = await getTemporaryDirectory();
        if (exePath.contains("UNC/") ||
            exePath.contains("UNC\\") ||
            path.isWithin(tmp.absolute.path, exePath)) {
          startFailedReason = StartFailedReason.invalidInstallPath;
          break;
        }

        if (VersionHelper.instance.majorVersion != 0 &&
            VersionHelper.instance.majorVersion < 10) {
          startFailedReason = StartFailedReason.systemVersionLow;
          startFailedReasonDesc =
              "Current: ${VersionHelper.instance.majorVersion}\nMinimum required: >= 10.0";
          break;
        }
      }
    } while (false);

    if (PlatformUtils.isPC()) {
      await windowManager.ensureInitialized();
      WindowOptions windowOptions = const WindowOptions(
        size: Size(1020, 680),
        minimumSize: Size(360, 500),
        center: true,
        backgroundColor: Colors.transparent,
        skipTaskbar: false,
        titleBarStyle: TitleBarStyle.normal,
      );
      windowManager.waitUntilReadyToShow(windowOptions, () async {
        await windowManager.setMinimumSize(const Size(360, 500));
        await windowManager.show();
        await windowManager.focus();
      });
      await windowManager.setMinimumSize(const Size(360, 500));
      await windowManager.show();
      await windowManager.focus();
    }

    await AutoUpdateManager.init();

    bool disableOrientation = await DeviceUtils.disableOrientation();
    if (!disableOrientation) {
      if (SettingManager.getConfig().ui.autoOrientation) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    }
  } catch (err, stacktrace) {
    startFailedReason = StartFailedReason.exception;
    startFailedReasonDesc = err.toString();
    String cmdline = args.toString();
    Log.w("main.run exception: ${err.toString()}, $cmdline");
  }
  try {
    await FastCachedImageConfig.init(subDir: AppUtils.getName());
  } catch (err, stacktrace) {
    Log.w("FastCachedImageConfig.init() exception: ${err.toString()}");
  }
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
  runApp(TranslationProvider(child: const MyApp()));
}

Future<void> _ensureSingleInstanceOrExit() async {
  const inProduction = bool.fromEnvironment("dart.vm.product");
  if (!inProduction) {
    return;
  }
  FlutterSingleInstance.debugMode = false;
  // Use a stable lock file key. On Linux, process names can vary by launch
  // path (e.g. xdg-open/AppImage), which breaks single-instance detection.
  FlutterSingleInstance.processName = AppUtils.getId();
  FlutterSingleInstance.onFocus = (metadata) {
    var args = metadata["args"] as List<dynamic>?;
    if (args != null && args.isNotEmpty) {
      String schemeArg = args.firstWhere((element) {
        final arg = element.toString().trim();
        return arg.startsWith(SystemSchemeUtils.getWmimoSchemeWith()) ||
            arg.startsWith(SystemSchemeUtils.getClashSchemeWith());
      }, orElse: () => '');
      if (schemeArg.isNotEmpty) {
        Biz.onEventSingletonInstance?.call(schemeArg);
      }
    }
  };

  final singleInstance = FlutterSingleInstance();
  final isFirst = await singleInstance.isFirstInstance(
    maxRetries: Platform.isLinux ? 5 : 1,
    retryInterval: const Duration(milliseconds: 250),
  );

  if (!isFirst) {
    try {
      await singleInstance.focus({"args": processArgs});
    } catch (err) {
      Log.w("single instance focus exception: ${err.toString()}");
    }

    // Never continue launching a second process.
    exit(0);
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp>
    with WidgetsBindingObserver, WindowListener, TrayListener {
  static const kMenuStatus = "status_info";
  static const kMenuConnect = "connect";
  static const kMenuDisconnect = "disconnect";
  static const kMenuRestartCore = "restart_core";
  static const kMenuSystemProxy = "toggle_system_proxy";
  static const kMenuTunMode = "toggle_tun_mode";
  static const kMenuModeRule = "mode_rule";
  static const kMenuModeGlobal = "mode_global";
  static const kMenuModeDirect = "mode_direct";
  static const kMenuUpdateAllProfiles = "update_all_profiles";
  static const kMenuCopyProxyCmd = "copy_proxy_cmd";
  static const kMenuDelayTest = "delay_test_all";
  static const kMenuOpenConfigDir = "open_config_dir";
  static const kMenuOpenLogs = "open_logs";
  static const kMenuOpen = "show_window";
  static const kMenuExit = "exit_app";
  bool _launchAtStartup = false;
  bool _windowVisibleForMac = false;
  bool _trayGrey = true;
  Menu? _menu;
  String _trafficOld = "";
  String _speedOld = "";
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (PlatformUtils.isPC()) {
      windowManager.addListener(this);
      windowManager.setPreventClose(true);
      trayManager.addListener(this);
      _setTray(true, false, true);
    }
    if (Platform.isMacOS) {
      Biz.onEventTrafficChanged.add((String traffic, String speed) {
        if (!SettingManager.getConfig().showTrayTraffic) {
          traffic = "";
          speed = "";
        }
        if (_trafficOld != traffic || _speedOld != speed) {
          _trafficOld = traffic;
          _speedOld = speed;
          if (traffic.isEmpty && speed.isEmpty) {
            trayManager.setTitle("");
          }
          if (traffic.isNotEmpty && speed.isNotEmpty) {
            trayManager.setTitle("$traffic $speed");
          } else if (traffic.isNotEmpty) {
            trayManager.setTitle(traffic);
          } else if (speed.isNotEmpty) {
            trayManager.setTitle(speed);
          }
        }
      });
    }

    AppLifecycleStateNofity.init();
    LocaleSettings.getLocaleStream().listen((event) {});
    String launchStartupArg = processArgs.firstWhere(
      (element) => element == AppArgs.launchStartup,
      orElse: () => '',
    );
    _launchAtStartup = launchStartupArg.isNotEmpty;

    AppLifecycleStateNofity.stateLaunch(_launchAtStartup);
    _init();
  }

  @override
  void dispose() {
    AppLifecycleStateNofity.uninit();
    WidgetsBinding.instance.removeObserver(this);
    if (PlatformUtils.isPC()) {
      windowManager.removeListener(this);
      trayManager.removeListener(this);
      trayManager.destroy();
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        AppLifecycleStateNofity.stateResumed("resumed");
        break;
      case AppLifecycleState.inactive:
        AppLifecycleStateNofity.stateInactive("inactive");
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        AppLifecycleStateNofity.statePaused("paused");
        break;
      case AppLifecycleState.hidden:
        AppLifecycleStateNofity.stateInactive("hidden");
        break;
    }
  }

  @override
  Future<AppExitResponse> didRequestAppExit() async {
    await _quit();
    return AppExitResponse.cancel;
  }

  @override
  void didHaveMemoryPressure() {
    Log.w("memoryPressure");
  }

  @override
  Widget build(BuildContext context) {
    String schemeArg = processArgs.firstWhere((element) {
      final arg = element.trim();
      return arg.startsWith(SystemSchemeUtils.getWmimoSchemeWith()) ||
          arg.startsWith(SystemSchemeUtils.getClashSchemeWith());
    }, orElse: () => '');

    List<NavigatorObserver> observers = [];

    observers.add(AppRouteObserver.instance);

    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: Themes())],
      child: Consumer<Themes>(
        builder: (context, appTheme, _) {
          Provider.of<Themes>(
            context,
          ).setTheme(SettingManager.getConfig().ui.theme, false);
          Widget app = Shortcuts(
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.select): ActivateIntent(),
            },
            child: MaterialApp(
              //showSemanticsDebugger: false,
              debugShowCheckedModeBanner: false,
              locale: TranslationProvider.of(context).flutterLocale,
              supportedLocales: AppLocaleUtils.supportedLocales,
              localizationsDelegates: GlobalMaterialLocalizations.delegates,
              navigatorObservers: observers,
              home: PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (Platform.isAndroid || Platform.isIOS) {
                    MoveToBackgroundUtils.moveToBackground();
                  }
                },
                child: startFailedReason != null
                    ? LaunchFailedScreen(
                        startFailedReason: startFailedReason!,
                        startFailedReasonDesc: startFailedReasonDesc,
                      )
                    : HomeScreen(launchUrl: schemeArg.trim()),
              ),
              builder: SettingManager.getConfig().ui.disableFontScaler
                  ? (context, widget) {
                      return MediaQuery(
                        data: MediaQuery.of(
                          context,
                        ).copyWith(textScaler: TextScaler.noScaling),
                        child: widget!,
                      );
                    }
                  : null,
              themeMode: appTheme.themeMode(),
              theme: appTheme.themeData(context),
              darkTheme: ThemeDataDark.theme(context),
            ),
          );

          if (linuxRotate180Fix) {
            // Workaround for some Linux devices where Flutter content is upside down.
            app = RotatedBox(quarterTurns: 2, child: app);
          }

          return app;
        },
      ),
    );
  }

  @override
  void onWindowClose() async {
    Log.d("onWindowClose");
    await windowManager.hide();
    _windowVisibleForMac = false;
    AppLifecycleStateNofity.statePaused("close");
  }

  @override
  void onWindowMinimize() {
    _windowVisibleForMac = false;
    Log.d("onWindowMinimize");
    AppLifecycleStateNofity.statePaused("minimize");
  }

  @override
  void onWindowRestore() {
    _windowVisibleForMac = true;
    Log.d("onWindowRestore");
    AppLifecycleStateNofity.stateResumed("restore");
  }

  @override
  void onWindowFocus() {
    if (Platform.isMacOS) {
      if (!_windowVisibleForMac) {
        Log.d("onWindowFocus");
        _windowVisibleForMac = true;
        AppLifecycleStateNofity.stateResumed("restore");
      }
    }
  }

  @override
  void onWindowDeviceShutdown() {
    Log.d("main.dart onWindowDeviceShutdown");
    _quit();
  }

  @override
  void onWindowUserSessionDisconnect() {
    Log.d("main.dart onWindowUserSessionDisconnect");
  }

  void firstShowWindow(bool forceShow) {
    if (!PlatformUtils.isPC()) {
      return;
    }
    Future.microtask(() async {
      try {
        final settings = SettingManager.getConfig();
        if (Platform.isMacOS && settings.hideDockIcon) {
          FlutterVpnService.hideDockIcon(true);
        }
        await windowManager.show();
        await windowManager.focus();
        onWindowRestore();
      } catch (e) {
        Log.w("firstShowWindow exception: $e");
      }
    });
  }

  Future<void> _init() async {
    Biz.onEventExit = (() {
      _quit();
    });

    Biz.onEventVPNStateChanged = ((bool connected) {
      if (PlatformUtils.isPC()) {
        if (_trayGrey == !connected) {
          return;
        }
        _setTray(!connected, false, false);
        if (Platform.isMacOS && !connected) {
          _trafficOld = "";
          _speedOld = "";
          trayManager.setTitle("");
        }
      }
    });
    firstShowWindow(true);
    if (startFailedReason == null) {
      Biz.onEventInitHomeFinish.add(() {
        firstShowWindow(false);
      });

      await Biz.init(_launchAtStartup);
    } else {
      firstShowWindow(true);
    }
  }

  Future<void> _uninit() async {
    if (PlatformUtils.isPC()) {
      await windowManager.hide();
    }
    if (startFailedReason == null) {
      await Biz.uninit();
    }
    if (PlatformUtils.isPC()) {
      await trayManager.destroy();
    }
  }

  Future<void> _quit() async {
    print(">>> _QUIT CALLED STACKTRACE:\n${StackTrace.current}");
    await _uninit();
    Future.delayed(const Duration(seconds: 0), () async {
      await Log.uninit();
      await ServicesBinding.instance.exitApplication(AppExitType.required);
    });
  }

  void _setTray(bool grey, bool destroy, bool quitIfFailed) {
    Future.delayed(const Duration(milliseconds: 300), () async {
      if (destroy || Platform.isLinux) {
        try {
          await trayManager.destroy();
        } catch (_) {}
      }

      try {
        if (Platform.isWindows) {
          String iconFile = grey ? 'grey_tray.ico' : 'tray.ico';
          String iconPath = path.join(
            PathUtils.appAssetsDir(),
            "flutter_assets",
            "assets",
            "images",
            iconFile,
          );
          if (!await File(iconPath).exists()) {
            iconPath = path.join("assets", "images", iconFile);
          }
          await trayManager.setIcon(iconPath, isTemplate: false);
        } else {
          await trayManager.setIcon(
            grey ? 'assets/images/grey_tray.png' : 'assets/images/tray.png',
            isTemplate: false,
          );
        }
        _trayGrey = grey;
      } catch (err, stacktrace) {
        Log.w("setIcon exception: ${err.toString()}");
        print(">>> TRAY SET ICON EXCEPTION (IGNORED): $err");
      }
      try {
        if (!Platform.isLinux) {
          await trayManager.setToolTip(AppUtils.getName());
        } else {
          await _setTrayMenu(grey);
        }
      } catch (e) {
        print(">>> TRAY SET TOOLTIP EXCEPTION (IGNORED): $e");
      }
    });
  }

  Future<void> _setTrayMenu(bool grey) async {
    if (!PlatformUtils.isPC()) {
      return;
    }
    final mode = ClashSettingManager.getConfigsMode();
    final isSysProxy = await VPNService.getSystemProxyEnable();
    final tunEnable = ClashSettingManager.getConfig().Tun?.Enable ?? false;
    final profiles = ProfileManager.getProfiles();
    final currentProfile = ProfileManager.getCurrent();

    // 1. Status and Core Control
    List<MenuItem> items = [
      MenuItem(
        key: kMenuStatus,
        label: grey ? "  ⚪ 核心未连接  " : "  🟢 核心已连接  ",
        disabled: true,
      ),
      if (grey) ...[
        MenuItem(key: kMenuConnect, label: "  ▶ 启动代理连接  "),
      ],
      if (!grey) ...[
        MenuItem(key: kMenuDisconnect, label: "  ⏹ 断开代理连接  "),
        MenuItem(key: kMenuRestartCore, label: "  🔄 重启代理核心  "),
      ],
      MenuItem.separator(),

      // 2. System Proxy & TUN Switch
      MenuItem.checkbox(
        key: kMenuSystemProxy,
        checked: isSysProxy,
        label: "  🌐 系统代理  ",
      ),
      MenuItem.checkbox(
        key: kMenuTunMode,
        checked: tunEnable,
        label: "  🛡 TUN 模式  ",
      ),
      MenuItem.separator(),

      // 3. Outbound Mode Submenu
      MenuItem.submenu(
        label: "  🔀 出站模式 (${mode == ClashConfigsMode.rule ? '规则' : mode == ClashConfigsMode.global ? '全局' : '直连'})  ",
        submenu: Menu(
          items: [
            MenuItem.checkbox(
              key: kMenuModeRule,
              checked: mode == ClashConfigsMode.rule,
              label: "  规则分流 (Rule)  ",
            ),
            MenuItem.checkbox(
              key: kMenuModeGlobal,
              checked: mode == ClashConfigsMode.global,
              label: "  全局代理 (Global)  ",
            ),
            MenuItem.checkbox(
              key: kMenuModeDirect,
              checked: mode == ClashConfigsMode.direct,
              label: "  直接连接 (Direct)  ",
            ),
          ],
        ),
      ),
    ];

    // 4. Profiles Submenu
    List<MenuItem> profileItems = [];
    if (profiles.isNotEmpty) {
      for (var p in profiles) {
        final displayName = p.remark.isNotEmpty ? p.remark : (p.url.isNotEmpty ? p.url : p.id);
        profileItems.add(
          MenuItem.checkbox(
            key: "profile_${p.id}",
            checked: currentProfile?.id == p.id,
            label: "  $displayName  ",
          ),
        );
      }
      profileItems.add(MenuItem.separator());
    }
    profileItems.add(
      MenuItem(key: kMenuUpdateAllProfiles, label: "  🔄 更新所有订阅配置  "),
    );
    final curProfileName = currentProfile != null
        ? (currentProfile.remark.isNotEmpty ? currentProfile.remark : currentProfile.id)
        : '未选择';
    items.add(
      MenuItem.submenu(
        label: "  📑 订阅配置 ($curProfileName)  ",
        submenu: Menu(items: profileItems),
      ),
    );

    // 5. Proxy Nodes Submenu
    try {
      final nodes = await ProxyNodeLoader.loadCurrentProfileNodes();
      if (nodes.isNotEmpty) {
        List<MenuItem> nodeMenuItems = [];
        final selectableNodes =
            nodes.where((n) => !ClashProtocolType.isGroupType(n.type)).toList();
        if (selectableNodes.isNotEmpty) {
          for (var i = 0; i < math.min(15, selectableNodes.length); i++) {
            final node = selectableNodes[i];
            nodeMenuItems.add(
              MenuItem(
                key: "node_GLOBAL:::_:::${node.name}",
                label: "  ${node.name}  ",
              ),
            );
          }
          items.add(
            MenuItem.submenu(
              label: "  ⚡ 代理节点 (${selectableNodes.length}个)  ",
              submenu: Menu(items: nodeMenuItems),
            ),
          );
        }
      }
    } catch (_) {}

    // 6. Tools Submenu
    items.add(
      MenuItem.submenu(
        label: "  🛠 实用工具  ",
        submenu: Menu(
          items: [
            MenuItem(key: kMenuCopyProxyCmd, label: "  📋 复制系统代理命令  "),
            MenuItem(key: kMenuDelayTest, label: "  ⚡ 一键全节点测速  "),
            MenuItem.separator(),
            MenuItem(key: kMenuOpenConfigDir, label: "  📁 打开应用配置目录  "),
            MenuItem(key: kMenuOpenLogs, label: "  📄 查看核心运行日志  "),
          ],
        ),
      ),
    );
    items.add(MenuItem.separator());

    // 7. Window & Exit
    items.add(MenuItem(key: kMenuOpen, label: "  🖥 显示主界面  "));
    items.add(MenuItem(key: kMenuExit, label: "  ❌ 退出程序  "));

    _menu = Menu(items: items);
    await trayManager.setContextMenu(_menu!);
    if (!Platform.isLinux) {
      await trayManager.popUpContextMenu(bringAppToFront: true);
    }
  }

  @override
  void onTrayIconMouseDown() async {
    if (await windowManager.isMinimized()) {
      await windowManager.restore();
    } else {
      await windowManager.show();
      onWindowRestore();
    }
  }

  @override
  void onTrayIconRightMouseDown() async {
    await _setTrayMenu(_trayGrey);
  }

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    final key = menuItem.key ?? "";
    if (key == kMenuConnect) {
      VpnActionHandler.vpnConnect?.call("menu", false);
    } else if (key == kMenuDisconnect) {
      VpnActionHandler.vpnDisconnect?.call("menu", false);
    } else if (key == kMenuRestartCore) {
      VpnActionHandler.vpnReconnect?.call("menu", false);
    } else if (key == kMenuSystemProxy) {
      final isSys = await VPNService.getSystemProxyEnable();
      await VPNService.setSystemProxy(!isSys);
      await _setTrayMenu(_trayGrey);
    } else if (key == kMenuTunMode) {
      final config = ClashSettingManager.getConfig();
      final currentTun = config.Tun?.Enable ?? false;
      config.Tun?.Enable = !currentTun;
      await ClashSettingManager.save();
      if (!_trayGrey) {
        VpnActionHandler.vpnReconnect?.call("tun", false);
      }
      await _setTrayMenu(_trayGrey);
    } else if (key == kMenuModeRule) {
      await ClashSettingManager.setConfigsMode(ClashConfigsMode.rule);
      await _setTrayMenu(_trayGrey);
    } else if (key == kMenuModeGlobal) {
      await ClashSettingManager.setConfigsMode(ClashConfigsMode.global);
      await _setTrayMenu(_trayGrey);
    } else if (key == kMenuModeDirect) {
      await ClashSettingManager.setConfigsMode(ClashConfigsMode.direct);
      await _setTrayMenu(_trayGrey);
    } else if (key.startsWith("profile_")) {
      final profileId = key.substring("profile_".length);
      ProfileManager.setCurrent(profileId);
      if (!_trayGrey) {
        VpnActionHandler.vpnReconnect?.call("profile_change", false);
      }
      await _setTrayMenu(_trayGrey);
    } else if (key.startsWith("node_")) {
      final parts = key.substring("node_".length).split(":::_:::");
      if (parts.length == 2) {
        await ClashHttpApi.setProxiesNode(parts[0], parts[1]);
      }
    } else if (key == kMenuUpdateAllProfiles) {
      await ProfileManager.updateAll();
    } else if (key == kMenuCopyProxyCmd) {
      final port = ClashSettingManager.getMixedPort();
      final cmd = Platform.isWindows
          ? 'set http_proxy=http://127.0.0.1:$port\nset https_proxy=http://127.0.0.1:$port\nset all_proxy=socks5://127.0.0.1:$port'
          : 'export http_proxy=http://127.0.0.1:$port\nexport https_proxy=http://127.0.0.1:$port\nexport all_proxy=socks5://127.0.0.1:$port';
      await Clipboard.setData(ClipboardData(text: cmd));
    } else if (key == kMenuDelayTest) {
      final nodes = await ProxyNodeLoader.loadCurrentProfileNodes();
      for (var n in nodes) {
        if (!ClashProtocolType.isGroupType(n.type)) {
          ClashHttpApi.getDelay(
            n.name,
            url: "http://www.gstatic.com/generate_204",
            timeout: const Duration(seconds: 5),
          );
        }
      }
    } else if (key == kMenuOpenConfigDir) {
      final dir = await PathUtils.profileDir();
      if (Platform.isWindows) {
        Process.run('explorer.exe', [dir]);
      } else if (Platform.isMacOS) {
        Process.run('open', [dir]);
      } else if (Platform.isLinux) {
        Process.run('xdg-open', [dir]);
      }
    } else if (key == kMenuOpenLogs) {
      final logPath = await PathUtils.serviceLogFilePath();
      final logFile = File(logPath);
      if (await logFile.exists()) {
        if (Platform.isWindows) {
          Process.run('notepad.exe', [logPath]);
        } else if (Platform.isMacOS) {
          Process.run('open', [logPath]);
        } else if (Platform.isLinux) {
          Process.run('xdg-open', [logPath]);
        }
      }
    } else if (key == kMenuOpen) {
      if (await windowManager.isMinimized()) {
        await windowManager.restore();
      } else {
        await windowManager.show();
        onWindowRestore();
      }
    } else if (key == kMenuExit) {
      await _quit();
    }
  }
}
