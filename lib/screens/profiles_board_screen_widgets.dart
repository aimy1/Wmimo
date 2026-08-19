// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:io';

import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/modules/board_provider_manager.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/runtime/return_result.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/file_view_screen.dart';
import 'package:wmimo/screens/profile_settings_edit_screen.dart';
import 'package:wmimo/screens/qrcode_screen.dart';
import 'package:wmimo/screens/theme_define.dart';

class ProfilesBoardItem extends StatelessWidget {
  const ProfilesBoardItem({
    super.key,
    required this.setting,
    required this.selected,
    required this.onTap,
    required this.onTapUpdate,
    required this.onTapEdit,
    required this.onTapDelete,
    required this.onTapViewFile,
    required this.onTapCopyUrl,
    required this.onTapQrcode,
  });

  final ProfileSetting setting;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onTapUpdate;
  final VoidCallback onTapEdit;
  final VoidCallback onTapDelete;
  final VoidCallback onTapViewFile;
  final VoidCallback onTapCopyUrl;
  final VoidCallback onTapQrcode;

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final settings = SettingManager.getConfig();
    final patch = ProfilePatchManager.getProfilePatch(setting.patch);
    final provider = BoardProviderManager.getProviderById(setting.boardProviderId);
    final isUpdating = ProfileManager.updating.contains(setting.id);

    String patchRemark = "";
    if (setting.patch.isEmpty || patch.id.isEmpty) {
      final currentPatch = ProfilePatchManager.getCurrent();
      patchRemark = currentPatch.getShowName(context);
    } else {
      patchRemark = patch.getShowName(context);
    }

    String uploadStr = "";
    String downloadStr = "";
    String totalStr = "";
    double progress = 0.0;
    bool hasTraffic = false;
    Tuple2<bool, String>? trafficExpire;
    String updateInterval = "";

    if (setting.isRemote()) {
      if (setting.upload != 0 || setting.download != 0 || setting.total != 0) {
        hasTraffic = true;
        uploadStr = ClashHttpApi.convertTrafficToStringDouble(setting.upload);
        downloadStr = ClashHttpApi.convertTrafficToStringDouble(setting.download);
        totalStr = ClashHttpApi.convertTrafficToStringDouble(setting.total);
        if (setting.total > 0) {
          final used = setting.upload + setting.download;
          progress = (used / setting.total).clamp(0.0, 1.0);
        }
      }
      if (setting.expire.isNotEmpty) {
        trafficExpire = setting.getExpireTime(settings.languageTag);
      }
      if (setting.update != null) {
        final interval = DateTime.now().difference(setting.update!);
        if (interval.inDays > 0) {
          updateInterval = "${interval.inDays}天前";
        } else if (interval.inHours > 0) {
          updateInterval = "${interval.inHours}小时前";
        } else {
          updateInterval = "< 1小时前";
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: selected
            ? (isDark
                ? const Color(0xFF1E3A8A).withValues(alpha: 0.35)
                : const Color(0xFFEFF6FF))
            : (isDark ? const Color(0xFF151D2E) : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected
              ? ThemeDefine.kColorBlue
              : theme.dividerColor.withValues(alpha: 0.35),
          width: selected ? 1.5 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Icon + Title & Badges + Actions
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Provider/Type Leading Icon
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: selected
                            ? ThemeDefine.kColorBlue.withValues(alpha: 0.15)
                            : (isDark
                                ? const Color(0xFF1E293B)
                                : const Color(0xFFF1F5F9)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: (provider != null &&
                                provider.appIconUrl.isNotEmpty &&
                                provider.logoBranding)
                            ? FastCachedImage(
                                url: provider.appIconUrl,
                                width: 22,
                                height: 22,
                                cacheWidth: 64,
                                cacheHeight: 64,
                                loadingBuilder: (context, progress) =>
                                    const SizedBox.shrink(),
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                  Icons.cloud_outlined,
                                  size: 20,
                                  color: ThemeDefine.kColorBlue,
                                ),
                              )
                            : Icon(
                                setting.isRemote()
                                    ? Icons.cloud_outlined
                                    : Icons.description_outlined,
                                size: 20,
                                color: selected
                                    ? ThemeDefine.kColorBlue
                                    : (isDark ? Colors.white70 : Colors.black54),
                              ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Profile Name & Tags
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  setting.getShowName(),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: selected
                                        ? ThemeDefine.kColorBlue
                                        : (isDark ? Colors.white : const Color(0xFF1E293B)),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (selected) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_rounded,
                                        size: 11,
                                        color: Colors.green,
                                      ),
                                      const SizedBox(width: 3),
                                      const Text(
                                        "使用中",
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),

                          // Badges Row
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: [
                              // Type Badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: setting.isRemote()
                                      ? ThemeDefine.kColorBlue.withValues(alpha: 0.12)
                                      : Colors.purple.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  setting.isRemote() ? "远程订阅" : "本地文件",
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: setting.isRemote()
                                        ? ThemeDefine.kColorBlue
                                        : Colors.purple,
                                  ),
                                ),
                              ),

                              // Patch Badge
                              if (patchRemark.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    patchRemark,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.65),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Actions Row
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Update button (if remote)
                        if (setting.isRemote())
                          Tooltip(
                            message: tcontext.meta.update,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: isUpdating ? null : onTapUpdate,
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: isUpdating
                                    ? const Center(
                                        child: SizedBox(
                                          width: 14,
                                          height: 14,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : const Icon(
                                        Icons.sync_rounded,
                                        size: 20,
                                        color: Colors.blueAccent,
                                      ),
                              ),
                            ),
                          ),

                        // Edit button
                        Tooltip(
                          message: tcontext.meta.edit,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8),
                            onTap: onTapEdit,
                            child: const SizedBox(
                              width: 32,
                              height: 32,
                              child: Icon(Icons.edit_outlined, size: 18),
                            ),
                          ),
                        ),

