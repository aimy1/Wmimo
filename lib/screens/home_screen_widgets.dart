import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/auto_update_manager.dart';
import 'package:wmimo/app/modules/biz.dart';
import 'package:wmimo/app/modules/board_provider_manager.dart';
import 'package:wmimo/app/modules/board_provider_notice_manager.dart';
import 'package:wmimo/app/modules/board_session_persistent_manager.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/modules/zashboard.dart';
import 'package:wmimo/app/runtime/return_result.dart';
import 'package:wmimo/app/utils/app_lifecycle_state_notify.dart';
import 'package:wmimo/app/utils/app_scheme_actions.dart';
import 'package:wmimo/app/utils/file_utils.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/move_to_background_utils.dart';
import 'package:wmimo/app/utils/network_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/about_screen.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/file_view_screen.dart';
import 'package:wmimo/screens/group_helper.dart';
import 'package:wmimo/screens/net_check_screen.dart';
import 'package:wmimo/screens/profiles_board_screen.dart';
import 'package:wmimo/screens/proxy_board_screen.dart';
import 'package:wmimo/screens/richtext_viewer.screen.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/webview_helper.dart';
import 'package:wmimo/screens/widgets/segmented_elevated_button.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:libclash_vpn_service/state.dart';
import 'package:libclash_vpn_service/vpn_service.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:tuple/tuple.dart';

class ProxyHttpOverrides extends HttpOverrides {
  ProxyHttpOverrides(this.proxyPort);

  final int proxyPort;

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.findProxy = (Uri uri) => "PROXY 127.0.0.1:$proxyPort";
    return client;
  }
}

class HomeScreenWidgetPart1 extends StatefulWidget {
  final Function(int tabIndex)? onNavigateToTab;
  const HomeScreenWidgetPart1({super.key, this.onNavigateToTab});

  @override
  State<HomeScreenWidgetPart1> createState() => _HomeScreenWidgetPart1();
}

class _HomeScreenWidgetPart1 extends State<HomeScreenWidgetPart1> {
  static final String _kNoSpeed = "↑ 0 B/s   ↓ 0 B/s";
  static final String _kNoTrafficTotal = "↑ 0 B   ↓ 0 B";
  //static final String _kNoMemory = "0 B   0 B";
  final FocusNode _focusNodeConnect = FocusNode();
  FlutterVpnServiceState _state = FlutterVpnServiceState.disconnected;
  Timer? _timerStateChecker;
  Timer? _timerConnectToCore;
  QuickActions? _quickActions;
  bool _quickActionWorking = false;

  //final ValueNotifier<String> _memory = ValueNotifier<String>(_kNoMemory);
  final ValueNotifier<String> _trafficSpeed = ValueNotifier<String>(_kNoSpeed);
  final ValueNotifier<String> _trafficTotal = ValueNotifier<String>(
    _kNoTrafficTotal,
  );
  final ValueNotifier<String> _proxyNow = ValueNotifier<String>("");
  bool _proxyNowUpdating = false;

  @override
  void initState() {
    super.initState();
    VPNService.onEventStateChanged.add(_onStateChanged);
    AppLifecycleStateNofity.onStateResumed(hashCode, _onStateResumed);
    AppLifecycleStateNofity.onStatePaused(hashCode, _onStatePaused);
    ProfileManager.onEventCurrentChanged.add(_onCurrentChanged);
    ProfileManager.onEventUpdate.add(_onUpdate);
    BoardProviderNoticeManager.onEventCheck.add(_onNoticeUpdate);
    BoardProviderNoticeManager.onEventReaded.add(_onNoticeReaded);
    if (!AppLifecycleStateNofity.isPaused()) {
      _onStateResumed();
    }
    Biz.onEventInitAllFinish.add(() async {
      if (Platform.isAndroid) {
        if (SettingManager.getConfig().excludeFromRecent) {
          FlutterVpnService.setExcludeFromRecents(true);
        }
      }
      await _onInitAllFinish();
    });
    ClashSettingManager.onEventModeChanged.add(() async {
      setState(() {});
    });
  }

