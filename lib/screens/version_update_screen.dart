// ignore_for_file: unused_catch_stack

import 'dart:io';
import 'dart:ui';

import 'package:app_installer/app_installer.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/auto_update_manager.dart';
import 'package:wmimo/app/utils/install_referrer_utils.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class VersionUpdateScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "VersionUpdateScreen");
  }

  const VersionUpdateScreen({super.key});

  @override
  State<VersionUpdateScreen> createState() => _VersionUpdateScreenState();
}

class _VersionUpdateScreenState
    extends LasyRenderingState<VersionUpdateScreen> {
  bool _installing = false;
  bool _downloading = false;
  String? _installerPath;

  @override
  void initState() {
    super.initState();
    AutoUpdateManager.onEventCheck.add(_onUpdateEvent);
    _checkStatus();
  }

  @override
  void dispose() {
    AutoUpdateManager.onEventCheck.remove(_onUpdateEvent);
    super.dispose();
  }

  void _onUpdateEvent() {
    if (mounted) {
      _checkStatus();
    }
  }

  Future<void> _checkStatus() async {
    final path = await AutoUpdateManager.checkReplace();
    final downloading = AutoUpdateManager.isDownloading();
    if (mounted) {
      setState(() {
        _installerPath = path;
        _downloading = downloading;
      });
    }
  }

  Future<void> _startDownload() async {
    setState(() {
      _downloading = true;
    });
    final success = await AutoUpdateManager.download(force: true);
    if (!mounted) return;
    if (!success) {
      setState(() {
        _downloading = false;
      });
      final tcontext = Translations.of(context);
      DialogUtils.showAlertDialog(
        context,
        tcontext.meta.downloadFailedTip,
        showCopy: true,
      );
    } else {
      await _checkStatus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    var checkVersion = AutoUpdateManager.getVersionCheck();

    return Scaffold(
      appBar: AppBar(
        title: Text(tcontext.meta.autoUpdate),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: ThemeDefine.kColorBlue.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.system_update_rounded,
                    color: ThemeDefine.kColorBlue,
                    size: 38,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _installerPath != null
                      ? tcontext.VersionUpdateScreen.versionReady(
                          p: checkVersion.version,
                        )
                      : tcontext.meta.discoveredNewVersion(version: checkVersion.version),
                  style: const TextStyle(
                    fontSize: ThemeConfig.kFontSizeListItem,
                    fontWeight: ThemeConfig.kFontWeightListItem,
                    color: ThemeDefine.kColorBlue,
                  ),
                ),
                const SizedBox(height: 30),
                if (_installing) ...[
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: RepaintBoundary(
                      child: CircularProgressIndicator(
                        color: ThemeDefine.kColorGreenBright,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(tcontext.meta.preparingUpdate),
                ] else if (_installerPath != null) ...[
                  SizedBox(
                    height: 45.0,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeDefine.kColorBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await checkReplace();
                      },
                      child: Text(tcontext.VersionUpdateScreen.update),
                    ),
                  ),
                ] else if (_downloading) ...[
                  const SizedBox(
                    width: 28,
                    height: 28,
                    child: RepaintBoundary(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(tcontext.meta.downloadingPackage),
                ] else ...[
                  SizedBox(
                    height: 45.0,
                    width: 200,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeDefine.kColorBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _startDownload,
                      child: Text(tcontext.meta.downloadUpdateNow),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (checkVersion.url.isNotEmpty)
                    TextButton(
                      onPressed: () async {
                        await launchUrl(
                          Uri.parse(checkVersion.url),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                      child: Text(tcontext.meta.downloadFromWeb),
                    ),
                ],
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    tcontext.VersionUpdateScreen.cancel,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> checkReplace() async {
    String? installer = await AutoUpdateManager.checkReplace();
    if (!mounted) {
      return;
    }
    if (installer == null) {
      await _checkStatus();
      if (_installerPath == null) {
        await _startDownload();
      }
      return;
    }
    if (_installing) {
      return;
    }
    _installing = true;
    setState(() {});
    try {
      await VPNService.stop();
      if (Platform.isWindows) {
        await launchUrl(Uri.file(installer));
        await Future.delayed(const Duration(milliseconds: 500));
        await ServicesBinding.instance.exitApplication(AppExitType.required);
      } else if (Platform.isMacOS) {
        await launchUrl(Uri.file(installer));
        await Future.delayed(const Duration(milliseconds: 500));
        await ServicesBinding.instance.exitApplication(AppExitType.required);
      } else if (Platform.isAndroid) {
        await AppInstaller.installApk(installer);
      } else if (Platform.isLinux) {
        if (!mounted) {
          return;
        }

        final channelName = InstallReferrerUtils.getBuildChannelName();
        if (channelName.toLowerCase().contains("appimage")) {
          await Process.run("chmod", ["+x", installer]);
          await Process.start(installer, [], mode: ProcessStartMode.detached);
          await ServicesBinding.instance.exitApplication(AppExitType.required);
          return;
        }

        String? password = await DialogUtils.showPasswordInputDialog(context);
        if (password == null || password.isEmpty) {
          _installing = false;
          setState(() {});
          return;
        }
        final shell = Platform.environment['SHELL'] ?? 'bash';
        final arguments = ["-c"];
        if (channelName.toLowerCase().contains("deb")) {
          arguments.add('echo "$password" | sudo -S dpkg -i "$installer"');
        } else if (channelName.toLowerCase().contains("rpm")) {
          arguments.add('echo "$password" | sudo -S rpm -i "$installer"');
        } else {
          arguments.add('echo "$password" | sudo -S dpkg -i "$installer"');
        }
        final result = await Process.run(shell, arguments);
        if (result.exitCode != 0) {
          if (!mounted) {
            _installing = false;
            setState(() {});
            return;
          }
          final tcontext = Translations.of(context);
          DialogUtils.showAlertDialog(
            context,
            tcontext.meta.installFailedWithCode(
              installer: installer,
              code: result.exitCode.toString(),
            ),
            showCopy: true,
            showFAQ: true,
            withVersion: true,
          );
          _installing = false;
          setState(() {});
          return;
        }
        await ServicesBinding.instance.exitApplication(AppExitType.required);
      }
    } catch (err, stacktrace) {
      Log.w("VersionUpdateScreen.checkReplace exception ${err.toString()}");
      _installing = false;
      if (!mounted) {
        return;
      }
      DialogUtils.showAlertDialog(
        context,
        err.toString(),
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
      setState(() {});
    }
    _installing = false;
    if (!mounted) {
      setState(() {});
    }
  }
}
