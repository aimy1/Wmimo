// ignore_for_file: prefer_interpolation_to_compose_strings, use_build_context_synchronously, empty_catches, unused_catch_stack

import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/auto_update_manager.dart';
import 'package:wmimo/app/modules/biz.dart';
import 'package:wmimo/app/modules/remote_config_manager.dart';
import 'package:wmimo/app/utils/app_lifecycle_state_notify.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/error_reporter_utils.dart';
import 'package:wmimo/app/utils/local_storage.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/mobile_permission_helper.dart';
import 'package:wmimo/app/utils/system_scheme_utils.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/home_screen_widgets.dart';
import 'package:wmimo/screens/connections_screen.dart';
import 'package:wmimo/screens/language_settings_screen.dart';
import 'package:wmimo/screens/profiles_board_screen.dart';
import 'package:wmimo/screens/proxy_board_screen.dart';
import 'package:wmimo/screens/scheme_handler.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/themes.dart';
import 'package:wmimo/screens/user_agreement_screen.dart';
import 'package:wmimo/screens/webview_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:libclash_vpn_service/state.dart';
import 'package:protocol_handler/protocol_handler.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

class HomeScreen extends StatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "/");
  }

  final String launchUrl;
  const HomeScreen({super.key, required this.launchUrl});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with WidgetsBindingObserver, ProtocolListener, AfterLayoutMixin {
  static const String userAgreementAgreedIdKey = 'userAgreementAgreedKey';

  bool _onInitAllFinished = false;
  String _initUrl = "";
  int _currentNavIndex = 0;
  FlutterVpnServiceState _vpnState = FlutterVpnServiceState.disconnected;
  final List<GlobalKey<NavigatorState>> _navigatorKeys = List.generate(
    5,
    (_) => GlobalKey<NavigatorState>(),
  );
  late final List<Widget> _tabPages;

  @override
  void initState() {
    super.initState();

    _tabPages = [
      _TabNavigator(
        navigatorKey: _navigatorKeys[0],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                HomeScreenWidgetPart1(
                  onNavigateToTab: (index) {
                    setState(() {
                      _currentNavIndex = index;
                    });
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      _TabNavigator(
        navigatorKey: _navigatorKeys[1],
        child: const ProxyBoardScreen(),
      ),
      _TabNavigator(
        navigatorKey: _navigatorKeys[2],
        child: const ProfilesBoardScreen(),
      ),
      _TabNavigator(
        navigatorKey: _navigatorKeys[3],
        child: const ConnectionsScreen(),
      ),
      _TabNavigator(
        navigatorKey: _navigatorKeys[4],
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: const [
                HomeScreenWidgetPart2(),
                SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    ];

    WidgetsBinding.instance.addObserver(this);
    protocolHandler.addListener(this);
    Biz.onEventSingletonInstance = (String url) {
      Log.w("onEventSingletonInstance: $url");
      if (!mounted) {
        return;
      }
      SchemeHandler.handle(context, url);
    };
    _initUrl = widget.launchUrl;
    _init();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    Biz.initHomeFinish();
    MobilePermissionHelper.requestInitialPermissions();
    ErrorReporterUtils.register(() {
      if (!mounted) {
        return;
      }
      final tcontext = Translations.of(context);
      DialogUtils.showAlertDialog(
        context,
        tcontext.meta.deviceNoSpace,
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
    });

    Future.delayed(const Duration(seconds: 0), () async {
      showAgreement();
    });

    Future.delayed(const Duration(seconds: 0), () async {
      if (Platform.isMacOS) {
        await hotKeyManager.unregisterAll();
        HotKey hotKey = HotKey(
          key: PhysicalKeyboardKey.keyW,
          modifiers: [HotKeyModifier.meta],
          scope: HotKeyScope.inapp,
        );
        await hotKeyManager.register(
          hotKey,
          keyDownHandler: (hotKey) {
            windowManager.hide();
          },
        );
      }
    });
  }

  Future<bool> futureBool(bool value) async {
    return value;
  }

  void showAgreement() async {
    String? agreement;
    try {
      if (Platform.isIOS || Platform.isMacOS) {
        agreement = await LocalStorage.read(userAgreementAgreedIdKey);
      } else {
        agreement = "true";
      }
    } catch (e) {}

    if (agreement != null) {
      return;
    }
    if (Platform.isIOS || Platform.isMacOS) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          settings: UserAgreementScreen.routSettings(),
          fullscreenDialog: true,
          builder: (context) => const UserAgreementScreen(),
        ),
      );
      LocalStorage.write(userAgreementAgreedIdKey, "true");
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: LanguageSettingsScreen.routSettings(),
        fullscreenDialog: true,
        builder: (context) => LanguageSettingsScreen(
          canPop: false,
          canGoBack: false,
          nextText: () {
            var tcontext = Translations.of(context);
            return tcontext.meta.done;
          },
        ),
      ),
    );
  }

  void _init() async {
    Biz.onEventInitAllFinish.add(() async {
      await _onInitAllFinish();
    });
  }

  Future<void> _onInitAllFinish() async {
    AutoUpdateManager.onEventCheck.add(() {
      setState(() {});
    });
    DialogUtils.faqCallback = (BuildContext context, String text) async {
      final tcontext = Translations.of(context);
      var remoteConfig = RemoteConfigManager.getConfig();
      await WebviewHelper.loadUrl(
        context,
        remoteConfig.faq,
        "faqCallback",
        title: tcontext.meta.faq,
      );
    };
    VPNService.onEventStateChanged.add(_onStateChanged);

    if (Platform.isWindows || Platform.isLinux) {
      final wmimoRegisterErr = await SystemSchemeUtils.register(
        SystemSchemeUtils.getWmimoScheme(),
      );
      if (wmimoRegisterErr != null) {
        Log.w("register wmimo scheme failed: $wmimoRegisterErr");
      }

      final clashRegisterErr = await SystemSchemeUtils.register(
        SystemSchemeUtils.getClashScheme(),
      );
      if (clashRegisterErr != null) {
        Log.w("register clash scheme failed: $clashRegisterErr");
      }
    }

    _onInitAllFinished = true;

    setState(() {});

    if (_initUrl.isNotEmpty) {
      await SchemeHandler.handle(context, _initUrl);
      _initUrl = "";
    }

    setState(() {});
  }

  Future<void> _onStateChanged(
    FlutterVpnServiceState state,
    Map<String, String> params,
  ) async {
    _vpnState = state;
    if (state == FlutterVpnServiceState.disconnected) {
      Biz.vpnStateChanged(false);
    } else if (state == FlutterVpnServiceState.connecting) {
    } else if (state == FlutterVpnServiceState.connected) {
      if (!AppLifecycleStateNofity.isPaused()) {}

      Biz.vpnStateChanged(true);
    } else if (state == FlutterVpnServiceState.reasserting) {
    } else if (state == FlutterVpnServiceState.disconnecting) {
    } else {}

    setState(() {});
  }

  @override
  void onProtocolUrlReceived(String url) {
    Log.i("onProtocolUrlReceived: $url");
    if (!mounted) {
      return;
    }
    if (!_onInitAllFinished) {
      _initUrl = url;
      return;
    }
    SchemeHandler.handle(context, url);
  }

  @override
  void dispose() {
    protocolHandler.removeListener(this);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _currentNavIndex == index;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: isSelected
            ? ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.2 : 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (_currentNavIndex == index) {
              final navState = _navigatorKeys[index].currentState;
              if (navState != null) {
                try {
                  if (navState.canPop()) {
                    navState.popUntil((route) => route.isFirst);
                  }
                } catch (_) {}
              }
            } else {
              setState(() {
                _currentNavIndex = index;
              });
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected
                      ? ThemeDefine.kColorBlue
                      : theme.colorScheme.onSurface.withValues(alpha: 0.65),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? ThemeDefine.kColorBlue
                          : theme.colorScheme.onSurface.withValues(alpha: 0.85),
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 3.5,
                    height: 16,
                    decoration: BoxDecoration(
                      color: ThemeDefine.kColorBlue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarFooter(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final connected = _vpnState == FlutterVpnServiceState.connected;
    final connecting = _vpnState == FlutterVpnServiceState.connecting ||
        _vpnState == FlutterVpnServiceState.disconnecting ||
        _vpnState == FlutterVpnServiceState.reasserting;

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
      child: Material(
        color: isDark
            ? const Color(0xFF151D2E)
            : const Color(0xFFE2E8F0).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            if (connecting) return;
            if (connected) {
              VpnActionHandler.vpnDisconnect?.call("sidebar", false);
            } else {
              VpnActionHandler.vpnConnect?.call("sidebar", false);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.4),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: connected
                        ? ThemeDefine.kColorGreenBright
                        : const Color(0xFF94A3B8),
                    shape: BoxShape.circle,
                    boxShadow: connected
                        ? [
                            BoxShadow(
                              color: ThemeDefine.kColorGreenBright
                                  .withValues(alpha: 0.5),
                              blurRadius: 6,
                              spreadRadius: 1.5,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    connecting
                        ? tcontext.meta.connecting
                        : (connected
                            ? tcontext.meta.connected
                            : tcontext.meta.disconnected),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Icon(
                  connected
                      ? Icons.power_settings_new_rounded
                      : Icons.play_arrow_rounded,
                  size: 16,
                  color: connected
                      ? ThemeDefine.kColorGreenBright
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    final tcontext = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final navItems = [
      (
        index: 0,
        icon: Icons.dashboard_outlined,
        selectedIcon: Icons.dashboard_rounded,
        label: tcontext.meta.overview,
      ),
      (
        index: 1,
        icon: Icons.alt_route_outlined,
        selectedIcon: Icons.alt_route_rounded,
        label: tcontext.meta.proxy,
      ),
      (
        index: 2,
        icon: Icons.dns_outlined,
        selectedIcon: Icons.dns_rounded,
        label: tcontext.meta.myProfiles,
      ),
      (
        index: 3,
        icon: Icons.hub_outlined,
        selectedIcon: Icons.hub_rounded,
        label: tcontext.meta.connections,
      ),
      (
        index: 4,
        icon: Icons.tune_outlined,
        selectedIcon: Icons.tune_rounded,
        label: tcontext.meta.settingApp,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E8F0),
            width: 0.8,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: navItems.map((item) {
              final isSelected = _currentNavIndex == item.index;
              return Expanded(
                child: InkWell(
                  onTap: () {
                    if (_currentNavIndex == item.index) {
                      final navState =
                          _navigatorKeys[item.index].currentState;
                      if (navState != null) {
                        try {
                          if (navState.canPop()) {
                            navState.popUntil((route) => route.isFirst);
                          }
                        } catch (_) {}
                      }
                    } else {
                      setState(() {
                        _currentNavIndex = item.index;
                      });
                    }
                  },
                  splashColor: ThemeDefine.kColorBlue.withValues(alpha: 0.1),
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSelected ? 16 : 0,
                          vertical: 3.5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeDefine.kColorBlue
                                  .withValues(alpha: isDark ? 0.22 : 0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          isSelected ? item.selectedIcon : item.icon,
                          size: 21,
                          color: isSelected
                              ? ThemeDefine.kColorBlue
                              : (isDark
                                  ? const Color(0xFF64748B)
                                  : const Color(0xFF64748B)),
                        ),
                      ),
                      const SizedBox(height: 2.5),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? ThemeDefine.kColorBlue
                              : (isDark
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF64748B)),
                          letterSpacing: -0.2,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var themes = Provider.of<Themes>(context, listen: false);
    final tcontext = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 640;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarIconBrightness: themes
                .getStatusBarIconBrightness(context),
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarDividerColor: Colors.transparent,
            statusBarBrightness: themes.getStatusBarBrightness(context),
            statusBarIconBrightness: themes.getStatusBarIconBrightness(context),
          ),
        ),
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final currentNavigator =
              _navigatorKeys[_currentNavIndex].currentState;
          if (currentNavigator != null && currentNavigator.canPop()) {
            currentNavigator.pop();
          }
        },
        child: SafeArea(
          child: isDesktop
              ? Row(
                  children: [
                    // Left Sidebar Navigation (Clash Verge Style)
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF0F172A)
                            : const Color(0xFFF1F5F9),
                        border: Border(
                          right: BorderSide(
                            color: Theme.of(context)
                                .dividerColor
                                .withValues(alpha: 0.5),
                            width: 0.8,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 14),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/app_icon_128.png',
                                    width: 28,
                                    height: 28,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppUtils.getName(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      Text(
                                        'v${AppUtils.getBuildinVersion().split('.').take(3).join('.')}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.45),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1, thickness: 0.8),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              children: [
                                _buildNavItem(
                                  context: context,
                                  index: 0,
                                  icon: Icons.dashboard_rounded,
                                  label: tcontext.meta.overview,
                                ),
                                _buildNavItem(
                                  context: context,
                                  index: 1,
                                  icon: Icons.alt_route_rounded,
                                  label: tcontext.meta.proxy,
                                ),
                                _buildNavItem(
                                  context: context,
                                  index: 2,
                                  icon: Icons.dns_rounded,
                                  label: tcontext.meta.myProfiles,
                                ),
                                _buildNavItem(
                                  context: context,
                                  index: 3,
                                  icon: Icons.hub_outlined,
                                  label: tcontext.meta.connections,
                                ),
                                _buildNavItem(
                                  context: context,
                                  index: 4,
                                  icon: Icons.tune_rounded,
                                  label: tcontext.meta.settingApp,
                                ),
                              ],
                            ),
                          ),
                          _buildSidebarFooter(context),
                        ],
                      ),
                    ),
                    // Right Main Workspace
                    Expanded(
                      child: IndexedStack(
                        index: _currentNavIndex,
                        children: _tabPages,
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/app_icon_128.png',
                              width: 26,
                              height: 26,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppUtils.getName(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: IndexedStack(
                        index: _currentNavIndex,
                        children: _tabPages,
                      ),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: !isDesktop ? _buildBottomNavBar(context) : null,
    );
  }
}

class _TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Widget child;

  const _TabNavigator({
    required this.navigatorKey,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateInitialRoutes: (NavigatorState navigator, String initialRoute) {
        return [
          MaterialPageRoute(
            builder: (context) => child,
          ),
        ];
      },
    );
  }
}
