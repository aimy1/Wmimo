import 'dart:io';

import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';

/// Wraps [child] with desktop window drag-to-move and double-click-to-maximize
/// behavior on PC platforms (Windows, macOS, Linux).
class DesktopDragArea extends StatelessWidget {
  final Widget child;
  final bool enableDoubleTapMaximize;

  const DesktopDragArea({
    super.key,
    required this.child,
    this.enableDoubleTapMaximize = true,
  });

  static Future<void> toggleMaximize() async {
    if (!PlatformUtils.isPC()) return;
    try {
      final isMaximized = await windowManager.isMaximized();
      if (isMaximized) {
        await windowManager.unmaximize();
      } else {
        await windowManager.maximize();
      }
    } catch (_) {}
  }

  static void startDragging() {
    if (!PlatformUtils.isPC()) return;
    try {
      windowManager.startDragging();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    if (!PlatformUtils.isPC()) return child;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) => startDragging(),
      onDoubleTap: enableDoubleTapMaximize ? toggleMaximize : null,
      child: child,
    );
  }
}

/// Immersive borderless window caption bar for Scheme A.
/// Provides a drag region across the top of the workspace and renders
/// theme-adaptive Minimize / Maximize-Restore / Close buttons on Windows & Linux.
class DesktopWindowCaptionBar extends StatefulWidget {
  final double height;
  final bool showLeadingLogo;
  final Color? backgroundColor;

  const DesktopWindowCaptionBar({
    super.key,
    this.height = 30.0,
    this.showLeadingLogo = false,
    this.backgroundColor,
  });

  @override
  State<DesktopWindowCaptionBar> createState() =>
      _DesktopWindowCaptionBarState();
}

