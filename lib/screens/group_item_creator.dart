// ignore_for_file: constant_identifier_names

import 'package:wmimo/screens/group_item_options.dart';
import 'package:wmimo/screens/group_item_widgets.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:flutter/material.dart';

class GroupItem {
  GroupItem({
    this.name,
    this.itemHeight = ThemeConfig.kGroupItemHeight,
    required this.options,
  });
  final String? name;
  final double? itemHeight;
  final List<GroupItemOptions> options;
}

class GroupItemCreator {
  static List<Widget> createGroups(
    BuildContext context,
    List<GroupItem> groups,
  ) {
    List<Widget> widgets = [];
    GroupItemCreator giCreator = GroupItemCreator();
    int index = 0;
    for (var group in groups) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: giCreator.createGroup(context, group, index == 0),
            ),
          ),
        ),
      );
      ++index;
    }
    return widgets;
  }

  Widget _createGroupName(BuildContext context, GroupItem group) {
    if (group.name == null || group.name!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 6),
        child: Text(
          group.name!,
          style: TextStyle(
            fontSize: ThemeConfig.kFontSizeListItem,
            fontWeight: ThemeConfig.kFontWeightListItem,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Column createGroup(BuildContext context, GroupItem group, bool isFirstGroup) {
    var widgets = [];
    for (var option in group.options) {
      late Widget widget;
      if (option.textOptions != null) {
        widget = GroupItemText(options: option.textOptions!);
      } else if (option.textFormFieldOptions != null) {
        widget = GroupItemTextField(options: option.textFormFieldOptions!);
      } else if (option.switchOptions != null) {
        widget = GroupItemSwitch(options: option.switchOptions!);
      } else if (option.pushOptions != null) {
        widget = GroupItemPush(options: option.pushOptions!);
      } else if (option.timerIntervalPickerOptions != null) {
        widget = GroupItemTimerIntervalPicker(
          options: option.timerIntervalPickerOptions!,
        );
      } else if (option.stringPickerOptions != null) {
        widget = GroupItemStringPicker(options: option.stringPickerOptions!);
      } else {
        continue;
      }
      widgets.add(SizedBox(height: group.itemHeight, child: widget));
    }
    return Column(
      children: [
        _createGroupName(context, group),
        Scrollbar(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return widgets[index];
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(height: 1, thickness: 0.8);
            },
            itemCount: widgets.length,
          ),
        ),
      ],
    );
  }
}
