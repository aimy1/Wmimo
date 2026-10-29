import 'dart:convert';
import 'dart:io';

void main() {
  const locales = ['ar', 'en', 'es', 'fa', 'ja', 'ko', 'ru', 'zh-CN', 'zh-TW'];
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

  for (final locale in locales) {
    final file = File('lib/i18n/$locale.i18n.json');
    final parsed = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    flattenedKeyMaps[locale] = flattenMap(parsed);
  }

  final baseKeys = flattenedKeyMaps['zh-CN']!.keys.toSet();
  print('=====================================================');
  print('          i18n Completeness Verification Report       ');
  print('=====================================================');
  print('Total Baseline Keys (zh-CN): ${baseKeys.length}');
  print('-----------------------------------------------------');
  print('| Locale | Total Keys | Missing Keys | Completeness |');
  print('|:-------|:-----------|:-------------|:-------------|');

  for (final locale in locales) {
    final currentKeys = flattenedKeyMaps[locale]!.keys.toSet();
    final missing = baseKeys.difference(currentKeys);
    final count = currentKeys.length;
    final pct = (count / baseKeys.length * 100).toStringAsFixed(1);
    print('| $locale | $count | ${missing.length} | $pct% |');
  }
  print('=====================================================');
}
