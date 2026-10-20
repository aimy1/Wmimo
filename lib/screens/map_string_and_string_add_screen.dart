// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class MapStringAndStringAddScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "MapStringAndStringAddScreen");
  }

  final String title;
  List<Tuple2<String, String>> data;
  final String dialogTitle;
  final String dialogTitle2;
  final String dialogTextHit;
  final String dialogTextHit2;
  MapStringAndStringAddScreen({
    super.key,
    required this.title,
    required this.data,
    this.dialogTitle = "",
    this.dialogTitle2 = "",
    this.dialogTextHit = "",
    this.dialogTextHit2 = "",
  });

  @override
  State<MapStringAndStringAddScreen> createState() =>
      _MapStringAndStringAddScreenState();
}

class _MapStringAndStringAddScreenState
    extends LasyRenderingState<MapStringAndStringAddScreen> {
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
      thumbVisibility: true,
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

  Widget createWidget(
    int index,
    Tuple2<String, String> current,
  ) {
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
              child: InkWell(
                borderRadius: ThemeDefine.kBorderRadius,
                onTap: () async {
                  onTapEditItem(current);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          current.item1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ThemeConfig.kFontSizeGroupItem,
                          ),
                        ),
                      ),
                      if (current.item2.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          current.item2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: ThemeConfig.kFontSizeListSubItem,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                        ),
                      ],
                    ],
                  ),
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
                onTapDelete(index);
              },
            ),
          ],
        ),
      ),
    );
  }

  void onTapEditItem(Tuple2<String, String> current) async {
    String? text = await DialogUtils.showTextInputDialog(
      context,
      current.item1,
      current.item2,
      "",
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
    if (text == null || text.isEmpty) {
      return;
    }
    for (var i = 0; i < widget.data.length; ++i) {
      if (widget.data[i].item1 == current.item1) {
        widget.data[i] = Tuple2(current.item1, text);
        break;
      }
    }

    setState(() {});
  }

  void onTapAdd() async {
    final tcontext = Translations.of(context);
    String? text = await DialogUtils.showTextInputDialog(
      context,
      tcontext.meta.add,
      "",
      "",
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
    if (text == null || text.isEmpty) {
      return;
    }
    for (var current in widget.data) {
      if (current.item1 == text) {
        return;
      }
    }

    widget.data.add(Tuple2(text, ""));
    setState(() {});
  }

  void onTapDelete(int index) {
    widget.data.removeAt(index);

    setState(() {});
  }
}
