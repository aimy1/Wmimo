import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yaml/yaml.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/modules/chain_proxy_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/chain_proxy_edit_dialog.dart';
import 'package:wmimo/screens/chain_proxy_screen.dart';

void main() {
  group('ChainProxyItem serialization & backward compatibility', () {
    test('migrates legacy hop1/hop2 fields into hops list', () {
      final legacy = ChainProxyItem.fromJson({
        'id': '100',
        'name': 'HK -> US',
        'hop1': 'HK-Relay',
        'hop2': 'US-Exit',
        'enabled': true,
        'delay': 120,
      });

      expect(legacy.hops, ['HK-Relay', 'US-Exit']);
      expect(legacy.hop1, 'HK-Relay');
      expect(legacy.hop2, 'US-Exit');
      expect(legacy.toJson()['hops'], ['HK-Relay', 'US-Exit']);
    });

    test('preserves 3+ multi-hop list in toJson/fromJson', () {
      final item = ChainProxyItem(
        id: '200',
        name: 'HK -> JP -> US',
        hops: ['HK-1', 'JP-2', 'US-3'],
      );
      final roundTrip = ChainProxyItem.fromJson(item.toJson());
      expect(roundTrip.hops, ['HK-1', 'JP-2', 'US-3']);
      expect(roundTrip.hop1, 'HK-1');
      expect(roundTrip.hop2, 'US-3');
    });
  });

  group('ChainProxyManager YAML dialer-proxy injection', () {
    const baseYaml = '''
port: 7890
proxies:
  - name: "HK-Entry"
    type: ss
    server: hk.example.com
    port: 443
    cipher: aes-128-gcm
    password: secret
  - name: "JP-Transit"
    type: trojan
    server: jp.example.com
    port: 443
    password: secret
  - name: "US-Exit"
    type: vless
    server: us.example.com
    port: 443
    uuid: 11111111-1111-1111-1111-111111111111

proxy-groups:
  - name: "🚀 节点选择"
    type: select
    proxies:
      - "HK-Entry"
      - "US-Exit"
  - name: "🌊 FlowSelect"
    type: select
    proxies: ["HK-Entry", "JP-Transit"]
  - name: "⚡ 自动选择"
    type: url-test
    url: http://www.gstatic.com/generate_204
    interval: 300
    proxies:
      - "HK-Entry"
      - "US-Exit"
''';

    test('injects 3-hop dialer-proxy chain and mounts into select groups cleanly', () {
      final chain = ChainProxyItem(
        id: 'c1',
        name: '🔗 HK ➔ JP ➔ US',
        hops: ['HK-Entry', 'JP-Transit', 'US-Exit'],
      );

      final result = ChainProxyManager.applyToProfileContent(baseYaml, [chain]);
      final parsed = loadYaml(result) as YamlMap;
      final proxies = (parsed['proxies'] as YamlList).cast<YamlMap>();

      final hop2 = proxies.firstWhere(
        (p) => p['name'].toString().contains('Hop 2'),
      );
      final finalNode = proxies.firstWhere(
        (p) => p['name'] == '🔗 HK ➔ JP ➔ US',
      );

      expect(hop2['type'], 'trojan');
      expect(hop2['dialer-proxy'], 'HK-Entry');
      expect(finalNode['type'], 'vless');
      expect(finalNode['dialer-proxy'], hop2['name']);

      // Verify select groups contain the final chain name, while url-test group does not
      final groups = (parsed['proxy-groups'] as YamlList).cast<YamlMap>();
      final mainSelect = groups.firstWhere((g) => g['name'] == '🚀 节点选择');
      final flowSelect = groups.firstWhere((g) => g['name'] == '🌊 FlowSelect');
      final autoGroup = groups.firstWhere((g) => g['name'] == '⚡ 自动选择');

      expect((mainSelect['proxies'] as YamlList), contains('🔗 HK ➔ JP ➔ US'));
      expect((flowSelect['proxies'] as YamlList), contains('🔗 HK ➔ JP ➔ US'));
      expect((autoGroup['proxies'] as YamlList), isNot(contains('🔗 HK ➔ JP ➔ US')));
    });

    test('supports entry hop referencing a policy group and skips invalid/missing hops', () {
      final validGroupEntryChain = ChainProxyItem(
        id: 'c2',
        name: '🔗 Auto ➔ US',
        hops: ['⚡ 自动选择', 'US-Exit'],
      );
      final missingNodeChain = ChainProxyItem(
        id: 'c3',
        name: 'BrokenChain',
        hops: ['NonExistentNode', 'US-Exit'],
      );
      final groupAsExitChain = ChainProxyItem(
        id: 'c4',
        name: 'BadExitGroup',
        hops: ['HK-Entry', '⚡ 自动选择'],
      );

      final result = ChainProxyManager.applyToProfileContent(
        baseYaml,
        [validGroupEntryChain, missingNodeChain, groupAsExitChain],
      );
      final parsed = loadYaml(result) as YamlMap;
      final proxies = (parsed['proxies'] as YamlList).cast<YamlMap>();

      expect(proxies.any((p) => p['name'] == '🔗 Auto ➔ US'), isTrue);
      expect(proxies.any((p) => p['name'] == 'BrokenChain'), isFalse);
      expect(proxies.any((p) => p['name'] == 'BadExitGroup'), isFalse);

      final cleaned = ChainProxyManager.removeInjectedBlock(result);
      final parsedCleaned = loadYaml(cleaned) as YamlMap;
      final cleanedProxies = (parsedCleaned['proxies'] as YamlList).cast<YamlMap>();
      expect(cleanedProxies.length, 3);
    });

    test('preserves 0-space indentation under proxies:', () {
      const zeroIndentYaml = '''
proxies:
- name: "NodeA"
  type: ss
  server: a.example.com
  port: 443
  cipher: aes-128-gcm
  password: p
- name: "NodeB"
  type: ss
  server: b.example.com
  port: 443
  cipher: aes-128-gcm
  password: p
proxy-groups:
- name: "PROXY"
  type: select
  proxies:
  - "NodeA"
  - "NodeB"
''';
      final chain = ChainProxyItem(
        id: 'z1',
        name: 'ZeroChain',
        hops: ['NodeA', 'NodeB'],
      );
      final result = ChainProxyManager.applyToProfileContent(zeroIndentYaml, [chain]);
      final parsed = loadYaml(result) as YamlMap;
      expect((parsed['proxies'] as YamlList).length, 3);
      final proxyGroup = (parsed['proxy-groups'] as YamlList).first as YamlMap;
      expect(proxyGroup['proxies'], contains('ZeroChain'));
    });
  });

  group('Chain Proxy UI widgets (Beta)', () {
    setUp(() async {
      await LocaleSettings.setLocale(AppLocale.zhCn);
    });

    testWidgets('ChainProxyScreen shows Beta title and single add CTA without FAB overlap', (tester) async {
      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: ChainProxyScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('(Beta)'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('ChainProxyEditDialog shows Beta badge and swaps hops cleanly', (tester) async {
      final nodes = [
        ClashProxiesNode()..name = '🇭🇰 香港 01'..type = 'VLESS',
        ClashProxiesNode()..name = '🇺🇸 美国 01'..type = 'Trojan',
      ];
      final initial = ChainProxyItem(
        id: 'edit1',
        name: '',
        hops: ['🇭🇰 香港 01', '🇺🇸 美国 01'],
      );

      ChainProxyItem? savedResult;
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: ElevatedButton(
                  onPressed: () async {
                    savedResult = await ChainProxyEditDialog.show(
                      context,
                      initialItem: initial,
                      availableNodes: nodes,
                    );
                  },
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('互换相邻节点'), findsOneWidget);

      await tester.tap(find.text('互换相邻节点'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('保存'));
      await tester.pumpAndSettle();

      expect(savedResult, isNotNull);
      expect(savedResult!.hops, ['🇺🇸 美国 01', '🇭🇰 香港 01']);
    });
  });
}
