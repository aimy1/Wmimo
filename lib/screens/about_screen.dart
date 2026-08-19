// ignore_for_file: unused_catch_stack

import 'dart:io';

import 'package:wmimo/app/modules/remote_config_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/file_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/url_launcher_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/group_item_creator.dart';
import 'package:wmimo/screens/group_item_options.dart';
import 'package:wmimo/screens/group_screen.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/webview_helper.dart';
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
    Size windowSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (Navigator.canPop(context))
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 40,
                          height: 30,
                          child: Icon(Icons.arrow_back_ios_outlined, size: 24),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        tcontext.meta.about,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: SingleChildScrollView(
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
                                  padding: const EdgeInsets.only(top: 5, bottom: 20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(18),
                                        child: Image.asset(
                                          'assets/images/app_icon_128.png',
                                          width: 72,
                                          height: 72,
                                          fit: BoxFit.contain,
                                        ),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<List<GroupItem>> getGroupOptions() async {
    final tcontext = Translations.of(context);
    var remoteConfig = RemoteConfigManager.getConfig();
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
          text: AppUtils.getBuildinVersion(),
        ),
      ),
      GroupItemOptions(
        textOptions: GroupItemTextOptions(
          name: tcontext.meta.core,
          text: "mihomo $coreVersion",
        ),
      ),
    ];

    groupOptions.add(GroupItem(options: options));

    if (!Platform.isIOS &&
        !Platform.isMacOS &&
        remoteConfig.donate.isNotEmpty) {
      List<GroupItemOptions> options1 = [
        GroupItemOptions(
          pushOptions: GroupItemPushOptions(
            name: tcontext.meta.donate,
            onPush: () async {
              String url = await UrlLauncherUtils.reorganizationUrlWithAnchor(
                remoteConfig.donate,
              );
              if (!mounted) {
                return;
              }
              await WebviewHelper.loadUrl(
                context,
                url,
                "donate",
                title: tcontext.meta.donate,
              );
            },
          ),
        ),
      ];
      groupOptions.add(GroupItem(options: options1));
    }
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
