import 'dart:async';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';

enum DnsProtocolType { doh, dot, doq, standard }

class DnsPresetItem {
  final String name;
  final String address;
  final DnsProtocolType protocol;
  final String group; // cn, global, adblock
  final String description;

  const DnsPresetItem({
    required this.name,
    required this.address,
    required this.protocol,
    required this.group,
    required this.description,
  });
}

class DnsQueryResult {
  final bool success;
  final String domain;
  final List<String> ips;
  final int latencyMs;
  final bool isFakeIp;
  final String? error;

  DnsQueryResult({
    required this.success,
    required this.domain,
    required this.ips,
    required this.latencyMs,
    required this.isFakeIp,
    this.error,
  });
}

class DnsHelper {
  static const List<DnsPresetItem> presetServers = [
    // 国内
    DnsPresetItem(
      name: "AliDNS (DoH3)",
      address: "https://dns.alidns.com/dns-query#h3=true",
      protocol: DnsProtocolType.doh,
      group: "cn",
      description: "Alibaba Cloud DoH with HTTP/3 support",
    ),
    DnsPresetItem(
      name: "AliDNS (DoT)",
      address: "tls://223.5.5.5:853",
      protocol: DnsProtocolType.dot,
      group: "cn",
      description: "Alibaba Cloud DNS over TLS",
    ),
    DnsPresetItem(
      name: "AliDNS (Standard)",
      address: "223.5.5.5",
      protocol: DnsProtocolType.standard,
      group: "cn",
      description: "Alibaba Public DNS IPv4",
    ),
    DnsPresetItem(
      name: "DNSPod (DoH)",
      address: "https://doh.pub/dns-query",
      protocol: DnsProtocolType.doh,
      group: "cn",
      description: "Tencent DNSPod DoH Public DNS",
    ),
    DnsPresetItem(
      name: "DNSPod (DoT)",
      address: "tls://dot.pub",
      protocol: DnsProtocolType.dot,
      group: "cn",
      description: "Tencent DNSPod DNS over TLS",
    ),
    DnsPresetItem(
      name: "DNSPod (Standard)",
      address: "119.29.29.29",
      protocol: DnsProtocolType.standard,
      group: "cn",
      description: "Tencent Public DNS IPv4",
    ),
    DnsPresetItem(
      name: "Baidu DNS",
      address: "180.76.76.76",
      protocol: DnsProtocolType.standard,
      group: "cn",
      description: "Baidu Public DNS",
    ),
    DnsPresetItem(
      name: "114 DNS",
      address: "114.114.114.114",
      protocol: DnsProtocolType.standard,
      group: "cn",
      description: "114 National Public DNS",
    ),

    // 国际
    DnsPresetItem(
      name: "Cloudflare (DoH3)",
      address: "https://cloudflare-dns.com/dns-query#h3=true",
      protocol: DnsProtocolType.doh,
      group: "global",
      description: "Cloudflare 1.1.1.1 DoH with HTTP/3",
    ),
    DnsPresetItem(
      name: "Cloudflare (DoT)",
      address: "tls://1.1.1.1",
      protocol: DnsProtocolType.dot,
      group: "global",
      description: "Cloudflare 1.1.1.1 DNS over TLS",
    ),
    DnsPresetItem(
      name: "Cloudflare (Standard)",
      address: "1.1.1.1",
      protocol: DnsProtocolType.standard,
      group: "global",
      description: "Cloudflare Fast IPv4 DNS",
    ),
    DnsPresetItem(
      name: "Google (DoH)",
      address: "https://dns.google/dns-query",
      protocol: DnsProtocolType.doh,
      group: "global",
      description: "Google Public DNS over HTTPS",
    ),
    DnsPresetItem(
      name: "Google (DoT)",
      address: "tls://8.8.8.8",
      protocol: DnsProtocolType.dot,
      group: "global",
      description: "Google Public DNS over TLS",
    ),
    DnsPresetItem(
      name: "Google (Standard)",
      address: "8.8.8.8",
      protocol: DnsProtocolType.standard,
      group: "global",
      description: "Google Public IPv4 DNS",
    ),
    DnsPresetItem(
      name: "Quad9 (DoH)",
      address: "https://dns.quad9.net/dns-query",
      protocol: DnsProtocolType.doh,
      group: "global",
      description: "Quad9 Secure Malware-blocking DNS",
    ),
    DnsPresetItem(
      name: "Quad9 (DoT)",
      address: "tls://9.9.9.9",
      protocol: DnsProtocolType.dot,
      group: "global",
      description: "Quad9 DNS over TLS",
    ),

    // 过滤与隐私
    DnsPresetItem(
      name: "AdGuard (DoQ)",
      address: "quic://dns.adguard-dns.com:784",
      protocol: DnsProtocolType.doq,
      group: "adblock",
      description: "AdGuard DNS over QUIC (Ultra low latency)",
    ),
    DnsPresetItem(
      name: "AdGuard (DoH)",
      address: "https://dns.adguard-dns.com/dns-query",
      protocol: DnsProtocolType.doh,
      group: "adblock",
      description: "AdGuard Default Ad-blocking DoH",
    ),
  ];

