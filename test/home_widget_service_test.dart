import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:libclash_vpn_service/state.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/utils/app_scheme_actions.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/home_widget_service.dart';
import 'package:wmimo/i18n/strings.g.dart';

void main() {
  group('HomeWidgetService - Traffic & Speed Formatting Tests', () {
    test('Formats byte counts and speeds accurately', () {
      expect(HomeWidgetService.formatBytes(0), '0 B');
      expect(HomeWidgetService.formatBytes(-50), '0 B');
      expect(HomeWidgetService.formatBytes(512), '512 B');
      expect(HomeWidgetService.formatBytes(1024 * 12), '12.0 KB');
      expect(HomeWidgetService.formatBytes(1024 * 1024 * 5), '5.0 MB');
      expect(HomeWidgetService.formatBytes(1024 * 1024 * 1024 * 2), '2.0 GB');

      expect(HomeWidgetService.formatSpeed(0), '0 B/s');
      expect(HomeWidgetService.formatSpeed(1024 * 256), '256.0 KB/s');
      expect(HomeWidgetService.formatSpeed(1024 * 1024 * 10), '10.0 MB/s');
    });

    test('Cycles and parses outbound modes cleanly', () {
      expect(
        HomeWidgetService.nextMode(ClashConfigsMode.rule),
        ClashConfigsMode.global,
      );
      expect(
        HomeWidgetService.nextMode(ClashConfigsMode.global),
        ClashConfigsMode.direct,
      );
      expect(
        HomeWidgetService.nextMode(ClashConfigsMode.direct),
        ClashConfigsMode.rule,
      );

      expect(HomeWidgetService.parseMode('rule'), ClashConfigsMode.rule);
      expect(HomeWidgetService.parseMode('GLOBAL'), ClashConfigsMode.global);
      expect(HomeWidgetService.parseMode('Direct'), ClashConfigsMode.direct);
      expect(HomeWidgetService.parseMode('invalid'), isNull);
    });

    test('Enriches node display names with region flags while preserving raw names', () {
      expect(HomeWidgetService.formatNodeDisplayName('香港 IEPL 01'), '🇭🇰 香港 IEPL 01');
      expect(HomeWidgetService.formatNodeDisplayName('🇭🇰 香港 IEPL 01'), '🇭🇰 香港 IEPL 01');
      expect(HomeWidgetService.formatNodeDisplayName('Tokyo BGP 02'), '🇯🇵 Tokyo BGP 02');
      expect(HomeWidgetService.formatNodeDisplayName('自动选择'), '⚡ 自动选择');
    });
  });

  group('HomeWidgetService - Snapshot Serialization & Quota Calculation Tests', () {
    test('Builds complete widget snapshot with quota and node list', () async {
      final zhTranslations = await AppLocale.zhCn.build();
      final labels = HomeWidgetService.buildLocalizedLabels(zhTranslations);

      final nodes = [
        const WmimoWidgetNodeItem(name: '自动选择', delay: 35, selected: false),
        const WmimoWidgetNodeItem(name: '🇭🇰 香港 IEPL 01', delay: 42, selected: true),
        const WmimoWidgetNodeItem(name: '🇯🇵 东京 BGP 02', delay: 68, selected: false),
      ];
      final profiles = [
        const WmimoWidgetProfileItem(id: 'sub1.yaml', name: '主力订阅', selected: true),
        const WmimoWidgetProfileItem(id: 'sub2.yaml', name: '备用线路', selected: false),
      ];

      final snap = HomeWidgetService.buildSnapshotMap(
        vpnState: FlutterVpnServiceState.connected,
        mode: 'rule',
        profileId: 'sub1.yaml',
        profileName: '主力订阅',
        groupName: '节点选择',
        currentNode: '🇭🇰 香港 IEPL 01',
        currentDelay: 42,
        controlPort: 9090,
        controlSecret: 'test-secret',
        upSpeed: 1024 * 512,
        downSpeed: 1024 * 1024 * 8,
        upTotal: 1024 * 1024 * 100,
        downTotal: 1024 * 1024 * 900,
        subUsed: 1024 * 1024 * 1024 * 25,
        subTotal: 1024 * 1024 * 1024 * 100,
        subExpire: '2026-12-31',
        nodes: nodes,
        profiles: profiles,
        actionToken: 'tok_123456',
        labels: labels,
      );

      expect(snap['connected'], isTrue);
      expect(snap['transitioning'], isFalse);
      expect(snap['vpnState'], 'connected');
      expect(snap['mode'], 'rule');
      expect(snap['currentNode'], '🇭🇰 香港 IEPL 01');
      expect(snap['currentDelay'], 42);
      expect(snap['upSpeedText'], '512.0 KB/s');
      expect(snap['downSpeedText'], '8.0 MB/s');
      expect(snap['subPercent'], 25);
      expect(snap['subRemainingText'], '75.0 GB');
      expect((snap['nodes'] as List).length, 3);
      expect((snap['profiles'] as List).length, 2);
      expect((snap['labels'] as Map)['statusTitle'], '节点状态');
      expect((snap['labels'] as Map)['trafficTitle'], '实时流量');
      expect((snap['labels'] as Map)['quickSwitchTitle'], '快捷切换');
    });

    test('All 9 locales provide non-empty widget localized labels', () async {
      for (final locale in AppLocale.values) {
        final tr = await locale.build();
        final labels = HomeWidgetService.buildLocalizedLabels(tr);
        for (final entry in labels.entries) {
          expect(
            entry.value.trim().isNotEmpty,
            isTrue,
            reason: '${locale.languageTag} widget.${entry.key} must not be empty',
          );
        }
      }
    });
  });

  group('HomeWidgetService - Authenticated Deep Link URI Parsing Tests', () {
    const validToken = 'a1b2c3d4e5f600112233445566778899';

    test('Rejects URIs with missing or mismatched action token', () {
      final noTokenUri = Uri.parse('wmimo://widget?action=connect');
      expect(
        HomeWidgetService.parseWidgetUri(noTokenUri, expectedToken: validToken),
        isNull,
      );

      final wrongTokenUri = Uri.parse('wmimo://widget?action=connect&token=forged');
      expect(
        HomeWidgetService.parseWidgetUri(wrongTokenUri, expectedToken: validToken),
        isNull,
      );
    });

    test('Parses valid authenticated widget commands accurately', () {
      expect(AppSchemeActions.widgetAction(), 'widget');

      final connectUri = Uri.parse(
        'wmimo://widget?action=connect&background=true&token=$validToken',
      );
      final connectCmd = HomeWidgetService.parseWidgetUri(
        connectUri,
        expectedToken: validToken,
      );
      expect(connectCmd, isNotNull);
      expect(connectCmd!.action, 'connect');
      expect(connectCmd.background, isTrue);

      final profileUri = Uri.parse(
        'wmimo://widget?action=switch-profile&profileId=sub_hk.yaml&token=$validToken',
      );
      final profileCmd = HomeWidgetService.parseWidgetUri(
        profileUri,
        expectedToken: validToken,
      );
      expect(profileCmd, isNotNull);
      expect(profileCmd!.action, 'switch-profile');
      expect(profileCmd.profileId, 'sub_hk.yaml');

      final openUri = Uri.parse(
        'wmimo://widget?action=open&tab=connections&token=$validToken',
      );
      final openCmd = HomeWidgetService.parseWidgetUri(
        openUri,
        expectedToken: validToken,
      );
      expect(openCmd, isNotNull);
      expect(openCmd!.action, 'open');
      expect(openCmd.tab, 'connections');
    });
  });

  group('Platform Native Widget Files Verification Tests', () {
    test('Android AppWidget providers, layouts, and metadata exist and are registered', () {
      final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      expect(manifest, contains('.WmimoStatusWidgetProvider'));
      expect(manifest, contains('.WmimoTrafficWidgetProvider'));
      expect(manifest, contains('.WmimoQuickSwitchWidgetProvider'));

      expect(File('android/app/src/main/res/layout/widget_status.xml').existsSync(), isTrue);
      expect(File('android/app/src/main/res/layout/widget_traffic.xml').existsSync(), isTrue);
      expect(File('android/app/src/main/res/layout/widget_quick_switch.xml').existsSync(), isTrue);

      expect(File('android/app/src/main/res/xml/widget_status_info.xml').existsSync(), isTrue);
      expect(File('android/app/src/main/res/xml/widget_traffic_info.xml').existsSync(), isTrue);
      expect(File('android/app/src/main/res/xml/widget_quick_switch_info.xml').existsSync(), isTrue);

      expect(
        File('android/app/src/main/kotlin/com/wmimo/app/WmimoWidgetUpdater.kt').existsSync(),
        isTrue,
      );
      expect(
        File('android/app/src/main/kotlin/com/wmimo/app/WmimoWidgetProviders.kt').existsSync(),
        isTrue,
      );
    });

    test('iOS WidgetKit bundle registers Status, Traffic, QuickSwitch, and Control widgets', () {
      final bundleSwift = File('ios/wmimoWidget/wmimoWidgetBundle.swift').readAsStringSync();
      expect(bundleSwift, contains('wmimoWidgetControl()'));
      expect(bundleSwift, contains('wmimoWidget()'));
      expect(bundleSwift, contains('WmimoTrafficWidget()'));
      expect(bundleSwift, contains('WmimoQuickSwitchWidget()'));

      final widgetSwift = File('ios/wmimoWidget/wmimoWidget.swift').readAsStringSync();
      expect(widgetSwift, contains('com.wmimo.app.wmimoWidget'));
      expect(widgetSwift, contains('com.wmimo.app.wmimoWidget.traffic'));
      expect(widgetSwift, contains('com.wmimo.app.wmimoWidget.quickSwitch'));

      final intentsSwift = File('ios/wmimoWidget/AppIntent.swift').readAsStringSync();
      expect(intentsSwift, contains('ToggleVpnWidgetIntent'));
      expect(intentsSwift, contains('RefreshWmimoWidgetIntent'));
      expect(intentsSwift, contains('SetOutboundModeIntent'));
      expect(intentsSwift, contains('SwitchProxyNodeIntent'));

      final controlSwift = File('ios/wmimoWidget/wmimoWidgetControl.swift').readAsStringSync();
      expect(controlSwift, contains(AppUtils.getControlKind()));

      final tileServiceKt =
          File('android/app/src/main/kotlin/com/wmimo/app/TileService.kt').readAsStringSync();
      expect(tileServiceKt, contains('requestTileUpdate'));
      expect(tileServiceKt, contains('currentNodeDisplay'));
    });
  });
}
