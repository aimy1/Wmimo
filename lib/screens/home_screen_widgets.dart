import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;

import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/auto_update_manager.dart';
import 'package:wmimo/app/modules/biz.dart';
import 'package:wmimo/app/modules/board_provider_notice_manager.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/screens/rules_screen.dart';
import 'package:wmimo/screens/logs_screen.dart';
import 'package:wmimo/app/utils/app_lifecycle_state_notify.dart';
import 'package:wmimo/app/utils/app_scheme_actions.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/mobile_permission_helper.dart';
import 'package:wmimo/app/utils/move_to_background_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/file_view_screen.dart';
import 'package:wmimo/screens/group_helper.dart';
import 'package:wmimo/screens/net_check_screen.dart';
import 'package:wmimo/screens/speed_test_screen.dart';
import 'package:wmimo/screens/profiles_board_screen.dart';
import 'package:wmimo/screens/proxy_board_screen.dart';
import 'package:wmimo/screens/settings_screen.dart';
import 'package:wmimo/screens/perapp_android_screen.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/ip_info_card.dart';
import 'package:wmimo/screens/widgets/segmented_elevated_button.dart';
import 'package:wmimo/screens/widgets/traffic_chart_card.dart';
import 'package:wmimo/screens/widgets/website_test_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:libclash_vpn_service/state.dart';
import 'package:libclash_vpn_service/vpn_service.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:tuple/tuple.dart';

class ProxyHttpOverrides extends HttpOverrides {
  ProxyHttpOverrides(this.proxyPort);

  final int proxyPort;

  static String resolveProxy(Uri uri, int proxyPort) {
    if (proxyPort <= 0) return "DIRECT";
    final host = uri.host.toLowerCase();
    if (host == "localhost" || host == "127.0.0.1" || host == "::1") {
      return "DIRECT";
    }
    return "PROXY 127.0.0.1:$proxyPort; DIRECT";
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.findProxy = (Uri uri) => resolveProxy(uri, proxyPort);
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
  final FocusNode _focusNodeConnect = FocusNode();
  FlutterVpnServiceState _state = FlutterVpnServiceState.disconnected;
  bool? _desiredConnected;
  Timer? _debounceToggleTimer;
  Timer? _timerStateChecker;
  Timer? _timerConnectToCore;
  QuickActions? _quickActions;
  bool _quickActionWorking = false;
  bool _isSwitchOperating = false;

  bool get _isEffectiveConnected {
    if (_desiredConnected != null) {
      return _desiredConnected!;
    }
    return _state == FlutterVpnServiceState.connected ||
        _state == FlutterVpnServiceState.connecting;
  }

  bool get _isTransitioning {
    if (_desiredConnected != null) {
      final actualConnected = _state == FlutterVpnServiceState.connected;
      if (_desiredConnected != actualConnected) return true;
    }
    return _state == FlutterVpnServiceState.connecting ||
        _state == FlutterVpnServiceState.disconnecting ||
        _state == FlutterVpnServiceState.reasserting;
  }

  final ValueNotifier<int> _chartTick = ValueNotifier<int>(0);
  final List<TrafficDataRecord> _trafficHistory = [];
  final ValueNotifier<String> _trafficSpeed = ValueNotifier<String>(_kNoSpeed);
  final ValueNotifier<String> _trafficTotal = ValueNotifier<String>(
    _kNoTrafficTotal,
  );
  final ValueNotifier<num> _uploadSpeedRaw = ValueNotifier<num>(0);
  final ValueNotifier<num> _downloadSpeedRaw = ValueNotifier<num>(0);
  final ValueNotifier<num> _uploadTotalRaw = ValueNotifier<num>(0);
  final ValueNotifier<num> _downloadTotalRaw = ValueNotifier<num>(0);
  final ValueNotifier<num> _memoryRaw = ValueNotifier<num>(0);
  final ValueNotifier<String> _proxyNow = ValueNotifier<String>("");
  bool _proxyNowUpdating = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    for (int i = 59; i >= 0; i--) {
      _trafficHistory.add(TrafficDataRecord(
        time: now.subtract(Duration(seconds: i)),
        upload: 0.0,
        download: 0.0,
      ));
    }
    VPNService.onEventStateChanged.add(_onStateChanged);
    AppLifecycleStateNofity.onStateResumed(hashCode, _onStateResumed);
    AppLifecycleStateNofity.onStatePaused(hashCode, _onStatePaused);
    ProfileManager.onEventCurrentChanged.add(_onCurrentChanged);
    ProfileManager.onEventAdd.add(_onProfileAdded);
    ProfileManager.onEventRemove.add(_onCurrentChanged);
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
    ClashSettingManager.onEventModeChanged.add(_onModeChangedEvent);
    Biz.onEventProxySelected.add(_onProxySelectedEvent);
    SettingManager.onSideBySideLayoutChanged.add(_onLayoutChangedEvent);
    _updateProxyNow();
  }

