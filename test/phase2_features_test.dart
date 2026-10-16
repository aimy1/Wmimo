import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/core_watchdog.dart';
import 'package:wmimo/app/utils/dns_helper.dart';
import 'package:wmimo/app/utils/geo_asset_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Phase 2 - Smart Encrypted DNS Helper Tests', () {
    test('DnsHelper correctly detects protocol and badges', () {
      expect(
        DnsHelper.detectProtocol("https://dns.alidns.com/dns-query#h3=true"),
        DnsProtocolType.doh,
      );
      expect(
        DnsHelper.getProtocolBadge("https://dns.alidns.com/dns-query#h3=true"),
        "DoH",
      );

      expect(
        DnsHelper.detectProtocol("tls://1.1.1.1:853"),
        DnsProtocolType.dot,
      );
      expect(
        DnsHelper.getProtocolBadge("tls://1.1.1.1:853"),
        "DoT",
      );

      expect(
        DnsHelper.detectProtocol("quic://dns.adguard-dns.com:784"),
        DnsProtocolType.doq,
      );
      expect(
        DnsHelper.getProtocolBadge("quic://dns.adguard-dns.com:784"),
        "DoQ",
      );

      expect(
        DnsHelper.detectProtocol("223.5.5.5"),
        DnsProtocolType.standard,
      );
      expect(
        DnsHelper.getProtocolBadge("223.5.5.5"),
        "UDP",
      );

      expect(
        DnsHelper.detectProtocol("127.0.0.1:53"),
        DnsProtocolType.standard,
      );
      expect(
        DnsHelper.getProtocolBadge("127.0.0.1:53"),
        "TCP/UDP",
      );
    });

    test('DnsHelper preset servers repository completeness', () {
      expect(DnsHelper.presetServers.isNotEmpty, isTrue);
      expect(DnsHelper.presetServers.length, greaterThanOrEqualTo(10));

      final names = DnsHelper.presetServers.map((s) => s.name).toList();
      expect(names.any((n) => n.contains("AliDNS")), isTrue);
      expect(names.any((n) => n.contains("DNSPod")), isTrue);
      expect(names.any((n) => n.contains("Cloudflare")), isTrue);
      expect(names.any((n) => n.contains("Google")), isTrue);
      expect(names.any((n) => n.contains("AdGuard")), isTrue);
      expect(names.any((n) => n.contains("Quad9")), isTrue);
    });

    test('DnsHelper applyScheme applies valid presets to ClashSettingManager', () {
      // 1. cn_speed
      DnsHelper.applyScheme(schemeId: 'cn_speed', autoSave: false);
      var dns = ClashSettingManager.getConfig().DNS;
      expect(dns, isNotNull);
      expect(dns!.OverWrite, isTrue);
      expect(dns.Enable, isTrue);
      expect(dns.EnhancedMode, ClashDnsEnhancedMode.fakeIp.name);
      expect(dns.NameServer!.any((s) => s.contains("alidns")), isTrue);
      expect(dns.Fallback!.any((s) => s.contains("cloudflare")), isTrue);

      // 2. anti_pollution
      DnsHelper.applyScheme(schemeId: 'anti_pollution', autoSave: false);
      dns = ClashSettingManager.getConfig().DNS;
      expect(dns!.NameServer!.any((s) => s.contains("cloudflare")), isTrue);
      expect(dns.NameServer!.any((s) => s.contains("google")), isTrue);

      // 3. adguard_privacy
      DnsHelper.applyScheme(schemeId: 'adguard_privacy', autoSave: false);
      dns = ClashSettingManager.getConfig().DNS;
      expect(dns!.NameServer!.any((s) => s.contains("adguard")), isTrue);
    });

    test('DnsHelper recommended Fake-IP filter list contains essentials', () {
      final filters = DnsHelper.defaultRecommendedFakeIpFilters;
      expect(filters.contains("*.lan"), isTrue);
      expect(filters.contains("*.local"), isTrue);
      expect(filters.contains("*.msftncsi.com"), isTrue);
      expect(filters.contains("+.push.apple.com"), isTrue);
      expect(filters.contains("+.bilibili.com"), isTrue);
      expect(filters.any((f) => f.contains("xbox")), isTrue);
      expect(filters.any((f) => f.contains("stun")), isTrue);
    });
  });

  group('Phase 2 - GeoAssetManager Tests', () {
    test('Resolves correct CDN download URLs for all providers', () {
      final jsDelivrUrl = GeoAssetManager.getDownloadUrl("geosite.dat", "jsdelivr");
      expect(jsDelivrUrl, contains("jsdelivr.net"));
      expect(jsDelivrUrl, contains("geosite.dat"));

      final fastGitUrl = GeoAssetManager.getDownloadUrl("geoip.dat", "fastgit");
      expect(fastGitUrl, contains("ghfast.top"));
      expect(fastGitUrl, contains("geoip.dat"));

      final githubUrl = GeoAssetManager.getDownloadUrl("geosite.dat", "github");
      expect(githubUrl, contains("github.com"));
      expect(githubUrl, contains("releases/download"));
    });

    test('GeoAssetInfo formatting', () {
      const emptyAsset = GeoAssetInfo(
        fileName: "test.dat",
        displayName: "Test",
        description: "Test Desc",
        filePath: "/tmp/test.dat",
        sizeBytes: 0,
        exists: false,
      );
      expect(emptyAsset.formattedSize, "Not Installed");
      expect(emptyAsset.formattedModifiedTime, "Never");

      final installedAsset = GeoAssetInfo(
        fileName: "geosite.dat",
        displayName: "GeoSite",
        description: "Ruleset",
        filePath: "/tmp/geosite.dat",
        sizeBytes: 15 * 1024 * 1024,
        modifiedTime: DateTime(2026, 10, 16, 12, 30),
        exists: true,
      );
      expect(installedAsset.formattedSize, "15.00 MB");
      expect(installedAsset.formattedModifiedTime, contains("2026-10-16"));
    });
  });

  group('Phase 2 - Core Watchdog Tests', () {
    test('Watchdog state control and tracking', () {
      expect(CoreWatchdog.isWatchdogEnabled, isTrue);

      CoreWatchdog.setUserConnected(true);
      expect(CoreWatchdog.getUserWantsConnected(), isTrue);

      CoreWatchdog.setUserConnected(false);
      expect(CoreWatchdog.getUserWantsConnected(), isFalse);

      CoreWatchdog.setWatchdogEnabled(false);
      expect(CoreWatchdog.isWatchdogEnabled, isFalse);

      CoreWatchdog.setWatchdogEnabled(true);
      expect(CoreWatchdog.isWatchdogEnabled, isTrue);
    });
  });

  group('Phase 2 - Localization Strings Tests', () {
    test('Verifies Phase 2 translation keys exist across all 9 locales', () async {
      for (final locale in AppLocale.values) {
        final t = await locale.build();
        expect(t.dns.flushCache.isNotEmpty, isTrue);
        expect(t.dns.presets.isNotEmpty, isTrue);
        expect(t.dns.geoAssetsTitle.isNotEmpty, isTrue);
        expect(t.dns.dnsTester.isNotEmpty, isTrue);
      }

      final tZh = await AppLocale.zhCn.build();
      expect(tZh.dns.flushCache, "清空 DNS 缓存");
      expect(tZh.dns.presets, "快速预设方案");
      expect(tZh.dns.geoAssetsTitle, "GEO 离线数据库");
      expect(tZh.dns.dnsTester, "DNS 实时解析诊断");
    });
  });
}