  @override
  void dispose() {
    VPNService.onEventStateChanged.remove(_onStateChanged);
    AppLifecycleStateNofity.onStateResumed(hashCode, null);
    AppLifecycleStateNofity.onStatePaused(hashCode, null);
    ProfileManager.onEventCurrentChanged.remove(_onCurrentChanged);
    ProfileManager.onEventUpdate.remove(_onUpdate);
    BoardProviderNoticeManager.onEventCheck.remove(_onNoticeUpdate);
    BoardProviderNoticeManager.onEventReaded.remove(_onNoticeReaded);
    _focusNodeConnect.dispose();
    super.dispose();
  }

  void initQuickAction() async {
    if (!Platform.isIOS && !Platform.isAndroid) {
      return;
    }
    String connect = AppSchemeActions.connectAction();
    String disconnect = AppSchemeActions.disconnectAction();
    try {
      _quickActions ??= QuickActions();
      await _quickActions!.initialize((String shortcutType) async {
        if (_quickActionWorking) {
          return;
        }
        _quickActionWorking = true;
        var state = await VPNService.getState();
        if (shortcutType == connect) {
          if (state != FlutterVpnServiceState.invalid &&
              state != FlutterVpnServiceState.disconnected) {
            MoveToBackgroundUtils.moveToBackground(
              duration: const Duration(milliseconds: 300),
            );
            _quickActionWorking = false;
            return;
          }

          bool ok = await start("quickAction");
          if (ok) {
            MoveToBackgroundUtils.moveToBackground(
              duration: const Duration(milliseconds: 300),
            );
          }
        } else if (shortcutType == disconnect) {
          if (state == FlutterVpnServiceState.connected) {
            await stop();
          }
          MoveToBackgroundUtils.moveToBackground(
            duration: const Duration(milliseconds: 300),
          );
        }
        _quickActionWorking = false;
      });

      await _quickActions!.setShortcutItems(<ShortcutItem>[
        ShortcutItem(type: connect, localizedTitle: 'ON', icon: 'ic_launcher'),
        ShortcutItem(
          type: disconnect,
          localizedTitle: 'OFF',
          icon: 'ic_launcher',
        ),
      ]);
    } catch (err) {
      Log.w("initQuickAction exception ${err.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    bool connected = _state == FlutterVpnServiceState.connected;
    final currentProfile = ProfileManager.getCurrent();
    final currentProfileName = currentProfile?.getShowName() ?? "";
    final provider = BoardProviderManager.getProviderById(
      currentProfile?.boardProviderId ?? "",
    );

    final settings = SettingManager.getConfig();
    String tranffic = "";
    Tuple2<bool, String>? tranfficExpire;
    if (currentProfile != null && currentProfile.isRemote()) {
      if (currentProfile.upload != 0 ||
          currentProfile.download != 0 ||
          currentProfile.total != 0) {
        String upload = ClashHttpApi.convertTrafficToStringDouble(
          currentProfile.upload,
        );
        String download = ClashHttpApi.convertTrafficToStringDouble(
          currentProfile.download,
        );
        String total = ClashHttpApi.convertTrafficToStringDouble(
          currentProfile.total,
        );
        tranffic = "↑ $upload ↓ $download/$total";
      }
      if (currentProfile.expire.isNotEmpty) {
        tranfficExpire = currentProfile.getExpireTime(settings.languageTag);
      }
    }
    bool notice =
        BoardProviderNoticeManager.getFirstUnread(provider?.id ?? "") != null;
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: connected
                                ? ThemeDefine.kColorGreenBright
                                : const Color(0xFF94A3B8),
                            shape: BoxShape.circle,
                            boxShadow: connected
                                ? [
                                    BoxShadow(
                                      color: ThemeDefine.kColorGreenBright
                                          .withValues(alpha: 0.4),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          connected
                              ? tcontext.meta.connected
                              : tcontext.meta.disconnected,
                          style: const TextStyle(
                            fontSize: 16.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Transform.scale(
                          scale: 0.95,
                          child: Switch.adaptive(
                            value: _state == FlutterVpnServiceState.connected,
                            activeThumbColor: Colors.white,
                            activeTrackColor: ThemeDefine.kColorGreenBright,
                            focusNode: _focusNodeConnect,
                            onChanged: (bool value) async {
                              if (value) {
                                await start("switch");
                              } else {
                                await stop();
                              }
                            },
                          ),
                        ),
                        if (_state == FlutterVpnServiceState.connecting ||
                            _state == FlutterVpnServiceState.disconnecting ||
                            _state == FlutterVpnServiceState.reasserting)
                          const Positioned(
                            left: 6,
                            child: SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: ThemeDefine.kColorGreenBright,
                                strokeWidth: 2.5,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  child: SegmentedElevatedButton(
                    segments: [
                      SegemntedElevatedButtonItem(
                        value: ClashConfigsMode.rule.index,
                        text: tcontext.meta.rule,
                      ),
                      SegemntedElevatedButtonItem(
                        value: ClashConfigsMode.global.index,
                        text: tcontext.meta.global,
                      ),
                      SegemntedElevatedButtonItem(
                        value: ClashConfigsMode.direct.index,
                        text: tcontext.meta.direct,
                      ),
                    ],
                    selected: ClashSettingManager.getConfigsMode().index,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    onPressed: (int value) async {
                      ClashConfigsMode type = ClashConfigsMode.values[value];
                      var error = await ClashSettingManager.setConfigsMode(type);
                      if (!context.mounted) {
                        return;
                      }
                      if (error != null) {
                        DialogUtils.showAlertDialog(
                          context,
                          error.message,
                          withVersion: true,
                        );
                        return;
                      }
                      _updateProxyNow();
                    },
                  ),
                ),
                if (connected) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surface
                          .withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Theme.of(context)
                            .dividerColor
                            .withValues(alpha: 0.6),
                        width: 0.8,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.speed_rounded,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ValueListenableBuilder<String>(
                                  builder: _buildWithTrafficSpeedValue,
                                  valueListenable: _trafficSpeed,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 22,
                          color: Theme.of(context).dividerColor,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Icon(
                                Icons.data_usage_rounded,
                                size: 18,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ValueListenableBuilder<String>(
                                  builder: _buildWithTrafficSpeedValue,
                                  valueListenable: _trafficTotal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Column(
              children: [
                ListTile(
                  title: Text(tcontext.meta.myProfiles),
                  leading: Icon(
                    Icons.dns_rounded,
                    size: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  subtitle: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentProfile != null) ...[
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            currentProfileName,
                            style: const TextStyle(
                              color: ThemeDefine.kColorBlue,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      if (tranffic.isNotEmpty) ...[
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            tranffic,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.7),
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                      if (tranfficExpire != null) ...[
                        Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            tranfficExpire.item2,
                            style: TextStyle(
                              color: tranfficExpire.item1
                                  ? Colors.red
                                  : ThemeDefine.kColorBlue,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  trailing: SizedBox(
                    width: 90,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (provider != null &&
                            GroupHelper.canShowVpnProvider(provider)) ...[
                          SizedBox(
                            width: 34,
                            height: 34,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(17),
                              onTap: () async {
                                final session =
                                    BoardSessionPersistentManager.instance()
                                        .getBySubscribeUrl(
                                          currentProfile?.url ?? "",
                                        );
                                await GroupHelper.showVpnProvider(
                                  context,
                                  provider,
                                  session,
                                );
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  provider.appIconUrl.isNotEmpty &&
                                          provider.logoBranding
                                      ? FastCachedImage(
                                          url: provider.appIconUrl,
                                          width: 26,
                                          height: 26,
                                          cacheWidth: 52,
                                          cacheHeight: 52,
                                          loadingBuilder: (
                                            context,
                                            loadingProgress,
                                          ) => const SizedBox.shrink(),
                                          errorBuilder: (
                                            context,
                                            error,
                                            stackTrace,
                                          ) => const Icon(
                                            Icons.business,
                                            size: 26,
                                          ),
                                        )
                                      : const Icon(Icons.business, size: 26),
                                  if (notice) ...[
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(
                          width: 34,
                          height: 34,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(17),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  settings: ProfilesBoardScreen.routSettings(),
                                  builder: (context) => ProfilesBoardScreen(
                                    navigateToAdd: true,
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            child: const Icon(Icons.add_rounded, size: 24),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_right, size: 20),
                      ],
                    ),
                  ),
                  minVerticalPadding: 16,
                  onTap: () async {
                    if (widget.onNavigateToTab != null) {
                      widget.onNavigateToTab!(2);
                      return;
                    }
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: ProfilesBoardScreen.routSettings(),
                        builder: (context) => ProfilesBoardScreen(),
                      ),
                    );
                    setState(() {});
                  },
                ),
                const Divider(height: 1, thickness: 0.8),
                ListTile(
                  title: Text(tcontext.meta.proxy),
                  leading: Icon(
                    Icons.alt_route_rounded,
                    size: 22,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  subtitle: ValueListenableBuilder<String>(
                    builder: _buildWithValue,
                    valueListenable: _proxyNow,
                  ),
                  trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
                  minVerticalPadding: 16,
                  onTap: () async {
                    if (widget.onNavigateToTab != null) {
                      widget.onNavigateToTab!(1);
                      return;
                    }
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        settings: ProxyBoardScreen.routSettings(),
                        builder: (context) => ProxyBoardScreen(),
                      ),
                    );
                    _updateProxyNow();
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                _buildQuickActionTile(
                  context: context,
                  icon: Icons.dashboard_outlined,
                  label: tcontext.meta.board,
                  onTap: _onTapBoard,
                ),
                const SizedBox(width: 8),
                _buildQuickActionTile(
                  context: context,
                  icon: Icons.description_outlined,
                  label: tcontext.meta.runtimeProfile,
                  onTap: _onTapRunTimeProfile,
                ),
                const SizedBox(width: 8),
                _buildQuickActionTile(
                  context: context,
                  icon: Icons.network_check_rounded,
                  label: tcontext.meta.networkCheck,
                  onTap: _onTapNetCheck,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 6),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWithTrafficSpeedValue(
    BuildContext context,
    String value,
    Widget? child,
  ) {
    return Text(
      value,
      textAlign: TextAlign.left,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: ThemeConfig.kFontSizeListSubItem,
        fontWeight: FontWeight.w500,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
      ),
    );
  }

  Widget _buildWithValue(BuildContext context, String value, Widget? child) {
    return Text(
      value,
      textAlign: TextAlign.start,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: ThemeDefine.kColorBlue,
        fontWeight: FontWeight.w500,
        fontFamily: Platform.isWindows ? 'Emoji' : null,
      ),
    );
  }

  Future<String> _getLocalAddress() async {
    String ipLocal = "127.0.0.1";
    String ipInterface = ipLocal;

    List<NetInterfacesInfo> interfaces = await NetworkUtils.getInterfaces(
      addressType: InternetAddressType.IPv4,
    );
    if (interfaces.isNotEmpty) {
      ipInterface = interfaces.first.address;
    }
    for (var interf in interfaces) {
      if (interf.name.startsWith("en") || interf.name.startsWith("wlan")) {
        ipInterface = interf.address;
        break;
      }
    }

    return ipInterface;
  }

  Future<void> _onInitAllFinish() async {
    VpnActionHandler.vpnConnect = _vpnConnect;
    VpnActionHandler.vpnDisconnect = _vpnDisconnect;
    VpnActionHandler.vpnReconnect = _vpnReconnect;
    initQuickAction();
    if (PlatformUtils.isPC()) {
      if (SettingManager.getConfig().autoConnectAfterLaunch) {
        await start("launch");
      }
    }
  }

  Future<void> stop() async {
    await VPNService.stop();
  }

  Future<bool> start(String from) async {
    final currentProfile = ProfileManager.getCurrent();
    if (currentProfile == null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          settings: ProfilesBoardScreen.routSettings(),
          builder: (context) => ProfilesBoardScreen(),
        ),
      );
      setState(() {});
      return false;
    }
    if (Platform.isLinux) {
      String? installer = await AutoUpdateManager.checkReplace();
      if (installer != null) {
        return true;
      }
      final servicePath = PathUtils.serviceExePath();
      if (!await FlutterVpnService.isServiceAuthorized(servicePath)) {
        if (!mounted) {
          return false;
        }
        String? password = await DialogUtils.showPasswordInputDialog(context);
        if (password == null || password.isEmpty) {
          setState(() {});
          return true;
        }
        final result = await FlutterVpnService.authorizeService(
          servicePath,
          password,
        );
        if (result != null) {
          if (!mounted) {
            return false;
          }
          bool? ok = await DialogUtils.showConfirmDialog(
            context,
            "${result.message}\n\n${t.meta.continueConnectConfirm}",
          );
          if (!mounted) {
            return false;
          }
          setState(() {});
          if (ok != true) {
            return false;
          }
        }
      }
    }
    var state = await VPNService.getState();
    if (state == FlutterVpnServiceState.connecting ||
        state == FlutterVpnServiceState.disconnecting ||
        state == FlutterVpnServiceState.reasserting) {
      setState(() {});
      return false;
    }

    var err = await VPNService.start(const Duration(seconds: 60));
    if (!mounted) {
      return false;
    }
    setState(() {});
    if (err != null) {
      if (err.message == "willCompleteAfterRebootInstall") {
        err.message = t.meta.willCompleteAfterRebootInstall;
      } else if (err.message == "requestNeedsUserApproval") {
        err.message = t.meta.requestNeedsUserApproval;
      } else if (err.message.contains("FullDiskAccessPermissionRequired")) {
        err.message = t.meta.FullDiskAccessPermissionRequired;
      } else if (err.message.contains(
        "configure tun interface: Access is denied",
      )) {
        err.message += "\n${t.meta.tunModeRunAsAdmin}";
      }

      DialogUtils.showAlertDialog(context, err.message, withVersion: true);
      return false;
    }
    return true;
  }

  Future<void> _vpnConnect(String from, bool background) async {
    Future.delayed(const Duration(seconds: 0), () async {
      bool ok = await start(from);
      if (ok) {
        if (background) {
          MoveToBackgroundUtils.moveToBackground(
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    });
  }

  Future<void> _vpnDisconnect(String from, bool background) async {
    Future.delayed(const Duration(seconds: 0), () async {
      await stop();
      if (background) {
        MoveToBackgroundUtils.moveToBackground(
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }

  Future<void> _vpnReconnect(String from, bool background) async {
    Future.delayed(const Duration(seconds: 0), () async {
      await stop();
      bool ok = await start(from);
      if (ok) {
        if (background) {
          MoveToBackgroundUtils.moveToBackground(
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    });
  }

  Future<void> _onStateChanged(
    FlutterVpnServiceState state,
    Map<String, String> params,
  ) async {
    if (_state == state) {
      return;
    }
    _state = state;
    if (state == FlutterVpnServiceState.disconnected) {
      _disconnectToCore();
      Biz.vpnStateChanged(false);
    } else if (state == FlutterVpnServiceState.connecting) {
    } else if (state == FlutterVpnServiceState.connected) {
      if (!AppLifecycleStateNofity.isPaused()) {
        _connectToCore();
      }
      Biz.vpnStateChanged(true);
    } else if (state == FlutterVpnServiceState.reasserting) {
      _disconnectToCore();
    } else if (state == FlutterVpnServiceState.disconnecting) {
      _stopStateCheckTimer();
      Zashboard.stop();
    } else {
      _disconnectToCore();
      Biz.vpnStateChanged(false);
    }
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _onStateResumed() async {
    _checkState();
    _startStateCheckTimer();
    _connectToCore();

    _updateProxyNow();
  }

  Future<void> _onStatePaused() async {
    _stopStateCheckTimer();
    if (Platform.isMacOS && SettingManager.getConfig().showTrayTraffic) {
      return;
    }
    _disconnectToCore(resetUI: false);
  }

  Future<void> _onCurrentChanged(String id) async {
    if (id.isEmpty) {
      await VPNService.stop();
      return;
    }

    final err = await VPNService.restart(const Duration(seconds: 60));
    if (err != null) {
      if (!mounted) {
        return;
      }
      DialogUtils.showAlertDialog(context, err.message, withVersion: true);
    }
  }

  Future<void> _onUpdate(String id, bool finish) async {
    setState(() {});
  }

  Future<void> _onNoticeUpdate() async {
    setState(() {});
  }

  Future<void> _onNoticeReaded() async {
    setState(() {});
  }

  Future<void> _checkState() async {
    var state = await VPNService.getState();
    await _onStateChanged(state, {});
  }

  void _startStateCheckTimer() {
    const Duration duration = Duration(seconds: 1);
    _timerStateChecker ??= Timer.periodic(duration, (timer) async {
      if (!Platform.isMacOS) {
        if (AppLifecycleStateNofity.isPaused()) {
          return;
        }
      }
      await _checkState();
    });
  }

  void _stopStateCheckTimer() {
    if (!Platform.isMacOS) {
      _timerStateChecker?.cancel();
      _timerStateChecker = null;
    }
  }

  Future<void> _updateConnections() async {
    String connections = await FlutterVpnService.clashiApiConnections(false);
    String tranffic = await FlutterVpnService.clashiApiTraffic();

    String trafficTotalNew = "";
    String trafficSpeedNew = "";
    try {
      var obj = jsonDecode(connections);
      ClashConnections body = ClashConnections();
      body.fromJson(obj, false);
      //_memory.value =
      //    ClashHttpApi.convertTrafficToStringDouble(body.memory);
      trafficTotalNew =
          "↑ ${ClashHttpApi.convertTrafficToStringDouble(body.uploadTotal)}  ↓ ${ClashHttpApi.convertTrafficToStringDouble(body.downloadTotal)} ";
    } catch (err) {}
    try {
      var obj = jsonDecode(tranffic);
      ClashTraffic traffic = ClashTraffic();
      traffic.fromJson(obj);
      trafficSpeedNew =
          "↑ ${ClashHttpApi.convertTrafficToStringDouble(traffic.upload)}/s  ↓ ${ClashHttpApi.convertTrafficToStringDouble(traffic.download)}/s";
    } catch (err) {}
    Biz.trafficChanged(trafficTotalNew, trafficSpeedNew);
    if (AppLifecycleStateNofity.isPaused()) {
      return;
    }
    _trafficTotal.value = trafficTotalNew;
    _trafficSpeed.value = trafficSpeedNew;
  }

  Future<void> _connectToCore() async {
    bool started = await VPNService.getStarted();
    if (!started) {
      return;
    }
    if (AppLifecycleStateNofity.isPaused()) {
      return;
    }
    await _updateConnections();
    const Duration duration = Duration(seconds: 1);
    _timerConnectToCore ??= Timer.periodic(duration, (timer) async {
      if (AppLifecycleStateNofity.isPaused()) {
        return;
      }
      await _updateConnections();
      if (_proxyNow.value.isEmpty) {
        Future.delayed(Duration(seconds: 1), () async {
          _updateProxyNow();
        });
      }
    });
  }

  Future<void> _disconnectToCore({bool resetUI = true}) async {
    _timerConnectToCore?.cancel();
    _timerConnectToCore = null;
    if (resetUI) {
      _trafficTotal.value = _kNoTrafficTotal;
      _trafficSpeed.value = _kNoSpeed;
      Biz.trafficChanged("", "");
      // _memory.value = _kNoMemory;
      _proxyNow.value = "";
    }
  }

  Future<void> _updateProxyNow() async {
    if (_state == FlutterVpnServiceState.connected) {
      if (AppLifecycleStateNofity.isPaused()) {
        return;
      }
      if (_proxyNowUpdating) {
        return;
      }
      _proxyNowUpdating = true;

      final result = await ClashHttpApi.getNowProxy(
        ClashSettingManager.getConfig().Mode ?? ClashConfigsMode.rule.name,
      );
      if (result.error != null || result.data!.isEmpty) {
        _proxyNow.value = "";
      } else {
        if (result.data!.length >= 2) {
          if (result.data!.first.delay != null) {
            _proxyNow.value =
                "${result.data![1].name} -> ${result.data!.first.name} (${result.data!.first.delay} ms)";
          } else {
            _proxyNow.value =
                "${result.data![1].name} -> ${result.data!.first.name}";
          }
        } else {
          if (result.data!.first.delay != null) {
            _proxyNow.value =
                "${result.data!.first.name} (${result.data!.first.delay} ms)";
          } else {
            _proxyNow.value = result.data!.first.name;
          }
        }
      }
      _proxyNowUpdating = false;
    } else {
      _proxyNow.value = "";
    }
  }

  Future<void> _onTapBoard() async {
    final tcontext = Translations.of(context);
    var setting = SettingManager.getConfig();
    if (setting.boardOnline && setting.boardUrl.isNotEmpty) {
      final uri = Uri.tryParse(setting.boardUrl);
      if (uri == null) {
        final msg = "${tcontext.meta.urlInvalid}:${setting.boardUrl}";
        DialogUtils.showAlertDialog(context, msg, withVersion: true);
        return;
      }
      final shortUrl = Uri(
        scheme: uri.scheme,
        userInfo: uri.userInfo,
        host: uri.host,
        port: uri.port,
      );
      String host = Platform.isIOS ? await _getLocalAddress() : "127.0.0.1";
      String secret = ClashSettingManager.getConfig().Secret!;
      final url =
          '${shortUrl.toString()}/?hostname=$host&port=${ClashSettingManager.getControlPort()}&secret=$secret&http=true';

      if (!mounted) {
        return;
      }
      await WebviewHelper.loadUrl(
        context,
        url,
        "onlineboard",
        title: tcontext.meta.board,
        inappWebViewOpenExternal: true,
      );
      return;
    }
    ReturnResult result = await Zashboard.start();
    if (result.error != null) {
      if (!mounted) {
        return;
      }
      DialogUtils.showAlertDialog(
        context,
        result.error!.message,
        withVersion: true,
      );
      return;
    }
    String url = result.data!;
    if (!mounted) {
      return;
    }
    await WebviewHelper.loadUrl(
      context,
      url,
      "board",
      title: tcontext.meta.board,
      inappWebViewOpenExternal: false,
    );
    if (PlatformUtils.isMobile()) {
      await Zashboard.stop();
    }
    _updateProxyNow();
  }

  Future<void> _onTapRunTimeProfile() async {
    final tcontext = Translations.of(context);
    late String content;
    try {
      final path = await PathUtils.serviceCoreRuntimeProfileFilePath();
      content = await File(path).readAsString();
    } catch (err) {
      if (!mounted) {
        return;
      }
      DialogUtils.showAlertDialog(
        context,
        err.toString(),
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
      return;
    }
    if (!mounted) {
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: FileViewScreen.routSettings(),
        builder: (context) => FileViewScreen(
          title: tcontext.meta.runtimeProfile,
          content: content,
        ),
      ),
    );
  }

  Future<void> _onTapNetCheck() async {
    if (widget.onNavigateToTab != null) {
      widget.onNavigateToTab!(3);
      return;
    }
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: NetCheckScreen.routSettings(),
        builder: (context) => const NetCheckScreen(),
      ),
    );
  }
}

class HomeScreenWidgetPart2 extends StatelessWidget {
  const HomeScreenWidgetPart2({super.key});

  Widget _buildSectionCard({
    required BuildContext context,
    required List<Widget> items,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => items[index],
            separatorBuilder: (_, __) => const Divider(height: 1, thickness: 0.8),
            itemCount: items.length,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AutoUpdateCheckVersion versionCheck = AutoUpdateManager.getVersionCheck();
    final tcontext = Translations.of(context);

    // Group 1: Core & Configuration
    final coreItems = [
      ListTile(
        title: Text(tcontext.meta.settingApp),
        leading: const Icon(Icons.tune_rounded, size: 22),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
        minVerticalPadding: 16,
        onTap: () async {
          await GroupHelper.showAppSettings(context);
        },
      ),
      ListTile(
        title: Text(tcontext.meta.settingCore),
        leading: const Icon(Icons.settings_suggest_rounded, size: 22),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
        minVerticalPadding: 16,
        onTap: () async {
          await GroupHelper.showClashSettings(context);
        },
      ),
      ListTile(
        title: Text(tcontext.meta.coreLog),
        leading: const Icon(Icons.terminal_rounded, size: 22),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
        minVerticalPadding: 16,
        onTap: () async {
          String content = "";
          final fileErrPath = await PathUtils.serviceStdErrorFilePath();
          final filePath = await PathUtils.serviceLogFilePath();
          File file = File(fileErrPath);
          const split = "\n-------------------------------\n";
          if (await file.exists()) {
            final errContent = await file.readAsString();
            if (errContent.isNotEmpty) {
              content += split;
              content += errContent;
            }
          }
          final item = await FileUtils.readAsStringReverse(
            filePath,
            50 * 1024,
            false,
          );
          if (item != null) {
            if (content.isNotEmpty) {
              content += split;
            }
            content += item.item1;
          }
          if (!context.mounted) {
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: RichtextViewScreen.routSettings(),
              builder: (context) => RichtextViewScreen(
                title: tcontext.meta.coreLog,
                file: "",
                content: content,
                showAction: true,
              ),
            ),
          );
        },
      ),
    ];

    // Group 2: Data & Sync
    final dataItems = [
      ListTile(
        title: Text(tcontext.meta.backupAndSync),
        leading: const Icon(Icons.cloud_sync_outlined, size: 22),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
        minVerticalPadding: 16,
        onTap: () async {
          GroupHelper.showBackupAndSync(context);
        },
      ),
      if (versionCheck.newVersion)
        ListTile(
          title: Text(tcontext.meta.hasNewVersion(p: versionCheck.version)),
          leading: const Icon(
            Icons.new_releases_rounded,
            size: 22,
            color: Colors.amber,
          ),
          trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
          minVerticalPadding: 16,
          onTap: () async {
            GroupHelper.newVersionUpdate(context);
          },
        ),
    ];

    // Group 3: Help & About
    final aboutItems = [
      ListTile(
        title: Text(tcontext.meta.help),
        leading: const Icon(Icons.help_outline_rounded, size: 22),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
        minVerticalPadding: 16,
        onTap: () async {
          await GroupHelper.showHelp(context);
        },
      ),
      ListTile(
        title: Text(tcontext.meta.about),
        leading: const Icon(Icons.info_outline_rounded, size: 22),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
        minVerticalPadding: 16,
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              settings: AboutScreen.routSettings(),
              builder: (context) => const AboutScreen(),
            ),
          );
        },
      ),
    ];

    return Column(
      children: [
        _buildSectionCard(context: context, items: coreItems),
        _buildSectionCard(context: context, items: dataItems),
        _buildSectionCard(context: context, items: aboutItems),
      ],
    );
  }
}
