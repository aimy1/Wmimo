// ignore_for_file: constant_identifier_names

import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/group_item_options.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/sheet.dart';
import 'package:wmimo/screens/widgets/text_field.dart';
import 'package:flutter/material.dart';

class GroupItemText extends StatelessWidget {
  const GroupItemText({super.key, required this.options});

  final GroupItemTextOptions options;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: options.onPush,
      onLongPress: options.onLongPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          options.child ?? const SizedBox.shrink(),
          options.child != null ? const SizedBox(width: 6) : const SizedBox.shrink(),
          if ((options.tips != null) && options.tips!.isNotEmpty) ...[
            InkWell(
              onTap: () {
                DialogUtils.showAlertDialog(context, options.tips!);
              },
              child: Tooltip(
                message: options.tips,
                child: const Icon(Icons.info_outlined, size: 20),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Expanded(
            flex: ((1 - options.textWidthPercent) * 10).toInt(),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                options.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ThemeConfig.kFontSizeGroupItem,
                  fontWeight: ThemeConfig.kFontWeightListItem,
                ),
              ),
            ),
          ),
          Expanded(
            flex: ((options.textWidthPercent) * 10).toInt(),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                options.text ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: options.textStyle ??
                    TextStyle(
                      fontSize: ThemeConfig.kFontSizeListSubItem,
                      color: options.textColor ??
                          Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                    ),
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

class GroupItemTextField extends StatelessWidget {
  const GroupItemTextField({super.key, required this.options});

  final GroupItemTextFieldOptions options;

  @override
  Widget build(BuildContext context) {
    var controller = options.controller ?? TextEditingController();
    controller.value = controller.value.copyWith(text: options.text);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if ((options.tips != null) && options.tips!.isNotEmpty) ...[
          InkWell(
            onTap: () {
              DialogUtils.showAlertDialog(context, options.tips!);
            },
            child: Tooltip(
              message: options.tips,
              child: const Icon(Icons.info_outlined, size: 20),
            ),
          ),
          const SizedBox(width: 6),
        ],
        Expanded(
          flex: ((1 - options.textWidthPercent) * 10).toInt(),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              options.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ThemeConfig.kFontSizeGroupItem,
                fontWeight: ThemeConfig.kFontWeightListItem,
              ),
            ),
          ),
        ),
        Expanded(
          flex: ((options.textWidthPercent) * 10).toInt(),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextFieldEx(
              style: options.textStyle ??
                  TextStyle(fontSize: ThemeConfig.kFontSizeGroupItem),
              readOnly: options.readOnly,
              controller: controller,
              textInputAction: options.textInputAction,
              obscureText: options.obscureText,
              decoration: InputDecoration(
                hintText: options.hint,
                errorText: options.errorText,
                border: InputBorder.none,
                isDense: true,
              ),
              textAlign: TextAlign.right,
              keyboardType: options.keyboardType,
              inputFormatters: options.inputFormatters,
              focusNode: options.focusNode,
              autocorrect: false,
              enableSuggestions: true,
              autofocus: options.autoFocus,
              onChanged: options.onChanged,
              enabled: options.enabled,
              onSubmitted: options.onSubmitted,
              title: options.name,
            ),
          ),
        ),
      ],
    );
  }
}

class GroupItemSwitch extends StatelessWidget {
  const GroupItemSwitch({super.key, required this.options});

  final GroupItemSwitchOptions options;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if ((options.tips != null) && options.tips!.isNotEmpty) ...[
          InkWell(
            onTap: () {
              DialogUtils.showAlertDialog(context, options.tips!);
            },
            child: Tooltip(
              message: options.tips,
              child: const Icon(Icons.info_outlined, size: 20),
            ),
          ),
          const SizedBox(width: 6),
        ],
        if (options.reddot == true) ...[
          Container(
            width: 7,
            height: 7,
            margin: const EdgeInsets.only(right: 6),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ],
        Expanded(
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              options.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: ThemeConfig.kFontSizeGroupItem,
                fontWeight: ThemeConfig.kFontWeightListItem,
              ),
            ),
          ),
        ),
        Transform.scale(
          scale: 0.9,
          child: Switch.adaptive(
            value: options.switchValue ?? false,
            activeThumbColor: Colors.white,
            activeTrackColor: ThemeDefine.kColorGreenBright,
            onChanged: options.onSwitch,
          ),
        ),
      ],
    );
  }
}

class GroupItemPush extends StatelessWidget {
  const GroupItemPush({super.key, required this.options});

