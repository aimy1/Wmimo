import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/screens/logs_screen.dart';

void main() {
  group('ClashLog.fromLogLine tests', () {
    test('parses standard Go logrus info line with timestamp and msg', () {
      const line =
          'time="2026-10-28T20:38:45.476636900+08:00" level=info msg="Geodata Loader mode: memconservative"';
      final log = ClashLog.fromLogLine(line);

      expect(log.type, equals('info'));
      expect(log.payload, equals('Geodata Loader mode: memconservative'));
      expect(log.time.hour, isNotNull);
    });

    test('parses warning line with quoted msg and unescapes internal characters', () {
      const line =
          'time="2026-10-22T13:45:39.752532400+08:00" level=warning msg="invalid Ipcidr:[103.96. 152.0/21]"';
      final log = ClashLog.fromLogLine(line);

      expect(log.type, equals('warning'));
      expect(log.payload, equals('invalid Ipcidr:[103.96. 152.0/21]'));
    });

    test('parses error line with escaped quotes inside msg', () {
      const line =
          'time="2026-10-28T20:44:06.900400400+08:00" level=error msg="failed to get response: Head \\"http://www.gstatic.com/generate_204\\": context deadline exceeded"';
      final log = ClashLog.fromLogLine(line);

      expect(log.type, equals('error'));
      expect(
        log.payload,
        equals(
          'failed to get response: Head "http://www.gstatic.com/generate_204": context deadline exceeded',
        ),
      );
    });

    test('handles fallback for raw stdout / panic line', () {
      const line = 'FATAL: could not bind to port 7890';
      final log = ClashLog.fromLogLine(line);

      expect(log.type, equals('error'));
      expect(log.payload, equals(line));
    });

    test('handles empty line without crashing', () {
      final log = ClashLog.fromLogLine('   ');
      expect(log.type, equals(''));
      expect(log.payload, equals(''));
    });
  });

  group('LogsScreen normalizeLevel tests', () {
    test('normalizes error and fatal to ERROR', () {
      expect(LogsScreen.normalizeLevel('error'), equals('ERROR'));
      expect(LogsScreen.normalizeLevel('ERROR'), equals('ERROR'));
      expect(LogsScreen.normalizeLevel('fatal'), equals('ERROR'));
      expect(LogsScreen.normalizeLevel('FATAL'), equals('ERROR'));
    });

    test('normalizes warning and warn to WARN', () {
      expect(LogsScreen.normalizeLevel('warning'), equals('WARN'));
      expect(LogsScreen.normalizeLevel('WARNING'), equals('WARN'));
      expect(LogsScreen.normalizeLevel('warn'), equals('WARN'));
      expect(LogsScreen.normalizeLevel('WARN'), equals('WARN'));
    });

    test('normalizes debug to DEBUG', () {
      expect(LogsScreen.normalizeLevel('debug'), equals('DEBUG'));
      expect(LogsScreen.normalizeLevel('DEBUG'), equals('DEBUG'));
    });

    test('normalizes info and other/empty to INFO', () {
      expect(LogsScreen.normalizeLevel('info'), equals('INFO'));
      expect(LogsScreen.normalizeLevel('INFO'), equals('INFO'));
      expect(LogsScreen.normalizeLevel(''), equals('INFO'));
      expect(LogsScreen.normalizeLevel('unknown'), equals('INFO'));
    });
  });
}
