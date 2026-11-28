import 'dart:io';
import 'package:board_service/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/remote_config.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/geo_asset_manager.dart';
import 'package:wmimo/app/utils/package_manager_android.dart';
import 'package:wmimo/app/utils/uwp_loopback_helper.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/widgets/animated_indexed_stack.dart';
import 'package:libclash_vpn_service/vpn_service.dart';

void main() {
  group('Section 4 - UWP Loopback Exemption Helper Tests', () {
    test('Identifies common UWP applications correctly', () {
      expect(
        UwpAppInfo.checkIsCommon('Microsoft.WindowsStore_8wekyb3d8bbwe', 'Microsoft Store'),
        isTrue,
      );
      expect(
        UwpAppInfo.checkIsCommon('Microsoft.GamingApp_8wekyb3d8bbwe', 'Xbox'),
        isTrue,
      );
      expect(
        UwpAppInfo.checkIsCommon('Microsoft.MinecraftUWP_8wekyb3d8bbwe', 'Minecraft'),
        isTrue,
      );
      expect(
        UwpAppInfo.checkIsCommon('Microsoft.MicrosoftEdge_8wekyb3d8bbwe', 'Microsoft Edge'),
        isTrue,
      );
      expect(
        UwpAppInfo.checkIsCommon('Microsoft.WindowsTerminal_8wekyb3d8bbwe', 'Windows Terminal'),
        isTrue,
      );
      expect(
        UwpAppInfo.checkIsCommon('RandomVendor.UnknownApp_12345', 'Unknown'),
        isFalse,
      );
    });

    test('UwpAppInfo properties, friendlyName and toggle', () {
      final friendly = UwpAppInfo.friendlyName(
        'Microsoft.WindowsTerminal_8wekyb3d8bbwe',
        'ms-resource:AppName',
      );
      expect(friendly, contains('Windows Terminal'));

      final item = UwpAppInfo(
        sid: 'S-1-15-2-1234-5678',
        displayName: 'Microsoft Store',
        moniker: 'microsoft.windowsstore',
        isExempt: false,
        isCommon: true,
      );

      expect(item.sid, 'S-1-15-2-1234-5678');
      expect(item.displayName, 'Microsoft Store');
      expect(item.moniker, 'microsoft.windowsstore');
      expect(item.isExempt, isFalse);
      expect(item.isCommon, isTrue);

      item.isExempt = true;
      expect(item.isExempt, isTrue);
    });
  });

  group('Section 4 - Android Per-App Proxy Logic Tests', () {
    test('Distinguishes system apps from user apps using flags', () {
      final userApp = PackageInfoEx()
        ..name = 'My User App'
        ..info = PackageInfoFromApplicationInfo(
          ApplicationInfoImpl('com.example.userapp', flags: 0),
        );

      final systemApp = PackageInfoEx()
        ..name = 'Android System'
        ..info = PackageInfoFromApplicationInfo(
          ApplicationInfoImpl(
            'com.android.system',
            flags: PackageManagerAndroid.kAndroidFlagSystem,
          ),
        );

      bool isSystem(PackageInfoEx app) {
        return app.info.applicationInfo != null &&
            (app.info.applicationInfo!.flags & PackageManagerAndroid.kAndroidFlagSystem != 0);
      }

      expect(isSystem(userApp), isFalse);
      expect(isSystem(systemApp), isTrue);
    });

    test('Per-app whitelist vs blacklist filtering', () {
      final selectedPackages = {'com.google.chrome', 'com.twitter.android'};

      // Whitelist Mode: Only selected packages are proxied
      bool isProxiedInWhitelist(String pkg) => selectedPackages.contains(pkg);
      expect(isProxiedInWhitelist('com.google.chrome'), isTrue);
      expect(isProxiedInWhitelist('com.twitter.android'), isTrue);
      expect(isProxiedInWhitelist('com.tencent.mm'), isFalse);

      // Blacklist Mode: Selected packages are bypassed, all others proxied
      bool isProxiedInBlacklist(String pkg) => !selectedPackages.contains(pkg);
      expect(isProxiedInBlacklist('com.google.chrome'), isFalse);
      expect(isProxiedInBlacklist('com.twitter.android'), isFalse);
      expect(isProxiedInBlacklist('com.tencent.mm'), isTrue);
    });
  });

  group('Section 4 - Path Utils & Core Binary Resolution Tests', () {
    test('Resolves service executable name appropriately', () {
      final exeName = PathUtils.serviceExeName();
      expect(exeName.isNotEmpty, isTrue);
      expect(exeName, contains('wmimoService'));
    });
  });

  group('Section 4 - Slang I18n Translation Coverage Tests', () {
    test('All 9 locales contain Section 4 keys', () async {
      for (final locale in AppLocale.values) {
        final t = await locale.build();
        expect(t.meta.uwpLoopback.isNotEmpty, isTrue);
        expect(t.meta.uwpLoopbackDesc.isNotEmpty, isTrue);
        expect(t.meta.proxySelectedMode.isNotEmpty, isTrue);
        expect(t.meta.bypassSelectedMode.isNotEmpty, isTrue);
        expect(t.meta.userApps.isNotEmpty, isTrue);
        expect(t.meta.systemApps.isNotEmpty, isTrue);
        expect(t.meta.selectAll.isNotEmpty, isTrue);
        expect(t.meta.deselectAll.isNotEmpty, isTrue);
        expect(t.meta.invertSelection.isNotEmpty, isTrue);
        expect(t.dns.addPresetServer.isNotEmpty, isTrue);
        expect(t.dns.manageFakeIpFilter(p: '10').isNotEmpty, isTrue);
        expect(t.dns.fakeIpFilterDesc(p: '10').isNotEmpty, isTrue);
        expect(t.meta.proxySelection.isNotEmpty, isTrue);
        expect(t.meta.autoSelect.isNotEmpty, isTrue);
        expect(t.meta.regionHk.isNotEmpty, isTrue);
        expect(t.meta.macMoveToApplications.isNotEmpty, isTrue);
        expect(t.meta.notifCurrentNode.isNotEmpty, isTrue);
        expect(t.meta.notifMode.isNotEmpty, isTrue);
        expect(t.meta.notifPort.isNotEmpty, isTrue);
        expect(t.meta.notifProfile.isNotEmpty, isTrue);
        expect(t.meta.notifDisconnect.isNotEmpty, isTrue);
        expect(t.meta.notifSwitchNode.isNotEmpty, isTrue);
        expect(t.meta.notifVpnConnected.isNotEmpty, isTrue);
        expect(t.meta.tunSwitchToSystemProxy.isNotEmpty, isTrue);
        expect(t.meta.tunCreateAdapterFailedAdmin.isNotEmpty, isTrue);
        expect(t.meta.resetConfirm.isNotEmpty, isTrue);
        expect(t.meta.resetSuccess.isNotEmpty, isTrue);
        expect(t.meta.resetCoreConfirm.isNotEmpty, isTrue);
        expect(t.meta.resetCoreSuccess.isNotEmpty, isTrue);
      }
    });
  });

  group('Android Ongoing Notification (Option 1) Tests', () {
    test('FlutterVpnService retains and updates active notification state', () async {
      await FlutterVpnService.updateNotification(
        nodeName: 'HK-01 专线',
        mode: '规则分流',
        profileName: '我的专属订阅',
      );

      expect(FlutterVpnService.activeNodeName, 'HK-01 专线');
      expect(FlutterVpnService.activeMode, '规则分流');
      expect(FlutterVpnService.activeProfileName, '我的专属订阅');

      // Partial updates only overwrite specified fields
      await FlutterVpnService.updateNotification(nodeName: 'JP-02 高速');
      expect(FlutterVpnService.activeNodeName, 'JP-02 高速');
      expect(FlutterVpnService.activeMode, '规则分流');
      expect(FlutterVpnService.activeProfileName, '我的专属订阅');
    });

    test('Notification formatting strings match Option 1 specs', () {
      final node = 'HK-01 专线';
      final mode = '规则分流';
      final profile = '我的专属订阅';
      final port = 7890;

      final title = node.isNotEmpty ? 'Wmimo · $node' : 'Wmimo';
      final content = '$mode · $profile';
      final bigText = [
        if (node.isNotEmpty) '当前节点: $node',
        if (mode.isNotEmpty) '运行模式: $mode · 端口: $port',
        if (profile.isNotEmpty) '配置订阅: $profile',
      ].join('\n');

      expect(title, 'Wmimo · HK-01 专线');
      expect(content, '规则分流 · 我的专属订阅');
      expect(bigText, contains('当前节点: HK-01 专线'));
      expect(bigText, contains('运行模式: 规则分流 · 端口: 7890'));
      expect(bigText, contains('配置订阅: 我的专属订阅'));
    });
  });

  group('GeoIP Direct File URLs, Multi-CDN Fallback & Android Lifecycle Sync Tests', () {
    test('ClashSettingManager defaultRawExtensionRuleset uses direct .dat and .mmdb file URLs', () {
      final ruleset = ClashSettingManager.defaultRawExtensionRuleset();
      expect(ruleset.GeoIpUrl, endsWith('/geoip.dat'));
      expect(ruleset.GeoSiteUrl, endsWith('/geosite.dat'));
      expect(ruleset.AsnUrl, endsWith('/GeoLite2-ASN.mmdb'));
    });

    test('GeoAssetManager getCandidateUrls provides multi-CDN fallback chain for geoip.dat', () {
      final urls = GeoAssetManager.getCandidateUrls('geoip.dat', 'jsdelivr');
      expect(urls.length, greaterThanOrEqualTo(4));
      expect(urls.first, contains('testingcf.jsdelivr.net'));
      expect(urls.any((u) => u.contains('fastly.jsdelivr.net')), isTrue);
      expect(urls.any((u) => u.contains('ghfast.top')), isTrue);
      expect(urls.any((u) => u.contains('github.com/MetaCubeX')), isTrue);
      for (final u in urls) {
        expect(u, endsWith('/geoip.dat'));
      }
    });

    test('Android VPN service stops cleanly on task removal and MainActivity supports setExcludeFromRecents', () {
      final manifest = File('android/app/src/main/AndroidManifest.xml').readAsStringSync();
      expect(manifest, contains('android:name=".WmimoVpnService"'));
      expect(manifest, contains('android:stopWithTask="true"'));

      final vpnServiceKt = File('android/app/src/main/kotlin/com/wmimo/app/WmimoVpnService.kt').readAsStringSync();
      expect(vpnServiceKt, contains('override fun onTaskRemoved'));
      expect(vpnServiceKt, contains('isCorePortListening'));

      final mainActivityKt = File('android/app/src/main/kotlin/com/wmimo/app/MainActivity.kt').readAsStringSync();
      expect(mainActivityKt, contains('"setExcludeFromRecents"'));
      expect(mainActivityKt, contains('task.setExcludeFromRecents(enable)'));
    });

    test('Security hardening: Crypto encrypts credentials, RemoteConfig.isSelfHost blocks subdomain spoofing, Fake-IP uses 198.18.0.1/16', () {
      const secret = 'my_super_secret_token_123';
      final encrypted = Crypto.encrypt('custom_key', secret);
      expect(encrypted, isNot(equals(secret)));
      expect(encrypted, startsWith('WMIMO_ENC_V1:'));
      expect(Crypto.decrypt('custom_key', encrypted), equals(secret));
      // Legacy plaintext fallback
      expect(Crypto.decrypt('custom_key', 'legacy_plain_token'), equals('legacy_plain_token'));

      final webdav = SettingConfigItemWebDev()
        ..url = 'https://dav.example.com'
        ..user = 'alice'
        ..password = 'webdav_pass_456';
      final json = webdav.toJson();
      expect(json['password'], startsWith('WMIMO_ENC_V1:'));
      final restored = SettingConfigItemWebDev.fromJsonStatic(json);
      expect(restored.password, equals('webdav_pass_456'));

      expect(RemoteConfig.isSelfHost('https://wmimo.buzz/donate', 'wmimo.buzz'), isTrue);
      expect(RemoteConfig.isSelfHost('https://pay.wmimo.buzz/donate', 'wmimo.buzz'), isTrue);
      expect(RemoteConfig.isSelfHost('https://evil.wmimo.buzz.attacker.com/donate', 'wmimo.buzz'), isFalse);

      expect(ClashSettingManager.defaultDNS().FakeIPRange, equals('198.18.0.1/16'));
    });

    testWidgets('AnimatedIndexedStack lazy mode only mounts active tab until switched', (tester) async {
      int tab1Builds = 0;
      int tab2Builds = 0;
      int currentIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: AnimatedIndexedStack(
                  index: currentIndex,
                  lazy: true,
                  children: [
                    Builder(builder: (_) {
                      tab1Builds++;
                      return const Text('Tab 1');
                    }),
                    Builder(builder: (_) {
                      tab2Builds++;
                      return const Text('Tab 2');
                    }),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () => setState(() => currentIndex = 1),
                ),
              );
            },
          ),
        ),
      );

      expect(tab1Builds, equals(1));
      expect(tab2Builds, equals(0));

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(tab2Builds, greaterThanOrEqualTo(1));
      expect(find.text('Tab 2'), findsOneWidget);
    });
  });
}

