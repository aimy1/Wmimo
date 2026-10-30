import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/app/utils/platform_utils.dart';

/// Manages desktop window sizing, positioning, maximization state,
/// and persists them across application restarts.
class WindowStateManager with WindowListener {
  static final WindowStateManager instance = WindowStateManager._internal();
  WindowStateManager._internal();

  static const Size kDefaultSize = Size(800, 560);
  static const Size kMinimumSize = Size(360, 480);

  Timer? _debounceTimer;
  bool _initialized = false;
  bool _isApplying = false;

  /// Initializes window size, position, and listeners on PC platforms.
  static Future<void> init() async {
    if (!PlatformUtils.isPC()) return;
    await instance._initInternal();
  }

  Future<void> _initInternal() async {
    if (_initialized) return;
    _initialized = true;

    final windowConfig = SettingManager.getConfig().window;
    Size initialSize = kDefaultSize;
    Offset? initialPosition;
    bool shouldCenter = true;

    if (windowConfig.isValid) {
      final w = windowConfig.width!.clamp(kMinimumSize.width, 10000.0);
      final h = windowConfig.height!.clamp(kMinimumSize.height, 10000.0);
      initialSize = Size(w, h);

      if (windowConfig.x != null && windowConfig.y != null) {
        final pos = Offset(windowConfig.x!, windowConfig.y!);
        final isVisible = await _isPositionVisibleOnAnyDisplay(pos, initialSize);
        if (isVisible) {
          initialPosition = pos;
          shouldCenter = false;
        } else {
          Log.i("Saved window position ($pos) is off-screen. Re-centering window.");
        }
      }
    }

    final WindowOptions windowOptions = WindowOptions(
      size: initialSize,
      minimumSize: kMinimumSize,
      center: shouldCenter,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
      windowButtonVisibility: Platform.isMacOS,
    );

    Future<void> applyWindowSettings() async {
      if (_isApplying) return;
      _isApplying = true;
      try {
        await windowManager.setMinimumSize(kMinimumSize);
        if (initialPosition != null && !shouldCenter) {
          try {
            await windowManager.setPosition(initialPosition);
          } catch (e) {
            Log.w("Failed to restore window position: $e");
          }
        }
        if (windowConfig.isMaximized) {
          try {
            await windowManager.maximize();
          } catch (e) {
            Log.w("Failed to maximize window: $e");
          }
        }
        await windowManager.show();
        await windowManager.focus();
      } finally {
        _isApplying = false;
      }
    }

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await applyWindowSettings();
    });
    // Direct call fallback in case waitUntilReadyToShow completes synchronously
    await applyWindowSettings();

    windowManager.addListener(this);
  }

  /// Checks if the window area intersects significantly with any active display.
  Future<bool> _isPositionVisibleOnAnyDisplay(Offset pos, Size size) async {
    try {
      final displays = await screenRetriever.getAllDisplays();
      if (displays.isEmpty) return true;

      final windowRect = Rect.fromLTWH(pos.dx, pos.dy, size.width, size.height);
      for (final display in displays) {
        final displayX = display.visiblePosition?.dx ?? 0.0;
        final displayY = display.visiblePosition?.dy ?? 0.0;
        final displayW = display.visibleSize?.width ?? display.size.width;
        final displayH = display.visibleSize?.height ?? display.size.height;

        final displayRect = Rect.fromLTWH(displayX, displayY, displayW, displayH);
        final overlap = windowRect.intersect(displayRect);
        // If at least 120x80 of the window is visible on this screen
        if (!overlap.isEmpty && overlap.width >= 120 && overlap.height >= 80) {
          return true;
        }
      }
      return false;
    } catch (e) {
      Log.w("Failed to query displays with screenRetriever: $e");
      return true; // Fallback to allowed if check encounters an error
    }
  }

  @override
  void onWindowResized() {
    _scheduleRecord();
  }

  @override
  void onWindowMoved() {
    _scheduleRecord();
  }

  @override
  void onWindowMaximize() {
    if (!PlatformUtils.isPC()) return;
    SettingManager.getConfig().window.isMaximized = true;
    _scheduleRecord(saveImmediate: true);
  }

  @override
  void onWindowUnmaximize() {
    if (!PlatformUtils.isPC()) return;
    SettingManager.getConfig().window.isMaximized = false;
    // Delay slightly to give native window manager time to exit maximized bounds
    Future.delayed(const Duration(milliseconds: 150), () {
      _scheduleRecord(saveImmediate: true);
    });
  }

  void _scheduleRecord({bool saveImmediate = false}) {
    if (!PlatformUtils.isPC() || _isApplying) return;
    _debounceTimer?.cancel();
    if (saveImmediate) {
      recordAndSave();
    } else {
      _debounceTimer = Timer(const Duration(milliseconds: 600), () {
        recordAndSave();
      });
    }
  }

  /// Queries current window geometry and updates SettingConfig, saving to disk.
  Future<void> recordAndSave() async {
    if (!PlatformUtils.isPC() || _isApplying) return;
    try {
      final isMinimized = await windowManager.isMinimized();
      if (isMinimized) {
        return; // Avoid saving negative/minimized coordinates (-32000, -32000)
      }

      final isMaximized = await windowManager.isMaximized();
      final windowConfig = SettingManager.getConfig().window;
      windowConfig.isMaximized = isMaximized;

      if (!isMaximized) {
        final size = await windowManager.getSize();
        final pos = await windowManager.getPosition();

        if (size.width >= kMinimumSize.width && size.height >= kMinimumSize.height) {
          windowConfig.width = size.width;
          windowConfig.height = size.height;
          windowConfig.x = pos.dx;
          windowConfig.y = pos.dy;
        }
      }

      await SettingManager.save();
    } catch (e) {
      Log.w("WindowStateManager.recordAndSave error: $e");
    }
  }

  /// Cancels any pending debounce timer and forces an immediate save.
  /// Call this on app close or exit.
  static Future<void> saveImmediate() async {
    if (!PlatformUtils.isPC()) return;
    instance._debounceTimer?.cancel();
    await instance.recordAndSave();
  }
}
