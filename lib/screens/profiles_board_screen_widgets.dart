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
import 'package:wmimo/app/utils/file_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/file_view_screen.dart';
import 'package:wmimo/screens/profile_settings_edit_screen.dart';
import 'package:wmimo/screens/profiles_patch_board_screen.dart';
import 'package:wmimo/screens/qrcode_screen.dart';
import 'package:wmimo/screens/theme_define.dart';

class ProfilesBoardItem extends StatelessWidget {
  const ProfilesBoardItem({
    super.key,
    required this.setting,
    required this.selected,
    this.nodeCount,
    required this.onTap,
    required this.onTapUpdate,
    required this.onTapEdit,
    required this.onTapDelete,
    required this.onTapViewFile,
    required this.onTapCopyUrl,
    required this.onTapQrcode,
    required this.onTapOpenInFolder,
    required this.onTapCopyFilePath,
    required this.onTapDuplicate,
  });

  final ProfileSetting setting;
  final bool selected;
  final int? nodeCount;
  final VoidCallback onTap;
  final VoidCallback onTapUpdate;
  final VoidCallback onTapEdit;
  final VoidCallback onTapDelete;
  final VoidCallback onTapViewFile;
  final VoidCallback onTapCopyUrl;
  final VoidCallback onTapQrcode;
  final VoidCallback onTapOpenInFolder;
  final VoidCallback onTapCopyFilePath;
  final VoidCallback onTapDuplicate;

