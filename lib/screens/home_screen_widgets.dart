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

class TrafficWaveChartPainter extends CustomPainter {
  final List<double> downloadHistory;
  final List<double> uploadHistory;
  final Color downloadColor;
  final Color uploadColor;
  final bool isDark;

  TrafficWaveChartPainter({
    required this.downloadHistory,
    required this.uploadHistory,
    required this.downloadColor,
    required this.uploadColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (downloadHistory.isEmpty && uploadHistory.isEmpty) return;

    double maxVal = 1024 * 10; // minimum scale: 10 KB/s
    for (var v in downloadHistory) {
      if (v > maxVal) maxVal = v;
    }
    for (var v in uploadHistory) {
      if (v > maxVal) maxVal = v;
    }

    // Grid lines
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05)
      ..strokeWidth = 0.8;
    canvas.drawLine(
      Offset(0, size.height * 0.33),
      Offset(size.width, size.height * 0.33),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.66),
      Offset(size.width, size.height * 0.66),
      gridPaint,
    );

    _drawLineAndFill(canvas, size, downloadHistory, maxVal, downloadColor);
    _drawLineAndFill(canvas, size, uploadHistory, maxVal, uploadColor);
  }

  void _drawLineAndFill(
    Canvas canvas,
    Size size,
    List<double> history,
    double maxVal,
    Color color,
  ) {
    if (history.length < 2) return;

    final stepX = size.width / (history.length - 1);
    final path = Path();
    final fillPath = Path();

    double getY(double val) {
      final ratio = (val / maxVal).clamp(0.0, 1.0);
      return size.height - (ratio * (size.height - 4)) - 2;
    }

    path.moveTo(0, getY(history.first));
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(0, getY(history.first));

    for (int i = 1; i < history.length; i++) {
      final prevX = (i - 1) * stepX;
      final prevY = getY(history[i - 1]);
      final currX = i * stepX;
      final currY = getY(history[i]);

      final midX = (prevX + currX) / 2;
      path.cubicTo(midX, prevY, midX, currY, currX, currY);
      fillPath.cubicTo(midX, prevY, midX, currY, currX, currY);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Fill gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: isDark ? 0.28 : 0.18),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Stroke line
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant TrafficWaveChartPainter oldDelegate) => true;
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
  Timer? _timerStateChecker;
  Timer? _timerConnectToCore;
  QuickActions? _quickActions;
  bool _quickActionWorking = false;

  final ValueNotifier<String> _trafficSpeed = ValueNotifier<String>(_kNoSpeed);
  final ValueNotifier<String> _trafficTotal = ValueNotifier<String>(
    _kNoTrafficTotal,
  );
  final ValueNotifier<num> _uploadSpeedRaw = ValueNotifier<num>(0);
  final ValueNotifier<num> _downloadSpeedRaw = ValueNotifier<num>(0);
  final ValueNotifier<num> _uploadTotalRaw = ValueNotifier<num>(0);
  final ValueNotifier<num> _downloadTotalRaw = ValueNotifier<num>(0);
  final ValueNotifier<num> _memoryRaw = ValueNotifier<num>(0);
  final List<double> _uploadHistory = List<double>.filled(30, 0.0);
  final List<double> _downloadHistory = List<double>.filled(30, 0.0);
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
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        // 流量统计卡片
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 标题栏与实时状态
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: ThemeDefine.kColorBlue.withValues(
                              alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.1,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.auto_graph_rounded,
                            size: 18,
                            color: ThemeDefine.kColorBlue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '流量统计',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ValueListenableBuilder<num>(
                          valueListenable: _memoryRaw,
                          builder: (context, mem, _) {
                            if (mem <= 0 || !connected) return const SizedBox.shrink();
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: (Theme.of(context).brightness == Brightness.dark
                                        ? const Color(0xFF1E293B)
                                        : const Color(0xFFE2E8F0))
                                    .withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '内存: ${ClashHttpApi.convertTrafficToStringDouble(mem)}',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.65),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                          decoration: BoxDecoration(
                            color: connected
                                ? ThemeDefine.kColorGreenBright.withValues(
                                    alpha: Theme.of(context).brightness == Brightness.dark ? 0.15 : 0.1,
                                  )
                                : (Theme.of(context).brightness == Brightness.dark
                                    ? const Color(0xFF1E293B)
                                    : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: connected
                                  ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.3)
                                  : Theme.of(context).dividerColor.withValues(alpha: 0.3),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: connected
                                      ? ThemeDefine.kColorGreenBright
                                      : const Color(0xFF94A3B8),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                connected ? '实时监控' : '未连接',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: connected
                                      ? ThemeDefine.kColorGreenBright
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // 实时流量波形图
                Container(
                  height: 68,
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF0F172A).withValues(alpha: 0.7)
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
                      width: 0.8,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: ValueListenableBuilder<num>(
                      valueListenable: _downloadSpeedRaw,
                      builder: (context, _, __) {
                        return CustomPaint(
                          painter: TrafficWaveChartPainter(
                            downloadHistory: _downloadHistory,
                            uploadHistory: _uploadHistory,
                            downloadColor: const Color(0xFF10B981),
                            uploadColor: const Color(0xFF3B82F6),
                            isDark: Theme.of(context).brightness == Brightness.dark,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // 4 个指标小卡片
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<num>(
                        valueListenable: _uploadSpeedRaw,
                        builder: (context, value, _) {
                          return _buildTrafficTile(
                            context: context,
                            icon: Icons.arrow_upward_rounded,
                            iconColor: const Color(0xFF3B82F6),
                            label: '实时上传',
                            value: '${ClashHttpApi.convertTrafficToStringDouble(value)}/s',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ValueListenableBuilder<num>(
                        valueListenable: _downloadSpeedRaw,
                        builder: (context, value, _) {
                          return _buildTrafficTile(
                            context: context,
                            icon: Icons.arrow_downward_rounded,
                            iconColor: const Color(0xFF10B981),
                            label: '实时下载',
                            value: '${ClashHttpApi.convertTrafficToStringDouble(value)}/s',
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ValueListenableBuilder<num>(
                        valueListenable: _uploadTotalRaw,
                        builder: (context, value, _) {
                          return _buildTrafficTile(
                            context: context,
                            icon: Icons.cloud_upload_outlined,
                            iconColor: const Color(0xFF8B5CF6),
                            label: '本次上传',
                            value: ClashHttpApi.convertTrafficToStringDouble(value),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ValueListenableBuilder<num>(
                        valueListenable: _downloadTotalRaw,
                        builder: (context, value, _) {
                          return _buildTrafficTile(
                            context: context,
                            icon: Icons.cloud_download_outlined,
                            iconColor: const Color(0xFF06B6D4),
                            label: '本次下载',
                            value: ClashHttpApi.convertTrafficToStringDouble(value),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                // 订阅套餐流量进度
                if (currentProfile != null && currentProfile.isRemote() && currentProfile.total > 0) ...[
                  const SizedBox(height: 10),
                  _buildSubscriptionQuotaSection(
                    context: context,
                    profile: currentProfile,
                    expireInfo: tranfficExpire,
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

  Widget _buildTrafficTile({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0F172A).withValues(alpha: 0.6)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.3),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: isDark ? 0.2 : 0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionQuotaSection({
    required BuildContext context,
    required ProfileSetting profile,
    required Tuple2<bool, String>? expireInfo,
  }) {
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

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF151D2E)
            : const Color(0xFFF1F5F9).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.pie_chart_outline_rounded,
                    size: 15,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '套餐用量: $usedStr / $totalStr (剩余 $remainingStr)',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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
          if (expireInfo != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.event_outlined,
                  size: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 5),
                Text(
                  '到期时间: ${expireInfo.item2}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: expireInfo.item1
                        ? Colors.red
                        : theme.colorScheme.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ],
        ],
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
      _uploadHistory.removeAt(0);
      _uploadHistory.add(traffic.upload.toDouble());
      _downloadHistory.removeAt(0);
      _downloadHistory.add(traffic.download.toDouble());
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
      _uploadSpeedRaw.value = 0;
      _downloadSpeedRaw.value = 0;
      _uploadTotalRaw.value = 0;
      _downloadTotalRaw.value = 0;
      _memoryRaw.value = 0;
      _uploadHistory.fillRange(0, _uploadHistory.length, 0.0);
      _downloadHistory.fillRange(0, _downloadHistory.length, 0.0);
      Biz.trafficChanged("", "");
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

    // Group 3: Help
    final helpItems = [
      ListTile(
        title: Text(tcontext.meta.help),
        leading: const Icon(Icons.help_outline_rounded, size: 22),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
        minVerticalPadding: 16,
        onTap: () async {
          await GroupHelper.showHelp(context);
        },
      ),
    ];

    return Column(
      children: [
        _buildSectionCard(context: context, items: coreItems),
        _buildSectionCard(context: context, items: dataItems),
        _buildSectionCard(context: context, items: helpItems),
      ],
    );
  }
}
