import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/profile_manager.dart';

void main() {
  group('Profiles Search Filtering Logic Tests', () {
    final profile1 = ProfileSetting(
      id: 'sub_hongkong.yaml',
      remark: '香港高速专线',
      url: 'https://hk.airport.example.com/api/v1/client/subscribe?token=abc',
    );

    final profile2 = ProfileSetting(
      id: 'sub_us_backup.yaml',
      remark: '美国备用节点',
      url: 'https://us.nodes.net/sub',
    );

    final profile3 = ProfileSetting(
      id: 'company_intranet.json',
      remark: '公司内网直连',
      url: '',
    );

    final all = [profile1, profile2, profile3];

    List<ProfileSetting> filter(String query) {
      if (query.trim().isEmpty) return all;
      final kw = query.trim().toLowerCase();
      return all.where((s) {
        final name = s.getShowName().toLowerCase();
        final remark = s.remark.toLowerCase();
        final url = s.url.toLowerCase();
        final id = s.id.toLowerCase();

        return name.contains(kw) ||
            remark.contains(kw) ||
            url.contains(kw) ||
            id.contains(kw);
      }).toList();
    }

    test('Empty query returns all profiles', () {
      expect(filter('').length, equals(3));
      expect(filter('   ').length, equals(3));
    });

    test('Searches by remark in Chinese', () {
      final results = filter('香港');
      expect(results.length, equals(1));
      expect(results.first.id, equals('sub_hongkong.yaml'));

      final backupResults = filter('备用');
      expect(backupResults.length, equals(1));
      expect(backupResults.first.id, equals('sub_us_backup.yaml'));
    });

    test('Searches by domain or URL part case-insensitively', () {
      final results = filter('AIRPORT.EXAMPLE.COM');
      expect(results.length, equals(1));
      expect(results.first.remark, equals('香港高速专线'));

      final usResults = filter('nodes.net');
      expect(usResults.length, equals(1));
      expect(usResults.first.id, equals('sub_us_backup.yaml'));
    });

    test('Searches by file ID or extension', () {
      final jsonResults = filter('.json');
      expect(jsonResults.length, equals(1));
      expect(jsonResults.first.id, equals('company_intranet.json'));

      final yamlResults = filter('.yaml');
      expect(yamlResults.length, equals(2));
    });

    test('Returns empty when no match', () {
      final results = filter('non_existent_keyword_xyz');
      expect(results, isEmpty);
    });
  });
}
