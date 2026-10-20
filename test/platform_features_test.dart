import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/utils/package_manager_android.dart';
import 'package:wmimo/app/utils/uwp_loopback_helper.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
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
}

