// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class ListAddScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings(String viewTag) {
    return RouteSettings(name: "ListAddScreen:$viewTag");
  }

  final String title;
  List<String> data;
  final Set<String> invalidData;
  final String dialogTitle;
  final String dialogTextHit;
  final Future<String?> Function()? onTapAdd;
  final void Function(List<String>)? onChanged;
  ListAddScreen({
    super.key,
    required this.title,
    required this.data,
    this.invalidData = const {},
    this.dialogTitle = "",
    this.dialogTextHit = "",
    this.onTapAdd,
    this.onChanged,
  });

  @override
  State<ListAddScreen> createState() => _ListAddScreenState();
}

class _ListAddScreenState extends LasyRenderingState<ListAddScreen> {
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
      appBar: WmimoAppBar(
        title: widget.title,
        actions: [
          IconButton(
            tooltip: tcontext.meta.add,
            icon: const Icon(Icons.add_rounded, size: 24),
            splashRadius: 20,
            onPressed: () async {
              onTapAdd();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _loadListView(),
      ),
    );
  }

  Widget _loadListView() {
    if (widget.data.isEmpty) {
      final tcontext = Translations.of(context);
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.format_list_bulleted_rounded,
              size: 48,
              color: Colors.grey.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 12),
            Text(
              tcontext.meta.none,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      );
    }

    return Scrollbar(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          var current = widget.data[index];
          return createWidget(index, current);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 1, thickness: 0.3);
        },
      ),
    );
  }

  Widget createWidget(int index, dynamic current) {
    final currentStr = current.toString();
    final tcontext = Translations.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: ThemeDefine.kBorderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        width: double.infinity,
        height: ThemeConfig.kListItemHeight2,
        child: Row(
          children: [
            Expanded(
              child: Text(
                currentStr,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: ThemeConfig.kFontSizeGroupItem,
                  color: widget.invalidData.contains(currentStr)
                      ? Colors.red
                      : null,
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(
                Icons.remove_circle_outlined,
                size: 24,
                color: Colors.red,
              ),
              splashRadius: 20,
              tooltip: tcontext.meta.remove,
              onPressed: () async {
                onTapDelete(currentStr);
              },
            ),
          ],
        ),
      ),
    );
  }

  void onTapAdd() async {
    String? text;
    if (widget.onTapAdd != null) {
      text = await widget.onTapAdd!();
    } else {
      final tcontext = Translations.of(context);
      text = await DialogUtils.showTextInputDialog(
        context,
        widget.dialogTitle.isNotEmpty ? widget.dialogTitle : tcontext.meta.add,
        "",
        widget.dialogTextHit.isNotEmpty ? widget.dialogTextHit : "",
        null,
        null,
        (text) {
          text = text.trim();
          if (text.isEmpty) {
            return false;
          }

          return true;
        },
      );
    }

    if (text == null) {
      return;
    }
    text = text.trim();
    if (text.isEmpty) {
      return;
    }
    final parts = text.contains(';') || text.contains(',')
        ? text
            .split(RegExp(r'[;,]'))
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList()
        : [text];
    bool changed = false;
    for (final part in parts) {
      if (!widget.data.contains(part)) {
        widget.data.add(part);
        changed = true;
      }
    }
    if (changed) {
      widget.onChanged?.call(widget.data);
      setState(() {});
    }
  }

  void onTapDelete(String text) {
    if (widget.data.remove(text)) {
      widget.onChanged?.call(widget.data);
      setState(() {});
    }
  }
}
