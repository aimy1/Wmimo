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
  final String timezoneUtc;
  final String postal;
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
    this.timezoneUtc = '',
    this.postal = '',
    this.latitude,
    this.longitude,
    this.isProxy = false,
  });

  String get ipType => ip.contains(':') ? 'IPv6' : 'IPv4';

  String get flagEmoji {
    if (countryCode.length != 2) return "🌐";
    final int firstLetter = countryCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
    final int secondLetter = countryCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
    return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
  }

  String get formattedCoordinates {
    if (latitude == null || longitude == null) return '';
    final lat = latitude!;
    final lon = longitude!;
    final latStr = "${lat.abs().toStringAsFixed(2)}°${lat >= 0 ? 'N' : 'S'}";
    final lonStr = "${lon.abs().toStringAsFixed(2)}°${lon >= 0 ? 'E' : 'W'}";
    return "$latStr, $lonStr";
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

  String get locationString {
    final parts = <String>[];
    if (country.isNotEmpty) parts.add(country);
    if (region.isNotEmpty && region != country) parts.add(region);
    if (city.isNotEmpty && city != country && city != region) parts.add(city);
    return parts.isEmpty ? (country.isNotEmpty ? country : "-") : parts.join(' · ');
  }

  String get timezoneDisplay {
    if (timezone.isEmpty) return timezoneUtc;
    if (timezoneUtc.isNotEmpty) {
      return "$timezone ($timezoneUtc)";
    }
    return timezone;
  }
}

class IpInfoHelper {
  static Future<IpInfoData?> fetchIpInfo({int? proxyPort, bool isProxy = false}) async {
    // 1. Try ip.sb first (fast, comprehensive)
    try {
      final data = await _fetchFromUrl('https://api.ip.sb/geoip', proxyPort);
      if (data != null && data['ip'] != null) {
        double? lat;
        double? lon;
        if (data['latitude'] != null) lat = double.tryParse(data['latitude'].toString());
        if (data['longitude'] != null) lon = double.tryParse(data['longitude'].toString());
        final asnNum = _formatAsn(data['asn']);
        final orgName = data['organization']?.toString() ?? (data['asn_organization']?.toString() ?? '');
        final ispName = data['isp']?.toString() ?? orgName;
        final tzUtc = _formatOffset(data['offset']);

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
          timezoneUtc: tzUtc,
          postal: data['postal_code']?.toString() ?? '',
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
        final asnNum = _formatAsn(conn['asn']);
        final ispName = conn['isp']?.toString() ?? '';
        final orgName = conn['org']?.toString() ?? ispName;
        final tzUtc = tz['utc'] != null ? "UTC${tz['utc']}" : '';

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
          timezoneUtc: tzUtc,
          postal: data['postal']?.toString() ?? '',
          latitude: lat,
          longitude: lon,
          isProxy: isProxy,
        );
      }
    } catch (_) {}

    // 3. Try ipapi.co as fallback
    try {
      final data = await _fetchFromUrl('https://ipapi.co/json/', proxyPort);
      if (data != null && data['ip'] != null) {
        double? lat;
        double? lon;
        if (data['latitude'] != null) lat = double.tryParse(data['latitude'].toString());
        if (data['longitude'] != null) lon = double.tryParse(data['longitude'].toString());
        final asnNum = _formatAsn(data['asn']);
        final orgName = data['org']?.toString() ?? '';
        final tzUtc = _formatOffset(data['utc_offset']);

        return IpInfoData(
          ip: data['ip']?.toString() ?? '',
          country: data['country_name']?.toString() ?? '',
          countryCode: data['country_code']?.toString() ?? '',
          region: data['region']?.toString() ?? '',
          city: data['city']?.toString() ?? '',
          isp: orgName,
          org: orgName,
          asn: asnNum,
          timezone: data['timezone']?.toString() ?? '',
          timezoneUtc: tzUtc,
          postal: data['postal']?.toString() ?? '',
          latitude: lat,
          longitude: lon,
          isProxy: isProxy,
        );
      }
    } catch (_) {}

    // 4. Try ip-api.com as fallback
    try {
      final data = await _fetchFromUrl('http://ip-api.com/json', proxyPort);
      if (data != null && data['query'] != null) {
        double? lat;
        double? lon;
        if (data['lat'] != null) lat = double.tryParse(data['lat'].toString());
        if (data['lon'] != null) lon = double.tryParse(data['lon'].toString());
        final asnNum = _formatAsn(data['as']);
        final ispName = data['isp']?.toString() ?? '';
        final orgName = data['org']?.toString() ?? ispName;

        return IpInfoData(
          ip: data['query']?.toString() ?? '',
          country: data['country']?.toString() ?? '',
          countryCode: data['countryCode']?.toString() ?? '',
          region: data['regionName']?.toString() ?? (data['region']?.toString() ?? ''),
          city: data['city']?.toString() ?? '',
          isp: ispName.isNotEmpty ? ispName : orgName,
          org: orgName.isNotEmpty ? orgName : ispName,
          asn: asnNum,
          timezone: data['timezone']?.toString() ?? '',
          timezoneUtc: '',
          postal: data['zip']?.toString() ?? '',
          latitude: lat,
          longitude: lon,
          isProxy: isProxy,
        );
      }
    } catch (_) {}

    // 5. Try myip.la as fallback
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
          timezoneUtc: '',
          postal: '',
          latitude: lat,
          longitude: lon,
          isProxy: isProxy,
        );
      }
    } catch (_) {}

    return null;
  }

  static String _formatAsn(dynamic rawAsn) {
    if (rawAsn == null) return '';
    final str = rawAsn.toString().trim();
    if (str.isEmpty) return '';
    if (str.toUpperCase().startsWith('AS')) {
      final parts = str.split(' ');
      return parts.first.toUpperCase();
    }
    return 'AS$str';
  }

  static String _formatOffset(dynamic offset) {
    if (offset == null) return '';
    final str = offset.toString().trim();
    if (str.isEmpty) return '';
    final numVal = int.tryParse(str);
    if (numVal != null) {
      if (numVal.abs() >= 1800) {
        // Offset in seconds (e.g., -28800 -> UTC-8, 28800 -> UTC+8)
        final hours = (numVal / 3600).round();
        final sign = hours >= 0 ? '+' : '';
        return "UTC$sign$hours";
      } else if (numVal.abs() >= 100 && numVal.abs() <= 1400) {
        // Offset in HHMM format (e.g., +0800 -> UTC+8, -0530 -> UTC-5:30)
        final hours = numVal ~/ 100;
        final mins = numVal.abs() % 100;
        final sign = hours >= 0 ? '+' : '';
        return mins == 0
            ? "UTC$sign$hours"
            : "UTC$sign$hours:${mins.toString().padLeft(2, '0')}";
      } else {
        final sign = numVal >= 0 ? '+' : '';
        return "UTC$sign$numVal";
      }
    }
    if (str.startsWith('+') || str.startsWith('-')) {
      return "UTC$str";
    }
    return str;
  }

  static Future<Map<String, dynamic>?> _fetchFromUrl(String url, int? proxyPort) async {
    HttpClient? client;
    try {
      client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 5);
      if (proxyPort != null && proxyPort > 0) {
        client.findProxy = (uri) => 'PROXY 127.0.0.1:$proxyPort';
      } else {
        client.findProxy = (uri) => 'DIRECT';
      }

      final request = await client.getUrl(Uri.parse(url)).timeout(const Duration(seconds: 5));
      request.headers.set(HttpHeaders.userAgentHeader, 'Wmimo/1.0');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close().timeout(const Duration(seconds: 5));
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
