import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:wmimo/app/modules/profile_manager.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:wmimo/app/modules/board_provider_manager.dart';
import 'package:wmimo/app/utils/file_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/add_profile_by_import_from_file_screen.dart';
import 'package:wmimo/screens/add_profile_by_scan_qrcode_screen.dart';
import 'package:wmimo/screens/add_profile_by_url_screen.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/group_helper.dart';
import 'package:wmimo/screens/login_step_provider_screen.dart';
import 'package:wmimo/screens/profiles_board_screen_widgets.dart';
import 'package:wmimo/screens/profiles_patch_board_screen.dart';
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
            IconButton(
              tooltip: tcontext.meta.openProfilesDir,
              onPressed: () async {
                final dir = await PathUtils.profilesDir();
                await FileUtils.openDirectory(dir);
              },
              icon: const Icon(Icons.folder_open_outlined),
            ),
          IconButton(
            tooltip: tcontext.meta.profilePatches,
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
            icon: const Icon(Icons.alt_route_rounded),
          ),
          IconButton(
            tooltip: tcontext.meta.backupAndSync,
            onPressed: () {
              GroupHelper.showBackupAndSync(context);
            },
            icon: const Icon(Icons.cloud_sync_outlined),
          ),
          IconButton(
            tooltip: tcontext.meta.update,
            onPressed: ProfileManager.updating.isNotEmpty
                ? null
                : () async {
                    onTapUpdateAll();
                  },
            icon: ProfileManager.updating.isNotEmpty
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync_rounded),
          ),
          IconButton(
            tooltip: tcontext.meta.add,
            onPressed: () async {
              onTapAdd();
            },
            icon: const Icon(Icons.add_rounded, size: 22),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: WmimoSearchBar(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  hintText: tcontext.meta.searchProfiles,
                  badgeText: _searchKeyword.isNotEmpty
                      ? '${filteredProfiles.length}/${allProfiles.length}'
                      : null,
                ),
              ),
              const SizedBox(height: 10),
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
