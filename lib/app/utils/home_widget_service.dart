// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:libclash_vpn_service/state.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/biz.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_lifecycle_state_notify.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/node_region_helper.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';
import 'package:wmimo/i18n/strings.g.dart';

@immutable
class WmimoWidgetNodeItem {
  final String name;
  final String displayName;
  final int? delay;
  final bool selected;

  const WmimoWidgetNodeItem({
    required this.name,
    String? displayName,
    this.delay,
    this.selected = false,
  }) : displayName = displayName ?? name;

  Map<String, dynamic> toJson() => {
    'name': name,
    'displayName': displayName,
    'delay': delay,
    'selected': selected,
  };

  factory WmimoWidgetNodeItem.fromJson(Map<String, dynamic> json) {
    final rawDelay = json['delay'];
    final rawName = json['name']?.toString() ?? '';
    final rawDisplay = json['displayName']?.toString() ?? '';
    return WmimoWidgetNodeItem(
      name: rawName,
      displayName: rawDisplay.isNotEmpty ? rawDisplay : rawName,
      delay: rawDelay is num && rawDelay > 0 ? rawDelay.toInt() : null,
      selected: json['selected'] == true,
    );
  }
}

@immutable
class WmimoWidgetProfileItem {
  final String id;
  final String name;
  final bool selected;

  const WmimoWidgetProfileItem({
    required this.id,
    required this.name,
    this.selected = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'selected': selected,
  };

  factory WmimoWidgetProfileItem.fromJson(Map<String, dynamic> json) {
    return WmimoWidgetProfileItem(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      selected: json['selected'] == true,
    );
  }
}

@immutable
class WmimoWidgetCommand {
  final String action;
  final String? profileId;
  final String? groupName;
  final String? nodeName;
  final String? mode;
  final String? tab;
  final bool background;

  const WmimoWidgetCommand({
    required this.action,
    this.profileId,
    this.groupName,
    this.nodeName,
    this.mode,
    this.tab,
    this.background = false,
  });
}

class HomeWidgetService {
  static const MethodChannel _channel = MethodChannel('com.wmimo.app/widget');
  static const Duration _trafficThrottleInterval = Duration(seconds: 3);
  static const Duration _nodesRefreshInterval = Duration(seconds: 12);

  static bool _initialized = false;
  static String _actionToken = '';
  static String get actionToken => _actionToken;

  @visibleForTesting
  static set debugActionToken(String token) {
    _actionToken = token;
  }

  static FlutterVpnServiceState _vpnState = FlutterVpnServiceState.disconnected;
  static String _currentNode = '';
  static String _groupName = '';
  static int? _currentDelay;
  static num _upSpeed = 0;
  static num _downSpeed = 0;
  static num _upTotal = 0;
  static num _downTotal = 0;

  static List<WmimoWidgetNodeItem> _cachedNodes = const [];
  static DateTime _lastTrafficPushTime = DateTime.fromMillisecondsSinceEpoch(0);
  static DateTime _lastNodesRefreshTime = DateTime.fromMillisecondsSinceEpoch(0);
  static bool _isRefreshingNodes = false;
  static String _lastPushedJson = '';

  /// Optional callback registered by [HomeScreen] to switch bottom/side nav tabs
  static void Function(int tabIndex)? onNavigateToTab;

  static bool get _isMobilePlatform =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Formats a proxy node name with its region flag if not already prefixed.
  static String formatNodeDisplayName(String rawName) {
    final trimmed = rawName.trim();
    if (trimmed.isEmpty) return '';
    final region = NodeRegionHelper.getRegion(trimmed);
    if (region.code == 'OTHER' || region.code == 'ALL' || region.flag.isEmpty) {
      return trimmed;
    }
    final clean = NodeRegionHelper.getDisplayNameWithoutFlag(trimmed);
    return '${region.flag} $clean';
  }

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    if (_isMobilePlatform) {
      _channel.setMethodCallHandler(_onMethodCall);
      try {
        final token = await _channel.invokeMethod<String>('getWidgetToken');
        if (token != null && token.isNotEmpty) {
          _actionToken = token;
        }
      } catch (_) {}
    }

    if (_actionToken.isEmpty) {
      _actionToken = _generateFallbackToken();
    }

