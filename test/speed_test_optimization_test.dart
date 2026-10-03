import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/screens/speed_test_screen.dart';

void main() {
  group('SpeedTestServer Tests', () {
    test('Presets contain expected default servers', () {
      final presets = SpeedTestServer.presets;
      expect(presets.length, greaterThanOrEqualTo(4));

      final cf = presets.firstWhere((s) => s.id == 'cloudflare');
      expect(cf.downloadUrl, contains('speed.cloudflare.com'));
      expect(cf.pingUrls, isNotEmpty);

      final fast = presets.firstWhere((s) => s.id == 'fast');
      expect(fast.name, contains('Fast.com'));

      final apple = presets.firstWhere((s) => s.id == 'apple');
      expect(apple.name, contains('Apple'));

      final cachefly = presets.firstWhere((s) => s.id == 'cachefly');
      expect(cachefly.name, contains('CacheFly'));
    });
  });

  group('NetworkGrade Rating Tests', () {
    test('Calculates S-Grade gaming and 8K streaming accurately', () {
      final grade = NetworkGrade.calculate(
        ping: 28.0,
        jitter: 3.0,
        download: 120.0,
        upload: 35.0,
      );

      expect(grade.gameGrade, 'S 级');
      expect(grade.streamGrade, '8K 超清');
      expect(grade.meetingGrade, '极佳');
    });

    test('Calculates A-Grade gaming and 4K streaming accurately', () {
      final grade = NetworkGrade.calculate(
        ping: 65.0,
        jitter: 12.0,
        download: 45.0,
        upload: 15.0,
      );

      expect(grade.gameGrade, 'A 级');
      expect(grade.streamGrade, '4K 臻彩');
      expect(grade.meetingGrade, '良好');
    });

    test('Calculates C-Grade gaming and standard streaming for degraded network', () {
      final grade = NetworkGrade.calculate(
        ping: 250.0,
        jitter: 50.0,
        download: 8.0,
        upload: 2.0,
      );

      expect(grade.gameGrade, 'C 级');
      expect(grade.streamGrade, '标清');
      expect(grade.meetingGrade, '一般');
    });
  });

  group('SpeedTestRecord Serialization Tests', () {
    test('Serializes to and deserializes from JSON with serverName intact', () {
      final now = DateTime.now();
      final record = SpeedTestRecord(
        time: now,
        nodeName: 'HK IPLC 01',
        ping: 32.5,
        jitter: 4.1,
        downloadSpeed: 156.8,
        uploadSpeed: 42.0,
        isProxy: true,
        serverName: 'Cloudflare Anycast',
      );

      final json = record.toJson();
      expect(json['nodeName'], 'HK IPLC 01');
      expect(json['serverName'], 'Cloudflare Anycast');
      expect(json['downloadSpeed'], 156.8);

      final restored = SpeedTestRecord.fromJson(json);
      expect(restored.nodeName, record.nodeName);
      expect(restored.serverName, record.serverName);
      expect(restored.ping, record.ping);
      expect(restored.jitter, record.jitter);
      expect(restored.downloadSpeed, record.downloadSpeed);
      expect(restored.uploadSpeed, record.uploadSpeed);
      expect(restored.isProxy, record.isProxy);
    });
  });
}
