import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/screens/home_screen_widgets.dart';
import 'package:wmimo/screens/proxy_board_screen.dart';
import 'package:wmimo/screens/settings_screen.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';

void main() {
  group('Phase 1 - Modular Decoupling & SettingsScreen Tests', () {
    test('SettingsScreen exposes valid route settings', () {
      final settings = SettingsScreen.routSettings();
      expect(settings.name, 'SettingsScreen');
    });

    test('HomeScreenWidgetPart2 is backwards compatible alias of SettingsScreen', () {
      const widget = HomeScreenWidgetPart2();
      expect(widget, isA<SettingsScreen>());
    });
  });

  group('Phase 2 - Latency Local Repaint & NodeLatencyState Tests', () {
    test('NodeLatencyState correctly encapsulates latency and testing status', () {
      const state1 = NodeLatencyState(null, true);
      expect(state1.delay, isNull);
      expect(state1.isTesting, isTrue);

      const state2 = NodeLatencyState(120, false);
      expect(state2.delay, 120);
      expect(state2.isTesting, isFalse);

      const state3 = NodeLatencyState(-1, false);
      expect(state3.delay, -1);
      expect(state3.isTesting, isFalse);
    });
  });

  group('Phase 3 - Network & ProxyHttpOverrides Safety Tests', () {
    test('ProxyHttpOverrides bypasses localhost and loopback addresses', () {
      expect(
        ProxyHttpOverrides.resolveProxy(Uri.parse('http://127.0.0.1:9090/proxies'), 7890),
        'DIRECT',
      );
      expect(
        ProxyHttpOverrides.resolveProxy(Uri.parse('http://localhost:9090/version'), 7890),
        'DIRECT',
      );
      expect(
        ProxyHttpOverrides.resolveProxy(Uri.parse('http://[::1]:9090/configs'), 7890),
        'DIRECT',
      );
      expect(
        ProxyHttpOverrides.resolveProxy(Uri.parse('https://example.com/api'), 7890),
        'PROXY 127.0.0.1:7890; DIRECT',
      );
    });

    test('ProxyHttpOverrides defaults to DIRECT when proxyPort is invalid or zero', () {
      expect(
        ProxyHttpOverrides.resolveProxy(Uri.parse('https://example.com'), 0),
        'DIRECT',
      );
      expect(
        ProxyHttpOverrides.resolveProxy(Uri.parse('https://example.com'), -1),
        'DIRECT',
      );
    });
  });

  group('Phase 4 - Profile Engine & Config Protection Tests', () {
    test('ensureProfileHasProxyGroups creates .orig backup and preserves original content', () async {
      final tempDir = await Directory.systemTemp.createTemp('wmimo_profile_test_');
      final testFile = File('${tempDir.path}/subscription.yaml');

      const originalYaml = '''
proxies:
  - name: "HK Node 01"
    type: ss
    server: 1.2.3.4
    port: 8388
    cipher: aes-128-gcm
    password: test
''';

      await testFile.writeAsString(originalYaml, flush: true);

      await ProxyNodeLoader.ensureProfileHasProxyGroups(testFile.path);

      // Verify backup companion file was generated
      final origBackup = File('${testFile.path}.orig');
      expect(await origBackup.exists(), isTrue);
      expect(await origBackup.readAsString(), originalYaml);

      // Verify synthesized file has proxy-groups appended
      final updatedContent = await testFile.readAsString();
      expect(updatedContent, contains('proxy-groups:'));
      expect(updatedContent, contains('HK Node 01'));
      expect(updatedContent, contains('节点选择'));

      // Clean up
      try {
        await tempDir.delete(recursive: true);
      } catch (_) {}
    });
  });
}
