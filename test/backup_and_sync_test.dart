import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:wmimo/app/utils/backup_and_sync_utils.dart';
import 'package:wmimo/app/utils/zip_utils.dart';

void main() {
  group('BackupAndSyncUtils integrity & schema tests', () {
    test('getZipFileNameList includes chain_proxies.json and marks optional files safely', () {
      final list = BackupAndSyncUtils.getZipFileNameList();
      final names = BackupAndSyncUtils.getFileNamesFromList(list);

      expect(names, contains(BackupAndSyncUtils.chainProxiesFileName));

      final map = {for (final t in list) t.item1: t.item2};
      // Optional files should not block fresh-install backups
      expect(map[BackupAndSyncUtils.chainProxiesFileName], isFalse);
      expect(map['diversion_template.json'], isFalse);
      expect(map['providers.json'], isFalse);
      expect(map['board_sessions.json'], isFalse);
    });

    test('validZip validates compatible backups, rejects zip-slip and incompatible archives', () async {
      final tempDir = await Directory.systemTemp.createTemp('wmimo_backup_test_');
      addTearDown(() async {
        if (await tempDir.exists()) {
          await tempDir.delete(recursive: true);
        }
      });

      // 1. Valid backup zip containing setting.json and chain_proxies.json
      final settingFile = File(path.join(tempDir.path, 'setting.json'));
      await settingFile.writeAsString('{"auto_orientation": true}');
      final chainFile = File(path.join(tempDir.path, BackupAndSyncUtils.chainProxiesFileName));
      await chainFile.writeAsString('[]');

      final validZipPath = path.join(tempDir.path, 'valid.zip');
      final zipErr = await ZipUtils.zip([settingFile.path, chainFile.path], validZipPath);
      expect(zipErr, isNull);
      expect(await BackupAndSyncUtils.validZip(validZipPath), isNull);

      // 2. Incompatible zip containing unrelated file
      final randomFile = File(path.join(tempDir.path, 'unrelated.txt'));
      await randomFile.writeAsString('hello');
      final badZipPath = path.join(tempDir.path, 'incompatible.zip');
      await ZipUtils.zip([randomFile.path], badZipPath);
      final badRes = await BackupAndSyncUtils.validZip(badZipPath);
      expect(badRes, isNotNull);
      expect(badRes!.message, contains('not compatible'));

      // 3. Zip-slip traversal path entry must be rejected
      final archive = Archive()
        ..addFile(ArchiveFile.string('../evil.json', '{}'));
      final slipBytes = ZipEncoder().encodeBytes(archive);
      final slipZipPath = path.join(tempDir.path, 'slip.zip');
      await File(slipZipPath).writeAsBytes(slipBytes, flush: true);

      final slipRes = await BackupAndSyncUtils.validZip(slipZipPath);
      expect(slipRes, isNotNull);
      expect(slipRes!.message, contains('Insecure file path'));
    });
  });
}
