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
      final hasName = group.name != null && group.name!.isNotEmpty;
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasName)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8, top: 4),
                  child: Row(
                    children: [
                      Container(
                        width: 3.5,
                        height: 13,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        group.name!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                ),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: Theme.of(context).dividerColor.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                  child: giCreator.createGroup(context, group, index == 0),
                ),
              ),
            ],
          ),
        ),
      );
      ++index;
    }
    return widgets;
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
        Scrollbar(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) {
              return widgets[index];
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(
                height: 1,
                thickness: 0.6,
                color: Theme.of(context).dividerColor.withValues(alpha: 0.25),
              );
            },
            itemCount: widgets.length,
          ),
        ),
      ],
    );
  }
}

