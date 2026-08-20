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
  final String org;
  final String asn;
  final String timezone;
  final double? latitude;
  final double? longitude;
  final bool isProxy;

  IpInfoData({
    required this.ip,
    this.country = '',
    this.countryCode = '',
    this.region = '',
    this.city = '',
    this.isp = '',
    this.org = '',
    this.asn = '',
    this.timezone = '',
    this.latitude,
    this.longitude,
    this.isProxy = false,
  });

  String get flagEmoji {
    if (countryCode.length != 2) return "🌐";
    final int firstLetter = countryCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  String get coordinatesString {
    if (latitude == null || longitude == null) {
      return countryCode;
    }
    final latStr = latitude!.toStringAsFixed(2);
    final lonStr = longitude!.toStringAsFixed(2);
    if (countryCode.isNotEmpty) {
      return "$countryCode, $lonStr, $latStr";
    }
    return "$lonStr, $latStr";
  }

  String get locationCityRegion {
    if (city.isNotEmpty && region.isNotEmpty && city != region) {
      return "$city, $region";
    }
    if (city.isNotEmpty) return city;
    if (region.isNotEmpty) return region;
    return country.isNotEmpty ? country : "-";
  }
}

class IpInfoHelper {
  static Future<IpInfoData?> fetchIpInfo({int? proxyPort, bool isProxy = false}) async {
    // 1. Try ip.sb first
    try {
      final data = await _fetchFromUrl('https://api.ip.sb/geoip', proxyPort);
      if (data != null && data['ip'] != null) {
        double? lat;
        double? lon;
        if (data['latitude'] != null) lat = double.tryParse(data['latitude'].toString());
        if (data['longitude'] != null) lon = double.tryParse(data['longitude'].toString());
        final asnNum = data['asn'] != null ? 'AS${data['asn']}' : '';
        final orgName = data['organization']?.toString() ?? (data['asn_organization']?.toString() ?? '');
        final ispName = data['isp']?.toString() ?? orgName;

        return IpInfoData(
          ip: data['ip']?.toString() ?? '',
          country: data['country']?.toString() ?? '',
          countryCode: data['country_code']?.toString() ?? '',
          region: data['region']?.toString() ?? '',
          city: data['city']?.toString() ?? '',
          isp: ispName.isNotEmpty ? ispName : orgName,
          org: orgName.isNotEmpty ? orgName : ispName,
          asn: asnNum,
          timezone: data['timezone']?.toString() ?? '',
          latitude: lat,
          longitude: lon,
          isProxy: isProxy,
        );
      }
    } catch (_) {}

    // 2. Try ipwho.is as fallback
    try {
      final data = await _fetchFromUrl('https://ipwho.is/', proxyPort);
      if (data != null && data['ip'] != null) {
        final conn = data['connection'] is Map ? data['connection'] : {};
        final tz = data['timezone'] is Map ? data['timezone'] : {};
        double? lat;
        double? lon;
        if (data['latitude'] != null) lat = double.tryParse(data['latitude'].toString());
        if (data['longitude'] != null) lon = double.tryParse(data['longitude'].toString());
        final asnNum = conn['asn'] != null ? 'AS${conn['asn']}' : '';
        final ispName = conn['isp']?.toString() ?? '';
        final orgName = conn['org']?.toString() ?? ispName;

        return IpInfoData(
          ip: data['ip']?.toString() ?? '',
          country: data['country']?.toString() ?? '',
          countryCode: data['country_code']?.toString() ?? '',
          region: data['region']?.toString() ?? '',
          city: data['city']?.toString() ?? '',
          isp: ispName.isNotEmpty ? ispName : orgName,
          org: orgName.isNotEmpty ? orgName : ispName,
          asn: asnNum,
          timezone: tz['id']?.toString() ?? '',
          latitude: lat,
          longitude: lon,
          isProxy: isProxy,
        );
      }
    } catch (_) {}

    // 3. Try myip.la as fallback
    try {
      final data = await _fetchFromUrl('https://api.myip.la/en?json', proxyPort);
      if (data != null && data['ip'] != null) {
        final loc = data['location'] is Map ? data['location'] : {};
        double? lat;
        double? lon;
        if (loc['latitude'] != null) lat = double.tryParse(loc['latitude'].toString());
        if (loc['longitude'] != null) lon = double.tryParse(loc['longitude'].toString());

        return IpInfoData(
          ip: data['ip']?.toString() ?? '',
          country: loc['country_name']?.toString() ?? '',
          countryCode: loc['country_code']?.toString() ?? '',
          region: loc['province']?.toString() ?? '',
          city: loc['city']?.toString() ?? '',
          isp: '',
          org: '',
          asn: '',
          timezone: '',
          latitude: lat,
          longitude: lon,
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