  static const List<String> defaultRecommendedFakeIpFilters = [
    "*.lan",
    "*.local",
    "time.*.com",
    "time.*.gov",
    "time.*.edu.cn",
    "time.*.apple.com",
    "time-ios.apple.com",
    "time1.cloud.tencent.com",
    "*.pool.ntp.org",
    "*.ntp.org.cn",
    "+.services.googleapis.cn",
    "+.push.apple.com",
    "localhost.ptlogin2.qq.com",
    "+.stun.*.*",
    "+.stun.*.*.*",
    "+.stun.*.*.*.*",
    "*.n.n.srv.nintendo.net",
    "+.stun.playstation.net",
    "xbox.*.*.microsoft.com",
    "*.*.xboxlive.com",
    "*.msftncsi.com",
    "*.msftconnecttest.com",
    "*.mcdn.bilivideo.cn",
    "+.bilibili.com",
    "+.bilicdn.com",
    "+.bilivideo.com",
    "+.market.xiaomi.com",
    "WORKGROUP",
  ];

  static DnsProtocolType detectProtocol(String server) {
    final lower = server.toLowerCase().trim();
    if (lower.startsWith("https://")) return DnsProtocolType.doh;
    if (lower.startsWith("tls://")) return DnsProtocolType.dot;
    if (lower.startsWith("quic://")) return DnsProtocolType.doq;
    return DnsProtocolType.standard;
  }

  static String getProtocolBadge(String server) {
    switch (detectProtocol(server)) {
      case DnsProtocolType.doh:
        return "DoH";
      case DnsProtocolType.dot:
        return "DoT";
      case DnsProtocolType.doq:
        return "DoQ";
      case DnsProtocolType.standard:
        return server.contains(":") ? "TCP/UDP" : "UDP";
    }
  }