  void _showContextMenu(BuildContext context, Offset globalPosition) {
    final tcontext = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        globalPosition & const Size(40, 40),
        Offset.zero & overlay.size,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF262629) : Colors.white,
      items: [
        if (!selected)
          PopupMenuItem(
            value: 'select',
            child: Row(
              children: [
                const Icon(Icons.check_circle_outline_rounded, size: 18, color: Colors.green),
                const SizedBox(width: 8),
                Text(tcontext.meta.useThisProfile),
              ],
            ),
          ),
        if (setting.isRemote())
          PopupMenuItem(
            value: 'update',
            child: Row(
              children: [
                const Icon(Icons.sync_rounded, size: 18, color: Colors.blueAccent),
                const SizedBox(width: 8),
                Text(tcontext.meta.update),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              const Icon(Icons.edit_outlined, size: 18),
              const SizedBox(width: 8),
              Text(tcontext.meta.edit),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'viewFile',
          child: Row(
            children: [
              const Icon(Icons.code_rounded, size: 18),
              const SizedBox(width: 8),
              Text(setting.isRemote()
                  ? tcontext.meta.viewYamlConfig
                  : tcontext.meta.editYamlConfig),
            ],
          ),
        ),
        if (PlatformUtils.isPC()) ...[
          PopupMenuItem(
            value: 'openInFolder',
            child: Row(
              children: [
                const Icon(Icons.folder_open_outlined, size: 18),
                const SizedBox(width: 8),
                Text(tcontext.meta.openInFolder),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'copyFilePath',
            child: Row(
              children: [
                const Icon(Icons.file_copy_outlined, size: 18),
                const SizedBox(width: 8),
                Text(tcontext.meta.copyFilePath),
              ],
            ),
          ),
        ],
        PopupMenuItem(
          value: 'duplicate',
          child: Row(
            children: [
              const Icon(Icons.copy_all_rounded, size: 18),
              const SizedBox(width: 8),
              Text(tcontext.meta.duplicateProfile),
            ],
          ),
        ),
        if (setting.isRemote()) ...[
          PopupMenuItem(
            value: 'copyUrl',
            child: Row(
              children: [
                const Icon(Icons.copy_rounded, size: 18),
                const SizedBox(width: 8),
                Text(tcontext.meta.copySubscriptionUrl),
              ],
            ),
          ),
          PopupMenuItem(
            value: 'qrcode',
            child: Row(
              children: [
                const Icon(Icons.qr_code_rounded, size: 18),
                const SizedBox(width: 8),
                Text(tcontext.meta.qrCode),
              ],
            ),
          ),
        ],
        const PopupMenuDivider(),
        PopupMenuItem(
          value: 'delete',
          child: Row(
            children: [
              const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.redAccent),
              const SizedBox(width: 8),
              Text(
                tcontext.meta.deleteProfile,
                style: const TextStyle(color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == null) return;
      switch (value) {
        case 'select':
          onTap();
          break;
        case 'update':
          onTapUpdate();
          break;
        case 'edit':
          onTapEdit();
          break;
        case 'viewFile':
          onTapViewFile();
          break;
        case 'openInFolder':
          onTapOpenInFolder();
          break;
        case 'copyFilePath':
          onTapCopyFilePath();
          break;
        case 'duplicate':
          onTapDuplicate();
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
    });
  }

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
          updateInterval = tcontext.meta.daysAgo(p: interval.inDays.toString());
        } else if (interval.inHours > 0) {
          updateInterval = tcontext.meta.hoursAgo(p: interval.inHours.toString());
        } else {
          updateInterval = tcontext.meta.lessThanOneHourAgo;
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      constraints: const BoxConstraints(minHeight: 146),
      decoration: BoxDecoration(
        color: selected
            ? ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.12 : 0.08)
            : (isDark ? const Color(0xFF1C1C1E) : Colors.white),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected
              ? ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.55 : 0.45)
              : theme.dividerColor.withValues(alpha: isDark ? 0.2 : 0.35),
          width: selected ? 1.1 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: selected
                ? ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.12 : 0.06)
                : Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: selected ? 10 : 8,
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
          onSecondaryTapUp: (details) =>
              _showContextMenu(context, details.globalPosition),
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
                                ? const Color(0xFF262629)
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
                                      Text(
                                        tcontext.meta.inUse,
                                        style: const TextStyle(
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
                                  setting.isRemote()
                                      ? tcontext.meta.remoteSubscription
                                      : tcontext.meta.localProfile,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: setting.isRemote()
                                        ? ThemeDefine.kColorBlue
                                        : Colors.purple,
                                  ),
                                ),
                              ),

                              // Node Count Badge
                              if (nodeCount != null && nodeCount! > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ThemeDefine.kColorGreenBright
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.hub_rounded,
                                        size: 10,
                                        color: ThemeDefine.kColorGreenBright,
                                      ),
                                      const SizedBox(width: 3),
                                      Text(
                                        tcontext.meta.nodeCount(p: nodeCount.toString()),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: ThemeDefine.kColorGreenBright,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Patch Badge (clickable to manage patches)
                              if (patchRemark.isNotEmpty)
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          settings:
                                              ProfilesPatchBoardScreen.routSettings(),
                                          builder: (context) =>
                                              const ProfilesPatchBoardScreen(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 1.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.08),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            patchRemark,
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.65),
                                            ),
                                          ),
                                          const SizedBox(width: 2),
                                          Icon(
                                            Icons.chevron_right_rounded,
                                            size: 11,
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.4),
                                          ),
                                        ],
                                      ),
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
                          tooltip: tcontext.meta.more,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onSelected: (value) {
                            switch (value) {
                              case 'viewFile':
                                onTapViewFile();
                                break;
                              case 'openInFolder':
                                onTapOpenInFolder();
                                break;
                              case 'copyFilePath':
                                onTapCopyFilePath();
                                break;
                              case 'duplicate':
                                onTapDuplicate();
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
                                  Text(setting.isRemote()
                                      ? tcontext.meta.viewYamlConfig
                                      : tcontext.meta.editYamlConfig),
                                ],
                              ),
                            ),
                            if (PlatformUtils.isPC()) ...[
                              PopupMenuItem(
                                value: 'openInFolder',
                                child: Row(
                                  children: [
                                    const Icon(Icons.folder_open_outlined, size: 18),
                                    const SizedBox(width: 8),
                                    Text(tcontext.meta.openInFolder),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'copyFilePath',
                                child: Row(
                                  children: [
                                    const Icon(Icons.file_copy_outlined, size: 18),
                                    const SizedBox(width: 8),
                                    Text(tcontext.meta.copyFilePath),
                                  ],
                                ),
                              ),
                            ],
                            PopupMenuItem(
                              value: 'duplicate',
                              child: Row(
                                children: [
                                  const Icon(Icons.copy_all_rounded, size: 18),
                                  const SizedBox(width: 8),
                                  Text(tcontext.meta.duplicateProfile),
                                ],
                              ),
                            ),
                            if (setting.isRemote()) ...[
                              PopupMenuItem(
                                value: 'copyUrl',
                                child: Row(
                                  children: [
                                    const Icon(Icons.copy_rounded, size: 18),
                                    const SizedBox(width: 8),
                                    Text(tcontext.meta.copySubscriptionUrl),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'qrcode',
                                child: Row(
                                  children: [
                                    const Icon(Icons.qr_code_rounded, size: 18),
                                    const SizedBox(width: 8),
                                    Text(tcontext.meta.qrCode),
                                  ],
                                ),
                              ),
                            ],
                            const PopupMenuDivider(),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(Icons.delete_outline_rounded,
                                      size: 18, color: Colors.redAccent),
                                  const SizedBox(width: 8),
                                  Text(
                                    tcontext.meta.deleteProfile,
                                    style: const TextStyle(color: Colors.redAccent),
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
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: hasTraffic ? progress : 0.0,
                    minHeight: 5,
                    backgroundColor: isDark
                        ? const Color(0xFF334155).withValues(alpha: hasTraffic ? 1.0 : 0.45)
                        : const Color(0xFFE2E8F0),
                    valueColor: AlwaysStoppedAnimation(
                      hasTraffic
                          ? (progress > 0.9
                              ? Colors.redAccent
                              : (progress > 0.75
                                  ? Colors.orangeAccent
                                  : ThemeDefine.kColorBlue))
                          : (isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Traffic Used / Total OR Placeholder
                    Expanded(
                      child: hasTraffic
                          ? Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: "↑ $uploadStr  ",
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "↓ $downloadStr  ",
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                  TextSpan(
                                    text: "/ $totalStr",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                                    ),
                                  ),
                                ],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  setting.isRemote()
                                      ? Icons.all_inclusive_rounded
                                      : Icons.insert_drive_file_outlined,
                                  size: 13,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                                ),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    setting.isRemote()
                                        ? tcontext.meta.noTrafficData
                                        : tcontext.meta.localProfile,
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(width: 8),

                    // Expire Date
                    if (trafficExpire != null)
                      Tooltip(
                        message: "${tcontext.meta.expireTime}: ${trafficExpire.item2}",
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.event_outlined,
                              size: 12,
                              color: trafficExpire.item1
                                  ? Colors.redAccent
                                  : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              trafficExpire.item2,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: trafficExpire.item1
                                    ? Colors.redAccent
                                    : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                        ),
                      )
                    else if (!hasTraffic)
                      Text(
                        "—",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.35),
                        ),
                      ),
                  ],
                ),

                // Bottom Metadata Row (File Name & Update Time)
                const SizedBox(height: 10),
                const Divider(height: 1, thickness: 0.5),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // File Name
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.insert_drive_file_outlined,
                            size: 13,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              setting.id,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'monospace',
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Last Updated
                    if (updateInterval.isNotEmpty)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.schedule_rounded,
                            size: 13,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            updateInterval,
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
  const ProfilesBoardScreenWidget({
    super.key,
    required this.settings,
    this.searchKeyword = '',
    this.onClearSearch,
  });
  final List<ProfileSetting> settings;
  final String searchKeyword;
  final VoidCallback? onClearSearch;

  @override
  State<ProfilesBoardScreenWidget> createState() => _ProfilesBoardScreenWidget();
}

