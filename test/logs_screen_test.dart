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

  group('LogsScreen.parseLogCategory and matchesFilter tests', () {
    test('strips [Process] and [Sniffer] prefixes when extracting PROC and SNIFF tags', () {
      final proc = LogsScreen.parseLogCategory(
        '[Process] chrome.exe -> 1.1.1.1:443',
      );
      expect(proc.tag, equals('PROC'));
      expect(proc.rawBracketTag, equals('[Process]'));
      expect(proc.displayPayload, equals('chrome.exe -> 1.1.1.1:443'));

      final sniff = LogsScreen.parseLogCategory(
        '[Sniffer] replace domain [142.250.1.1] --> [www.google.com]',
      );
      expect(sniff.tag, equals('SNIFF'));
      expect(sniff.rawBracketTag, equals('[Sniffer]'));
      expect(
        sniff.displayPayload,
        equals('replace domain [142.250.1.1] --> [www.google.com]'),
      );
    });

    test('strips [DNS], [TCP], [UDP], and [Rule] prefixes cleanly', () {
      final dns = LogsScreen.parseLogCategory('[DNS] resolve www.example.com');
      expect(dns.tag, equals('DNS'));
      expect(dns.displayPayload, equals('resolve www.example.com'));

      final tcp = LogsScreen.parseLogCategory('[TCP] 127.0.0.1:1234 --> 8.8.8.8:443');
      expect(tcp.tag, equals('TCP'));
      expect(tcp.displayPayload, equals('127.0.0.1:1234 --> 8.8.8.8:443'));

      final rule = LogsScreen.parseLogCategory('[Rule] match DomainKeyword(google)');
      expect(rule.tag, equals('RULE'));
      expect(rule.displayPayload, equals('match DomainKeyword(google)'));
    });

    test('matchesFilter respects selectedLevel and searchKeyword', () {
      final errLog = ClashLog.fromLogLine(
        'time="2026-10-28T20:44:06+08:00" level=error msg="[DNS] timeout"',
      );
      final debugLog = ClashLog.fromLogLine(
        'time="2026-10-28T20:44:06+08:00" level=debug msg="[TCP] keepalive"',
      );

      expect(
        LogsScreen.matchesFilter(
          errLog,
          selectedLevel: 'ERROR',
          searchKeyword: '',
        ),
        isTrue,
      );
      expect(
        LogsScreen.matchesFilter(
          debugLog,
          selectedLevel: 'ERROR',
          searchKeyword: '',
        ),
        isFalse,
      );
      expect(
        LogsScreen.matchesFilter(
          errLog,
          selectedLevel: 'ALL',
          searchKeyword: '[dns]',
        ),
        isTrue,
      );
      expect(
        LogsScreen.matchesFilter(
          debugLog,
          selectedLevel: 'ALL',
          searchKeyword: '[dns]',
        ),
        isFalse,
      );
    });
  });
}
