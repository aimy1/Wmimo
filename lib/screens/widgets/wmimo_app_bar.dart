import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/desktop_window_caption_bar.dart';

/// A unified, responsive application bar for secondary screens in Wmimo.
/// Replaces inconsistent faux-appbar rows and standardizes navigation, title typography,
/// touch targets (>= 44x44), and surface styling across all platforms.
class WmimoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final dynamic title; // String or Widget
  final dynamic subtitle; // String or Widget
  final Widget? badge;
  final Widget? leading;
  final double? leadingWidth;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final bool showBottomDivider;

  const WmimoAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.badge,
    this.leading,
    this.leadingWidth,
    this.actions,
    this.bottom,
    this.centerTitle,
    this.elevation = 0,
    this.backgroundColor,
    this.showBottomDivider = false,
  });

  @override
  Size get preferredSize => Size.fromHeight(
        52.0 + (bottom?.preferredSize.height ?? 0.0),
      );

  Widget _buildLeading(BuildContext context) {
    if (leading != null) return leading!;

    final canPop = ModalRoute.of(context)?.canPop ?? false;
    if (!canPop) return const SizedBox(width: 8);

    return Padding(
      padding: const EdgeInsets.only(left: 6),
      child: Tooltip(
        message: MaterialLocalizations.of(context).backButtonTooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(ThemeDefine.kRadiusMedium),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.maybePop(context);
          },
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(
              Platform.isIOS
                  ? Icons.arrow_back_ios_new_rounded
                  : Icons.arrow_back_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget titleWidget;
    if (title is Widget) {
      titleWidget = title as Widget;
    } else {
      titleWidget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              title.toString(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (badge != null) ...[
            const SizedBox(width: 8),
            badge!,
          ],
        ],
      );
    }

    Widget? subtitleWidget;
    if (subtitle != null) {
      if (subtitle is Widget) {
        subtitleWidget = subtitle as Widget;
      } else {
        subtitleWidget = Text(
          subtitle.toString(),
          style: TextStyle(
            fontSize: 11.5,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }
    }

    final columnTitle = subtitleWidget != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: (centerTitle ?? false)
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              titleWidget,
              const SizedBox(height: 1),
              subtitleWidget,
            ],
          )
        : titleWidget;

    return AppBar(
      elevation: elevation,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle ?? (Platform.isIOS),
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      automaticallyImplyLeading: false,
      flexibleSpace: const DesktopDragArea(child: SizedBox.expand()),
      leading: _buildLeading(context),
      leadingWidth: leadingWidth ??
          (leading != null
              ? (leading is SizedBox && (leading as SizedBox).width == 0
                  ? 0
                  : null)
              : ((ModalRoute.of(context)?.canPop ?? false) ? 50 : 8)),
      titleSpacing: 4,
      title: columnTitle,
      actions: actions != null
          ? [
              ...actions!,
              const SizedBox(width: 8),
            ]
          : null,
      bottom: bottom != null
          ? bottom
          : (showBottomDivider
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(0.8),
                  child: Container(
                    color: isDark
                        ? const Color(0xFF262629)
                        : const Color(0xFFE2E8F0),
                    height: 0.8,
                  ),
                )
              : null),
    );
  }
}
