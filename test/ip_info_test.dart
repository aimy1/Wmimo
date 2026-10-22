import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/utils/ip_info_helper.dart';

void main() {
  group('IpInfoData Model & Formatting Tests', () {
    test('Correctly identifies IPv4 and IPv6', () {
      final ipv4 = IpInfoData(ip: '104.21.56.12');
      expect(ipv4.ipType, equals('IPv4'));

      final ipv6 = IpInfoData(ip: '2606:4700:3037::ac43:8876');
      expect(ipv6.ipType, equals('IPv6'));
    });

    test('Formats flag emojis correctly', () {
      final us = IpInfoData(ip: '1.1.1.1', countryCode: 'US');
      expect(us.flagEmoji, equals('🇺🇸'));

      final jp = IpInfoData(ip: '1.1.1.1', countryCode: 'JP');
      expect(jp.flagEmoji, equals('🇯🇵'));

      final hk = IpInfoData(ip: '1.1.1.1', countryCode: 'HK');
      expect(hk.flagEmoji, equals('🇭🇰'));

      final invalid = IpInfoData(ip: '1.1.1.1', countryCode: '');
      expect(invalid.flagEmoji, equals('🌐'));
    });

    test('Formats coordinates into human readable latitude/longitude string', () {
      final data = IpInfoData(
        ip: '1.1.1.1',
        latitude: 34.0544,
        longitude: -118.244,
      );
      expect(data.formattedCoordinates, equals('34.05°N, 118.24°W'));

      final southern = IpInfoData(
        ip: '1.1.1.1',
        latitude: -33.8688,
        longitude: 151.2093,
      );
      expect(southern.formattedCoordinates, equals('33.87°S, 151.21°E'));

      final empty = IpInfoData(ip: '1.1.1.1');
      expect(empty.formattedCoordinates, isEmpty);
    });

    test('Formats timezone with UTC offset', () {
      final withUtc = IpInfoData(
        ip: '1.1.1.1',
        timezone: 'America/Los_Angeles',
        timezoneUtc: 'UTC-7',
      );
      expect(withUtc.timezoneDisplay, equals('America/Los_Angeles (UTC-7)'));

      final withoutUtc = IpInfoData(
        ip: '1.1.1.1',
        timezone: 'Asia/Tokyo',
      );
      expect(withoutUtc.timezoneDisplay, equals('Asia/Tokyo'));
    });

    test('Constructs location string properly without duplicate terms', () {
      final full = IpInfoData(
        ip: '1.1.1.1',
        country: 'United States',
        region: 'California',
        city: 'Los Angeles',
      );
      expect(full.locationString, equals('United States · California · Los Angeles'));

      final citySameAsCountry = IpInfoData(
        ip: '1.1.1.1',
        country: 'Singapore',
        region: 'Singapore',
        city: 'Singapore',
      );
      expect(citySameAsCountry.locationString, equals('Singapore'));
    });
  });
}
