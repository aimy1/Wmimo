// ignore_for_file: unused_catch_stack

import 'dart:io';

import 'package:wmimo/app/extension/datetime.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:wmimo/app/runtime/return_result.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/zip_utils.dart';
import 'package:path/path.dart' as path;
import 'package:tuple/tuple.dart';

class BackupAndSyncUtils {
  static String getZipExtension() => 'zip';

  static String getZipFileName() {
    final appName = AppUtils.getName();
    final appVersion = AppUtils.getBuildinVersion();
    var name =
        '${appName}_${appVersion}_${Platform.operatingSystem}_${DateTime.now().formatLikeFileNameTimestamp}.backup.${getZipExtension()}';
    name = name.replaceAll(' ', '');
    return name;
  }

  static Future<String> getZipFilePath() async {
    final dir = await PathUtils.cacheDir();
    return path.join(dir, getZipFileName());
  }

  static const String chainProxiesFileName = 'chain_proxies.json';

  static List<Tuple2<String, bool>> getZipFileNameList() {
    final profiles = ProfileManager.getProfiles();
    final profilePatchs = ProfilePatchManager.getProfilePatchs();
    var list = [
      Tuple2(PathUtils.serviceCoreSettingFileName(), false),
      Tuple2(PathUtils.settingFileName(), true),
      Tuple2(PathUtils.profilesFileName(), true),
      Tuple2(PathUtils.profilePatchsFileName(), false),
      Tuple2(PathUtils.diversionTemplateFileName(), false),
      Tuple2(PathUtils.providersConfigFileName(), false),
      Tuple2(PathUtils.boardSessionFileName(), false),
      const Tuple2(chainProxiesFileName, false),
    ];
    if (profiles.isNotEmpty) {
      list.add(Tuple2(PathUtils.profilesName(), true));
    }
    if (profilePatchs.isNotEmpty) {
      list.add(Tuple2(PathUtils.profilePatchsName(), false));
    }

    return list;
  }

  static List<String> getFileNamesFromList(List<Tuple2<String, bool>> list) {
    return list.map((tuple) => tuple.item1).toList();
  }

  static Future<ReturnResultError?> validZip(String zipPath) async {
    final result = await ZipUtils.list(zipPath);
    if (result.error != null) {
      return result.error;
    }
    if (result.data!.isEmpty) {
      return ReturnResultError('backup zip file is empty');
    }

    final expectedFileNames = getFileNamesFromList(getZipFileNameList());
    final actualFileNames = result.data!;
    for (final name in actualFileNames) {
      if (name.contains("..") ||
          name.startsWith("/") ||
          name.startsWith("\\") ||
          name.contains(":")) {
        return ReturnResultError('Insecure file path detected in backup: $name');
      }
    }
    final normalizedActual = actualFileNames
        .map((n) => n.split(RegExp(r'[\\/]')).first)
        .toSet();
    final intersection = expectedFileNames.toSet().intersection(normalizedActual);

    if (intersection.isEmpty) {
      return ReturnResultError('backup zip file is not compatible');
    }
    return null;
  }
}
