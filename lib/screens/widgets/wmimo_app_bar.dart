import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/desktop_window_caption_bar.dart';

/// A unified, responsive application bar for primary and secondary screens in Wmimo.
/// Standardizes navigation, title typography, action button sizing, and 16px horizontal
/// grid alignment across all screens.
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
    if (!canPop) return const SizedBox(width: 12);

    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Tooltip(
        message: MaterialLocalizations.of(context).backButtonTooltip,
        child: InkWell(
          borderRadius: BorderRadius.circular(ThemeDefine.kRadiusMedium),
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.maybePop(context);
          },
          child: SizedBox(
            width: 38,
            height: 38,
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
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                height: 1.2,
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

    final defaultActionIconColor =
        theme.colorScheme.onSurface.withValues(alpha: 0.85);

    return IconButtonTheme(
      data: IconButtonThemeData(
        style: IconButton.styleFrom(
          iconSize: 20,
          padding: EdgeInsets.zero,
          visualDensity: VisualDensity.compact,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: const Size(34, 34),
          fixedSize: const Size(34, 34),
          foregroundColor: defaultActionIconColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      child: AppBar(
        toolbarHeight: 52.0,
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
                : ((ModalRoute.of(context)?.canPop ?? false) ? 48 : 12)),
        titleSpacing: 4,
        title: columnTitle,
        actions: actions != null
            ? [
                ...actions!.map(
                  (w) => Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: w,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
      ),
    );
  }
}

/// Standardized 38px search input bar used across Proxy, Profiles, Connections, and Rules screens.
class WmimoSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final String? badgeText;
  final VoidCallback? onClear;

  const WmimoSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.focusNode,
    this.badgeText,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: controller,
      builder: (context, value, _) {
        final hasText = value.text.trim().isNotEmpty;
        return Container(
          height: 38,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF262629) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              fontSize: 13,
              height: 1.2,
            ),
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 12.5,
                height: 1.2,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.42),
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                size: 18,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 38,
                minHeight: 38,
              ),
              suffixIcon: hasText
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (badgeText != null && badgeText!.isNotEmpty) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeDefine.kColorBlue.withValues(
                                alpha: isDark ? 0.22 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              badgeText!,
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w600,
                                color: ThemeDefine.kColorBlue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: onClear ?? () => controller.clear(),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              Icons.clear_rounded,
                              size: 16,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.55),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                    )
                  : null,
              suffixIconConstraints: const BoxConstraints(
                minHeight: 38,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 9),
            ),
          ),
        );
      },
    );
  }
}
