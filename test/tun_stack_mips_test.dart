import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:libclash_vpn_service/vpn_service.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';

void main() {
  group('Mihomo MIPS TUN Stack Core & Model Tests', () {
    test('ClashTunStack enum has all four stacks including mips', () {
      expect(ClashTunStack.values.map((e) => e.name),
          containsAll(['gvisor', 'mixed', 'system', 'mips']));
      expect(ClashTunStack.mips.name, equals('mips'));
    });

    test('ClashTunStack.toList() contains mips on desktop platforms', () {
      final list = ClashTunStack.toList();
      if (!Platform.isIOS && !Platform.isMacOS) {
        expect(list, contains('mips'));
        expect(list, contains('gvisor'));
        expect(list, contains('mixed'));
        expect(list, contains('system'));
        expect(list.first, equals('gvisor'),
            reason: 'Fallback stack must remain gvisor for compatibility');
      } else {
        expect(list, equals(['gvisor']));
      }
    });

    testWidgets('ClashTunStack toTupleList and descriptions provide UI info',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            locale: const Locale('zh', 'CN'),
            home: Builder(
              builder: (context) {
                final tuples = ClashTunStack.toTupleList(context);
                final descriptions = ClashTunStack.getDescriptions(context);

                if (!Platform.isIOS && !Platform.isMacOS) {
                  expect(tuples.length, equals(4));
                  final mipsTuple =
                      tuples.firstWhere((item) => item.item1 == 'mips');
                  expect(mipsTuple.item2, equals('MIPS (Mihomo IP Stack)'));

                  expect(descriptions.containsKey('mips'), isTrue);
                  expect(descriptions['mips'], isNotEmpty);
                  expect(descriptions['mips'], contains('Mihomo'));
                } else {
                  expect(tuples.length, equals(1));
                  expect(tuples.first.item1, equals('gvisor'));
                }

                return const SizedBox();
              },
            ),
          ),
        ),
      );
    });

    test('RawTun serializes and deserializes mips stack properly', () {
      final tun = RawTun.by(
        OverWrite: true,
        Enable: true,
        Stack: ClashTunStack.mips.name,
        MTU: 1500,
        Inet4Address: ['172.19.0.1/30'],
      );

      final jsonMap = tun.toJson();
      expect(jsonMap['stack'], equals('mips'));
      expect(jsonMap['enable'], isTrue);
      expect(jsonMap['overwrite'], isTrue);

      final restored = RawTun.fromJson(jsonMap);
      expect(restored.Stack, equals('mips'));
      expect(restored.Enable, isTrue);
      expect(restored.MTU, equals(1500));
    });

    test('ClashSettingManager defaultTun preserves gvisor default', () {
      final defaultTun = ClashSettingManager.defaultTun();
      expect(defaultTun.Stack, equals(ClashTunStack.gvisor.name),
          reason: 'Default TUN stack must not be changed without user intent');
    });

    test('VpnServiceConfig serializes and deserializes tun_stack properly', () {
      final config = VpnServiceConfig();
      expect(config.tun_stack, equals('mixed'),
          reason: 'Default tun_stack in VpnServiceConfig must be mixed for backwards compatibility');

      config.tun_stack = ClashTunStack.mips.name;
      final json = config.toJson();
      expect(json['tun_stack'], equals('mips'));

      final restored = VpnServiceConfig();
      restored.fromJson(json);
      expect(restored.tun_stack, equals('mips'));
    });

    test('Mihomo core natively validates all 4 stacks including mips', () {
      final coreExe = File('bind/windows/core/wmimoService.exe');
      if (!coreExe.existsSync() || !Platform.isWindows) {
        return; // Skip on non-Windows test environments
      }

      final stacks = ['gvisor', 'system', 'mixed', 'mips'];
      final tempDir = Directory.systemTemp.createTempSync('wmimo_tun_test_');

      try {
        for (final stack in stacks) {
          final testYaml = '''
mixed-port: 19890
mode: rule
log-level: silent
tun:
  enable: true
  stack: $stack
  auto-route: false
  auto-detect-interface: false
''';
          final testFile = File('${tempDir.path}/test_$stack.yaml');
          testFile.writeAsStringSync(testYaml);

          final result = Process.runSync(coreExe.path, ['-t', '-f', testFile.path]);
          expect(result.exitCode, equals(0),
              reason: 'Core validation failed for stack $stack: ${result.stderr} ${result.stdout}');
          expect(result.stdout.toString(), contains('successful'),
              reason: 'Core did not report success for stack $stack');
        }
      } finally {
        tempDir.deleteSync(recursive: true);
      }
    });
  });
}
