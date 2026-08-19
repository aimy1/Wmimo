// ignore_for_file: unused_catch_stack

import 'dart:io';

import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:wmimo/app/modules/diversion_template_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/runtime/return_result.dart';
import 'package:wmimo/app/utils/backup_and_sync_utils.dart';
import 'package:wmimo/app/utils/file_utils.dart';
import 'package:wmimo/app/utils/http_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/zip_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

class BackupHelper {
  static Future<ReturnResultError?> backupToZip(
    BuildContext context,
    String zipPath,
  ) async {
    var dir = await PathUtils.profileDir();
    var fileList = BackupAndSyncUtils.getZipFileNameList();
    List<String> zipFileList = [];
    try {
      for (var file in fileList) {
        var filePath = path.join(dir, file.item1);
        if (file.item2) {
          final d = Directory(filePath);
          final f = File(filePath);
          bool fexist = await f.exists();
          bool dexist = await d.exists() && (await d.list().length > 0);
          if (!fexist && !dexist) {
            if (!context.mounted) {
              return ReturnResultError("$filePath not exist");
            }
            final tcontext = Translations.of(context);
            return ReturnResultError(tcontext.meta.fileNotExist(p: filePath));
          }
          zipFileList.add(filePath);
        }
      }
      var error = await ZipUtils.zip(zipFileList, zipPath);
      return error;
    } catch (err) {
      return ReturnResultError(err.toString());
    }
  }

  static Future<ReturnResultError?> reloadFromZip(String zipPath) async {
    var result = await BackupAndSyncUtils.validZip(zipPath);
    if (result != null) {
      return result;
    }
    await VPNService.stop();
    await ProfileManager.removeAllProfile();
    await ProfilePatchManager.removeAllProfile();
    var dir = await PathUtils.profileDir();
    var error = await ZipUtils.unzip(zipPath, dir);
    if (error != null) {
      return error;
    }

    await SettingManager.reload();
    await ClashSettingManager.reload();
    await ProfileManager.reload();
    await ProfilePatchManager.reload();
    await DiversionTemplateManager.reload();
    return null;
  }

  static Future<ReturnResultError?> restoreBackupFromUrl(
    BuildContext context,
    String url,
  ) async {
    Uri? downloadUri = Uri.tryParse(url);
    if (downloadUri == null) {
      return ReturnResultError("invalid URL: $url");
    }
    if (!context.mounted) {
      return null;
    }
    final tcontext = Translations.of(context);
    bool? ok = await DialogUtils.showConfirmDialog(
      context,
      tcontext.meta.rewriteConfirm,
    );
    if (ok != true) {
      return null;
    }
    if (!context.mounted) {
      return null;
    }
    DialogUtils.showLoadingDialog(context, text: "");
    String dir = await PathUtils.cacheDir();
    String filePath = path.join(dir, BackupAndSyncUtils.getZipFileName());
    var result = await HttpUtils.httpDownload(
      downloadUri,
      filePath,
      null,
      null,
      false,
      const Duration(seconds: 10),
    );

    if (!context.mounted) {
      return null;
    }
    Navigator.pop(context);
    if (result.error != null) {
      DialogUtils.showAlertDialog(
        context,
        result.error!.message,
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
      return ReturnResultError(result.error!.message);
    }
    await backupRestoreFromZip(context, filePath);
    await FileUtils.deletePath(filePath);
    return null;
  }

  static Future<void> backupRestoreFromZip(
    BuildContext context,
    String zipPath,
  ) async {
    if (!context.mounted) {
      return;
    }
    final tcontext = Translations.of(context);

    var error = await reloadFromZip(zipPath);
    if (!context.mounted) {
      return;
    }
    if (error != null) {
      DialogUtils.showAlertDialog(
        context,
        error.message,
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
    } else {
      DialogUtils.showAlertDialog(context, tcontext.meta.importSuccess);
    }
  }
}
