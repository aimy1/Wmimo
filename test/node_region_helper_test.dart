import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/utils/node_region_helper.dart';

void main() {
  group('NodeRegionHelper Tests', () {
    test('Identifies regional flags from Chinese names correctly', () {
      expect(NodeRegionHelper.getFlag('🇭🇰 香港 01 [BGP]'), '🇭🇰');
      expect(NodeRegionHelper.getFlag('🇯🇵 日本东京 02 [专线]'), '🇯🇵');
      expect(NodeRegionHelper.getFlag('🇸🇬 新加坡 03 [0.5x]'), '🇸🇬');
      expect(NodeRegionHelper.getFlag('🇺🇸 美国洛杉矶 04'), '🇺🇸');
      expect(NodeRegionHelper.getFlag('🇹🇼 台湾台北 05'), '🇹🇼');
      expect(NodeRegionHelper.getFlag('🇰🇷 韩国首尔 06'), '🇰🇷');
      expect(NodeRegionHelper.getFlag('🇬🇧 英国伦敦 07'), '🇬🇧');
      expect(NodeRegionHelper.getFlag('🇩🇪 德国法兰克福 08'), '🇩🇪');
    });

    test('Identifies regional flags from English abbreviations and airport codes', () {
      expect(NodeRegionHelper.getFlag('HK-BGP-01'), '🇭🇰');
      expect(NodeRegionHelper.getFlag('JP-Tokyo-NRT'), '🇯🇵');
      expect(NodeRegionHelper.getFlag('SG-Changi-01'), '🇸🇬');
      expect(NodeRegionHelper.getFlag('US-LAX-02'), '🇺🇸');
      expect(NodeRegionHelper.getFlag('TW-TPE-01'), '🇹🇼');
      expect(NodeRegionHelper.getFlag('KR-ICN-01'), '🇰🇷');
      expect(NodeRegionHelper.getFlag('UK-LHR-01'), '🇬🇧');
      expect(NodeRegionHelper.getFlag('FRA-DE-01'), '🇩🇪');
      expect(NodeRegionHelper.getFlag('SYD-AU-01'), '🇦🇺');
      expect(NodeRegionHelper.getFlag('YVR-CA-01'), '🇨🇦');
    });

    test('Identifies special groups like Auto, Fallback, Direct', () {
      expect(NodeRegionHelper.getFlag('自动选择'), '⚡');
      expect(NodeRegionHelper.getFlag('AUTO-TEST'), '⚡');
      expect(NodeRegionHelper.getFlag('故障转移'), '🛡️');
      expect(NodeRegionHelper.getFlag('DIRECT'), '🎯');
    });

    test('extractAvailableRegions counts accurately', () {
      final nodes = [
        ClashProxiesNode()..name = 'HK 01',
        ClashProxiesNode()..name = 'HK 02',
        ClashProxiesNode()..name = 'JP Tokyo',
        ClashProxiesNode()..name = 'US Los Angeles',
        ClashProxiesNode()..name = 'Unknown Node 99',
      ];

      final regions = NodeRegionHelper.extractAvailableRegions(nodes);

      // ALL should have 5
      expect(regions.first.region.code, 'ALL');
      expect(regions.first.count, 5);

      // HK should have 2
      final hk = regions.firstWhere((r) => r.region.code == 'HK');
      expect(hk.count, 2);

      // JP should have 1
      final jp = regions.firstWhere((r) => r.region.code == 'JP');
      expect(jp.count, 1);

      // US should have 1
      final us = regions.firstWhere((r) => r.region.code == 'US');
      expect(us.count, 1);

      // OTHER should have 1
      final other = regions.firstWhere((r) => r.region.code == 'OTHER');
      expect(other.count, 1);
    });

    test('LatencyTestTarget presets are defined correctly', () {
      expect(LatencyTestTarget.presets.length, greaterThanOrEqualTo(5));
      expect(LatencyTestTarget.defaultTarget.id, 'cloudflare');
      expect(LatencyTestTarget.presets.any((t) => t.id == 'google'), isTrue);
      expect(LatencyTestTarget.presets.any((t) => t.id == 'openai'), isTrue);
      expect(LatencyTestTarget.presets.any((t) => t.id == 'bilibili'), isTrue);
    });
  });
}
