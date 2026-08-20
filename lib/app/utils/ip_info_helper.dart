import 'dart:async';
import 'dart:convert';
import 'dart:io';

class IpInfoData {
  final String ip;
  final String country;
  final String countryCode;
  final String region;
  final String city;
  final String isp;
  final String asn;
  final bool isProxy;

  IpInfoData({
    required this.ip,
    this.country = '',
    this.countryCode = '',
    this.region = '',
    this.city = '',
    this.isp = '',
    this.asn = '',
    this.isProxy = false,
  });

  String get flagEmoji {
    if (countryCode.length != 2) return "🌐";
    final int firstLetter = countryCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  String get locationString {
    final parts = <String>[];
    if (country.isNotEmpty) parts.add(country);
    if (region.isNotEmpty && region != country && !region.contains(country)) {
      parts.add(region);
    }
    if (city.isNotEmpty && city != region && !region.contains(city)) {
      parts.add(city);
    }
    return parts.isEmpty ? "未知位置" : parts.join(' · ');
  }
}

class IpInfoHelper {
  static Future<IpInfoData?> fetchIpInfo({int? proxyPort, bool isProxy = false}) async {
    // 1. Try ip.sb first
    try {
      final data = await _fetchFromUrl('https://api.ip.sb/geoip', proxyPort);
      if (data != null && data['ip'] != null) {
        return IpInfoData(
          ip: data['ip']?.toString() ?? '',
          country: data['country']?.toString() ?? '',
          countryCode: data['country_code']?.toString() ?? '',
          region: data['region']?.toString() ?? '',
          city: data['city']?.toString() ?? '',
          isp: data['isp']?.toString() ?? (data['organization']?.toString() ?? ''),
          asn: data['asn'] != null ? 'AS${data['asn']}' : '',
          isProxy: isProxy,
        );
      }
    } catch (_) {}

    // 2. Try ipwho.is as fallback
    try {
      final data = await _fetchFromUrl('https://ipwho.is/', proxyPort);
      if (data != null && data['ip'] != null) {
        final conn = data['connection'] is Map ? data['connection'] : {};
        return IpInfoData(
          ip: data['ip']?.toString() ?? '',
          country: data['country']?.toString() ?? '',
          countryCode: data['country_code']?.toString() ?? '',
          region: data['region']?.toString() ?? '',
          city: data['city']?.toString() ?? '',
          isp: conn['isp']?.toString() ?? (conn['org']?.toString() ?? ''),
          asn: conn['asn'] != null ? 'AS${conn['asn']}' : '',
          isProxy: isProxy,
        );
      }
    } catch (_) {}

    // 3. Try myip.la as fallback
    try {
      final data = await _fetchFromUrl('https://api.myip.la/en?json', proxyPort);
      if (data != null && data['ip'] != null) {
        final loc = data['location'] is Map ? data['location'] : {};
        return IpInfoData(
          ip: data['ip']?.toString() ?? '',
          country: loc['country_name']?.toString() ?? '',
          countryCode: loc['country_code']?.toString() ?? '',
          region: loc['province']?.toString() ?? '',
          city: loc['city']?.toString() ?? '',
          isp: '',
          asn: '',
          isProxy: isProxy,
        );
      }
    } catch (_) {}

    return null;
  }

  static Future<Map<String, dynamic>?> _fetchFromUrl(String url, int? proxyPort) async {
    HttpClient? client;
    try {
      client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 6);
      if (proxyPort != null && proxyPort > 0) {
        client.findProxy = (uri) => 'PROXY 127.0.0.1:$proxyPort';
      } else {
        client.findProxy = (uri) => 'DIRECT';
      }

      final request = await client.getUrl(Uri.parse(url)).timeout(const Duration(seconds: 6));
      request.headers.set(HttpHeaders.userAgentHeader, 'Wmimo/1.0');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close().timeout(const Duration(seconds: 6));
      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        return jsonDecode(body) as Map<String, dynamic>;
      }
    } catch (_) {
      return null;
    } finally {
      client?.close(force: true);
    }
    return null;
  }
}
