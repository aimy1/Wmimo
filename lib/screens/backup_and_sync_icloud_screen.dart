// ignore_for_file: empty_catches

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:wmimo/app/runtime/return_result.dart';
import 'package:wmimo/app/utils/backup_and_sync_utils.dart';
import 'package:wmimo/app/utils/file_utils.dart';
import 'package:wmimo/app/utils/icloud_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/backup_helper.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class BackupAndSyncIcloudScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "BackupAndSyncIcloudScreen");
  }

  const BackupAndSyncIcloudScreen({super.key});

  @override
  State<BackupAndSyncIcloudScreen> createState() =>
      _BackupAndSyncIcloudScreenState();
}

class _BackupAndSyncIcloudScreenState
    extends LasyRenderingState<BackupAndSyncIcloudScreen>
    with AfterLayoutMixin {
  bool _loading = false;
  bool _uploading = false;
  List<String> _fileList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await list();
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 50,
                        height: 30,
                        child: Icon(Icons.arrow_back_ios_outlined, size: 26),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tcontext.meta.iCloud,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        _uploading
                            ? const Row(
                                children: [
                                  SizedBox(width: 12),
                                  SizedBox(
                                    width: 26,
                                    height: 26,
                                    child: RepaintBoundary(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                ],
                              )
                            : InkWell(
                                onTap: () {
                                  onTapBackup();
                                },
                                child: const SizedBox(
                                  width: 50,
                                  height: 30,
                                  child: Icon(
                                    Icons.cloud_upload_outlined,
                                    size: 26,
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(child: _loadListView()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadListView() {
    if (_loading) {
      return const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: RepaintBoundary(child: CircularProgressIndicator(strokeWidth: 2.5)),
        ),
      );
    }
    final tcontext = Translations.of(context);
    if (_fileList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_off_outlined,
                size: 44,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35),
              ),
              const SizedBox(height: 12),
              Text(
                tcontext.BackupAndSyncWebdavScreen.noBackupsYet,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.5,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }
    Size windowSize = MediaQuery.of(context).size;
    return Scrollbar(
      thumbVisibility: true,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: _fileList.length,
        itemBuilder: (BuildContext context, int index) {
          var current = _fileList[index];
          return createWidget(current, windowSize);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1, thickness: 0.3);
        },
      ),
    );
  }

  Widget createWidget(String current, Size windowSize) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Material(
        borderRadius: ThemeDefine.kBorderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          width: double.infinity,
          child: Row(
            children: [
              Icon(
                Icons.inventory_2_outlined,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  current,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: ThemeConfig.kFontSizeGroupItem,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.cloud_download_outlined, size: 22),
                onPressed: _uploading ? null : () => onTapDownload(current),
              ),
              IconButton(
                visualDensity: VisualDensity.compact,
                icon: const Icon(
                  Icons.remove_circle_outlined,
                  size: 22,
                  color: Colors.red,
                ),
                onPressed: _uploading ? null : () => onTapDelete(current),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> list() async {
    if (!mounted) {
      return;
    }
    _loading = true;
    setState(() {});
    var result = await ICloudUtils.list();
    if (!mounted) {
      return;
    }
    _loading = false;
    setState(() {});

    if (result.error != null) {
      DialogUtils.showAlertDialog(
        context,
        result.error!.message,
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
      return;
    }
    _fileList = result.data!;
    _fileList.sort((a, b) => b.compareTo(a));

    setState(() {});
  }

  Future<void> onTapBackup() async {
    _uploading = true;
    setState(() {});
    try {
      String dir = await PathUtils.cacheDir();
      if (!mounted) {
        return;
      }
      String filePath = path.join(dir, BackupAndSyncUtils.getZipFileName());
      ReturnResultError? error = await BackupHelper.backupToZip(
        context,
        filePath,
      );
      if (!mounted) {
        FileUtils.deletePath(filePath);
        return;
      }
      if (error != null) {
        _uploading = false;
        setState(() {});
        DialogUtils.showAlertDialog(
          context,
          error.message,
          showCopy: true,
          showFAQ: true,
          withVersion: true,
        );
        return;
      }
      error = await ICloudUtils.upload(
        relativePath: path.basename(filePath),
        localPath: filePath,
      );

      FileUtils.deletePath(filePath);
      if (!mounted) {
        return;
      }
      _uploading = false;
      setState(() {});
      if (error != null) {
        DialogUtils.showAlertDialog(
          context,
          error.message,
          showCopy: true,
          showFAQ: true,
          withVersion: true,
        );
        return;
      }
      final tcontext = Translations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(tcontext.BackupAndSyncWebdavScreen.backupSuccess),
          duration: const Duration(seconds: 2),
        ),
      );
      await list();
    } catch (err) {
      if (!mounted) {
        return;
      }
      _uploading = false;
      setState(() {});
      DialogUtils.showAlertDialog(
        context,
        err.toString(),
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
    }
  }

  Future<void> onTapDownload(String filename) async {
    final tcontext = Translations.of(context);
    bool? ok = await DialogUtils.showConfirmDialog(
      context,
      tcontext.meta.rewriteConfirm,
    );
    if (ok != true || !mounted) {
      return;
    }
    DialogUtils.showLoadingDialog(context, text: "");
    String dir = await PathUtils.cacheDir();
    String filePath = path.join(dir, BackupAndSyncUtils.getZipFileName());
    ReturnResultError? error = await ICloudUtils.download(
      relativePath: filename,
      localPath: filePath,
    );
    if (!mounted) {
      await FileUtils.deletePath(filePath);
      return;
    }
    Navigator.pop(context);
    if (error != null) {
      await FileUtils.deletePath(filePath);
      if (!mounted) return;
      DialogUtils.showAlertDialog(
        context,
        error.message,
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
      return;
    }
    await BackupHelper.backupRestoreFromZip(context, filePath);
    await FileUtils.deletePath(filePath);
  }

  Future<void> onTapDelete(String filename) async {
    final tcontext = Translations.of(context);
    final ok = await DialogUtils.showConfirmDialog(
      context,
      tcontext.BackupAndSyncWebdavScreen.deleteConfirm(name: filename),
    );
    if (ok != true || !mounted) {
      return;
    }
    var error = await ICloudUtils.delete(filename);
    if (!mounted) {
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
      return;
    }
    _fileList.remove(filename);
    setState(() {});
  }
}
