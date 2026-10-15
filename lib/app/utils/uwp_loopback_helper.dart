// ignore_for_file: empty_catches

import 'dart:async';
import 'dart:io';
import 'package:wmimo/app/utils/log.dart';

class UwpAppInfo {
  final String sid;
  final String moniker;
  final String displayName;
  bool isExempt;
  final bool isCommon;

  UwpAppInfo({
    required this.sid,
    required this.moniker,
    required this.displayName,
    required this.isExempt,
    required this.isCommon,
  });

  static bool checkIsCommon(String moniker, String displayName) {
    final lower = '${moniker.toLowerCase()} ${displayName.toLowerCase()}';
    final commonKeywords = [
      'windowsstore',
      'store',
      'xbox',
      'minecraft',
      'windowsterminal',
      'terminal',
      'microsoftedge',
      'edge',
      'outlook',
      'communicationsapps',
      'mail',
      'spotify',
      'netflix',
      'gamingapp',
      'gamebar',
      'photos',
      'calculator',
      'winget',
    ];
    return commonKeywords.any((k) => lower.contains(k));
  }

  static String friendlyName(String moniker, String? rawDisplayName) {
    if (rawDisplayName != null &&
        rawDisplayName.isNotEmpty &&
        !rawDisplayName.startsWith('ms-resource:') &&
        !rawDisplayName.startsWith('@{') &&
        !rawDisplayName.startsWith('@')) {
      return rawDisplayName;
    }

    // Moniker usually looks like: Microsoft.WindowsTerminal_8wekyb3d8bbwe
    var clean = moniker;
    final underIdx = clean.lastIndexOf('_');
    if (underIdx != -1) {
      clean = clean.substring(0, underIdx);
    }
    if (clean.toLowerCase().startsWith('microsoft.')) {
      clean = clean.substring('microsoft.'.length);
    } else if (clean.toLowerCase().startsWith('microsoftcorporationii.')) {
      clean = clean.substring('microsoftcorporationii.'.length);
    }

    // Split by dots or camelCase
    final parts = clean.split('.');
    final readable = parts.map((p) {
      return p.replaceAllMapped(
        RegExp(r'([a-z])([A-Z])'),
        (m) => '${m.group(1)} ${m.group(2)}',
      );
    }).join(' ');

    return readable.trim().isNotEmpty ? readable.trim() : moniker;
  }
}

class UwpLoopbackHelper {
  static Future<Set<String>> getExemptSids() async {
    final sids = <String>{};
    if (!Platform.isWindows) return sids;

    try {
      final res = await Process.run('CheckNetIsolation.exe', [
        'LoopbackExempt',
        '-s',
      ]);
      final lines = (res.stdout as String).split(RegExp(r'\r?\n'));
      for (var line in lines) {
        line = line.trim();
        if (line.startsWith('SID:') || line.startsWith('sid:')) {
          final sid = line.substring(4).trim();
          if (sid.isNotEmpty) {
            sids.add(sid);
          }
        }
      }
    } catch (e) {
      Log.w('getExemptSids error: $e');
    }
    return sids;
  }

  static Future<List<UwpAppInfo>> loadInstalledUwpApps() async {
    final apps = <UwpAppInfo>[];
    if (!Platform.isWindows) return apps;

    final exemptSids = await getExemptSids();

    try {
      final regResult = await Process.run('reg', [
        'query',
        r'HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Mappings',
        '/s',
      ]);

      final blocks = (regResult.stdout as String).split(RegExp(r'\r?\n\r?\n'));
      for (final block in blocks) {
        if (!block.contains(r'AppContainer\Mappings\S-1-15-')) continue;
        final lines = block.split(RegExp(r'\r?\n'));
        String? sid;
        String? moniker;
        String? displayName;

        for (var l in lines) {
          l = l.trim();
          if (l.startsWith('HKEY_CURRENT_USER') && l.contains(r'Mappings\')) {
            final parts = l.split(r'Mappings\');
            if (parts.length > 1) {
              final sub = parts[1].split(r'\')[0];
              sid = sub.trim();
            }
          } else if (l.startsWith('Moniker')) {
            final parts = l.split(RegExp(r'\s+REG_SZ\s+'));
            if (parts.length > 1) moniker = parts[1].trim();
          } else if (l.startsWith('DisplayName')) {
            final parts = l.split(RegExp(r'\s+REG_SZ\s+'));
            if (parts.length > 1) displayName = parts[1].trim();
          }
        }

        if (sid != null && moniker != null && moniker.isNotEmpty) {
          final fName = UwpAppInfo.friendlyName(moniker, displayName);
          final isCommon = UwpAppInfo.checkIsCommon(moniker, fName);
          apps.add(UwpAppInfo(
            sid: sid,
            moniker: moniker,
            displayName: fName,
            isExempt: exemptSids.contains(sid),
            isCommon: isCommon,
          ));
        }
      }
    } catch (e) {
      Log.w('loadInstalledUwpApps error: $e');
    }

    // Sort: Common apps first, then alphabetically
    apps.sort((a, b) {
      if (a.isCommon && !b.isCommon) return -1;
      if (!a.isCommon && b.isCommon) return 1;
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });

    return apps;
  }

  static Future<bool> applyExemptions({
    required List<UwpAppInfo> allApps,
    required Set<String> targetExemptSids,
  }) async {
    if (!Platform.isWindows) return false;

    final currentExemptSids = await getExemptSids();
    final toAdd = targetExemptSids.difference(currentExemptSids);
    final toRemove = currentExemptSids.difference(targetExemptSids);

    try {
      // Execute adds and removes in parallel chunks
      final futures = <Future<ProcessResult>>[];
      for (final sid in toAdd) {
        futures.add(
          Process.run('CheckNetIsolation.exe', [
            'LoopbackExempt',
            '-a',
            '-p=$sid',
          ]),
        );
      }
      for (final sid in toRemove) {
        futures.add(
          Process.run('CheckNetIsolation.exe', [
            'LoopbackExempt',
            '-d',
            '-p=$sid',
          ]),
        );
      }
      await Future.wait(futures);

      for (var app in allApps) {
        app.isExempt = targetExemptSids.contains(app.sid);
      }
      return true;
    } catch (e) {
      Log.w('applyExemptions error: $e');
      return false;
    }
  }
}
