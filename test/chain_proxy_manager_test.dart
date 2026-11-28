import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/modules/chain_proxy_manager.dart';
import 'package:wmimo/app/modules/diversion_template_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ChainProxyItem Model Tests', () {
    test('Default values and initialization', () {
      final item = ChainProxyItem(
        name: '香港 ➔ 美国',
        hop1: 'HK-01',
        hop2: 'US-01',
      );
      expect(item.id.isNotEmpty, isTrue);
      expect(item.name, equals('香港 ➔ 美国'));
      expect(item.hop1, equals('HK-01'));
      expect(item.hop2, equals('US-01'));
      expect(item.enabled, isTrue);
      expect(item.delay, isNull);
    });

    test('toJson and fromJson serialization', () {
      final original = ChainProxyItem(
        id: 'test_id_123',
        name: 'Custom Chain',
        hop1: 'SG-Transit',
        hop2: 'JP-Residential',
        enabled: false,
        delay: 245,
      );

      final json = original.toJson();
      expect(json['id'], equals('test_id_123'));
      expect(json['name'], equals('Custom Chain'));
      expect(json['hop1'], equals('SG-Transit'));
      expect(json['hop2'], equals('JP-Residential'));
      expect(json['enabled'], isFalse);
      expect(json['delay'], equals(245));

      final restored = ChainProxyItem.fromJson(json);
      expect(restored.id, equals(original.id));
      expect(restored.name, equals(original.name));
      expect(restored.hop1, equals(original.hop1));
      expect(restored.hop2, equals(original.hop2));
      expect(restored.enabled, equals(original.enabled));
      expect(restored.delay, equals(original.delay));
    });

    test('clone produces identical copy', () {
      final original = ChainProxyItem(
        id: 'clone_id',
        name: 'Clone Test',
        hop1: 'NodeA',
        hop2: 'NodeB',
        enabled: true,
        delay: 120,
      );
      final cloned = original.clone();
      expect(cloned.id, equals(original.id));
      expect(cloned.name, equals(original.name));
      expect(cloned.hop1, equals(original.hop1));
      expect(cloned.hop2, equals(original.hop2));
      expect(cloned.enabled, equals(original.enabled));
      expect(cloned.delay, equals(original.delay));
    });
  });

  group('ClashProtocolType & ProxyGroupTemplate Relay Tests', () {
    test('ClashProtocolType contains Relay and is recognized as group', () {
      expect(ClashProtocolType.relay.name, equals("Relay"));
      expect(ClashProtocolType.isGroupType("relay"), isTrue);
      expect(ClashProtocolType.isGroupType("Relay"), isTrue);
      expect(ClashProtocolType.GroupToList(), contains("Relay"));
      expect(ClashProtocolType.toList(), contains("Relay"));
    });

    test('ProxyGroupTemplate supports relay type', () {
      expect(ProxyGroupTemplate.getTypes(), contains("relay"));
      expect(ProxyGroupTemplate.toClashProtocolTypeString("relay"), equals("Relay"));
    });
  });

  group('ChainProxyManager YAML Injection & Removal Tests', () {
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('chain_proxy_test_');
    });

    tearDown(() async {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('applyToProfile injects relay proxy-groups and maintains idempotency', () async {
      final profileFile = File('${tempDir.path}/profile.yaml');
      const initialYaml = '''
proxies:
  - name: "HK-01"
    type: ss
    server: 1.1.1.1
    port: 8388
  - name: "US-01"
    type: ss
    server: 2.2.2.2
    port: 8388

proxy-groups:
  - name: "PROXY"
    type: select
    proxies:
      - "HK-01"
      - "US-01"
''';
      await profileFile.writeAsString(initialYaml);

      // Add test items into ChainProxyManager
      final item1 = ChainProxyItem(
        id: 'c1',
        name: '🔗 港美链式',
        hop1: 'HK-01',
        hop2: 'US-01',
        enabled: true,
      );
      final item2 = ChainProxyItem(
        id: 'c2',
        name: '🔗 禁用链式',
        hop1: 'HK-01',
        hop2: 'US-01',
        enabled: false,
      );

      // Access manager items directly for unit test isolation
      await ChainProxyManager.addOrUpdate(item1);
      await ChainProxyManager.addOrUpdate(item2);

      await ChainProxyManager.applyToProfile(profileFile.path);

      var content = await profileFile.readAsString();
      expect(content, contains('BEGIN WMIMO CHAIN PROXIES'));
      expect(content, contains('END WMIMO CHAIN PROXIES'));
      expect(content, contains('"dialer-proxy":"HK-01"'));
      expect(content, contains('🔗 港美链式'));
      expect(content, contains('HK-01'));
      expect(content, contains('US-01'));
      // Disabled item should not be injected
      expect(content, isNot(contains('🔗 禁用链式')));

      // Test idempotency: applying again should replace, not duplicate
      await ChainProxyManager.applyToProfile(profileFile.path);
      content = await profileFile.readAsString();
      final count = 'BEGIN WMIMO CHAIN PROXIES'.allMatches(content).length;
      expect(count, equals(1));

      // Test removal
      final cleaned = ChainProxyManager.removeInjectedBlock(content);
      expect(cleaned, isNot(contains('BEGIN WMIMO CHAIN PROXIES')));
      expect(cleaned, isNot(contains('🔗 港美链式')));
      expect(cleaned, contains('name: "PROXY"'));

      // Clean up item
      await ChainProxyManager.delete('c1');
      await ChainProxyManager.delete('c2');
    });
  });
}
