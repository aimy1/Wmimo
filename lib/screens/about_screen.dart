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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              height: 54,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.15),
                    width: 0.8,
                  ),
                ),
              ),
              child: Row(
                children: [
                  if (ModalRoute.of(context)?.canPop ?? false)
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.dividerColor.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          size: 20,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 36),
                  Expanded(
                    child: Text(
                      tcontext.meta.about,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 36),
                ],
              ),
            ),
            // Content Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
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
                                  padding: const EdgeInsets.only(top: 8, bottom: 24),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                                          ),
                                          borderRadius: BorderRadius.circular(22),
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                                              blurRadius: 16,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(19),
                                          child: Image.asset(
                                            'assets/images/app_icon_128.png',
                                            width: 68,
                                            height: 68,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        AppUtils.getName(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primary.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "v${AppUtils.getBuildinVersion()}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: theme.colorScheme.primary,
                                          ),
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
      GroupItemOptions(
        textOptions: GroupItemTextOptions(
          name: "作者 / Author",
          text: "aimy1",
        ),
      ),
      GroupItemOptions(
        pushOptions: GroupItemPushOptions(
          name: "开源代码仓库 / GitHub",
          text: "aimy1/Wmimo",
          onPush: () async {
            await UrlLauncherUtils.loadUrl("https://github.com/aimy1/Wmimo");
          },
        ),
      ),
      GroupItemOptions(
        textOptions: GroupItemTextOptions(
          name: "开源许可证 / License",
          text: "GPL-3.0",
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
