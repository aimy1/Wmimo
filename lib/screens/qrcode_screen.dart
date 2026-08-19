// ignore_for_file: empty_catches, use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';
import 'package:wmimo/app/utils/file_utils.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/app/utils/qrcode_utils.dart';
import 'package:wmimo/app/utils/url_launcher_utils.dart';
import 'package:wmimo/app/utils/windows_version_helper.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';

class QrcodeScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "QrcodeScreen");
  }

  final String title;
  final String content;
  final void Function()? callback;
  const QrcodeScreen({
    super.key,
    this.title = "",
    required this.content,
    this.callback,
  });

  @override
  State<QrcodeScreen> createState() => _QrcodeScreenState();
}

class _QrcodeScreenState extends LasyRenderingState<QrcodeScreen> {
  String _content = "";
  Image? _image;
  Uri? _url;

  @override
  void initState() {
    super.initState();
    _content = widget.content;
    _image = QrcodeUtils.toImage(_content).data;

    if (_content.startsWith("http://") || _content.startsWith("https://")) {
      _url = Uri.tryParse(_content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 36,
                        height: 30,
                        child: Icon(Icons.arrow_back_ios_outlined, size: 22),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.title.isEmpty
                            ? tcontext.meta.qrcode
                            : widget.title,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 36),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Content Body (Scrollable to prevent any overflow)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // QR Code Container
                          Container(
                            width: 240,
                            height: 240,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : const Color(0xFFE2E8F0),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: _image ??
                                  Text(
                                    tcontext.meta.qrcodeTooLong,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: Colors.redAccent,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Text Content Box
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.dividerColor.withValues(alpha: 0.3),
                                width: 0.8,
                              ),
                            ),
                            child: SelectableText(
                              _content,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 11.5,
                                fontFamily: 'monospace',
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.75),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Copy Button
                          SizedBox(
                            width: double.infinity,
                            height: 42,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ThemeDefine.kColorBlue,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              icon: const Icon(Icons.copy_rounded, size: 18),
                              label: Text(
                                tcontext.meta.copyUrl,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              onPressed: () async {
                                try {
                                  await Clipboard.setData(
                                    ClipboardData(text: _content),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("已复制到剪贴板"),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } catch (_) {}
                              },
                            ),
                          ),

                          // Open in Browser Button
                          if (_url != null) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 42,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: theme.dividerColor.withValues(alpha: 0.4),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.open_in_browser_rounded, size: 18),
                                label: Text(
                                  tcontext.meta.openUrl,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onPressed: () async {
                                  if (widget.callback != null) {
                                    widget.callback!();
                                  } else {
                                    await UrlLauncherUtils.loadUrl(_content);
                                  }
                                },
                              ),
                            ),
                          ],

                          // Share / Save Image Button
                          if (_image != null &&
                              (!Platform.isWindows ||
                                  (Platform.isWindows &&
                                      VersionHelper.instance.isWindows10RS5OrGreater))) ...[
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              height: 42,
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: theme.dividerColor.withValues(alpha: 0.4),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: const Icon(Icons.share_rounded, size: 18),
                                label: Text(
                                  tcontext.meta.qrcodeShare,
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onPressed: () async {
                                  String savePath = path.join(
                                    await PathUtils.cacheDir(),
                                    'qrcode_share.png',
                                  );
                                  await FileUtils.deletePath(savePath);
                                  await QrcodeUtils.saveAsImage(
                                    _content,
                                    savePath,
                                  );
                                  if (!context.mounted) return;
                                  try {
                                    final box = context.findRenderObject() as RenderBox?;
                                    final rect = box != null
                                        ? box.localToGlobal(Offset.zero) & box.size
                                        : null;
                                    await SharePlus.instance.share(
                                      ShareParams(
                                        files: [XFile(savePath)],
                                        sharePositionOrigin: rect,
                                      ),
                                    );
                                  } catch (err) {
                                    if (!context.mounted) return;
                                    DialogUtils.showAlertDialog(
                                      context,
                                      err.toString(),
                                      showCopy: true,
                                      showFAQ: true,
                                      withVersion: true,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
