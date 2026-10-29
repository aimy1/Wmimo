// ignore_for_file: unused_catch_stack

import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/file_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/url_launcher_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/donate_screen.dart';
import 'package:wmimo/screens/group_item_creator.dart';
import 'package:wmimo/screens/group_item_options.dart';
import 'package:wmimo/screens/group_screen.dart';
import 'package:wmimo/screens/qrcode_screen.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:flutter/material.dart';

class AboutScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "AboutScreen");
  }

  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => AboutScreenState();
}

class AboutScreenState extends LasyRenderingState<AboutScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (ModalRoute.of(context)?.canPop ?? false)
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 36,
                          height: 30,
                          child: Icon(Icons.arrow_back_ios_outlined, size: 22),
                        ),
                      )
                    else
                      const SizedBox(width: 36, height: 30),
                    Expanded(
                      child: Text(
                        tcontext.meta.about,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 36, height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: FutureBuilder(
                      future: getGroupOptions(),
                      builder:
                          (
                            BuildContext context,
                            AsyncSnapshot<List<GroupItem>> snapshot,
                          ) {
                            List<GroupItem> data = snapshot.hasData
                                ? snapshot.data!
                                : [];
                            return Column(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 8, bottom: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset(
                                          'assets/images/app_icon_256.png',
                                          width: 72,
                                          height: 72,
                                          fit: BoxFit.contain,
                                          filterQuality: FilterQuality.medium,
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          AppUtils.getName(),
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                ...GroupItemCreator.createGroups(
                                  context,
                                  data,
                                ),
                              ],
                            );
                          },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<GroupItem>> getGroupOptions([BuildContext? ctx]) async {
    final targetCtx = ctx ?? context;
    final tcontext = Translations.of(targetCtx);
    final coreVersion = AppUtils.getCoreVersion();
    List<GroupItem> groupOptions = [];

    List<GroupItemOptions> options = [
      GroupItemOptions(
        textOptions: GroupItemTextOptions(
          name: tcontext.meta.name,
          text: AppUtils.getName(),
        ),
      ),
      GroupItemOptions(
        textOptions: GroupItemTextOptions(
          name: tcontext.meta.version,
          text: AppUtils.getFormattedVersion(),
        ),
      ),
      GroupItemOptions(
        textOptions: GroupItemTextOptions(
          name: tcontext.meta.core,
          text: "mihomo $coreVersion",
        ),
      ),
      GroupItemOptions(
        textOptions: GroupItemTextOptions(
          name: tcontext.meta.author,
          text: "aimy1",
        ),
      ),
      GroupItemOptions(
        pushOptions: GroupItemPushOptions(
          name: tcontext.meta.website,
          text: "wmimo.buzz",
          onPush: () async {
            await UrlLauncherUtils.loadUrl("https://wmimo.buzz/");
          },
        ),
      ),
      GroupItemOptions(
        pushOptions: GroupItemPushOptions(
          name: tcontext.meta.githubRepo,
          text: "aimy1/Wmimo",
          onPush: () async {
            await UrlLauncherUtils.loadUrl("https://github.com/aimy1/Wmimo");
          },
        ),
      ),
      GroupItemOptions(
        pushOptions: GroupItemPushOptions(
          name: tcontext.meta.joinUs,
          text: "t.me/wmimoapp",
          onPush: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: QrcodeScreen.routSettings(),
                builder: (context) => QrcodeScreen(
                  title: tcontext.meta.joinUs,
                  content: "https://t.me/wmimoapp",
                ),
              ),
            );
          },
        ),
      ),
      GroupItemOptions(
        pushOptions: GroupItemPushOptions(
          name: tcontext.meta.openSourceLicense,
          text: "GPL-3.0",
          onPush: () async {
            showLicensePage(
              context: context,
              applicationName: AppUtils.getName(),
              applicationVersion: AppUtils.getFormattedVersion(),
              applicationIcon: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Image.asset(
                  'assets/images/app_icon_256.png',
                  width: 56,
                  height: 56,
                  fit: BoxFit.contain,
                ),
              ),
              applicationLegalese:
                  'Wmimo is licensed under the GNU General Public License v3.0 (GPL-3.0-or-later).\n'
                  'Rust workspace crates: Dual-licensed under MIT OR Apache-2.0.\n'
                  'Mihomo core: GPL-3.0-or-later.\n'
                  'Third-party components: BSD-3-Clause, MIT, Apache-2.0.',
            );
          },
        ),
      ),
    ];

    groupOptions.add(GroupItem(options: options));

    List<GroupItemOptions> options1 = [
      GroupItemOptions(
        pushOptions: GroupItemPushOptions(
          name: tcontext.meta.donate,
          text: "USDT (APTOS)",
          onPush: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: DonateScreen.routSettings(),
                builder: (context) => const DonateScreen(),
              ),
            );
          },
        ),
      ),
    ];
    groupOptions.add(GroupItem(options: options1));
    if (PlatformUtils.isPC()) {
      List<GroupItemOptions> options2 = [
        GroupItemOptions(
          pushOptions: GroupItemPushOptions(
            name: SettingManager.getConfig().devMode
                ? "${tcontext.meta.devOptions} (Dev Mode)"
                : tcontext.meta.devOptions,
            onPush: () async {
              onTapDevOptions();
            },
            onLongPress: () async {
              SettingManager.getConfig().devMode =
                  !SettingManager.getConfig().devMode;
              setState(() {});
            },
          ),
        ),
      ];
      groupOptions.add(GroupItem(options: options2));
    }

    return groupOptions;
  }

  void onTapDevOptions() async {
    final tcontext = Translations.of(context);
    Future<List<GroupItem>> getOptions(
      BuildContext context,
      SetStateCallback? setstate,
    ) async {
      List<GroupItemOptions> options = [
        if (PlatformUtils.isPC()) ...[
          GroupItemOptions(
            pushOptions: GroupItemPushOptions(
              name: tcontext.meta.openDir,
              onPush: () async {
                await FileUtils.openDirectory(await PathUtils.profileDir());
              },
            ),
          ),
        ],
      ];

      return [GroupItem(options: options)];
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: GroupScreen.routSettings("devOptions"),
        builder: (context) => GroupScreen(
          title: tcontext.meta.devOptions,
          getOptions: getOptions,
        ),
      ),
    );
    setState(() {});
  }
}
