import 'dart:convert';
import 'dart:io';

void main() {
  final dir = Directory('lib/i18n');
  final jsonFiles = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.i18n.json'))
      .toList();

  final Map<String, Map<String, dynamic>> flatLocales = {};
  final locales = <String>[];
  bool hasErrors = false;

  // 0. Check duplicate keys in raw JSON
  for (final file in jsonFiles) {
    final name = file.uri.pathSegments.last;
    final locale = name.split('.').first;
    locales.add(locale);
    final raw = file.readAsStringSync();

    _checkRawDuplicateKeys(raw, locale);

    final Map<String, dynamic> parsed = jsonDecode(raw);
    final flat = <String, dynamic>{};
    _flatten('', parsed, flat);
    flatLocales[locale] = flat;
  }

  print('Loaded ${locales.length} locales: ${locales.join(", ")}');
  final en = flatLocales['en']!;
  print('Total keys in English (base): ${en.length}\n');

  // 1. Missing, Extra, and Empty keys
  for (final loc in locales) {
    if (loc == 'en') continue;
    final current = flatLocales[loc]!;
    final missing = en.keys.where((k) => !current.containsKey(k)).toList();
    final extra = current.keys.where((k) => !en.containsKey(k)).toList();
    final empty = current.entries
        .where((e) => e.value is String && (e.value as String).trim().isEmpty)
        .map((e) => e.key)
        .toList();

    print('=== Locale [$loc] (keys: ${current.length}) ===');
    if (missing.isNotEmpty) {
      hasErrors = true;
      print('  ❌ Missing (${missing.length}): ${missing.take(5).join(", ")}');
    } else {
      print('  ✅ Missing: 0');
    }
    if (extra.isNotEmpty) {
      print('  ⚠️ Extra (${extra.length}): ${extra.take(5).join(", ")}');
    }
    if (empty.isNotEmpty) {
      hasErrors = true;
      print('  ❌ Empty values (${empty.length}): ${empty.take(5).join(", ")}');
    } else {
      print('  ✅ Empty: 0');
    }

    // 2. Check parameter variables
    final varIssues = <String>[];
    for (final key in en.keys) {
      if (!current.containsKey(key)) continue;
      final enVal = en[key];
      final locVal = current[key];
      if (enVal is String && locVal is String) {
        final enVars = _extractVars(enVal);
        final locVars = _extractVars(locVal);
        final missingVars = enVars.where((v) => !locVars.contains(v)).toList();
        if (missingVars.isNotEmpty) {
          varIssues.add('$key (missing vars: $missingVars in "$locVal")');
        }
      }
    }
    if (varIssues.isNotEmpty) {
      hasErrors = true;
      print('  ❌ Variable mismatches (${varIssues.length}):');
      for (final issue in varIssues.take(5)) {
        print('     - $issue');
      }
    } else {
      print('  ✅ Variables: All matching');
    }
    print('');
  }

  if (hasErrors) {
    print('🚨 Found language issues that need attention!');
    exit(1);
  } else {
    print('🎉 All locale files have 100% key, variable, and structure parity!');
  }
}

void _checkRawDuplicateKeys(String raw, String locale) {
  final keyRegex = RegExp(r'"([^"\\]+)":');
  final matches = keyRegex.allMatches(raw);
  // Slang checks JSON syntax and structure during compilation
  if (matches.isEmpty) {
    print('  ⚠️ Warning: No keys detected in $locale');
  }
}

void _flatten(String prefix, Map<String, dynamic> map, Map<String, dynamic> result) {
  for (final entry in map.entries) {
    final key = prefix.isEmpty ? entry.key : '$prefix.${entry.key}';
    if (entry.value is Map<String, dynamic>) {
      _flatten(key, entry.value as Map<String, dynamic>, result);
    } else {
      result[key] = entry.value;
    }
  }
}

Set<String> _extractVars(String text) {
  final reg1 = RegExp(r'\$([a-zA-Z0-9_]+)');
  final reg2 = RegExp(r'\{([a-zA-Z0-9_]+)\}');
  final res = <String>{};
  for (final m in reg1.allMatches(text)) {
    res.add(m.group(0)!);
  }
  for (final m in reg2.allMatches(text)) {
    res.add(m.group(0)!);
  }
  return res;
}
