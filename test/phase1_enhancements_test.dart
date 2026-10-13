import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/screens/proxy_board_screen.dart';
import 'package:wmimo/app/utils/node_region_helper.dart';

void main() {
  group('Phase 1 - Node Multiplier Extraction Tests', () {
    test('Extracts multipliers correctly from various node name formats', () {
      expect(ProxyBoardScreen.extractMultiplier('🇭🇰 香港 01 [0.5x]'), 0.5);
      expect(ProxyBoardScreen.extractMultiplier('🇹🇼 台湾 02 1.5倍'), 1.5);
      expect(ProxyBoardScreen.extractMultiplier('🇯🇵 日本 03 - 2X'), 2.0);
      expect(ProxyBoardScreen.extractMultiplier('🇺🇸 美国 04 | 0.2x'), 0.2);
      expect(ProxyBoardScreen.extractMultiplier('🇸🇬 新加坡 05 无倍率标注'), 1.0);
      expect(ProxyBoardScreen.extractMultiplier('特殊节点 10倍率'), 10.0);
    });
  });

  group('Phase 1 - Node Regex Filtering Tests', () {
    test('Filters nodes using regex OR expressions (e.g. hk|tw)', () {
      final nodes = [
        ClashProxiesNode()..name = '🇭🇰 香港 01 (0.5x)'..type = 'Shadowsocks',
        ClashProxiesNode()..name = '🇹🇼 台湾 02 (1.0x)'..type = 'Vmess',
        ClashProxiesNode()..name = '🇺🇸 美国 03 (2.0x)'..type = 'Trojan',
        ClashProxiesNode()..name = '🇯🇵 日本 04 (1.0x)'..type = 'Hysteria2',
      ];

      final pattern = 'hk|tw';
      final regex = RegExp(pattern, caseSensitive: false);

      final matched = nodes.where((n) {
        final region = NodeRegionHelper.getRegion(n.name);
        return regex.hasMatch(n.name) ||
            regex.hasMatch(region.name) ||
            regex.hasMatch(region.nameEn) ||
            regex.hasMatch(region.code) ||
            regex.hasMatch(n.type);
      }).toList();

      expect(matched.length, 2);
      expect(matched[0].name, contains('香港'));
      expect(matched[1].name, contains('台湾'));
    });

    test('Filters nodes using multiplier regex (e.g. 0\\.\\d+x)', () {
      final nodes = [
        ClashProxiesNode()..name = '🇭🇰 香港 01 0.2x'..type = 'Shadowsocks',
        ClashProxiesNode()..name = '🇭🇰 香港 02 0.5x'..type = 'Shadowsocks',
        ClashProxiesNode()..name = '🇹🇼 台湾 03 1.0x'..type = 'Vmess',
        ClashProxiesNode()..name = '🇺🇸 美国 04 2.0x'..type = 'Trojan',
      ];

      final regex = RegExp(r'0\.\d+x', caseSensitive: false);
      final matched = nodes.where((n) => regex.hasMatch(n.name)).toList();

      expect(matched.length, 2);
      expect(matched.map((n) => n.name), containsAll(['🇭🇰 香港 01 0.2x', '🇭🇰 香港 02 0.5x']));
    });
  });

  group('Phase 1 - Multi-Dimensional Sorting Tests', () {
    test('Sorts nodes by multiplier ascending', () {
      final nodes = [
        ClashProxiesNode()..name = 'Node C (2.0x)',
        ClashProxiesNode()..name = 'Node A (0.2x)',
        ClashProxiesNode()..name = 'Node B (1.0x)',
        ClashProxiesNode()..name = 'Node D (0.5x)',
      ];

      nodes.sort((a, b) {
        final multA = ProxyBoardScreen.extractMultiplier(a.name);
        final multB = ProxyBoardScreen.extractMultiplier(b.name);
        final cmp = multA.compareTo(multB);
        if (cmp != 0) return cmp;
        return a.name.compareTo(b.name);
      });

      expect(nodes[0].name, 'Node A (0.2x)');
      expect(nodes[1].name, 'Node D (0.5x)');
      expect(nodes[2].name, 'Node B (1.0x)');
      expect(nodes[3].name, 'Node C (2.0x)');
    });

    test('Sorts nodes by latency descending', () {
      final nodes = [
        ClashProxiesNode()..name = 'A'..delay = 50,
        ClashProxiesNode()..name = 'B'..delay = 200,
        ClashProxiesNode()..name = 'C'..delay = 100,
      ];

      nodes.sort((a, b) {
        final aDelay = a.delay ?? -1;
        final bDelay = b.delay ?? -1;
        final cmp = bDelay.compareTo(aDelay);
        if (cmp != 0) return cmp;
        return a.name.compareTo(b.name);
      });

      expect(nodes[0].name, 'B');
      expect(nodes[1].name, 'C');
      expect(nodes[2].name, 'A');
    });
  });
}
