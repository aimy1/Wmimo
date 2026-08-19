import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/proxy_board_screen_widgets.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:libclash_vpn_service/state.dart';

class ProxyBoardScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "/");
  }

  const ProxyBoardScreen({super.key});

  @override
  State<ProxyBoardScreen> createState() => _ProxyBoardScreenState();
}

class _ProxyBoardScreenState extends LasyRenderingState<ProxyBoardScreen>
    with WidgetsBindingObserver, AfterLayoutMixin {
  late ProxyScreenProxiesNodeWidgetController _controller;

  @override
  void initState() {
    _controller = ProxyScreenProxiesNodeWidgetController(
      onTesting: () {
        if (!mounted) {
          return;
        }
        setState(() {});
      },
    );
    VPNService.onEventStateChanged.add(_onVpnStateChanged);
    ProfileManager.onEventCurrentChanged.add(_onProfileChanged);
    super.initState();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {}

  @override
  void dispose() {
    VPNService.onEventStateChanged.remove(_onVpnStateChanged);
    ProfileManager.onEventCurrentChanged.remove(_onProfileChanged);
    SettingManager.save();
    super.dispose();
  }

  Future<void> _onVpnStateChanged(
    FlutterVpnServiceState state,
    Map<String, String> params,
  ) async {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onProfileChanged(String id) async {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    Size windowSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (Navigator.canPop(context))
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 40,
                          height: 30,
                          child: Icon(Icons.arrow_back_ios_outlined, size: 24),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        tcontext.meta.proxy,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                    Tooltip(
                      message: tcontext.meta.sort,
                      child: SizedBox(
                        width: 40,
                        height: 30,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          child: Icon(
                            Icons.sort,
                            size: 24,
                            color: SettingManager.getConfig().ui.delayTestSort
                                ? ThemeDefine.kColorBlue
                                : null,
                          ),
                          onTap: () {
                            SettingManager.getConfig().ui.delayTestSort =
                                !SettingManager.getConfig().ui.delayTestSort;
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                    _controller.delayTesting() != 0
                        ? Row(
                            children: [
                              const SizedBox(width: 8),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: RepaintBoundary(
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2.5),
                                    ),
                                  ),
                                  Text(
                                    _controller.delayTesting().toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize:
                                          _controller.delayTesting() > 999
                                              ? 8
                                              : 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 8),
                            ],
                          )
                        : Tooltip(
                            message: tcontext.meta.latencyTest,
                            child: SizedBox(
                              width: 40,
                              height: 30,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                child: const Icon(Icons.bolt, size: 26),
                                onTap: () async {
                                  await onTapTestDelay();
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: FutureBuilder(
                    future: getProxies(),
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<List<ClashProxiesNode>> snapshot,
                        ) {
                          List<ClashProxiesNode> data = snapshot.hasData
                              ? snapshot.data!
                              : [];
                          return data.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.alt_route_rounded,
                                        size: 48,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withValues(alpha: 0.3),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        tcontext.meta.none,
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface
                                              .withValues(alpha: 0.5),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ProxyScreenProxiesNodeWidget(
                                  nodes: data,
                                  controller: _controller,
                                );
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

  Future<List<ClashProxiesNode>> getProxies() async {
    var result = await ClashHttpApi.getProxies();
    if (result.error == null) {
      return result.data!;
    }

    return [];
  }

  Future<void> onTapTestDelay() async {
    return _controller.delayTest();
  }
}
