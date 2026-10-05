import 'dart:io';

void main() {
  final libDir = Directory('lib');
  final dartFiles = libDir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !f.path.contains('i18n'))
      .toList();

  final patterns = [
    RegExp(r'''Text\(\s*['"]([^'"]+)['"]'''),
    RegExp(r'''TextSpan\(\s*text:\s*['"]([^'"]+)['"]'''),
    RegExp(r'''tooltip:\s*['"]([^'"]+)['"]'''),
    RegExp(r'''showAlertDialog\(\s*[^,]+,\s*['"]([^'"]+)['"]'''),
    RegExp(r'''showSnackBar\(\s*SnackBar\(\s*content:\s*Text\(\s*['"]([^'"]+)['"]'''),
  ];

  final ignored = {
    'ms', 's', 'min', 'h', 'Mbps', 'Kbps', 'Gbps', 'B', 'KB', 'MB', 'GB', 'TB',
    'B/s', 'KB/s', 'MB/s', 'GB/s', 'OK', 'URL', 'IP', 'Direct', 'DIRECT', 'GLOBAL',
    'RULE', 'Clash', 'Wmimo', 'TUN', 'Proxy', 'HTTP', 'HTTPS', 'SOCKS5', 'TCP', 'UDP',
    'GitHub', 'Telegram', 'Android', 'iOS', 'Windows', 'macOS', 'Linux',
    'Selector', 'URLTest', 'Fallback', 'LoadBalance', 'Relay', 'Pass', 'Reject',
    'Mixed', 'Tun', 'System', 'Rule', 'Global',
  };

  print('Scanning ${dartFiles.length} files across lib/...\n');

  int foundCount = 0;
  for (final file in dartFiles) {
    // Skip protocol parsers and subscription converters
    if (file.path.contains('subscription_converter') ||
        file.path.contains('proxy_node_loader') ||
        file.path.contains('node_region_helper')) {
      continue;
    }

    final lines = file.readAsLinesSync();
    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      // Skip comments
      if (line.trim().startsWith('//') || line.trim().startsWith('/*')) continue;

      for (final p in patterns) {
        for (final match in p.allMatches(line)) {
          final content = match.group(1)!.trim();
          if (content.isEmpty) continue;
          if (RegExp(r'^[\d\s\.\:\,\-\_\/\+\%\#\*\(\)\@\!\?\>\<\=\|]+$').hasMatch(content)) continue;
          if (ignored.contains(content)) continue;
          if (content.runes.length <= 1) continue;

          print('${file.path}:${i + 1} -> "$content"');
          foundCount++;
        }
      }
    }
  }

  print('\nFound $foundCount potential unlocalized items.');
}