class _DesktopWindowCaptionBarState extends State<DesktopWindowCaptionBar>
    with WindowListener {
  bool _isMaximized = false;
  bool _isFocused = true;

  @override
  void initState() {
    super.initState();
    if (PlatformUtils.isPC()) {
      try {
        windowManager.addListener(this);
        _syncWindowState();
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    if (PlatformUtils.isPC()) {
      try {
        windowManager.removeListener(this);
      } catch (_) {}
    }
    super.dispose();
  }

  Future<void> _syncWindowState() async {
    try {
      final maximized = await windowManager.isMaximized();
      final focused = await windowManager.isFocused();
      if (mounted && (_isMaximized != maximized || _isFocused != focused)) {
        setState(() {
          _isMaximized = maximized;
          _isFocused = focused;
        });
      }
    } catch (_) {}
  }

  @override
  void onWindowMaximize() {
    if (mounted) {
      setState(() => _isMaximized = true);
    }
  }

  @override
  void onWindowUnmaximize() {
    if (mounted) {
      setState(() => _isMaximized = false);
    }
  }

  @override
  void onWindowRestore() {
    _syncWindowState();
  }

  @override
  void onWindowFocus() {
    if (mounted) {
      setState(() => _isFocused = true);
    }
  }

  @override
  void onWindowBlur() {
    if (mounted) {
      setState(() => _isFocused = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!PlatformUtils.isPC()) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final showButtons = !Platform.isMacOS;

    return Container(
      height: widget.height,
      color: widget.backgroundColor ?? Colors.transparent,
      child: Row(
        children: [
          Expanded(
            child: DesktopDragArea(
              child: Container(
                height: widget.height,
                color: Colors.transparent,
                padding: EdgeInsets.only(
                  left: Platform.isMacOS && widget.showLeadingLogo ? 72 : 14,
                ),
                alignment: Alignment.centerLeft,
                child: widget.showLeadingLogo
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/app_icon_256.png',
                            width: 16,
                            height: 16,
                            fit: BoxFit.contain,
                            filterQuality: FilterQuality.medium,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppUtils.getName(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: _isFocused ? 0.85 : 0.5,
                              ),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.expand(),
              ),
            ),
          ),
          if (showButtons) ...[
            _WindowCaptionButton(
              key: const ValueKey('window_btn_minimize'),
              type: _CaptionButtonType.minimize,
              isDark: isDark,
              isFocused: _isFocused,
              height: widget.height,
              onTap: () async {
                try {
                  await windowManager.minimize();
                } catch (_) {}
              },
            ),
            _WindowCaptionButton(
              key: const ValueKey('window_btn_maximize'),
              type: _isMaximized
                  ? _CaptionButtonType.restore
                  : _CaptionButtonType.maximize,
              isDark: isDark,
              isFocused: _isFocused,
              height: widget.height,
              onTap: () async {
                await DesktopDragArea.toggleMaximize();
                await _syncWindowState();
              },
            ),
            _WindowCaptionButton(
              key: const ValueKey('window_btn_close'),
              type: _CaptionButtonType.close,
              isDark: isDark,
              isFocused: _isFocused,
              height: widget.height,
              isClose: true,
              onTap: () async {
                try {
                  await windowManager.close();
                } catch (_) {}
              },
            ),
          ],
        ],
      ),
    );
  }
}

enum _CaptionButtonType {
  minimize,
  maximize,
  restore,
  close,
}

class _WindowCaptionButton extends StatefulWidget {
  final _CaptionButtonType type;
  final bool isDark;
  final bool isFocused;
  final double height;
  final bool isClose;
  final VoidCallback onTap;

  const _WindowCaptionButton({
    super.key,
    required this.type,
    required this.isDark,
    required this.isFocused,
    required this.height,
    this.isClose = false,
    required this.onTap,
  });

  @override
  State<_WindowCaptionButton> createState() => _WindowCaptionButtonState();
}

class _WindowCaptionButtonState extends State<_WindowCaptionButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.transparent;
    if (_isHovered) {
      if (widget.isClose) {
        bgColor = _isPressed
            ? const Color(0xFFC42B1C)
            : const Color(0xFFE81123);
      } else {
        bgColor = widget.isDark
            ? Colors.white.withValues(alpha: _isPressed ? 0.12 : 0.08)
            : Colors.black.withValues(alpha: _isPressed ? 0.09 : 0.06);
      }
    }

    Color iconColor;
    if (_isHovered && widget.isClose) {
      iconColor = Colors.white;
    } else {
      final baseColor = widget.isDark
          ? const Color(0xFFE2E8F0)
          : const Color(0xFF1E293B);
      iconColor = baseColor.withValues(
        alpha: _isHovered ? 1.0 : (widget.isFocused ? 0.78 : 0.42),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() {
        _isHovered = false;
        _isPressed = false;
      }),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          width: 46,
          height: widget.height,
          color: bgColor,
          alignment: Alignment.center,
          child: CustomPaint(
            size: const Size(10, 10),
            painter: _CaptionIconPainter(
              type: widget.type,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _CaptionIconPainter extends CustomPainter {
  final _CaptionButtonType type;
  final Color color;

  const _CaptionIconPainter({
    required this.type,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.15
      ..strokeCap = StrokeCap.square;

    switch (type) {
      case _CaptionButtonType.minimize:
        final y = size.height / 2;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
        break;

      case _CaptionButtonType.maximize:
        canvas.drawRect(
          Rect.fromLTWH(0.5, 0.5, size.width - 1.0, size.height - 1.0),
          paint,
        );
        break;

      case _CaptionButtonType.restore:
        // Front bottom-left rectangle
        final frontRect = Rect.fromLTWH(
          0.5,
          2.5,
          size.width - 3.0,
          size.height - 3.0,
        );
        canvas.drawRect(frontRect, paint);

        // Back top-right L-frame
        final path = Path()
          ..moveTo(2.5, 2.5)
          ..lineTo(2.5, 0.5)
          ..lineTo(size.width - 0.5, 0.5)
          ..lineTo(size.width - 0.5, size.height - 2.5)
          ..lineTo(size.width - 2.5, size.height - 2.5);
        canvas.drawPath(path, paint);
        break;

      case _CaptionButtonType.close:
        paint.strokeCap = StrokeCap.round;
        paint.strokeWidth = 1.25;
        canvas.drawLine(
          const Offset(0.5, 0.5),
          Offset(size.width - 0.5, size.height - 0.5),
          paint,
        );
        canvas.drawLine(
          Offset(size.width - 0.5, 0.5),
          Offset(0.5, size.height - 0.5),
          paint,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _CaptionIconPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.color != color;
  }
}
