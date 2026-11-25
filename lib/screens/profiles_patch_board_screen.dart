import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:wmimo/app/modules/profile_patch_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/add_profile_by_scan_qrcode_screen.dart';
import 'package:wmimo/screens/add_profile_patch_by_import_from_file_screen.dart';
import 'package:wmimo/screens/add_profile_patch_by_url_screen.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/profiles_patch_board_screen_widgets.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:wmimo/screens/widgets/sheet.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilesPatchBoardScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "/");
  }

  const ProfilesPatchBoardScreen({super.key});

  @override
  State<ProfilesPatchBoardScreen> createState() =>
      _ProfilesPatchBoardScreenState();
}

class _ProfilesPatchBoardScreenState
    extends LasyRenderingState<ProfilesPatchBoardScreen>
    with WidgetsBindingObserver, AfterLayoutMixin {
  @override
  void initState() {
    super.initState();
    ProfilePatchManager.onEventAdd.add(_onAdd);
    ProfilePatchManager.onEventRemove.add(_onRemove);
    ProfilePatchManager.onEventUpdate.add(_onUpdate);
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {}

  @override
  void dispose() {
    ProfilePatchManager.onEventAdd.remove(_onAdd);
    ProfilePatchManager.onEventRemove.remove(_onRemove);
    ProfilePatchManager.onEventUpdate.remove(_onUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);

    return Scaffold(
      appBar: WmimoAppBar(
        title: tcontext.meta.overwrite,
        actions: [
          IconButton(
            tooltip: tcontext.meta.update,
            onPressed: ProfilePatchManager.updating.isNotEmpty
                ? null
                : () async {
                    onTapUpdateAll();
                  },
            icon: ProfilePatchManager.updating.isNotEmpty
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: FutureBuilder(
            future: getProfiles(),
            builder:
                (
                  BuildContext context,
                  AsyncSnapshot<List<ProfilePatchSetting>> snapshot,
                ) {
                  List<ProfilePatchSetting> data = snapshot.hasData
                      ? snapshot.data!
                      : [];
                  return ProfilesPatchBoardScreenWidget(settings: data);
                },
          ),
        ),
      ),
    );
  }

  Future<List<ProfilePatchSetting>> getProfiles() async {
    return ProfilePatchManager.getProfiles();
  }

  void onTapUpdateAll() async {
    await ProfilePatchManager.updateAll();
  }

  void onTapAdd() async {
    final tcontext = Translations.of(context);
    var widgets = [
      ListTile(
        leading: const Icon(Icons.add_link_outlined),
        title: Text(tcontext.meta.profileAddUrlOrContent),
        onTap: () async {
          Navigator.of(context).pop();
          await Navigator.push(
            context,
            MaterialPageRoute(
              settings: AddProfilePatchByUrlScreen.routSettings(),
              builder: (context) => AddProfilePatchByUrlScreen(),
            ),
          );
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
              settings: AddProfilePatchByUrlScreen.routSettings(),
              builder: (context) =>
                  AddProfilePatchByUrlScreen(url: data!.text!),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.qr_code_scanner),
        title: Text(tcontext.meta.qrcodeScan),
        onTap: () async {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: AddProfileByScanQrcodeScanScreen.routSettings(),
              builder: (context) => const AddProfileByScanQrcodeScanScreen(),
            ),
          ).then((value) {
            if ((value != null) && (value.qrcode != null)) {
              if (!mounted) {
                return;
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  settings: AddProfilePatchByUrlScreen.routSettings(),
                  builder: (context) =>
                      AddProfilePatchByUrlScreen(url: value.qrcode!),
                ),
              );
            }
          });
        },
      ),
      ListTile(
        leading: const Icon(Icons.file_open_outlined),
        title: Text(tcontext.meta.profileImport),
        onTap: () async {
          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              settings: AddProfilePatchByImportFromFileScreen.routSettings(),
              builder: (context) =>
                  const AddProfilePatchByImportFromFileScreen(),
            ),
          );
        },
      ),
    ];

    showSheet(
      context: context,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (int i = 0; i < widgets.length; i++) ...[
                if (i > 0) const Divider(height: 1, thickness: 0.4),
                widgets[i],
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAdd(String id) async {
    setState(() {});
  }

  Future<void> _onRemove(String id) async {
    setState(() {});
  }

  Future<void> _onUpdate(String id, bool finish) async {
    setState(() {});
  }
}
