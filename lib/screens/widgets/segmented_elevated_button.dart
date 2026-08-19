// ignore_for_file: must_be_immutable

import 'package:wmimo/screens/theme_define.dart';
import 'package:flutter/material.dart';

class SegemntedElevatedButtonItem {
  SegemntedElevatedButtonItem({required this.value, required this.text});
  final int value;
  final String text;
}

class SegmentedElevatedButton extends StatefulWidget {
  SegmentedElevatedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.padding,
    this.background,
    this.buttonStyle,
    this.onPressed,
  });

  final List<SegemntedElevatedButtonItem> segments;
  int selected;
  final EdgeInsetsGeometry? padding;
  final Color? background;
  final ButtonStyle? buttonStyle;
  final Function(int value)? onPressed;

  @override
  State<SegmentedElevatedButton> createState() => _SegmentedElevatedButtonState();
}

class _SegmentedElevatedButtonState extends State<SegmentedElevatedButton> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: widget.background ??
            (isDark
                ? ThemeDefine.kColorDarkBg
                : const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.5),
          width: 0.8,
        ),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: List.generate(widget.segments.length, (index) {
          final isSelected = widget.selected == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  widget.selected = index;
                });
                widget.onPressed?.call(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark
                          ? ThemeDefine.kColorDarkCard
                          : Colors.white)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: isDark ? 0.25 : 0.06,
                            ),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    widget.segments[index].text,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? ThemeDefine.kColorBlue
                          : theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