  final GroupItemPushOptions options;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: options.onPush,
      onLongPress: options.onLongPress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if ((options.tips != null) && options.tips!.isNotEmpty) ...[
            InkWell(
              onTap: () {
                DialogUtils.showAlertDialog(context, options.tips!);
              },
              child: Tooltip(
                message: options.tips,
                child: const Icon(Icons.info_outlined, size: 20),
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (options.reddot == true) ...[
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: options.reddotColor ?? Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
          if (options.icon != null) ...[
            Icon(options.icon, size: 22, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
          ],
          Expanded(
            flex: ((1 - options.textWidthPercent) * 10).toInt(),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                options.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ThemeConfig.kFontSizeGroupItem,
                  fontWeight: ThemeConfig.kFontWeightListItem,
                ),
              ),
            ),
          ),
          Expanded(
            flex: (options.textWidthPercent * 10).toInt(),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                options.text ?? "",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: options.textStyle ??
                    TextStyle(
                      fontSize: ThemeConfig.kFontSizeListSubItem,
                      color: options.textColor ??
                          Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.6),
                    ),
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right, size: 20),
        ],
      ),
    );
  }
}

class GroupItemTimerIntervalPicker extends StatelessWidget {
  const GroupItemTimerIntervalPicker({super.key, required this.options});

  final GroupItemTimerIntervalPickerOptions options;

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    return InkWell(
      onTap: options.onPicker == null
          ? null
          : () async {
              DialogUtilsResult<Duration>? result =
                  await DialogUtils.showTimeIntervalPickerDialog(
                    context,
                    options.duration,
                    showDays: options.showDays,
                    showHours: options.showHours,
                    showMinutes: options.showMinutes,
                    showSeconds: options.showSeconds,
                    showDisable: options.showDisable,
                  );
              if (result != null) {
                options.duration = result.data;
              }

              options.onPicker!(result == null, options.duration);
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if ((options.tips != null) && options.tips!.isNotEmpty) ...[
            InkWell(
              onTap: () {
                DialogUtils.showAlertDialog(context, options.tips!);
              },
              child: Tooltip(
                message: options.tips,
                child: const Icon(Icons.info_outlined, size: 20),
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (options.reddot == true) ...[
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
          Expanded(
            flex: 8,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                options.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ThemeConfig.kFontSizeGroupItem,
                  fontWeight: ThemeConfig.kFontWeightListItem,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                _duratingToString(options.duration, tcontext.meta.disable),
                style: const TextStyle(
                  fontSize: ThemeConfig.kFontSizeListSubItem,
                  color: ThemeDefine.kColorBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right, size: 20),
        ],
      ),
    );
  }

  String _duratingToString(Duration? duration, String disable) {
    String ret = "";
    if (duration != null) {
      if (duration.inDays > 0) {
        ret = "${duration.inDays} d";
      } else if (duration.inHours > 0) {
        ret = "${duration.inHours} h";
      } else if (duration.inMinutes > 0) {
        ret = "${duration.inMinutes} m";
      } else if (duration.inSeconds > 0) {
        ret = "${duration.inSeconds} s";
      }
    } else {
      ret = disable;
    }

    return ret;
  }
}

class GroupItemStringPicker extends StatelessWidget {
  const GroupItemStringPicker({super.key, required this.options});

  final GroupItemStringPickerOptions options;

  @override
  Widget build(BuildContext context) {
    String selectedText = options.selected ?? "";
    var widgets = [];
    if (options.tupleStrings != null) {
      for (var key in options.tupleStrings!) {
        if (options.selected == key.item1) {
          selectedText = key.item2;
        }
        widgets.add(
          ListTile(
            title: Text(
              key.item2,
              style: TextStyle(
                color: options.selected == key.item1
                    ? ThemeDefine.kColorBlue
                    : null,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              options.selected = key.item1;
              options.onPicker?.call(options.selected);
            },
          ),
        );
      }
    } else if (options.strings != null) {
      for (var key in options.strings!) {
        widgets.add(
          ListTile(
            title: Text(
              key ?? "",
              style: TextStyle(
                color: options.selected == key ? ThemeDefine.kColorBlue : null,
              ),
            ),
            onTap: () async {
              Navigator.pop(context);
              options.selected = key;
              options.onPicker?.call(options.selected);
            },
          ),
        );
      }
    }
    return InkWell(
      onTap: options.onPicker == null
          ? null
          : () {
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
            },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if ((options.tips != null) && options.tips!.isNotEmpty) ...[
            InkWell(
              onTap: () {
                DialogUtils.showAlertDialog(context, options.tips!);
              },
              child: Tooltip(
                message: options.tips,
                child: const Icon(Icons.info_outlined, size: 20),
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (options.reddot == true) ...[
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.only(right: 6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ],
          Expanded(
            flex: ((1 - options.textWidthPercent) * 10).toInt(),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                options.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ThemeConfig.kFontSizeGroupItem,
                  fontWeight: ThemeConfig.kFontWeightListItem,
                ),
              ),
            ),
          ),
          Expanded(
            flex: (options.textWidthPercent * 10).toInt(),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(
                selectedText,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ThemeConfig.kFontSizeListSubItem,
                  color: ThemeDefine.kColorBlue,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right, size: 20),
        ],
      ),
    );
  }
}


