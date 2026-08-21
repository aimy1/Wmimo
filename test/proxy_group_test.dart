import 'package:flutter_test/flutter_test.dart';
import 'package:libclash_vpn_service/vpn_service.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';

void main() {
  group('ClashProtocolType tests', () {
    test('isGroupType correctly identifies proxy group types', () {
      expect(ClashProtocolType.isGroupType('Selector'), isTrue);
      expect(ClashProtocolType.isGroupType('selector'), isTrue);
      expect(ClashProtocolType.isGroupType('select'), isTrue);
      expect(ClashProtocolType.isGroupType('Select'), isTrue);
      expect(ClashProtocolType.isGroupType('URLTest'), isTrue);
      expect(ClashProtocolType.isGroupType('urltest'), isTrue);
      expect(ClashProtocolType.isGroupType('url-test'), isTrue);
      expect(ClashProtocolType.isGroupType('Fallback'), isTrue);
      expect(ClashProtocolType.isGroupType('fallback'), isTrue);
      expect(ClashProtocolType.isGroupType('LoadBalance'), isTrue);
      expect(ClashProtocolType.isGroupType('loadbalance'), isTrue);
      expect(ClashProtocolType.isGroupType('load-balance'), isTrue);
      expect(ClashProtocolType.isGroupType('Relay'), isTrue);
      expect(ClashProtocolType.isGroupType('relay'), isTrue);

      expect(ClashProtocolType.isGroupType('ss'), isFalse);
      expect(ClashProtocolType.isGroupType('vmess'), isFalse);
      expect(ClashProtocolType.isGroupType('vless'), isFalse);
      expect(ClashProtocolType.isGroupType('trojan'), isFalse);
      expect(ClashProtocolType.isGroupType('Direct'), isFalse);
      expect(ClashProtocolType.isGroupType(''), isFalse);
      expect(ClashProtocolType.isGroupType(null), isFalse);
    });
  });

  group('ProxyNodeLoader YAML Parsing tests', () {
    const sampleYaml = '''
mixed-port: 7890
allow-lan: false
mode: rule
log-level: info

proxies:
  - name: "HK Node 01"
    type: vmess
    server: 1.1.1.1
    port: 443
    uuid: 12345678-1234-1234-1234-123456789abc
    alterId: 0
    cipher: auto
  - name: "US Node 01"
    type: ss
    server: 2.2.2.2
    port: 8388
    cipher: aes-128-gcm
    password: pass

proxy-groups:
  - name: 节点选择
    type: select
    proxies:
      - "HK Node 01"
      - "US Node 01"
      - DIRECT
  - name: 自动选择
    type: url-test
    url: http://www.gstatic.com/generate_204
    interval: 300
    proxies:
      - "HK Node 01"
      - "US Node 01"

rules:
  - DOMAIN-SUFFIX,google.com,节点选择
  - MATCH,DIRECT
''';

    test('extractProxiesList extracts all proxies without truncation', () {
      final proxies = ProxyNodeLoader.extractProxiesList(sampleYaml);
      expect(proxies.length, equals(2));
      expect(proxies[0]['name'], equals('HK Node 01'));
      expect(proxies[0]['type'], equals('vmess'));
      expect(proxies[1]['name'], equals('US Node 01'));
      expect(proxies[1]['type'], equals('ss'));
    });

    test('extractProxyGroupsList extracts all proxy-groups without truncation', () {
      final groups = ProxyNodeLoader.extractProxyGroupsList(sampleYaml);
      expect(groups.length, equals(2));
      expect(groups[0]['name'], equals('节点选择'));
      expect(groups[0]['type'], equals('select'));
      expect(groups[1]['name'], equals('自动选择'));
      expect(groups[1]['type'], equals('url-test'));
    });

    test('parseProfileContent extracts both nodes and groups', () {
      final allNodes = ProxyNodeLoader.parseProfileContent(sampleYaml);
      expect(allNodes.isNotEmpty, isTrue);

      final groups = allNodes.where((n) => ClashProtocolType.isGroupType(n.type)).toList();
      expect(groups.length, equals(2));
      expect(groups[0].name, equals('节点选择'));
      expect(groups[0].all, containsAll(['HK Node 01', 'US Node 01', 'DIRECT']));
      expect(groups[1].name, equals('自动选择'));
    });
  });

  group('VpnServiceConfig tests', () {
    test('VpnServiceConfig properly serializes and deserializes mode and tun_mode', () {
      final config = VpnServiceConfig();
      config.control_port = 9090;
      config.mixed_port = 7890;
      config.mode = "global";
      config.tun_mode = true;
      config.secret = "test-secret";

      final json = config.toJson();
      expect(json['mode'], equals('global'));
      expect(json['tun_mode'], isTrue);
      expect(json['control_port'], equals(9090));
      expect(json['mixed_port'], equals(7890));

      final restored = VpnServiceConfig();
      restored.fromJson(json);
      expect(restored.mode, equals('global'));
      expect(restored.tun_mode, isTrue);
      expect(restored.control_port, equals(9090));
      expect(restored.mixed_port, equals(7890));
    });
  });

  group('ClashProxiesNode and ClashProxies delay tests', () {
    test('ClashProxiesNode.fromJson parses delay safely under various history formats', () {
      // 1. Empty history
      final node1 = ClashProxiesNode();
      node1.fromJson({
        'name': 'Node 1',
        'type': 'Shadowsocks',
        'history': [],
      });
      expect(node1.delay, isNull);

      // 2. Normal delay int
      final node2 = ClashProxiesNode();
      node2.fromJson({
        'name': 'Node 2',
        'type': 'Shadowsocks',
        'history': [
          {'time': '2026-08-22T02:00:00Z', 'delay': 180},
        ],
      });
      expect(node2.delay, equals(180));

      // 3. Timeout / 0 delay
      final node3 = ClashProxiesNode();
      node3.fromJson({
        'name': 'Node 3',
        'type': 'Shadowsocks',
        'history': [
          {'time': '2026-08-22T02:00:00Z', 'delay': 0},
        ],
      });
      expect(node3.delay, isNull);

      // 4. Null / Missing delay in history map
      final node4 = ClashProxiesNode();
      node4.fromJson({
        'name': 'Node 4',
        'type': 'Shadowsocks',
        'history': [
          {'time': '2026-08-22T02:00:00Z', 'delay': null},
        ],
      });
      expect(node4.delay, isNull);

      // 5. Double / num delay
      final node5 = ClashProxiesNode();
      node5.fromJson({
        'name': 'Node 5',
        'type': 'Shadowsocks',
        'history': [
          {'time': '2026-08-22T02:00:00Z', 'delay': 245.0},
        ],
      });
      expect(node5.delay, equals(245));
    });

    test('updateGroupDelay handles mutual recursive reference without stack overflow', () {
      final proxies = ClashProxies();
      final groupA = ClashProxiesNode()
        ..name = 'Group A'
        ..type = 'Selector'
        ..now = 'Group B'
        ..all = ['Group B'];
      final groupB = ClashProxiesNode()
        ..name = 'Group B'
        ..type = 'Selector'
        ..now = 'Group A'
        ..all = ['Group A'];
      proxies.proxies = [groupA, groupB];

      final delay = proxies.updateGroupDelay(groupA);
      expect(delay, isNull);
    });

    test('ClashProxies.fromJsonProxies parses real Clash API response after speed test', () {
      final jsonMap = {
        'proxies': {
          'GLOBAL': {
            'all': ['节点选择', '自动选择', 'DIRECT'],
            'history': [],
            'name': 'GLOBAL',
            'now': '节点选择',
            'type': 'Selector',
          },
          '节点选择': {
            'all': ['HK 01', 'US 01'],
            'history': [],
            'name': '节点选择',
            'now': 'HK 01',
            'type': 'Selector',
          },
          'HK 01': {
            'history': [
              {'time': '2026-08-22T02:00:00Z', 'delay': 120},
            ],
            'name': 'HK 01',
            'type': 'Shadowsocks',
          },
          'US 01': {
            'history': [
              {'time': '2026-08-22T02:00:00Z', 'delay': 0},
            ],
            'name': 'US 01',
            'type': 'Vmess',
          },
          'DIRECT': {
            'history': [],
            'name': 'DIRECT',
            'type': 'Direct',
          },
        },
      };

      final clashProxies = ClashProxies();
      clashProxies.fromJsonProxies(jsonMap);
      expect(clashProxies.proxies.isNotEmpty, isTrue);

      final hkNode = clashProxies.proxies.firstWhere((n) => n.name == 'HK 01');
      expect(hkNode.delay, equals(120));

      final usNode = clashProxies.proxies.firstWhere((n) => n.name == 'US 01');
      expect(usNode.delay, isNull);
    });
  });
}

