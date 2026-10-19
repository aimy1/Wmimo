// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/group_item_creator.dart';
import 'package:wmimo/screens/group_item_options.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

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
    List<Widget> actions = [];
    if (widget.onDone != null) {
      actions.add(
        IconButton(
          icon: Icon(
            widget.onDoneIcon ?? Icons.done_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          onPressed: () async {
            HapticFeedback.lightImpact();
            if (await widget.onDone!(context)) {
              if (context.mounted) {
                Navigator.pop(context, true);
              }
            }
            if (mounted) setState(() {});
          },
        ),
      );
    } else if (widget.tipsIfNoOnDone != null &&
        widget.tipsIfNoOnDone!.isNotEmpty) {
      actions.add(
        Tooltip(
          message: widget.tipsIfNoOnDone,
          child: IconButton(
            icon: Icon(
              Icons.info_outlined,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () {
              DialogUtils.showAlertDialog(
                context,
                widget.tipsIfNoOnDone!,
              );
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: WmimoAppBar(
        title: widget.title,
        leading: !widget.hasReturn ? const SizedBox.shrink() : null,
        leadingWidth: !widget.hasReturn ? 16 : null,
        actions: actions.isNotEmpty ? actions : null,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
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