  void _onLayoutChangedEvent() {
    if (!mounted) return;
    setState(() {});
  }

  void _onModeChangedEvent() {
    if (!mounted) return;
    setState(() {});
    _updateProxyNow();
  }

  void _onProxySelectedEvent(String nodeName) {
    if (!mounted) return;
    if (nodeName.isNotEmpty) {
      _proxyNow.value = nodeName;
    }
    _updateProxyNow();
  }

  @override
  void dispose() {
    _currentChangedDebounce?.cancel();
    ClashSettingManager.onEventModeChanged.remove(_onModeChangedEvent);
    Biz.onEventProxySelected.remove(_onProxySelectedEvent);
    SettingManager.onSideBySideLayoutChanged.remove(_onLayoutChangedEvent);
    VPNService.onEventStateChanged.remove(_onStateChanged);
    AppLifecycleStateNofity.onStateResumed(hashCode, null);
    AppLifecycleStateNofity.onStatePaused(hashCode, null);
    ProfileManager.onEventCurrentChanged.remove(_onCurrentChanged);
    ProfileManager.onEventAdd.remove(_onProfileAdded);
    ProfileManager.onEventRemove.remove(_onCurrentChanged);
    ProfileManager.onEventUpdate.remove(_onUpdate);
    BoardProviderNoticeManager.onEventCheck.remove(_onNoticeUpdate);
    BoardProviderNoticeManager.onEventReaded.remove(_onNoticeReaded);
    _debounceToggleTimer?.cancel();
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
    final connected = _isEffectiveConnected;
    final isTransitioning = _isTransitioning;
    final currentProfile = ProfileManager.getCurrent();
    final settings = SettingManager.getConfig();
    Tuple2<bool, String>? tranfficExpire;
    if (currentProfile != null && currentProfile.isRemote() && currentProfile.expire.isNotEmpty) {
      tranfficExpire = currentProfile.getExpireTime(settings.languageTag);
    }
    return Column(
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: connected
                                  ? ThemeDefine.kColorGreenBright
                                  : (isTransitioning
                                      ? ThemeDefine.kColorBlue
                                      : const Color(0xFF94A3B8)),
                              shape: BoxShape.circle,
                              boxShadow: connected
                                  ? [
                                      BoxShadow(
                                        color: ThemeDefine.kColorGreenBright
                                            .withValues(alpha: 0.4),
                                        blurRadius: 6,
                                        spreadRadius: 1.5,
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isTransitioning
                                ? tcontext.meta.connecting
                                : (connected
                                    ? tcontext.meta.connected
                                    : tcontext.meta.disconnected),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          if (isTransitioning) ...[
                            const SizedBox(width: 6),
                            const SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.8,
                                color: ThemeDefine.kColorBlue,
                              ),
                            ),
                          ],
                          const SizedBox(width: 8),
                          Flexible(
                            child: ValueListenableBuilder<String>(
                              valueListenable: _proxyNow,
                              builder: (context, proxyName, _) {
                                if (proxyName.trim().isEmpty) {
                                  return const SizedBox.shrink();
                                }
                                return InkWell(
                                  borderRadius: BorderRadius.circular(8),
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
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (Theme.of(context).brightness == Brightness.dark
                                              ? Colors.white
                                              : Colors.black)
                                          .withValues(alpha: 0.05),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            proxyName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withValues(alpha: 0.85),
                                              fontFamilyFallback: Platform.isWindows
                                                  ? const ['Emoji']
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Transform.scale(
                      scale: 0.88,
                      child: Switch.adaptive(
                        value: connected,
                        activeThumbColor: Colors.white,
                        activeTrackColor: ThemeDefine.kColorGreenBright,
                        focusNode: _focusNodeConnect,
                        onChanged: (bool value) {
                          HapticFeedback.lightImpact();
                          _requestToggle(value, from: "switch");
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 40,
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
                    padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                    onPressed: (int value) async {
                      HapticFeedback.selectionClick();
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
                const SizedBox(height: 8),
                // Clash Verge 风格开关: 系统代理 (PC) / 分应用代理 (Android) & TUN 模式
                Row(
                  children: [
                    // 系统代理 (PC端) 或 分应用代理 (Android端)
                    Expanded(
                      child: Platform.isAndroid
                          ? _buildClashVergeModeSwitch(
                              context: context,
                              icon: Icons.apps_rounded,
                              iconColor: ThemeDefine.kColorBlue,
                              title: tcontext.PerAppAndroidScreen.title,
                              isActive: ClashSettingManager.getConfig().Extension?.Tun.perApp.Enable == true,
                              subtitle: (ClashSettingManager.getConfig().Extension?.Tun.perApp.Enable == true)
                                  ? "${ClashSettingManager.getConfig().Extension?.Tun.perApp.PackageIds?.length ?? 0} ${tcontext.meta.selectedOnly}"
                                  : tcontext.meta.disable,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: PerAppAndroidScreen.routSettings(),
                                    builder: (context) => const PerAppAndroidScreen(),
                                  ),
                                );
                                setState(() {});
                              },
                              onSettingsTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    settings: PerAppAndroidScreen.routSettings(),
                                    builder: (context) => const PerAppAndroidScreen(),
                                  ),
                                );
                                setState(() {});
                              },
                              onChanged: (bool value) async {
                                var perapp = ClashSettingManager.getConfig().Extension?.Tun.perApp;
                                if (perapp != null) {
                                  perapp.Enable = value;
                                  await ClashSettingManager.save();
                                  setState(() {});
                                  if (_state == FlutterVpnServiceState.connected) {
                                    VpnActionHandler.vpnReconnect?.call("perapp", false);
                                  }
                                }
                              },
                            )
                          : _buildClashVergeModeSwitch(
                              context: context,
                              icon: Icons.laptop_windows_rounded,
                              iconColor: ThemeDefine.kColorBlue,
                              title: tcontext.meta.systemProxy,
                              isActive: SettingManager.getConfig().autoSetSystemProxy,
                              onChanged: (bool value) async {
                                SettingManager.getConfig().autoSetSystemProxy = value;
                                SettingManager.save();
                                if (PlatformUtils.isPC()) {
                                  if (_state == FlutterVpnServiceState.connected) {
                                    await VPNService.setSystemProxy(value);
                                  }
                                }
                                setState(() {});
                              },
                            ),
                    ),
                    const SizedBox(width: 8),
                    // TUN 模式
                    Expanded(
                      child: _buildClashVergeModeSwitch(
                        context: context,
                        icon: Icons.shield_outlined,
                        iconColor: const Color(0xFF10B981),
                        title: tcontext.meta.tunMode,
                        isActive: (ClashSettingManager.getConfig().Tun?.OverWrite == true &&
                            ClashSettingManager.getConfig().Tun?.Enable == true),
                        onSettingsTap: () async {
                          await GroupHelper.showClashSettingsTUN(context);
                          setState(() {});
                        },
                        onChanged: (bool value) async {
                          var tun = ClashSettingManager.getConfig().Tun;
                          if (tun != null) {
                            tun.OverWrite = true;
                            tun.Enable = value;
                            await ClashSettingManager.save();
                            setState(() {});
                            if (_state == FlutterVpnServiceState.connected) {
                              VpnActionHandler.vpnReconnect?.call("tun", false);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // 流量统计卡片
        TrafficChartCard(
          history: _trafficHistory,
          isConnected: connected,
          tickNotifier: _chartTick,
          uploadSpeed: _uploadSpeedRaw,
          downloadSpeed: _downloadSpeedRaw,
          uploadTotal: _uploadTotalRaw,
          downloadTotal: _downloadTotalRaw,
        ),
        // 首页并列排布: 网站测试 + IP 信息, 订阅配置 + 快捷工具
        LayoutBuilder(
          builder: (context, constraints) {
            final sideBySide = SettingManager.getConfig().ui.sideBySideLayout;
            final isWide = sideBySide && constraints.maxWidth >= 580;
            final websiteCard = WebsiteTestCard(
              mixedPort: ClashSettingManager.getMixedPort(),
            );
            final ipCard = IpInfoCard(
              isConnected: _state == FlutterVpnServiceState.connected,
              mixedPort: ClashSettingManager.getMixedPort(),
            );
            final subCard = _buildSubscriptionOrProfileCard(
              context: context,
              profile: currentProfile,
              expireInfo: tranfficExpire,
            );
            final quickActionCard = _buildQuickActionCard(context, tcontext);

            if (isWide) {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: websiteCard),
                      const SizedBox(width: 10),
                      Expanded(child: ipCard),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: subCard),
                      const SizedBox(width: 10),
                      Expanded(child: quickActionCard),
                    ],
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  const SizedBox(height: 10),
                  websiteCard,
                  const SizedBox(height: 10),
                  ipCard,
                  const SizedBox(height: 10),
                  subCard,
                  const SizedBox(height: 10),
                  quickActionCard,
                ],
              );
            }
          },
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
        color: Theme.of(context).brightness == Brightness.dark ? ThemeDefine.kColorDarkInner : Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(ThemeDefine.kRadiusSmall),
        child: InkWell(
          borderRadius: BorderRadius.circular(ThemeDefine.kRadiusSmall),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11,
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

  Widget _buildClashVergeModeSwitch({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool isActive,
    required ValueChanged<bool> onChanged,
    VoidCallback? onSettingsTap,
    VoidCallback? onTap,
    String? subtitle,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tcontext = Translations.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isDark
                ? ThemeDefine.kColorDarkInner
                : const Color(0xFFF1F5F9).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? iconColor.withValues(alpha: 0.45)
                  : theme.dividerColor.withValues(alpha: 0.35),
              width: isActive ? 1.0 : 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: (isActive ? iconColor : const Color(0xFF94A3B8))
                      .withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  icon,
                  size: 15,
                  color: isActive ? iconColor : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? theme.colorScheme.onSurface
                            : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle ?? (isActive ? tcontext.meta.enable : tcontext.meta.disable),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isActive
                            ? iconColor
                            : theme.colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
          if (onSettingsTap != null) ...[
            InkWell(
              borderRadius: BorderRadius.circular(6),
              onTap: onSettingsTap,
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Icon(
                  Icons.settings_outlined,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                ),
              ),
            ),
            const SizedBox(width: 2),
          ],
          SizedBox(
            width: 34,
            height: 20,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Switch(
                value: isActive,
                activeThumbColor: iconColor,
                activeTrackColor: iconColor.withValues(alpha: 0.4),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onChanged: (val) {
                  HapticFeedback.selectionClick();
                  onChanged(val);
                },
              ),
            ),
          ),
        ],
      ),
    ),
  ),
);
  }



  Widget _buildSubscriptionOrProfileCard({
    required BuildContext context,
    required ProfileSetting? profile,
    required Tuple2<bool, String>? expireInfo,
  }) {
    if (profile != null && profile.isRemote() && profile.total > 0) {
      return _buildSubscriptionQuotaSection(
        context: context,
        profile: profile,
        expireInfo: expireInfo,
      );
    }

    final tcontext = Translations.of(context);
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          if (widget.onNavigateToTab != null) {
            widget.onNavigateToTab!(2);
            return;
          }
          await Navigator.push(
            context,
            MaterialPageRoute(
              settings: ProfilesBoardScreen.routSettings(),
              builder: (context) => const ProfilesBoardScreen(),
            ),
          );
          setState(() {});
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 102),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 18,
                    color: ThemeDefine.kColorBlue,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    tcontext.meta.currentProfile,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                profile?.getShowName() ?? tcontext.meta.noProfilesYet,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                profile?.isRemote() == true
                    ? tcontext.meta.remoteSubscription
                    : tcontext.meta.localProfile,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, Translations tcontext) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                children: [
                  Icon(
                    Icons.grid_view_rounded,
                    size: 17,
                    color: ThemeDefine.kColorBlue,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    tcontext.meta.quickActions,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildQuickActionTile(
                  context: context,
                  icon: Icons.policy_rounded,
                  label: tcontext.meta.rules,
                  onTap: _onTapRules,
                ),
                const SizedBox(width: 4),
                _buildQuickActionTile(
                  context: context,
                  icon: Icons.article_outlined,
                  label: tcontext.meta.coreLog,
                  onTap: _onTapLogs,
                ),
                const SizedBox(width: 4),
                _buildQuickActionTile(
                  context: context,
                  icon: Icons.network_check_rounded,
                  label: tcontext.meta.networkCheck,
                  onTap: _onTapNetCheck,
                ),
                const SizedBox(width: 4),
                _buildQuickActionTile(
                  context: context,
                  icon: Icons.speed_rounded,
                  label: tcontext.meta.speedTest,
                  onTap: _onTapSpeedTest,
                ),
                const SizedBox(width: 4),
                _buildQuickActionTile(
                  context: context,
                  icon: Icons.description_outlined,
                  label: tcontext.meta.runtimeProfile,
                  onTap: _onTapRunTimeProfile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubscriptionQuotaSection({
    required BuildContext context,
    required ProfileSetting profile,
    required Tuple2<bool, String>? expireInfo,
  }) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    num used = profile.upload + profile.download;
    num total = profile.total;
    double percent = total > 0 ? (used / total) : 0.0;
    if (percent > 1.0) percent = 1.0;

    String usedStr = ClashHttpApi.convertTrafficToStringDouble(used);
    String totalStr = ClashHttpApi.convertTrafficToStringDouble(total);
    num remaining = (total - used).clamp(0, total);
    String remainingStr = ClashHttpApi.convertTrafficToStringDouble(remaining);

    Color statusColor = percent > 0.9
        ? Colors.red
        : (percent > 0.7 ? Colors.orange : ThemeDefine.kColorBlue);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () async {
          if (widget.onNavigateToTab != null) {
            widget.onNavigateToTab!(2);
            return;
          }
          await Navigator.push(
            context,
            MaterialPageRoute(
              settings: ProfilesBoardScreen.routSettings(),
              builder: (context) => const ProfilesBoardScreen(),
            ),
          );
          setState(() {});
        },
        child: Container(
          constraints: const BoxConstraints(minHeight: 102),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.pie_chart_outline_rounded,
                    size: 15,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${tcontext.meta.planUsage}: $usedStr / $totalStr',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${(percent * 100).toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 6,
                  backgroundColor: (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      '${tcontext.meta.remaining}: $remainingStr',
                      style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (expireInfo != null) ...[
                    const SizedBox(width: 8),
                    Tooltip(
                      message: '${tcontext.meta.expireTime}: ${expireInfo.item2}',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_outlined,
                            size: 12,
                            color: expireInfo.item1
                                ? Colors.red
                                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            expireInfo.item2,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: expireInfo.item1
                                  ? Colors.red
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onInitAllFinish() async {
    VpnActionHandler.vpnConnect = _vpnConnect;
    VpnActionHandler.vpnDisconnect = _vpnDisconnect;
    VpnActionHandler.vpnReconnect = _vpnReconnect;
    initQuickAction();
    final currentProfile = ProfileManager.getCurrent();
    if (currentProfile != null && SettingManager.getConfig().autoConnectAfterLaunch) {
      await start("launch");
      final savedMode = ClashSettingManager.getConfigsMode();
      unawaited(ClashHttpApi.setConfigsMode(savedMode.name));
    }
  }

  void _requestToggle(
    bool targetConnected, {
    required String from,
    bool background = false,
  }) {
    if (_desiredConnected != targetConnected) {
      setState(() {
        _desiredConnected = targetConnected;
      });
    }

    _debounceToggleTimer?.cancel();
    _debounceToggleTimer = Timer(const Duration(milliseconds: 140), () {
      _executeToggle(from: from, background: background);
    });
  }

  Future<void> _executeToggle({
    required String from,
    bool background = false,
  }) async {
    if (!mounted) return;
    final target = _desiredConnected;
    if (target == null) return;

    if (_isSwitchOperating) {
      return;
    }

    final isConnected = _state == FlutterVpnServiceState.connected;
    if (target == isConnected &&
        _state != FlutterVpnServiceState.connecting &&
        _state != FlutterVpnServiceState.disconnecting) {
      if (_desiredConnected != null) {
        setState(() {
          _desiredConnected = null;
        });
      }
      return;
    }

    _isSwitchOperating = true;
    bool ok = false;
    try {
      if (target) {
        ok = await start(from);
        if (ok && background) {
          MoveToBackgroundUtils.moveToBackground(
            duration: const Duration(milliseconds: 300),
          );
        }
      } else {
        await stop();
        ok = true;
        if (background) {
          MoveToBackgroundUtils.moveToBackground(
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    } finally {
      _isSwitchOperating = false;
      if (mounted) {
        if (!ok) {
          setState(() {
            _desiredConnected = null;
            _state = FlutterVpnServiceState.disconnected;
          });
        } else if (_desiredConnected != null &&
            _desiredConnected != (_state == FlutterVpnServiceState.connected)) {
          _executeToggle(from: from, background: background);
        } else {
          setState(() {
            _desiredConnected = null;
          });
        }
      }
    }
  }

  Future<void> stop() async {
    if (mounted) {
      setState(() {
        _state = FlutterVpnServiceState.disconnecting;
      });
    }
    try {
      await VPNService.stop();
    } finally {
      if (mounted) setState(() {});
    }
  }

  Future<bool> start(String from) async {
    if (mounted) {
      setState(() {
        _state = FlutterVpnServiceState.connecting;
      });
    }

    // Yield execution momentarily to allow Flutter UI framework to paint the "connecting" state and switch animation
    await Future.delayed(const Duration(milliseconds: 25));

    try {
      final currentProfile = ProfileManager.getCurrent();
      if (currentProfile == null) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            settings: ProfilesBoardScreen.routSettings(),
            builder: (context) => ProfilesBoardScreen(),
          ),
        );
        if (mounted) {
          setState(() {
            _desiredConnected = null;
            _state = FlutterVpnServiceState.disconnected;
          });
        }
        return false;
      }
      final clashSetting = ClashSettingManager.getConfig();
      final isTunEnabled = clashSetting.Tun?.Enable == true;
      if (Platform.isWindows && isTunEnabled && !VPNService.isRunAsAdmin()) {
        final bool? proceed = await DialogUtils.showConfirmDialog(
          context,
          "${t.meta.tunModeRunAsAdmin}\n\n${t.meta.tunSwitchToSystemProxy}",
        );
        if (!mounted) return false;
        if (proceed != true) {
          if (mounted) {
            setState(() {
              _desiredConnected = null;
              _state = FlutterVpnServiceState.disconnected;
            });
          }
          return false;
        }
        clashSetting.Tun?.Enable = false;
        await ClashSettingManager.save();
        SettingManager.getConfig().autoSetSystemProxy = true;
        await SettingManager.save();
        setState(() {});
      }
      if ((Platform.isLinux || Platform.isMacOS) && isTunEnabled) {
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
          if (Platform.isLinux && (password == null || password.isEmpty)) {
            setState(() {});
            return true;
          }
          final result = await FlutterVpnService.authorizeService(
            servicePath,
            password ?? "",
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
      if (Platform.isAndroid || Platform.isIOS) {
        bool vpnGranted = await MobilePermissionHelper.requestVpnPermission();
        if (!vpnGranted) {
          if (mounted) {
            setState(() {
              _desiredConnected = null;
              _state = FlutterVpnServiceState.disconnected;
            });
          }
          return false;
        }
      }

      var err = await VPNService.start(const Duration(seconds: 60));
      if (!mounted) {
        return false;
      }
      if (err != null) {
        if (mounted) {
          setState(() {
            _desiredConnected = null;
            _state = FlutterVpnServiceState.disconnected;
          });
        }
        if (err.message == "willCompleteAfterRebootInstall") {
          err.message = t.meta.willCompleteAfterRebootInstall;
        } else if (err.message == "requestNeedsUserApproval") {
          err.message = t.meta.requestNeedsUserApproval;
        } else if (err.message.contains("FullDiskAccessPermissionRequired")) {
          err.message = t.meta.FullDiskAccessPermissionRequired;
        } else if (err.message == "tunCreateAdapterFailedAdmin" ||
            err.message.contains("Access is denied") ||
            err.message.contains("TUN 虚拟网卡创建失败") ||
            err.message.contains("configure tun interface: Access is denied") ||
            err.message.contains("Start TUN listening error")) {
          err.message = t.meta.tunCreateAdapterFailedAdmin;
        }

        DialogUtils.showAlertDialog(context, err.message, withVersion: true);
        return false;
      }
      return true;
    } finally {
      if (mounted) setState(() {});
    }
  }

  void _vpnConnect(String from, bool background) {
    _requestToggle(true, from: from, background: background);
  }

  void _vpnDisconnect(String from, bool background) {
    _requestToggle(false, from: from, background: background);
  }

  void _vpnReconnect(String from, bool background) {
    _requestToggle(false, from: from, background: background);
    Future.delayed(const Duration(milliseconds: 180), () {
      if (mounted) {
        _requestToggle(true, from: from, background: background);
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
      if (_desiredConnected == false) {
        _desiredConnected = null;
      }
    } else if (state == FlutterVpnServiceState.connecting) {
    } else if (state == FlutterVpnServiceState.connected) {
      final savedMode = ClashSettingManager.getConfigsMode();
      unawaited(ClashHttpApi.setConfigsMode(savedMode.name));
      if (!AppLifecycleStateNofity.isPaused()) {
        _connectToCore();
      }
      Biz.vpnStateChanged(true);
      if (_desiredConnected == true) {
        _desiredConnected = null;
      }
    } else if (state == FlutterVpnServiceState.reasserting) {
      _disconnectToCore();
    } else if (state == FlutterVpnServiceState.disconnecting) {
      _stopStateCheckTimer();
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

  Timer? _currentChangedDebounce;

  void _onProfileAdded(String id) {
    if (mounted) {
      setState(() {});
    }
  }

  void _onCurrentChanged(String id) {
    _currentChangedDebounce?.cancel();
    _currentChangedDebounce = Timer(const Duration(milliseconds: 250), () async {
      if (!mounted) return;
      if (id.isEmpty) {
        await VPNService.stop();
        if (mounted) {
          setState(() {});
          _updateProxyNow();
        }
        return;
      }

      final started = await VPNService.getStarted();
      if (!started) {
        if (mounted) {
          setState(() {});
          _updateProxyNow();
        }
        return;
      }

      final err = await VPNService.restart(const Duration(seconds: 60));
      if (err != null) {
        if (!mounted) {
          return;
        }
        var msg = err.message;
        if (msg == "tunCreateAdapterFailedAdmin" ||
            msg.contains("Access is denied") ||
            msg.contains("TUN 虚拟网卡创建失败") ||
            msg.contains("configure tun interface: Access is denied") ||
            msg.contains("Start TUN listening error")) {
          msg = t.meta.tunCreateAdapterFailedAdmin;
        }
        DialogUtils.showAlertDialog(context, msg, withVersion: true);
      }
      if (mounted) {
        setState(() {});
        _updateProxyNow();
      }
    });
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
      _uploadTotalRaw.value = body.uploadTotal;
      _downloadTotalRaw.value = body.downloadTotal;
      _memoryRaw.value = body.memory;
      trafficTotalNew =
          "↑ ${ClashHttpApi.convertTrafficToStringDouble(body.uploadTotal)}  ↓ ${ClashHttpApi.convertTrafficToStringDouble(body.downloadTotal)} ";
    } catch (err) {}
    try {
      var obj = jsonDecode(tranffic);
      ClashTraffic traffic = ClashTraffic();
      traffic.fromJson(obj);
      _uploadSpeedRaw.value = traffic.upload;
      _downloadSpeedRaw.value = traffic.download;
      _trafficHistory.add(TrafficDataRecord(
        time: DateTime.now(),
        upload: traffic.upload.toDouble(),
        download: traffic.download.toDouble(),
      ));
      if (_trafficHistory.length > 600) {
        _trafficHistory.removeAt(0);
      }
      trafficSpeedNew =
          "↑ ${ClashHttpApi.convertTrafficToStringDouble(traffic.upload)}/s  ↓ ${ClashHttpApi.convertTrafficToStringDouble(traffic.download)}/s";
    } catch (err) {}
    Biz.trafficChanged(trafficTotalNew, trafficSpeedNew);
    if (AppLifecycleStateNofity.isPaused()) {
      return;
    }
    _trafficTotal.value = trafficTotalNew;
    _trafficSpeed.value = trafficSpeedNew;
    _chartTick.value++;
  }

  Future<void> _connectToCore() async {
    bool started = await VPNService.getStarted();
    if (!started) {
      return;
    }
    if (AppLifecycleStateNofity.isPaused()) {
      return;
    }
    final savedMode = ClashSettingManager.getConfigsMode();
    unawaited(ClashHttpApi.setConfigsMode(savedMode.name));
    await _updateConnections();
    const Duration duration = Duration(seconds: 1);
    _timerConnectToCore ??= Timer.periodic(duration, (timer) async {
      if (AppLifecycleStateNofity.isPaused()) {
        return;
      }
      await _updateConnections();
      if (_proxyNow.value.isEmpty) {
        _updateProxyNow();
      }
    });
  }

  Future<void> _disconnectToCore({bool resetUI = true}) async {
    _timerConnectToCore?.cancel();
    _timerConnectToCore = null;
    if (resetUI) {
      _trafficTotal.value = _kNoTrafficTotal;
      _trafficSpeed.value = _kNoSpeed;
      _uploadSpeedRaw.value = 0;
      _downloadSpeedRaw.value = 0;
      _uploadTotalRaw.value = 0;
      _downloadTotalRaw.value = 0;
      _memoryRaw.value = 0;
      final now = DateTime.now();
      _trafficHistory.clear();
      for (int i = 59; i >= 0; i--) {
        _trafficHistory.add(TrafficDataRecord(
          time: now.subtract(Duration(seconds: i)),
          upload: 0.0,
          download: 0.0,
        ));
      }
      Biz.trafficChanged("", "");
      _chartTick.value++;
      _updateProxyNow();
    }
  }

  Future<void> _updateProxyNow() async {
    if (AppLifecycleStateNofity.isPaused()) {
      return;
    }
    if (_proxyNowUpdating) {
      return;
    }
    _proxyNowUpdating = true;

    try {
      if (_state == FlutterVpnServiceState.connected) {
        final result = await ClashHttpApi.getNowProxy(
          ClashSettingManager.getConfig().Mode ?? ClashConfigsMode.rule.name,
        );
        if (result.error == null && result.data != null && result.data!.isNotEmpty) {
          _proxyNow.value = result.data!.first.name;
          _proxyNowUpdating = false;
          return;
        }
      }

      // Offline / disconnected fallback: load selected node from current profile
      final offlineNodes = await ProxyNodeLoader.loadCurrentProfileNodes();
      if (offlineNodes.isNotEmpty) {
        // Look for proxy group with 'now' or first proxy
        final groupWithSelection = offlineNodes.firstWhere(
          (n) => n.now.isNotEmpty,
          orElse: () => offlineNodes.first,
        );
        if (groupWithSelection.now.isNotEmpty) {
          _proxyNow.value = groupWithSelection.now;
        } else if (groupWithSelection.name.isNotEmpty) {
          _proxyNow.value = groupWithSelection.name;
        }
      }
    } catch (_) {
      // keep current or fallback
    } finally {
      _proxyNowUpdating = false;
    }
  }

  Future<void> _onTapRules() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: RulesScreen.routSettings(),
        builder: (context) => const RulesScreen(),
      ),
    );
  }

  Future<void> _onTapLogs() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: LogsScreen.routSettings(),
        builder: (context) => const LogsScreen(),
      ),
    );
  }

  Future<void> _onTapRunTimeProfile() async {
    final tcontext = Translations.of(context);
    String? content;
    try {
      final runtimePath = await PathUtils.serviceCoreRuntimeProfileFilePath();
      final runtimeFile = File(runtimePath);
      if (await runtimeFile.exists()) {
        final text = await runtimeFile.readAsString();
        if (text.trim().isNotEmpty) {
          content = text;
        }
      }

      if (content == null) {
        final patchFinalPath = await PathUtils.serviceCorePatchFinalPath();
        final patchFinalFile = File(patchFinalPath);
        if (await patchFinalFile.exists()) {
          final text = await patchFinalFile.readAsString();
          if (text.trim().isNotEmpty) {
            content = text;
          }
        }
      }

      if (content == null) {
        final currentProfile = ProfileManager.getCurrent();
        if (currentProfile != null) {
          final profileDir = await PathUtils.profilesDir();
          final profileFile = File(path.join(profileDir, currentProfile.id));
          if (await profileFile.exists()) {
            final text = await profileFile.readAsString();
            if (text.trim().isNotEmpty) {
              content = text;
            }
          }
        }
      }
    } catch (err) {
      Log.w("Read runtime profile exception: $err");
    }

    if (!mounted) {
      return;
    }

    if (content == null || content.trim().isEmpty) {
      DialogUtils.showAlertDialog(
        context,
        tcontext.meta.noProfilesYet,
        showCopy: false,
        showFAQ: false,
        withVersion: false,
      );
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: FileViewScreen.routSettings(),
        builder: (context) => FileViewScreen(
          title: tcontext.meta.runtimeProfile,
          content: content!,
        ),
      ),
    );
  }

  Future<void> _onTapNetCheck() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: NetCheckScreen.routSettings(),
        builder: (context) => const NetCheckScreen(),
      ),
    );
  }

  Future<void> _onTapSpeedTest() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: SpeedTestScreen.routSettings(),
        builder: (context) => const SpeedTestScreen(),
      ),
    );
  }
}

/// Backward-compatible alias for [SettingsScreen].
/// Settings screen logic is now cleanly isolated in `lib/screens/settings_screen.dart`.
typedef HomeScreenWidgetPart2 = SettingsScreen;

