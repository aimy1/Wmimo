import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Internationalization (i18n) Completeness & Integrity Tests', () {
    const locales = ['ar', 'en', 'es', 'fa', 'ja', 'ko', 'ru', 'zh-CN', 'zh-TW'];
    final Map<String, Map<String, dynamic>> rawJsonMaps = {};
    final Map<String, Map<String, String>> flattenedKeyMaps = {};

    Map<String, String> flattenMap(Map<String, dynamic> source, [String prefix = '']) {
      final Map<String, String> result = {};
      source.forEach((key, value) {
        final fullKey = prefix.isEmpty ? key : '$prefix.$key';
        if (value is Map<String, dynamic>) {
          result.addAll(flattenMap(value, fullKey));
        } else if (value is Map) {
          result.addAll(flattenMap(Map<String, dynamic>.from(value), fullKey));
        } else {
          result[fullKey] = value?.toString() ?? '';
        }
      });
      return result;
    }

    setUpAll(() {
      for (final locale in locales) {
        final file = File('lib/i18n/$locale.i18n.json');
        expect(file.existsSync(), isTrue, reason: 'i18n file for $locale must exist');
        final content = file.readAsStringSync();
        final parsed = jsonDecode(content) as Map<String, dynamic>;
        rawJsonMaps[locale] = parsed;
        flattenedKeyMaps[locale] = flattenMap(parsed);
      }
    });

    test('All 9 locales are present and load valid non-empty JSON', () {
      expect(flattenedKeyMaps.length, equals(9));
      for (final locale in locales) {
        expect(flattenedKeyMaps[locale]!.length, greaterThan(300),
            reason: '$locale key count should be substantial');
      }
    });

    test('Zero missing keys between baseline (zh-CN) and all other locales', () {
      final baseKeys = flattenedKeyMaps['zh-CN']!.keys.toSet();
      final Map<String, List<String>> missingReport = {};

      for (final locale in locales) {
        if (locale == 'zh-CN') continue;
        final currentKeys = flattenedKeyMaps[locale]!.keys.toSet();
        final missing = baseKeys.difference(currentKeys).toList();
        if (missing.isNotEmpty) {
          missingReport[locale] = missing;
        }
      }

      if (missingReport.isNotEmpty) {
        fail('Found missing i18n keys:\n${const JsonEncoder.withIndent('  ').convert(missingReport)}');
      }
      expect(missingReport.isEmpty, isTrue);
    });

    test('Placeholder parameter consistency across all translations', () {
      final baseMap = flattenedKeyMaps['en']!;
      final placeholderRegex = RegExp(r'\{([a-zA-Z0-9_]+)\}');
      final Map<String, List<String>> inconsistencies = {};

      for (final entry in baseMap.entries) {
        final key = entry.key;
        final enVal = entry.value;
        final enMatches = placeholderRegex.allMatches(enVal).map((m) => m.group(1)!).toSet();

        if (enMatches.isEmpty) continue;

        for (final locale in locales) {
          if (locale == 'en') continue;
          final val = flattenedKeyMaps[locale]![key];
          if (val == null) continue;
          final localMatches = placeholderRegex.allMatches(val).map((m) => m.group(1)!).toSet();
          if (!enMatches.containsAll(localMatches) || !localMatches.containsAll(enMatches)) {
            inconsistencies.putIfAbsent(locale, () => []).add(
                '$key: expected $enMatches but got $localMatches in "$val"');
          }
        }
      }

      if (inconsistencies.isNotEmpty) {
        fail('Found placeholder inconsistencies:\n${const JsonEncoder.withIndent('  ').convert(inconsistencies)}');
      }
      expect(inconsistencies.isEmpty, isTrue);
    });

    test('Reports verifiable key count statistics and 100% parity', () {
      final baseCount = flattenedKeyMaps['zh-CN']!.length;
      for (final locale in locales) {
        final count = flattenedKeyMaps[locale]!.length;
        final parity = (count / baseCount) * 100;
        expect(count, equals(baseCount),
            reason: '$locale has $count keys vs $baseCount baseline (${parity.toStringAsFixed(1)}%)');
      }
    });
  });
}