    if (!VPNService.onEventStateChanged.contains(_onVpnStateChanged)) {
      VPNService.onEventStateChanged.add(_onVpnStateChanged);
    }
    if (!ClashSettingManager.onEventModeChanged.contains(_onModeChanged)) {
      ClashSettingManager.onEventModeChanged.add(_onModeChanged);
    }
    if (!ProfileManager.onEventCurrentChanged.contains(_onProfileChanged)) {
      ProfileManager.onEventCurrentChanged.add(_onProfileChanged);
    }
    if (!ProfileManager.onEventAdd.contains(_onProfileChanged)) {
      ProfileManager.onEventAdd.add(_onProfileChanged);
    }
    if (!ProfileManager.onEventRemove.contains(_onProfileChanged)) {
      ProfileManager.onEventRemove.add(_onProfileChanged);
    }
    if (!ProfileManager.onEventUpdate.contains(_onProfileUpdated)) {
      ProfileManager.onEventUpdate.add(_onProfileUpdated);
    }
    if (!Biz.onEventProxySelected.contains(_onProxySelected)) {
      Biz.onEventProxySelected.add(_onProxySelected);
    }
    if (!Biz.onEventInitAllFinish.contains(_onInitAllFinished)) {
      Biz.onEventInitAllFinish.add(_onInitAllFinished);
    }
    AppLifecycleStateNofity.onStateResumed(
      identityHashCode(HomeWidgetService),
      _onAppResumed,
    );
    AppLifecycleStateNofity.onStatePaused(
      identityHashCode(HomeWidgetService),
      _onAppPaused,
    );

    unawaited(refreshNodesAndSync(forceReload: true));
  }

