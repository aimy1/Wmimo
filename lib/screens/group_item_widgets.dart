// ignore_for_file: constant_identifier_names

import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/group_item_options.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/sheet.dart';
import 'package:wmimo/screens/widgets/text_field.dart';
import 'package:flutter/material.dart';

class GroupItemText extends StatelessWidget {
  const GroupItemText({super.key, required this.options});

  final GroupItemTextOptions options;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
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
                child: Icon(Icons.info_outline_rounded, size: 20, color: theme.colorScheme.primary),
              ),
            ),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
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
                      fontSize: 13,
                      color: options.textColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.65),
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
    final theme = Theme.of(context);
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
              child: Icon(Icons.info_outline_rounded, size: 20, color: theme.colorScheme.primary),
            ),
          ),
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Expanded(
          flex: ((options.textWidthPercent) * 10).toInt(),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextFieldEx(
              style: options.textStyle ?? const TextStyle(fontSize: 13.5),
              readOnly: options.readOnly,
              controller: controller,
              textInputAction: options.textInputAction,
              obscureText: options.obscureText,
              decoration: InputDecoration(
                hintText: options.hint,
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                ),
                errorText: options.errorText,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
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
    final theme = Theme.of(context);
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
              child: Icon(Icons.info_outline_rounded, size: 20, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(width: 8),
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
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Transform.scale(
          scale: 0.85,
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
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
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
                child: Icon(Icons.info_outline_rounded, size: 20, color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(width: 8),
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
            Icon(options.icon, size: 20, color: theme.colorScheme.primary),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          if (options.text != null && options.text!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(7),
              ),
              child: Text(
                options.text!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: options.textStyle ??
                    TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: options.textColor ??
                          theme.colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Icon(
            Icons.chevron_right_rounded,
            size: 18,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
          ),
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
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(10),
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
                child: Icon(Icons.info_outline_rounded, size: 20, color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(width: 8),
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
            flex: 7,
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(
                options.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Text(
              _duratingToString(options.duration, tcontext.meta.disable),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 4),
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
    final theme = Theme.of(context);
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
                fontWeight: options.selected == key.item1 ? FontWeight.w700 : FontWeight.normal,
                color: options.selected == key.item1
                    ? theme.colorScheme.primary
                    : null,
              ),
            ),
            trailing: options.selected == key.item1
                ? Icon(Icons.check_rounded, color: theme.colorScheme.primary, size: 20)
                : null,
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
                fontWeight: options.selected == key ? FontWeight.w700 : FontWeight.normal,
                color: options.selected == key ? theme.colorScheme.primary : null,
              ),
            ),
            trailing: options.selected == key
                ? Icon(Icons.check_rounded, color: theme.colorScheme.primary, size: 20)
                : null,
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
      borderRadius: BorderRadius.circular(10),
      onTap: options.onPicker == null
          ? null
          : () {
              showSheet(
                context: context,
                body: SizedBox(
                  height: 380,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Scrollbar(
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return widgets[index];
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(
                            height: 1,
                            thickness: 0.6,
                            color: theme.dividerColor.withValues(alpha: 0.2),
                          );
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
                child: Icon(Icons.info_outline_rounded, size: 20, color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(width: 8),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
            decoration: BoxDecoration(
              color: theme.dividerColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(7),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  selectedText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.unfold_more_rounded,
                  size: 14,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

