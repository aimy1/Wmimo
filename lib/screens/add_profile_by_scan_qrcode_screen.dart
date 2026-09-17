// ignore_for_file: use_build_context_synchronously, empty_catches

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:screen_capturer/screen_capturer.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/app/utils/qrcode_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';

class QrcodeScanResult {
  String? qrcode;
}

class AddProfileByScanQrcodeScanScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "AddProfileByScanQrcodeScanScreen");
  }

  const AddProfileByScanQrcodeScanScreen({super.key});

  @override
  State<AddProfileByScanQrcodeScanScreen> createState() =>
      _AddProfileByScanQrcodeScanScreenState();
}

class _AddProfileByScanQrcodeScanScreenState
    extends LasyRenderingState<AddProfileByScanQrcodeScanScreen> {
  final QrcodeScanResult _result = QrcodeScanResult();
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  Image? _image;
  Uint8List? _imageBytes;
  String _qrContent = "";
  bool _isScanning = false;
  bool _scanFromFile = false;
  bool _showSnackBarShowed = false;
  bool _scanFailed = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onConfirm() {
    final tcontext = Translations.of(context);
    if (_qrContent.trim().isEmpty) {
      DialogUtils.showAlertDialog(
        context,
        tcontext.meta.qrcodeScanResultEmpty,
      );
      return;
    }
    _result.qrcode = _qrContent.trim();
    Navigator.pop(context, _result);
  }

  void _resetScan() {
    setState(() {
      _image = null;
      _imageBytes = null;
      _qrContent = "";
      _scanFailed = false;
      _isScanning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (_showSnackBarShowed) {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: SafeArea(
            child: _buildHeader(context),
          ),
        ),
        body: SafeArea(
          child: PlatformUtils.isMobile()
              ? _scanFromFile
                  ? _buildMobileImportView(context)
                  : _buildMobileCameraView(context)
              : _buildDesktopView(context),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top App Bar Header
  // ---------------------------------------------------------------------------
  Widget _buildHeader(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827).withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor.withValues(alpha: isDark ? 0.2 : 0.35),
            width: 0.8,
          ),
        ),
      ),
      child: Row(
        children: [
          // Back Button
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Title
          Expanded(
            child: Text(
              tcontext.meta.qrcodeScan,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15.5,
                letterSpacing: 0.2,
              ),
            ),
          ),

          // Actions
          if (PlatformUtils.isMobile()) ...[
            if (!_scanFromFile)
              IconButton(
                icon: FutureBuilder<bool>(
                  future: getFlashState(),
                  builder: (context, snapshot) {
                    final isOn = snapshot.hasData && snapshot.data == true;
                    return Icon(
                      isOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                      color: isOn ? ThemeDefine.kColorAmber : null,
                      size: 20,
                    );
                  },
                ),
                tooltip: "闪光灯",
                onPressed: () async {
                  try {
                    await controller?.toggleFlash();
                  } catch (err) {
                    DialogUtils.showAlertDialog(
                      context,
                      err.toString(),
                      showCopy: true,
                      showFAQ: true,
                      withVersion: true,
                    );
                  }
                  setState(() {});
                },
              ),
            IconButton(
              icon: Icon(
                _scanFromFile ? Icons.camera_alt_outlined : Icons.photo_library_outlined,
                size: 20,
              ),
              tooltip: _scanFromFile ? "相机扫码" : "相册选图",
              onPressed: () {
                setState(() {
                  _scanFromFile = !_scanFromFile;
                  _resetScan();
                });
              },
            ),
          ] else ...[
            // Desktop: Reset button if content or image loaded
            if (_image != null || _qrContent.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 20),
                tooltip: tcontext.meta.reScan,
                onPressed: _resetScan,
              ),
          ],

          // Done / Import Button in Header
          if (_qrContent.isNotEmpty) ...[
            const SizedBox(width: 4),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeDefine.kColorBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: const Icon(Icons.done_rounded, size: 16),
              label: Text(
                tcontext.meta.save,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              onPressed: _onConfirm,
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Desktop Layout (PC / Windows / macOS / Linux)
  // ---------------------------------------------------------------------------
  Widget _buildDesktopView(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 580),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Quick Action Cards (Screenshot, File Picker, Clipboard)
              _buildActionGrid(context),
              const SizedBox(height: 18),

              // 2. Central Scanner Viewfinder / Drop Zone
              _buildScannerZone(context),
              const SizedBox(height: 18),

              // 3. Scan Result Card (if recognized) or Failure Hint
              if (_qrContent.isNotEmpty)
                _buildResultCard(context)
              else if (_scanFailed && !_isScanning)
                _buildFailureCard(context),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Action Buttons Grid (Desktop & File mode)
  // ---------------------------------------------------------------------------
  Widget _buildActionGrid(BuildContext context) {
    final tcontext = Translations.of(context);
    final isMobile = PlatformUtils.isMobile();

    return Row(
      children: [
        if (!isMobile) ...[
          // Screenshot Button
          Expanded(
            child: _buildActionTile(
              context: context,
              icon: Icons.crop_free_rounded,
              gradientColors: const [Color(0xFF00BCDF), Color(0xFF0284C7)],
              title: tcontext.meta.screenshot,
              subtitle: "截取屏幕二维码",
              onTap: onPressScreenshot,
            ),
          ),
          const SizedBox(width: 12),
        ],

        // Pick Image File Button
        Expanded(
          child: _buildActionTile(
            context: context,
            icon: Icons.image_search_rounded,
            gradientColors: const [Color(0xFF8B5CF6), Color(0xFF6D28D9)],
            title: tcontext.meta.qrcodeScanFromImage,
            subtitle: "选择本地图片",
            onTap: isMobile ? onPressScanFromImageMobile : onPressScanFromImagePC,
          ),
        ),
        const SizedBox(width: 12),

        // Clipboard Button
        Expanded(
          child: _buildActionTile(
            context: context,
            icon: Icons.content_paste_rounded,
            gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
            title: tcontext.meta.qrcodeScanFromClipboard,
            subtitle: "读取剪贴板链接",
            onTap: onPressFromClipboard,
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required List<Color> gradientColors,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: isDark ? const Color(0xFF151D2E) : Colors.white,
      borderRadius: BorderRadius.circular(14),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _isScanning ? null : onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.dividerColor.withValues(alpha: isDark ? 0.25 : 0.4),
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: gradientColors.first.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10.5,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Central Scanner Viewfinder / Drop Zone
  // ---------------------------------------------------------------------------
  Widget _buildScannerZone(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tcontext = Translations.of(context);

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 220),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131A29) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _qrContent.isNotEmpty
              ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.5)
              : theme.dividerColor.withValues(alpha: isDark ? 0.3 : 0.4),
          width: _qrContent.isNotEmpty ? 1.5 : 0.8,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (_image != null) ...[
              // Image Display
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 240),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _image!,
                    ),
                  ),
                ),
              ),

              // Viewfinder Cyan Corner Brackets
              Positioned.fill(
                child: CustomPaint(
                  painter: _QrCornerBracketPainter(
                    cornerColor: _qrContent.isNotEmpty
                        ? ThemeDefine.kColorGreenBright
                        : const Color(0xFF38BDF8),
                  ),
                ),
              ),

              // Status indicator tag on top of image
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isScanning) ...[
                        const SizedBox(
                          width: 12,
                          height: 12,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "正在解析...",
                          style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ] else if (_qrContent.isNotEmpty) ...[
                        const Icon(Icons.check_circle_rounded, color: ThemeDefine.kColorGreenBright, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          tcontext.meta.qrcodeRecognized,
                          style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ] else ...[
                        const Icon(Icons.warning_amber_rounded, color: Color(0xFFF59E0B), size: 14),
                        const SizedBox(width: 4),
                        const Text(
                          "未识别到二维码",
                          style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ] else ...[
              // Standby / Empty Drop Zone
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Radar Scan Graphic
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.15 : 0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ThemeDefine.kColorBlue.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.qr_code_scanner_rounded,
                          size: 34,
                          color: ThemeDefine.kColorBlue,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      tcontext.meta.qrcodeDropHint,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "支持解析各类订阅、节点及配置二维码图片",
                      style: TextStyle(
                        fontSize: 11.5,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Recognition Result Card
  // ---------------------------------------------------------------------------
  Widget _buildResultCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tcontext = Translations.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151D2E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: ThemeDefine.kColorGreenBright.withValues(alpha: 0.35),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeDefine.kColorGreenBright.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Success Icon + Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: ThemeDefine.kColorGreenBright.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: ThemeDefine.kColorGreenBright,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                tcontext.meta.qrcodeRecognized,
                style: const TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: ThemeDefine.kColorGreenBright,
                ),
              ),
              const Spacer(),
              // Re-scan text button
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: _resetScan,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 14,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        tcontext.meta.reScan,
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Monospace Content Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: theme.dividerColor.withValues(alpha: 0.25),
                width: 0.8,
              ),
            ),
            child: SelectableText(
              _qrContent,
              maxLines: 4,
              style: TextStyle(
                fontFamily: "monospace",
                fontSize: 12,
                color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0369A1),
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Primary Actions Row
          Row(
            children: [
              // Copy Button
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: theme.dividerColor.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.copy_rounded, size: 16),
                  label: Text(
                    tcontext.meta.copyUrl,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: _qrContent));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(tcontext.meta.copiedToClipboard),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Confirm / Import Button
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeDefine.kColorBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.file_download_done_rounded, size: 18),
                  label: Text(
                    tcontext.meta.confirmImport,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  onPressed: _onConfirm,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Recognition Failure Hint Card
  // ---------------------------------------------------------------------------
  Widget _buildFailureCard(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tcontext = Translations.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2D1B14) : const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF59E0B),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "未能识别到有效二维码",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFD97706),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  tcontext.meta.qrcodeScanResultFailed,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark ? Colors.white70 : const Color(0xFF92400E),
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Mobile Camera Viewfinder Mode
  // ---------------------------------------------------------------------------
  Widget _buildMobileCameraView(BuildContext context) {
    final tcontext = Translations.of(context);
    final size = MediaQuery.of(context).size;
    final wh = size.width < size.height ? size.width : size.height;
    final scanArea = (wh < 400) ? wh - 40 : 360.0;

    return Stack(
      children: [
        // Camera QR Viewfinder
        Positioned.fill(
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: const Color(0xFF38BDF8),
              borderRadius: 16,
              borderLength: 32,
              borderWidth: 6,
              cutOutSize: scanArea,
            ),
            onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
          ),
        ),

        // Hint Text Banner at Top of scan area
        Positioned(
          top: 24,
          left: 20,
          right: 20,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                "将二维码放入框内即可自动扫描",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ),

        // Bottom Control Actions
        Positioned(
          bottom: 30,
          left: 20,
          right: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Flash Button
              _buildMobileCircleButton(
                icon: Icons.flash_on_rounded,
                label: "闪光灯",
                onTap: () async {
                  await controller?.toggleFlash();
                  setState(() {});
                },
              ),
              // Album Import Button
              _buildMobileCircleButton(
                icon: Icons.photo_library_rounded,
                label: tcontext.meta.qrcodeScanFromImage,
                onTap: () {
                  setState(() {
                    _scanFromFile = true;
                  });
                },
              ),
              // Clipboard Button
              _buildMobileCircleButton(
                icon: Icons.content_paste_rounded,
                label: tcontext.meta.qrcodeScanFromClipboard,
                onTap: onPressFromClipboard,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileCircleButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            shadows: [
              Shadow(color: Colors.black87, blurRadius: 4),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Mobile Import View (File / Gallery)
  // ---------------------------------------------------------------------------
  Widget _buildMobileImportView(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildActionGrid(context),
          const SizedBox(height: 16),
          _buildScannerZone(context),
          const SizedBox(height: 16),
          if (_qrContent.isNotEmpty)
            _buildResultCard(context)
          else if (_scanFailed && !_isScanning)
            _buildFailureCard(context),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Camera & Scan Handlers
  // ---------------------------------------------------------------------------
  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    setState(() {});
    controller.scannedDataStream.listen((scanData) {
      if (scanData.format != BarcodeFormat.qrcode) {
        return;
      }
      controller.pauseCamera();
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      result = scanData;
      _qrContent = result?.code ?? "";
      if (_qrContent.isNotEmpty) {
        _onConfirm();
      }
      setState(() {});
    });
  }

  void _onPermissionSet(
    BuildContext context,
    QRViewController ctrl,
    bool p,
  ) async {
    if (!p) {
      if (!mounted) return;
      if (_showSnackBarShowed) return;
      _showSnackBarShowed = true;
      final tcontext = Translations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          showCloseIcon: true,
          content: Text(
            tcontext.permission.requestNeed(p: tcontext.permission.camera),
          ),
        ),
      );
    }
  }

  Future<bool> getFlashState() async {
    if (controller == null) return false;
    try {
      final ret = await controller!.getFlashStatus();
      return ret == true;
    } catch (err) {
      return false;
    }
  }

  // ---------------------------------------------------------------------------
  // From Clipboard
  // ---------------------------------------------------------------------------
  Future<void> onPressFromClipboard() async {
    final tcontext = Translations.of(context);
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      final text = clipboardData?.text?.trim() ?? "";
      if (text.isNotEmpty) {
        setState(() {
          _qrContent = text;
          _image = null;
          _imageBytes = null;
          _scanFailed = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(tcontext.meta.qrcodeRecognized),
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        DialogUtils.showAlertDialog(
          context,
          tcontext.meta.qrcodeScanResultEmpty,
        );
      }
    } catch (err) {
      if (!mounted) return;
      DialogUtils.showAlertDialog(
        context,
        err.toString(),
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Mobile Gallery Scan
  // ---------------------------------------------------------------------------
  Future<void> onPressScanFromImageMobile() async {
    if (Platform.isAndroid) {
      return await onPressScanFromImagePC();
    }
    try {
      _resetScan();
      final ImagePicker picker = ImagePicker();
      final XFile? result = await picker.pickImage(source: ImageSource.gallery);

      if ((result != null) && result.path.isNotEmpty) {
        final filePath = result.path;
        final file = File(filePath);
        if (await file.exists()) {
          _image = Image.file(file);
          _isScanning = true;
        }
        if (!mounted) return;
        setState(() {});

        final qrcode = await QrcodeUtils.scanFromFile(filePath);
        if (!mounted) return;
        setState(() {
          _isScanning = false;
          if (qrcode == null || qrcode.isEmpty) {
            _scanFailed = true;
          } else {
            _qrContent = qrcode;
            _scanFailed = false;
          }
        });
      }
    } catch (err) {
      if (!mounted) return;
      setState(() => _isScanning = false);
      DialogUtils.showAlertDialog(
        context,
        err.toString(),
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // PC File Scan
  // ---------------------------------------------------------------------------
  Future<void> onPressScanFromImagePC() async {
    final tcontext = Translations.of(context);
    _resetScan();

    try {
      final List<String> extensions = ['png', 'jpg', 'jpeg', 'bmp', 'webp'];
      final FilePickerResult? result = await FilePicker.pickFiles(
        type: Platform.isAndroid ? FileType.any : FileType.custom,
        allowedExtensions: Platform.isAndroid ? null : extensions,
      );
      if (result != null && result.files.isNotEmpty) {
        final ext = path
            .extension(result.files.first.name)
            .replaceAll('.', '')
            .toLowerCase();
        if (!Platform.isAndroid && !extensions.contains(ext)) {
          DialogUtils.showAlertDialog(
            context,
            tcontext.meta.fileTypeInvalid(p: ext),
          );
          return;
        }
        final filePath = result.files.first.path!;
        final file = File(filePath);
        if (await file.exists()) {
          _image = Image.file(file);
          _isScanning = true;
        }
        setState(() {});

        final qrcode = await QrcodeUtils.scanFromFile(filePath);
        if (mounted) {
          setState(() {
            _isScanning = false;
            if (qrcode == null || qrcode.isEmpty) {
              _scanFailed = true;
            } else {
              _qrContent = qrcode;
              _scanFailed = false;
            }
          });
        }
      }
    } catch (err) {
      if (!mounted) return;
      setState(() => _isScanning = false);
      DialogUtils.showAlertDialog(
        context,
        err.toString(),
        showCopy: true,
        showFAQ: true,
        withVersion: true,
      );
    }
  }

  // ---------------------------------------------------------------------------
  // PC Screenshot Scan
  // ---------------------------------------------------------------------------
  Future<void> onPressScreenshot() async {
    final tcontext = Translations.of(context);
    _resetScan();

    if (Platform.isMacOS) {
      final bool allowed = await ScreenCapturer.instance.isAccessAllowed();
      if (!allowed) {
        DialogUtils.showAlertDialog(
          context,
          tcontext.permission.requestNeed(p: tcontext.permission.screen),
        );
        ScreenCapturer.instance.requestAccess(onlyOpenPrefPane: true);
        return;
      }
    }

    CapturedData? capturedData;
    try {
      capturedData = await ScreenCapturer.instance.capture(
        mode: CaptureMode.region,
        copyToClipboard: true,
      );
    } catch (_) {}

    if (capturedData != null && capturedData.imageBytes != null) {
      _imageBytes = capturedData.imageBytes;
      _image = Image.memory(_imageBytes!);
      _isScanning = true;
      setState(() {});

      try {
        final qrcode = await QrcodeUtils.scanFromImageData(_imageBytes!);
        if (mounted) {
          setState(() {
            _isScanning = false;
            if (qrcode == null || qrcode.isEmpty) {
              _scanFailed = true;
            } else {
              _qrContent = qrcode;
              _scanFailed = false;
            }
          });
        }
      } catch (err) {
        if (mounted) {
          setState(() => _isScanning = false);
          DialogUtils.showAlertDialog(
            context,
            err.toString(),
            showCopy: true,
            showFAQ: true,
            withVersion: true,
          );
        }
      }
    }
  }
}

// -----------------------------------------------------------------------------
// Viewfinder 4-Corner Bracket Painter
// -----------------------------------------------------------------------------
class _QrCornerBracketPainter extends CustomPainter {
  final Color cornerColor;

  const _QrCornerBracketPainter({
    required this.cornerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = cornerColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const double pad = 12.0;
    const double l = 24.0;

    // Top-Left
    canvas.drawLine(const Offset(pad, pad + l), const Offset(pad, pad), paint);
    canvas.drawLine(const Offset(pad, pad), const Offset(pad + l, pad), paint);

    // Top-Right
    canvas.drawLine(Offset(size.width - pad - l, pad), Offset(size.width - pad, pad), paint);
    canvas.drawLine(Offset(size.width - pad, pad), Offset(size.width - pad, pad + l), paint);

    // Bottom-Left
    canvas.drawLine(Offset(pad, size.height - pad - l), Offset(pad, size.height - pad), paint);
    canvas.drawLine(Offset(pad, size.height - pad), Offset(pad + l, size.height - pad), paint);

    // Bottom-Right
    canvas.drawLine(Offset(size.width - pad - l, size.height - pad), Offset(size.width - pad, size.height - pad), paint);
    canvas.drawLine(Offset(size.width - pad, size.height - pad), Offset(size.width - pad, size.height - pad - l), paint);
  }

  @override
  bool shouldRepaint(covariant _QrCornerBracketPainter oldDelegate) {
    return oldDelegate.cornerColor != cornerColor;
  }
}