                        // More menu
                        PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert_rounded, size: 20),
                          tooltip: "更多操作",
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case 'viewFile':
                                onTapViewFile();
                                break;
                              case 'copyUrl':
                                onTapCopyUrl();
                                break;
                              case 'qrcode':
                                onTapQrcode();
                                break;
                              case 'delete':
                                onTapDelete();
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'viewFile',
                              child: Row(
                                children: [
                                  const Icon(Icons.code_rounded, size: 18),
                                  const SizedBox(width: 8),
                                  Text(setting.isRemote() ? "查看 YAML 配置" : "编辑 YAML 配置"),
                                ],
                              ),
                            ),
                            if (setting.isRemote()) ...[
                              const PopupMenuItem(
                                value: 'copyUrl',
                                child: Row(
                                  children: [
                                    Icon(Icons.copy_rounded, size: 18),
                                    SizedBox(width: 8),
                                    Text("复制订阅链接"),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'qrcode',
                                child: Row(
                                  children: [
                                    Icon(Icons.qr_code_rounded, size: 18),
                                    SizedBox(width: 8),
                                    Text("二维码"),
                                  ],
                                ),
                              ),
                            ],
                            const PopupMenuDivider(),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete_outline_rounded,
                                      size: 18, color: Colors.redAccent),
                                  SizedBox(width: 8),
                                  Text(
                                    "删除配置",
                                    style: TextStyle(color: Colors.redAccent),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // Middle Section: Traffic Progress & Stats (Clash Verge Rev style)
                if (hasTraffic) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      backgroundColor: isDark
                          ? const Color(0xFF334155)
                          : const Color(0xFFE2E8F0),
                      valueColor: AlwaysStoppedAnimation(
                        progress > 0.9
                            ? Colors.redAccent
                            : (progress > 0.75
                                ? Colors.orangeAccent
                                : ThemeDefine.kColorBlue),
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Traffic Used / Total
                      Row(
                        children: [
                          Text(
                            "↑ $uploadStr",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "↓ $downloadStr",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "/ $totalStr",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),

                      // Expire Date
                      if (trafficExpire != null)
                        Text(
                          "📅 到期: ${trafficExpire.item2}",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: trafficExpire.item1
                                ? Colors.redAccent
                                : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                    ],
                  ),
                ],

                // Bottom Metadata Row (File Name & Update Time)
                const SizedBox(height: 10),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // File Name
                    Row(
                      children: [
                        Icon(
                          Icons.insert_drive_file_outlined,
                          size: 13,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          setting.id,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: 'monospace',
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),

                    // Last Updated
                    if (updateInterval.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "更新于 $updateInterval",
                            style: TextStyle(
                              fontSize: 11,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilesBoardScreenWidget extends StatefulWidget {
  const ProfilesBoardScreenWidget({super.key, required this.settings});
  final List<ProfileSetting> settings;

  @override
  State<ProfilesBoardScreenWidget> createState() => _ProfilesBoardScreenWidget();
}

class _ProfilesBoardScreenWidget extends State<ProfilesBoardScreenWidget> {
  @override
  void dispose() {
    ProfileManager.save();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final current = ProfileManager.getCurrent();

    if (widget.settings.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.folder_open_rounded,
              size: 56,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 16),
            Text(
              "暂无订阅配置",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "点击右上角 + 添加订阅链接或导入本地文件",
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      itemCount: widget.settings.length,
      itemBuilder: (context, index) {
        final setting = widget.settings[index];
        final isCurrent = current?.id == setting.id;

        return ProfilesBoardItem(
          key: Key(setting.id),
          setting: setting,
          selected: isCurrent,
          onTap: () {
            ProfileManager.setCurrent(setting.id);
            if (ModalRoute.of(context)?.canPop ?? false) {
              Navigator.of(context).pop();
            } else {
              setState(() {});
            }
          },
          onTapUpdate: () async {
            ReturnResultError? err = await ProfileManager.update(setting.id);
            if (err != null && mounted) {
              DialogUtils.showAlertDialog(
                context,
                err.message,
                showCopy: true,
                showFAQ: true,
                withVersion: true,
              );
            }
            if (mounted) setState(() {});
          },
          onTapEdit: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                settings: ProfilesSettingsEditScreen.routSettings(),
                builder: (context) => ProfilesSettingsEditScreen(profile: setting),
              ),
            );
            if (mounted) setState(() {});
          },
          onTapDelete: () async {
            bool? del = await DialogUtils.showConfirmDialog(
              context,
              tcontext.meta.removeConfirm,
            );
            if (del == true) {
              ProfileManager.remove(setting.id);
              if (mounted) setState(() {});
            }
          },
          onTapViewFile: () async {
            final path = await ProfileManager.getProfilePath(setting.id);
            final content = await File(path).readAsString();
            if (!mounted) return;
            await Navigator.push(
              context,
              MaterialPageRoute(
                settings: FileViewScreen.routSettings(),
                builder: (context) => FileViewScreen(
                  title: setting.getShowName(),
                  content: content,
                  onSave: setting.isRemote()
                      ? null
                      : (BuildContext context, String content) async {
                          await File(path).writeAsString(content);
                        },
                ),
              ),
            );
          },
          onTapCopyUrl: () {
            try {
              Clipboard.setData(ClipboardData(text: setting.url));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("订阅链接已复制到剪贴板"),
                  duration: Duration(seconds: 2),
                ),
              );
            } catch (_) {}
          },
          onTapQrcode: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: QrcodeScreen.routSettings(),
                builder: (context) => QrcodeScreen(content: setting.url),
              ),
            );
          },
        );
      },
    );
  }
}