  static String _generateFallbackToken() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(16, (_) => rnd.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  static void _onInitAllFinished() {
    unawaited(_consumePendingNativeActions());
    unawaited(refreshNodesAndSync(forceReload: true));
  }

  static void _onVpnStateChanged(
    FlutterVpnServiceState state,
    Map<String, String> params,
  ) {
    _vpnState = state;
    if (state == FlutterVpnServiceState.disconnected) {
      _upSpeed = 0;
      _downSpeed = 0;
      _upTotal = 0;
      _downTotal = 0;
      unawaited(refreshNodesAndSync(forceReload: true));
    } else if (state == FlutterVpnServiceState.connected) {
      unawaited(_applyOfflineWidgetOverridesOnConnect());
    } else {
      unawaited(syncNow(forceReload: true));
    }
  }

  /// Applies any node or mode selected on the widget while VPN was offline
  /// right as the core finishes connecting.
  static Future<void> _applyOfflineWidgetOverridesOnConnect() async {
    if (_isMobilePlatform) {
      try {
        final rawOverrides = await _channel
            .invokeMethod<Map<dynamic, dynamic>>('consumeNativeOverrides');
        if (rawOverrides != null && rawOverrides.isNotEmpty) {
          final modeStr = rawOverrides['mode']?.toString();
          final parsedMode = parseMode(modeStr);
          if (parsedMode != null) {
            await ClashSettingManager.setConfigsMode(parsedMode);
          }

          final nodeStr = rawOverrides['currentNode']?.toString() ?? '';
          if (nodeStr.isNotEmpty) {
            final group = _groupName.isNotEmpty ? _groupName : '节点选择';
            await ClashHttpApi.setProxiesNode(group, nodeStr);
            if (group != 'GLOBAL') {
              unawaited(
                ClashHttpApi.setProxiesNode('GLOBAL', nodeStr)
                    .catchError((_) => null),
              );
            }
            _currentNode = nodeStr;
            Biz.proxySelected(nodeStr);
          }
        }
      } catch (_) {}
    }
    await refreshNodesAndSync(forceReload: true);
  }

  static void _onModeChanged() {
    unawaited(refreshNodesAndSync(forceReload: true));
  }

  static void _onProfileChanged(String _) {
    _lastNodesRefreshTime = DateTime.fromMillisecondsSinceEpoch(0);
    unawaited(refreshNodesAndSync(forceReload: true));
  }

  static void _onProfileUpdated(String _, bool finish) {
    if (finish) {
      _lastNodesRefreshTime = DateTime.fromMillisecondsSinceEpoch(0);
      unawaited(refreshNodesAndSync(forceReload: true));
    }
  }

  static void _onProxySelected(String nodeName) {
    if (nodeName.trim().isNotEmpty) {
      _currentNode = nodeName.trim();
      if (_cachedNodes.isNotEmpty) {
        _cachedNodes = _cachedNodes
            .map(
              (n) => WmimoWidgetNodeItem(
                name: n.name,
                displayName: n.displayName,
                delay: n.delay,
                selected: n.name == _currentNode,
              ),
            )
            .toList();
      }
    }
    _lastNodesRefreshTime = DateTime.fromMillisecondsSinceEpoch(0);
    unawaited(refreshNodesAndSync(forceReload: true));
  }

  static void _onAppResumed() {
    unawaited(syncFromNativeOnResume());
  }

  static void _onAppPaused() {
    unawaited(syncNow(forceReload: true));
  }

  /// Called by [HomeScreenWidgetPart1] whenever live traffic or active proxy updates.
  static void updateRealtimeMetrics({
    FlutterVpnServiceState? vpnState,
    String? currentNode,
    num? upSpeed,
    num? downSpeed,
    num? upTotal,
    num? downTotal,
    bool forceReload = false,
  }) {
    if (vpnState != null) _vpnState = vpnState;
    if (currentNode != null && currentNode.trim().isNotEmpty) {
      _currentNode = currentNode.trim();
    }
    if (upSpeed != null) _upSpeed = upSpeed;
    if (downSpeed != null) _downSpeed = downSpeed;
    if (upTotal != null) _upTotal = upTotal;
    if (downTotal != null) _downTotal = downTotal;

    final now = DateTime.now();
    if (!forceReload &&
        now.difference(_lastTrafficPushTime) < _trafficThrottleInterval) {
      return;
    }
    _lastTrafficPushTime = now;

    if (now.difference(_lastNodesRefreshTime) >= _nodesRefreshInterval &&
        !_isRefreshingNodes) {
      unawaited(refreshNodesAndSync(forceReload: forceReload));
    } else {
      unawaited(syncNow(forceReload: forceReload));
    }
  }

  /// Refreshes the primary selector group's candidate nodes and active node delay,
  /// then pushes the updated snapshot to native home-screen widgets.
  static Future<void> refreshNodesAndSync({bool forceReload = false}) async {
    if (_isRefreshingNodes) {
      await syncNow(forceReload: forceReload);
      return;
    }
    _isRefreshingNodes = true;
    try {
      _vpnState = await VPNService.getState();
      List<ClashProxiesNode> allNodes = [];
      if (_vpnState == FlutterVpnServiceState.connected) {
        final res = await ClashHttpApi.getProxies();
        if (res.error == null && res.data != null && res.data!.isNotEmpty) {
          allNodes = res.data!;
        }
      }
      if (allNodes.isEmpty) {
        allNodes = await ProxyNodeLoader.loadCurrentProfileNodes();
      }

      if (allNodes.isNotEmpty) {
        final groups = allNodes
            .where((n) => ClashProtocolType.isGroupType(n.type))
            .toList();
        ClashProxiesNode? primaryGroup =
            ClashHttpApi.findPrimaryRuleGroup(groups);
        for (final g in groups) {
          final upper = g.name.toUpperCase();
          if (upper == 'PROXY' ||
              upper == 'PROXIES' ||
              g.name == '节点选择' ||
              g.name == '節點選擇') {
            primaryGroup = g;
            break;
          }
        }
        primaryGroup ??= groups.isNotEmpty ? groups.first : null;

        if (primaryGroup != null) {
          _groupName = primaryGroup.name;
          if (primaryGroup.now.isNotEmpty) {
            _currentNode = primaryGroup.now;
          }

          final nodeMap = <String, ClashProxiesNode>{
            for (final n in allNodes) n.name: n,
          };

          // Resolve effective delay for active node (following group chain if needed)
          int? resolvedDelay = nodeMap[_currentNode]?.delay;
          if (resolvedDelay == null || resolvedDelay <= 0) {
            final chain = ClashHttpApi.getNowChain(
              allNodes,
              primaryGroup,
              ClashSettingManager.getConfigsMode().name,
            );
            for (final hop in chain) {
              if (hop.delay != null && hop.delay! > 0) {
                resolvedDelay = hop.delay;
                break;
              }
            }
          }
          _currentDelay =
              (resolvedDelay != null && resolvedDelay > 0) ? resolvedDelay : null;

          // Build up to 6 quick-switch candidate nodes from primaryGroup.all
          final candidates = <WmimoWidgetNodeItem>[];
          final seen = <String>{};
          final excludedUpper = {
            'DIRECT',
            'REJECT',
            'REJECT-DROP',
            'PASS',
            'COMPATIBLE',
            'GLOBAL',
          };

          for (final candidateName in primaryGroup.all) {
            final trimmed = candidateName.trim();
            if (trimmed.isEmpty || seen.contains(trimmed)) continue;
            if (excludedUpper.contains(trimmed.toUpperCase())) continue;
            seen.add(trimmed);
            final nodeObj = nodeMap[trimmed];
            final delay =
                (nodeObj?.delay != null && nodeObj!.delay! > 0)
                    ? nodeObj.delay
                    : null;
            candidates.add(
              WmimoWidgetNodeItem(
                name: trimmed,
                displayName: formatNodeDisplayName(trimmed),
                delay: delay,
                selected: trimmed == _currentNode,
              ),
            );
          }

          // Ensure currently active node is always visible within the top 6 slots
          if (_currentNode.isNotEmpty &&
              candidates.length > 6 &&
              !candidates.take(6).any((e) => e.name == _currentNode)) {
            final activeIdx =
                candidates.indexWhere((e) => e.name == _currentNode);
            if (activeIdx >= 6) {
              final activeItem = candidates.removeAt(activeIdx);
              candidates.insert(0, activeItem);
            }
          }

          _cachedNodes = candidates.take(6).toList();
        }
      } else {
        _cachedNodes = const [];
        _groupName = '';
        _currentDelay = null;
      }
      _lastNodesRefreshTime = DateTime.now();
    } catch (e) {
      Log.w('HomeWidgetService.refreshNodesAndSync error: $e');
    } finally {
      _isRefreshingNodes = false;
    }

    await syncNow(forceReload: forceReload);
  }

  /// Synchronizes the current widget state snapshot to Android SharedPreferences / iOS App Group.
  static Future<void> syncNow({bool forceReload = false}) async {
    if (!_isMobilePlatform) return;

    try {
      final snapshotMap = buildCurrentSnapshotMap();
      final jsonStr = jsonEncode(snapshotMap);

      // Avoid redundant non-forced IPC writes when nothing changed
      if (!forceReload && jsonStr == _lastPushedJson) {
        return;
      }
      _lastPushedJson = jsonStr;

      await _channel.invokeMethod('syncWidgetSnapshot', {
        'snapshot': jsonStr,
        'forceReload': forceReload,
      });
    } catch (e) {
      Log.w('HomeWidgetService.syncNow error: $e');
    }
  }

  /// Builds the full serializable widget snapshot map from current app state.
  static Map<String, dynamic> buildCurrentSnapshotMap() {
    final currentProfile = ProfileManager.getCurrent();
    final allProfiles = ProfileManager.getProfiles();
    final settings = SettingManager.getConfig();
    final mode = ClashSettingManager.getConfigsMode();
    final controlPort = ClashSettingManager.getControlPort();
    final controlSecret = ClashSettingManager.getConfig().Secret ?? '';

    String subExpire = '';
    num subUsed = 0;
    num subTotal = 0;
    if (currentProfile != null) {
      subUsed = currentProfile.upload + currentProfile.download;
      subTotal = currentProfile.total;
      if (currentProfile.isRemote() && currentProfile.expire.isNotEmpty) {
        subExpire = currentProfile.getExpireTime(settings.languageTag).item2;
      }
    }

    final profileItems = <WmimoWidgetProfileItem>[];
    for (final p in allProfiles) {
      profileItems.add(
        WmimoWidgetProfileItem(
          id: p.id,
          name: p.getShowName(),
          selected: currentProfile?.id == p.id,
        ),
      );
    }
    // Keep active profile within top 4
    if (currentProfile != null &&
        profileItems.length > 4 &&
        !profileItems.take(4).any((p) => p.id == currentProfile.id)) {
      final idx = profileItems.indexWhere((p) => p.id == currentProfile.id);
      if (idx >= 4) {
        final active = profileItems.removeAt(idx);
        profileItems.insert(0, active);
      }
    }

    return buildSnapshotMap(
      vpnState: _vpnState,
      mode: mode.name,
      profileId: currentProfile?.id ?? '',
      profileName: currentProfile?.getShowName() ?? '',
      groupName: _groupName,
      currentNode: _currentNode,
      currentDelay: _currentDelay,
      controlPort: controlPort,
      controlSecret: controlSecret,
      upSpeed: _upSpeed,
      downSpeed: _downSpeed,
      upTotal: _upTotal,
      downTotal: _downTotal,
      subUsed: subUsed,
      subTotal: subTotal,
      subExpire: subExpire,
      nodes: _cachedNodes,
      profiles: profileItems.take(4).toList(),
      actionToken: _actionToken,
      labels: buildLocalizedLabels(),
    );
  }

  /// Pure snapshot builder (directly unit-testable).
  static Map<String, dynamic> buildSnapshotMap({
    required FlutterVpnServiceState vpnState,
    required String mode,
    required String profileId,
    required String profileName,
    required String groupName,
    required String currentNode,
    required int? currentDelay,
    required int controlPort,
    required String controlSecret,
    required num upSpeed,
    required num downSpeed,
    required num upTotal,
    required num downTotal,
    required num subUsed,
    required num subTotal,
    required String subExpire,
    required List<WmimoWidgetNodeItem> nodes,
    required List<WmimoWidgetProfileItem> profiles,
    required String actionToken,
    required Map<String, String> labels,
  }) {
    final isConnected = vpnState == FlutterVpnServiceState.connected;
    final isTransitioning = vpnState == FlutterVpnServiceState.connecting ||
        vpnState == FlutterVpnServiceState.disconnecting ||
        vpnState == FlutterVpnServiceState.reasserting;

    return {
      'version': 1,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
      'connected': isConnected,
      'transitioning': isTransitioning,
      'vpnState': vpnState.name,
      'mode': mode.toLowerCase(),
      'profileId': profileId,
      'profileName': profileName,
      'groupName': groupName,
      'currentNode': currentNode,
      'currentNodeDisplay': formatNodeDisplayName(currentNode),
      'currentDelay': currentDelay,
      'controlPort': controlPort,
      'controlSecret': controlSecret,
      'upSpeed': upSpeed.toInt(),
      'downSpeed': downSpeed.toInt(),
      'upSpeedText': formatSpeed(upSpeed),
      'downSpeedText': formatSpeed(downSpeed),
      'upTotal': upTotal.toInt(),
      'downTotal': downTotal.toInt(),
      'upTotalText': formatBytes(upTotal),
      'downTotalText': formatBytes(downTotal),
      'sessionTotalText': formatBytes(upTotal + downTotal),
      'subUsed': subUsed.toInt(),
      'subTotal': subTotal.toInt(),
      'subUsedText': formatBytes(subUsed),
      'subTotalText': formatBytes(subTotal),
      'subRemainingText':
          subTotal > 0 ? formatBytes((subTotal - subUsed).clamp(0, subTotal)) : '',
      'subPercent':
          subTotal > 0 ? ((subUsed / subTotal).clamp(0.0, 1.0) * 100).round() : 0,
      'subExpire': subExpire,
      'actionToken': actionToken,
      'nodes': nodes.map((n) => n.toJson()).toList(),
      'profiles': profiles.map((p) => p.toJson()).toList(),
      'labels': labels,
    };
  }

  static Map<String, String> buildLocalizedLabels([Translations? translations]) {
    final tr = translations ?? t;
    return {
      'appName': 'Wmimo',
      'connected': tr.meta.connected,
      'connecting': tr.meta.connecting,
      'disconnected': tr.meta.disconnected,
      'statusTitle': tr.widget.statusTitle,
      'trafficTitle': tr.widget.trafficTitle,
      'quickSwitchTitle': tr.widget.quickSwitchTitle,
      'upload': tr.widget.upload,
      'download': tr.widget.download,
      'sessionTotal': tr.widget.sessionTotal,
      'quota': tr.widget.quota,
      'remaining': tr.widget.remaining,
      'noProfile': tr.widget.noProfile,
      'noNodes': tr.widget.noNodes,
      'tapToConnect': tr.widget.tapToConnect,
      'tapToDisconnect': tr.widget.tapToDisconnect,
      'modeRule': tr.widget.modeRule,
      'modeGlobal': tr.widget.modeGlobal,
      'modeDirect': tr.widget.modeDirect,
      'refresh': tr.widget.refresh,
      'switchNode': tr.widget.switchNode,
      'switchProfile': tr.widget.switchProfile,
    };
  }

  static String formatBytes(num? bytes) {
    if (bytes == null || bytes <= 0) return '0 B';
    final formatted = ClashHttpApi.convertTrafficToStringDouble(bytes);
    return formatted.isNotEmpty ? formatted : '0 B';
  }

  static String formatSpeed(num? bytesPerSec) {
    return '${formatBytes(bytesPerSec)}/s';
  }

  static ClashConfigsMode nextMode(ClashConfigsMode current) {
    switch (current) {
      case ClashConfigsMode.rule:
        return ClashConfigsMode.global;
      case ClashConfigsMode.global:
        return ClashConfigsMode.direct;
      case ClashConfigsMode.direct:
        return ClashConfigsMode.rule;
    }
  }

  static ClashConfigsMode? parseMode(String? rawMode) {
    if (rawMode == null || rawMode.trim().isEmpty) return null;
    final lower = rawMode.trim().toLowerCase();
    for (final m in ClashConfigsMode.values) {
      if (m.name.toLowerCase() == lower) return m;
    }
    return null;
  }

  /// Parses and authenticates a `wmimo://widget?...` URI.
  /// Returns null if the URI is not a widget URI or fails token validation.
  static WmimoWidgetCommand? parseWidgetUri(
    Uri uri, {
    required String expectedToken,
    bool allowEmptyTokenForTest = false,
  }) {
    if (uri.host != 'widget') return null;

    final token = uri.queryParameters['token'] ?? '';
    if (!allowEmptyTokenForTest) {
      if (expectedToken.isEmpty || token != expectedToken) {
        Log.w('HomeWidgetService: rejected widget URI with invalid token');
        return null;
      }
    }

    final action = (uri.queryParameters['action'] ?? '').trim().toLowerCase();
    if (action.isEmpty) return null;

    final bgParam = (uri.queryParameters['background'] ?? '').toLowerCase();
    final background = bgParam == 'true' || bgParam == '1';

    return WmimoWidgetCommand(
      action: action,
      profileId: uri.queryParameters['profileId'] ?? uri.queryParameters['profile'],
      groupName: uri.queryParameters['group'] ?? uri.queryParameters['groupName'],
      nodeName: uri.queryParameters['node'] ?? uri.queryParameters['nodeName'],
      mode: uri.queryParameters['mode'],
      tab: uri.queryParameters['tab'],
      background: background,
    );
  }

  /// Executes a validated [WmimoWidgetCommand].
  static Future<bool> executeCommand(WmimoWidgetCommand cmd) async {
    switch (cmd.action) {
      case 'connect':
        VpnActionHandler.vpnConnect?.call('widget', cmd.background);
        return true;

      case 'disconnect':
        VpnActionHandler.vpnDisconnect?.call('widget', cmd.background);
        return true;

      case 'toggle':
        final started = await VPNService.getStarted();
        if (started) {
          VpnActionHandler.vpnDisconnect?.call('widget', cmd.background);
        } else {
          VpnActionHandler.vpnConnect?.call('widget', cmd.background);
        }
        return true;

      case 'reconnect':
        VpnActionHandler.vpnReconnect?.call('widget', cmd.background);
        return true;

      case 'switch-profile':
        final profileId = cmd.profileId?.trim() ?? '';
        if (profileId.isEmpty) return false;
        ProfileManager.setCurrent(profileId);
        final started = await VPNService.getStarted();
        if (started) {
          VpnActionHandler.vpnReconnect?.call('widget_profile', cmd.background);
        } else {
          await refreshNodesAndSync(forceReload: true);
        }
        return true;

      case 'switch-node':
        final nodeName = cmd.nodeName?.trim() ?? '';
        if (nodeName.isEmpty) return false;
        final group = (cmd.groupName != null && cmd.groupName!.trim().isNotEmpty)
            ? cmd.groupName!.trim()
            : (_groupName.isNotEmpty ? _groupName : '节点选择');
        final started = await VPNService.getStarted();
        if (started) {
          await ClashHttpApi.setProxiesNode(group, nodeName);
          if (group != 'GLOBAL') {
            unawaited(
              ClashHttpApi.setProxiesNode('GLOBAL', nodeName)
                  .catchError((_) => null),
            );
          }
        }
        _currentNode = nodeName;
        Biz.proxySelected(nodeName);
        await refreshNodesAndSync(forceReload: true);
        return true;

      case 'set-mode':
        final targetMode = parseMode(cmd.mode);
        if (targetMode == null) return false;
        await ClashSettingManager.setConfigsMode(targetMode);
        await refreshNodesAndSync(forceReload: true);
        return true;

      case 'cycle-mode':
        final next = nextMode(ClashSettingManager.getConfigsMode());
        await ClashSettingManager.setConfigsMode(next);
        await refreshNodesAndSync(forceReload: true);
        return true;

      case 'open':
        final tab = (cmd.tab ?? 'home').trim().toLowerCase();
        int tabIdx = 0;
        if (tab == 'proxies' || tab == 'nodes') {
          tabIdx = 1;
        } else if (tab == 'profiles') {
          tabIdx = 2;
        } else if (tab == 'connections' || tab == 'traffic') {
          tabIdx = 3;
        } else if (tab == 'settings') {
          tabIdx = 4;
        }
        onNavigateToTab?.call(tabIdx);
        return true;

      case 'refresh':
        await refreshNodesAndSync(forceReload: true);
        return true;

      default:
        return false;
    }
  }

  /// Reconciles any state changes performed directly by native widgets while
  /// the Flutter UI was paused or backgrounded.
  static Future<void> syncFromNativeOnResume() async {
    if (!_isMobilePlatform) return;
    try {
      await _consumePendingNativeActions();

      final rawOverrides =
          await _channel.invokeMethod<Map<dynamic, dynamic>>('consumeNativeOverrides');
      if (rawOverrides != null && rawOverrides.isNotEmpty) {
        final modeStr = rawOverrides['mode']?.toString();
        final parsedMode = parseMode(modeStr);
        if (parsedMode != null &&
            parsedMode != ClashSettingManager.getConfigsMode()) {
          await ClashSettingManager.setConfigsMode(parsedMode);
        }

        final nodeStr = rawOverrides['currentNode']?.toString() ?? '';
        if (nodeStr.isNotEmpty && nodeStr != _currentNode) {
          _currentNode = nodeStr;
          Biz.proxySelected(nodeStr);
        }

        final vpnStopped = rawOverrides['vpnStopped'] == true;
        if (vpnStopped && await VPNService.getStarted()) {
          await VPNService.stop();
        }
      }
    } catch (e) {
      Log.w('HomeWidgetService.syncFromNativeOnResume error: $e');
    }

    await refreshNodesAndSync(forceReload: true);
  }

  static Future<void> _consumePendingNativeActions() async {
    if (!_isMobilePlatform) return;
    try {
      final rawAction =
          await _channel.invokeMethod<Map<dynamic, dynamic>>('getPendingWidgetAction');
      if (rawAction != null && rawAction.isNotEmpty) {
        await _handleActionMap(rawAction);
      }
    } catch (_) {}
  }

  static Future<dynamic> _onMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onWidgetAction':
        final args = call.arguments;
        if (args is Map) {
          await _handleActionMap(args);
        }
        return true;

      case 'onNativeStateChanged':
        final args = call.arguments;
        if (args is Map) {
          final modeStr = args['mode']?.toString();
          final parsedMode = parseMode(modeStr);
          if (parsedMode != null &&
              parsedMode != ClashSettingManager.getConfigsMode()) {
            await ClashSettingManager.setConfigsMode(parsedMode);
          }
          final nodeStr = args['currentNode']?.toString() ?? '';
          if (nodeStr.isNotEmpty && nodeStr != _currentNode) {
            _currentNode = nodeStr;
            Biz.proxySelected(nodeStr);
          }
          if (args['vpnStopped'] == true && await VPNService.getStarted()) {
            await VPNService.stop();
          }
        }
        await refreshNodesAndSync(forceReload: true);
        return true;

      default:
        return null;
    }
  }

  static Future<void> _handleActionMap(Map<dynamic, dynamic> map) async {
    final uriStr = map['uri']?.toString() ?? '';
    if (uriStr.isNotEmpty) {
      final uri = Uri.tryParse(uriStr);
      if (uri != null) {
        final cmd = parseWidgetUri(uri, expectedToken: _actionToken);
        if (cmd != null) {
          await executeCommand(cmd);
        }
      }
      return;
    }

    final token = map['token']?.toString() ?? '';
    if (_actionToken.isNotEmpty && token != _actionToken) {
      Log.w('HomeWidgetService: ignored unauthenticated native widget action');
      return;
    }
    final action = map['action']?.toString() ?? '';
    if (action.isEmpty) return;

    await executeCommand(
      WmimoWidgetCommand(
        action: action,
        profileId: map['profileId']?.toString(),
        groupName: map['groupName']?.toString(),
        nodeName: map['nodeName']?.toString(),
        mode: map['mode']?.toString(),
        tab: map['tab']?.toString(),
        background: map['background'] == true,
      ),
    );
  }
}