  static void applyScheme({
    required String schemeId, // 'cn_speed' | 'anti_pollution' | 'adguard_privacy'
    bool autoSave = true,
  }) {
    final dns = ClashSettingManager.getConfig().DNS;
    if (dns == null) return;

    dns.OverWrite = true;
    dns.Enable = true;
    dns.PreferH3 = true;
    dns.EnhancedMode = ClashDnsEnhancedMode.fakeIp.name;

    if (schemeId == 'cn_speed') {
      // 国内极速双栈
      dns.NameServer = [
        "https://dns.alidns.com/dns-query#h3=true",
        "https://doh.pub/dns-query",
        "223.5.5.5",
        "119.29.29.29",
      ];
      dns.Fallback = [
        "https://cloudflare-dns.com/dns-query#h3=true",
        "https://dns.google/dns-query",
        "tls://1.1.1.1",
      ];
      dns.DirectNameServer = [
        "223.5.5.5",
        "119.29.29.29",
        "system",
      ];
      dns.DefaultNameserver = [
        "223.5.5.5",
        "119.29.29.29",
        "1.1.1.1",
      ];
      dns.ProxyServerNameserver = [
        "https://dns.alidns.com/dns-query#h3=true",
        "223.5.5.5",
        "1.1.1.1",
      ];
    } else if (schemeId == 'anti_pollution') {
      // 安全防污染模式
      dns.NameServer = [
        "https://cloudflare-dns.com/dns-query#h3=true",
        "https://dns.google/dns-query",
        "tls://1.1.1.1",
        "tls://8.8.8.8",
      ];
      dns.Fallback = [
        "https://dns.quad9.net/dns-query",
        "tls://9.9.9.9",
        "quic://dns.adguard-dns.com:784",
      ];
      dns.DirectNameServer = [
        "223.5.5.5",
        "119.29.29.29",
      ];
      dns.DefaultNameserver = [
        "1.1.1.1",
        "8.8.8.8",
        "223.5.5.5",
      ];
      dns.ProxyServerNameserver = [
        "tls://1.1.1.1",
        "tls://8.8.8.8",
      ];
    } else if (schemeId == 'adguard_privacy') {
      // 广告拦截与隐私保护
      dns.NameServer = [
        "quic://dns.adguard-dns.com:784",
        "https://dns.adguard-dns.com/dns-query",
        "https://dns.alidns.com/dns-query#h3=true",
      ];
      dns.Fallback = [
        "https://dns.quad9.net/dns-query",
        "https://cloudflare-dns.com/dns-query#h3=true",
      ];
      dns.DirectNameServer = [
        "223.5.5.5",
        "119.29.29.29",
      ];
      dns.DefaultNameserver = [
        "223.5.5.5",
        "1.1.1.1",
      ];
      dns.ProxyServerNameserver = [
        "https://dns.adguard-dns.com/dns-query",
        "223.5.5.5",
      ];
    }

    if (autoSave) {
      ClashSettingManager.save();
    }
  }

  static void resetFakeIpFilterToDefaults({bool autoSave = true}) {
    final dns = ClashSettingManager.getConfig().DNS;
    if (dns == null) return;
    dns.FakeIPFilter = List.from(defaultRecommendedFakeIpFilters);
    if (autoSave) {
      ClashSettingManager.save();
    }
  }

  static Future<DnsQueryResult> queryDnsTest(String domain, {String type = "A"}) async {
    final cleanDomain = domain.trim().replaceAll("http://", "").replaceAll("https://", "").split("/").first;
    if (cleanDomain.isEmpty) {
      return DnsQueryResult(
        success: false,
        domain: domain,
        ips: [],
        latencyMs: 0,
        isFakeIp: false,
        error: "Domain is empty",
      );
    }

    final stopwatch = Stopwatch()..start();
    try {
      final res = await ClashHttpApi.dnsQuery(cleanDomain, queryType: type);
      stopwatch.stop();

      if (res.error != null) {
        return DnsQueryResult(
          success: false,
          domain: cleanDomain,
          ips: [],
          latencyMs: stopwatch.elapsedMilliseconds,
          isFakeIp: false,
          error: res.error!.message,
        );
      }

      final ips = res.data ?? [];
      bool fakeIp = false;
      for (final ip in ips) {
        if (ip.startsWith("198.18.") || ip.startsWith("172.19.")) {
          fakeIp = true;
          break;
        }
      }

      return DnsQueryResult(
        success: true,
        domain: cleanDomain,
        ips: ips,
        latencyMs: stopwatch.elapsedMilliseconds,
        isFakeIp: fakeIp,
      );
    } catch (e) {
      stopwatch.stop();
      return DnsQueryResult(
        success: false,
        domain: cleanDomain,
        ips: [],
        latencyMs: stopwatch.elapsedMilliseconds,
        isFakeIp: false,
        error: e.toString(),
      );
    }
  }
}
