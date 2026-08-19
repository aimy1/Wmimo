// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/group_item_creator.dart';
import 'package:wmimo/screens/group_item_options.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:flutter/material.dart';

class GroupScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings(String viewTag) {
    return RouteSettings(name: "GroupScreen:$viewTag");
  }

  final String title;
  final Future<List<GroupItem>> Function(
    BuildContext context,
    SetStateCallback? setstate,
  )
  getOptions;
  final bool hasReturn;
  final Future<bool> Function(BuildContext context)? onDone;
  final String? tipsIfNoOnDone;
  final IconData? onDoneIcon;
  final Future<void> Function(BuildContext context)? onFirstLayout;
  const GroupScreen({
    super.key,
    required this.title,
    required this.getOptions,
    this.hasReturn = true,
    this.onDone,
    this.tipsIfNoOnDone,
    this.onDoneIcon,
    this.onFirstLayout,
  });

  @override
  State<GroupScreen> createState() => GroupScreenState();
}

class GroupScreenState extends LasyRenderingState<GroupScreen>
    with AfterLayoutMixin {
  static int _adsCount = 0;
  bool _hasAds = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_hasAds) {
      --GroupScreenState._adsCount;
      _hasAds = false;
    }

    super.dispose();
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    if (widget.onFirstLayout != null) {
      widget.onFirstLayout!.call(context);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  if (widget.hasReturn)
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
                      widget.title,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  if (widget.onDone != null)
                    InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () async {
                        if (await widget.onDone!(context)) {
                          Navigator.pop(context, true);
                        }
                        setState(() {});
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          widget.onDoneIcon ?? Icons.check_rounded,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  else if (widget.tipsIfNoOnDone != null && widget.tipsIfNoOnDone!.isNotEmpty)
                    Tooltip(
                      message: widget.tipsIfNoOnDone,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(10),
                        onTap: () {
                          DialogUtils.showAlertDialog(
                            context,
                            widget.tipsIfNoOnDone!,
                          );
                        },
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: theme.dividerColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    )
                  else
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
                    future: getGroupOptionsWithTryCatch(),
                    builder:
                        (
                          BuildContext context,
                          AsyncSnapshot<List<GroupItem>> snapshot,
                        ) {
                          List<GroupItem> data = snapshot.hasData
                              ? snapshot.data!
                              : [];
                          List<Widget> children = [];

                          children.addAll(
                            GroupItemCreator.createGroups(context, data),
                          );
                          return Column(children: children);
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

  Future<List<GroupItem>> getGroupOptionsWithTryCatch() async {
    try {
      return await getGroupOptions();
    } catch (err, stacktrace) {
      if (!mounted) {
        return [];
      }
      DialogUtils.showAlertDialog(
        context,
        "${err.toString()}\n${stacktrace.toString()}",
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
      return [];
    }
  }

  Future<List<GroupItem>> getGroupOptions() async {
    var groups = await widget.getOptions(context, () {
      setState(() {});
    });
    for (var group in groups) {
      for (var option in group.options) {
        if ((option.textOptions != null) &&
            (option.textOptions!.onPush != null)) {
          var callback = option.textOptions!.onPush;
          option.textOptions!.onPush = () async {
            await callback!();
            if (!mounted) {
              return;
            }
            setState(() {});
          };
        } else if ((option.switchOptions != null) &&
            (option.switchOptions!.onSwitch != null)) {
          var callback = option.switchOptions!.onSwitch;
          option.switchOptions!.onSwitch = (bool value) async {
            await callback!(value);
            if (!mounted) {
              return;
            }
            setState(() {});
          };
        } else if ((option.pushOptions != null) &&
            (option.pushOptions!.onPush != null)) {
          var callback = option.pushOptions!.onPush;
          option.pushOptions!.onPush = () async {
            await callback!();
            if (!mounted) {
              return;
            }
            setState(() {});
          };
        } else if ((option.timerIntervalPickerOptions != null) &&
            (option.timerIntervalPickerOptions!.onPicker != null)) {
          var callback = option.timerIntervalPickerOptions!.onPicker;
          option.timerIntervalPickerOptions!.onPicker =
              (bool canceled, Duration? value) async {
                await callback!(canceled, value);
                if (!mounted) {
                  return;
                }
                setState(() {});
              };
        } else if ((option.stringPickerOptions != null) &&
            (option.stringPickerOptions!.onPicker != null)) {
          var callback = option.stringPickerOptions!.onPicker;
          option.stringPickerOptions!.onPicker = (String? value) async {
            await callback!(value);
            if (!mounted) {
              return;
            }
            setState(() {});
          };
        }
      }
    }

    return groups;
  }
}
