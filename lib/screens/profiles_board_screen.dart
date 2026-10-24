import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:wmimo/app/modules/remote_config_manager.dart';
import 'package:wmimo/app/modules/board_provider_manager.dart';
import 'package:wmimo/app/utils/file_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/url_launcher_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/add_profile_by_import_from_file_screen.dart';
import 'package:wmimo/screens/add_profile_by_scan_qrcode_screen.dart';
import 'package:wmimo/screens/add_profile_by_url_screen.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/group_helper.dart';
import 'package:wmimo/screens/login_step_provider_screen.dart';
import 'package:wmimo/screens/profiles_board_screen_widgets.dart';
import 'package:wmimo/screens/profiles_patch_board_screen.dart';
import 'package:wmimo/screens/webview_helper.dart';
import 'package:wmimo/screens/widgets/sheet.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilesBoardScreen extends StatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "/");
  }

  final bool navigateToAdd;
  const ProfilesBoardScreen({super.key, this.navigateToAdd = false});

  @override
  State<ProfilesBoardScreen> createState() => _ProfilesBoardScreenState();
}

class _ProfilesBoardScreenState extends State<ProfilesBoardScreen>
    with WidgetsBindingObserver, AfterLayoutMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _searchKeyword = "";

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    ProfileManager.onEventAdd.add(_onAdd);
    ProfileManager.onEventRemove.add(_onRemove);
    ProfileManager.onEventUpdate.add(_onUpdate);
    ProfileManager.onEventCurrentChanged.add(_onCurrentChanged);
    _reloadProfiles();
  }

  void _onSearchChanged() {
    final kw = _searchController.text.trim();
    if (_searchKeyword != kw) {
      setState(() {
        _searchKeyword = kw;
      });
    }
  }

  Future<void> _reloadProfiles() async {
    await ProfileManager.load();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _reloadProfiles();
    if (widget.navigateToAdd) {
      onTapAdd();
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    ProfileManager.onEventAdd.remove(_onAdd);
    ProfileManager.onEventRemove.remove(_onRemove);
    ProfileManager.onEventUpdate.remove(_onUpdate);
    ProfileManager.onEventCurrentChanged.remove(_onCurrentChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final allProfiles = ProfileManager.getProfiles();

    final filteredProfiles = _searchKeyword.isEmpty
        ? allProfiles
        : allProfiles.where((s) {
            final kw = _searchKeyword.toLowerCase();
            final name = s.getShowName().toLowerCase();
            final remark = s.remark.toLowerCase();
            final url = s.url.toLowerCase();
            final id = s.id.toLowerCase();
            final provider = BoardProviderManager.getProviderById(s.boardProviderId);
            final providerName = provider?.name.toLowerCase() ?? "";
            final patch = ProfilePatchManager.getProfilePatch(s.patch);
            final patchName = patch.getShowName(context).toLowerCase();

            return name.contains(kw) ||
                remark.contains(kw) ||
                url.contains(kw) ||
                id.contains(kw) ||
                providerName.contains(kw) ||
                patchName.contains(kw);
          }).toList();

    return Scaffold(
      appBar: WmimoAppBar(
        title: tcontext.meta.myProfiles,
        actions: [
          if (PlatformUtils.isPC())
            Tooltip(
              message: tcontext.meta.openProfilesDir,
              child: IconButton(
                onPressed: () async {
                  final dir = await PathUtils.profilesDir();
                  await FileUtils.openDirectory(dir);
                },
                icon: const Icon(
                  Icons.folder_open_outlined,
                  size: 22,
                ),
              ),
            ),
          Tooltip(
            message: tcontext.meta.profilePatches,
            child: IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    settings: ProfilesPatchBoardScreen.routSettings(),
                    builder: (context) => const ProfilesPatchBoardScreen(),
                  ),
                );
                await _reloadProfiles();
              },
              icon: const Icon(
                Icons.alt_route_rounded,
                size: 22,
              ),
            ),
          ),
          Tooltip(
            message: tcontext.meta.backupAndSync,
            child: IconButton(
              onPressed: () {
                GroupHelper.showBackupAndSync(context);
              },
              icon: const Icon(
                Icons.cloud_sync_outlined,
                size: 22,
              ),
            ),
          ),
          ProfileManager.updating.isNotEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Center(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                )
              : Tooltip(
                  message: tcontext.meta.update,
                  child: IconButton(
                    onPressed: () async {
                      onTapUpdateAll();
                    },
                    icon: const Icon(
                      Icons.sync_rounded,
                      size: 22,
                    ),
                  ),
                ),
          Tooltip(
            message: tcontext.meta.add,
            child: IconButton(
              onPressed: () async {
                onTapAdd();
              },
              icon: const Icon(Icons.add_rounded, size: 24),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Column(
            children: [
              if (allProfiles.isNotEmpty || _searchKeyword.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF262629)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.15),
                        width: 0.6,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: tcontext.meta.searchProfiles,
                        hintStyle: TextStyle(
                          fontSize: 12.5,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_searchKeyword.isNotEmpty) ...[
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${filteredProfiles.length}/${allProfiles.length}',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  _searchController.clear();
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(Icons.clear_rounded, size: 16),
                                ),
                              ),
                              const SizedBox(width: 4),
                            ],
                          ],
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 9),
                      ),
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Expanded(
                child: ProfilesBoardScreenWidget(
                  settings: filteredProfiles,
                  searchKeyword: _searchKeyword,
                  onClearSearch: () => _searchController.clear(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapUpdateAll() async {
    await ProfileManager.updateAll();
  }

  void onTapAdd() async {
    final tcontext = Translations.of(context);
    bool hideGetProfile = false;
    final currentProfile = ProfileManager.getCurrent();
    if (currentProfile != null && currentProfile.boardProviderId.isNotEmpty) {
      var provider = BoardProviderManager.getProviderById(
        currentProfile.boardProviderId,
      );
      if (provider != null && provider.hideRecommendMenu) {
        hideGetProfile = true;
      }
    }
    final cn =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode == "CN";
    final login = ListTile(
      leading: const Icon(Icons.login_outlined),
      title: Text(tcontext.loginScreen.login),
      onTap: () async {
        Navigator.of(context).pop();
        await Navigator.push(
          context,
          MaterialPageRoute(
            settings: LoginStepProviderScreen.routSettings(),
            builder: (context) => const LoginStepProviderScreen(),
          ),
        );
        await _reloadProfiles();
      },
    );
    var widgets = [
      if (!hideGetProfile) ...[
        ListTile(
          leading: const Icon(Icons.shopping_cart_outlined),
          title: Text(
            Platform.isIOS
                ? tcontext.meta.getProfile
                : "${tcontext.meta.getProfile} / ${tcontext.meta.buyProfile}",
          ),
          onTap: () async {
            Navigator.of(context).pop();
            var remoteConfig = RemoteConfigManager.getConfig();

            String url = remoteConfig.getTranffic;

            url = await UrlLauncherUtils.reorganizationUrlWithAnchor(url);

            if (!mounted) {
              return;
            }
            await WebviewHelper.loadUrl(
              context,
              url,
              "getTranffic",
              title: tcontext.meta.getProfile,
              inappWebViewOpenExternal: true,
            );
            await _reloadProfiles();
          },
        ),
      ],
      if (cn) ...[login],
      ListTile(
        leading: const Icon(Icons.add_link_outlined),
        title: Text(tcontext.meta.profileAddUrlOrContent),
        onTap: () async {
          Navigator.of(context).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              settings: AddProfileByUrlScreen.routSettings(),
              builder: (context) => AddProfileByUrlScreen(),
            ),
          );
          await _reloadProfiles();
        },
      ),
      ListTile(
        leading: const Icon(Icons.content_paste_outlined),
        title: Text(tcontext.meta.importFromClipboard),
        onTap: () async {
          Navigator.of(context).pop();
          ClipboardData? data;
          try {
            data = await Clipboard.getData("text/plain");
          } catch (err) {
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
            return;
          }
          if (!mounted) {
            return;
          }
          if (data == null || data.text == null || data.text!.isEmpty) {
            return;
          }
          await Navigator.push(
            context,
            MaterialPageRoute(
              settings: AddProfileByUrlScreen.routSettings(),
              builder: (context) => AddProfileByUrlScreen(url: data!.text!),
            ),
          );
          await _reloadProfiles();
        },
      ),
      ListTile(
        leading: const Icon(Icons.qr_code_scanner),
        title: Text(tcontext.meta.qrcodeScan),
        onTap: () async {
          Navigator.of(context).pop();
          final value = await Navigator.push(
            context,
            MaterialPageRoute(
              settings: AddProfileByScanQrcodeScanScreen.routSettings(),
              builder: (context) => const AddProfileByScanQrcodeScanScreen(),
            ),
          );
          if ((value != null) && (value.qrcode != null)) {
            if (!mounted) {
              return;
            }
            await Navigator.push(
              context,
              MaterialPageRoute(
                settings: AddProfileByUrlScreen.routSettings(),
                builder: (context) =>
                    AddProfileByUrlScreen(url: value.qrcode!),
              ),
            );
          }
          await _reloadProfiles();
        },
      ),
      ListTile(
        leading: const Icon(Icons.file_open_outlined),
        title: Text(tcontext.meta.profileImport),
        onTap: () async {
          Navigator.of(context).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              settings: AddProfileByImportFromFileScreen.routSettings(),
              builder: (context) => const AddProfileByImportFromFileScreen(),
            ),
          );
          await _reloadProfiles();
        },
      ),
      if (!cn) ...[login],
    ];

    showSheet(
      context: context,
      body: SizedBox(
        height: 400,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Scrollbar(
            child: ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return widgets[index];
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(height: 1, thickness: 0.3);
              },
              itemCount: widgets.length,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onAdd(String id) async {
    await _reloadProfiles();
  }

  Future<void> _onRemove(String id) async {
    await _reloadProfiles();
  }

  Future<void> _onUpdate(String id, bool finish) async {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onCurrentChanged(String id) async {
    if (mounted) {
      setState(() {});
    }
  }
}
