import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/clash/clash_config.dart';
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
}