class _ProfilesBoardScreenWidget extends State<ProfilesBoardScreenWidget> {
  final Map<String, int> _nodeCounts = {};

  @override
  void initState() {
    super.initState();
    _loadNodeCounts();
  }

  @override
  void didUpdateWidget(covariant ProfilesBoardScreenWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _loadNodeCounts();
  }

  Future<void> _loadNodeCounts() async {
    for (final setting in widget.settings) {
      if (!_nodeCounts.containsKey(setting.id)) {
        try {
          final nodes = await ProxyNodeLoader.loadNodesFromProfile(setting.id);
          final count = nodes.where((n) => n.all.isEmpty).length;
          if (mounted) {
            setState(() {
              _nodeCounts[setting.id] = count;
            });
          }
        } catch (_) {}
      }
    }
  }

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
      if (widget.searchKeyword.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 56,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                ),
                const SizedBox(height: 16),
                Text(
                  tcontext.meta.noMatchingProfiles,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 12),
                if (widget.onClearSearch != null)
                  TextButton.icon(
                    onPressed: widget.onClearSearch,
                    icon: const Icon(Icons.clear_rounded, size: 16),
                    label: Text(tcontext.meta.clear),
                    style: TextButton.styleFrom(
                      foregroundColor: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        );
      }
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
              tcontext.meta.noProfilesYet,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              tcontext.meta.addProfilePrompt,
              style: TextStyle(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = constraints.maxWidth >= 1050
            ? 3
            : (constraints.maxWidth >= 600 ? 2 : 1);

        if (crossAxisCount == 1) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            itemCount: widget.settings.length,
            itemBuilder: (context, index) {
              return _buildItem(widget.settings[index], current, tcontext);
            },
          );
        }

        final columns = List.generate(crossAxisCount, (_) => <Widget>[]);
        for (int i = 0; i < widget.settings.length; i++) {
          columns[i % crossAxisCount].add(
            _buildItem(widget.settings[i], current, tcontext),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int c = 0; c < crossAxisCount; c++) ...[
                if (c > 0) const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: columns[c],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(
    ProfileSetting setting,
    ProfileSetting? current,
    Translations tcontext,
  ) {
    final isCurrent = current?.id == setting.id;

    return ProfilesBoardItem(
      key: Key(setting.id),
      setting: setting,
      selected: isCurrent,
      nodeCount: _nodeCounts[setting.id],
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
      onTapOpenInFolder: () async {
        final path = await ProfileManager.getProfilePath(setting.id);
        await FileUtils.openFileInFolder(path);
      },
      onTapCopyFilePath: () async {
        final path = await ProfileManager.getProfilePath(setting.id);
        Clipboard.setData(ClipboardData(text: path));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tcontext.meta.copySuccess),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      onTapDuplicate: () async {
        final res = await ProfileManager.duplicateProfile(setting.id);
        if (res.error == null && mounted) {
          await _loadNodeCounts();
          setState(() {});
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tcontext.meta.copySuccess),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      },
      onTapCopyUrl: () {
        try {
          Clipboard.setData(ClipboardData(text: setting.url));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tcontext.meta.subscriptionUrlCopied),
              duration: const Duration(seconds: 2),
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
  }
}
