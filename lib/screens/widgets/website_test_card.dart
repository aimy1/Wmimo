import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';

class WebsiteTarget {
  final String id;
  final String name;
  final String url;
  final IconData? icon;
  final Color? color;
  int? latency;
  bool isTesting;

  WebsiteTarget({
    required this.id,
    required this.name,
    required this.url,
    this.icon,
    this.color,
    this.latency,
    this.isTesting = false,
  });
}

class WebsiteTestCard extends StatefulWidget {
  final int? mixedPort;

  const WebsiteTestCard({
    super.key,
    this.mixedPort,
  });

  @override
  State<WebsiteTestCard> createState() => _WebsiteTestCardState();
}

class _WebsiteTestCardState extends State<WebsiteTestCard> {
  late final List<WebsiteTarget> _targets;
  bool _isTestingAll = false;

  @override
  void initState() {
    super.initState();
    _targets = [
      WebsiteTarget(
        id: 'apple',
        name: 'Apple',
        url: 'https://captive.apple.com/hotspot-detect.html',
        icon: Icons.apple,
      ),
      WebsiteTarget(
        id: 'github',
        name: 'GitHub',
        url: 'https://github.com',
        icon: Icons.code_rounded,
      ),
      WebsiteTarget(
        id: 'google',
        name: 'Google',
        url: 'https://www.google.com/generate_204',
        icon: Icons.travel_explore_rounded,
        color: const Color(0xFF4285F4),
      ),
      WebsiteTarget(
        id: 'youtube',
        name: 'YouTube',
        url: 'https://www.youtube.com/generate_204',
        icon: Icons.play_arrow_rounded,
        color: const Color(0xFFFF0000),
      ),
    ];
  }

  int? get _effectivePort => widget.mixedPort ?? ClashSettingManager.getMixedPort();

  Future<void> _testTarget(WebsiteTarget target) async {
    if (!mounted || target.isTesting) return;
    setState(() {
      target.isTesting = true;
    });

    final port = _effectivePort;
    final latency = await _measureLatency(target.url, port);

    if (!mounted) return;
    setState(() {
      target.isTesting = false;
      target.latency = latency;
    });
  }

  Future<void> _testAllTargets() async {
    if (_isTestingAll || !mounted) return;
    HapticFeedback.selectionClick();
    setState(() {
      _isTestingAll = true;
      for (final t in _targets) {
        t.isTesting = true;
      }
    });

    final port = _effectivePort;
    await Future.wait(_targets.map((t) async {
      final latency = await _measureLatency(t.url, port);
      if (mounted) {
        setState(() {
          t.isTesting = false;
          t.latency = latency;
        });
      }
    }));

    if (mounted) {
      setState(() {
        _isTestingAll = false;
      });
    }
  }

  static Future<int> _measureLatency(String url, int? proxyPort) async {
    final sw = Stopwatch()..start();
    HttpClient? client;
    try {
      client = HttpClient();
      client.connectionTimeout = const Duration(seconds: 4);
      if (proxyPort != null && proxyPort > 0) {
        client.findProxy = (uri) => 'PROXY 127.0.0.1:$proxyPort';
      } else {
        client.findProxy = (uri) => 'DIRECT';
      }

      final uri = Uri.parse(url);
      final req = await client.getUrl(uri).timeout(const Duration(seconds: 4));
      req.headers.set(HttpHeaders.userAgentHeader, 'Wmimo/1.0');
      final resp = await req.close().timeout(const Duration(seconds: 4));
      sw.stop();
      if (resp.statusCode >= 200 && resp.statusCode < 400) {
        return sw.elapsedMilliseconds;
      }
      return -1;
    } catch (_) {
      return -1;
    } finally {
      client?.close(force: true);
    }
  }

  void _showAddTargetDialog() {
    final nameController = TextEditingController();
    final urlController = TextEditingController(text: 'https://');
    final tcontext = Translations.of(context);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            tcontext.meta.addTestWebsite,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: tcontext.meta.websiteNameHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: tcontext.meta.websiteUrl,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(tcontext.meta.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ThemeDefine.kColorBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                final name = nameController.text.trim();
                final url = urlController.text.trim();
                if (name.isNotEmpty && url.startsWith('http')) {
                  setState(() {
                    _targets.add(
                      WebsiteTarget(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        name: name,
                        url: url,
                        icon: Icons.public_rounded,
                        color: ThemeDefine.kColorBlue,
                      ),
                    );
                  });
                  Navigator.pop(ctx);
                }
              },
              child: Text(tcontext.meta.ok),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBrandLogo(WebsiteTarget target, bool isDark) {
    if (target.id == 'apple') {
      return Icon(
        Icons.apple,
        size: 26,
        color: isDark ? Colors.white : Colors.black87,
      );
    }
    if (target.id == 'github') {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: isDark ? Colors.white24 : Colors.black87,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.code_rounded,
          size: 16,
          color: isDark ? Colors.white : Colors.white,
        ),
      );
    }
    if (target.id == 'google') {
      return Container(
        width: 26,
        height: 26,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Text(
          'G',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFF4285F4),
            fontFamily: 'Roboto',
          ),
        ),
      );
    }
    if (target.id == 'youtube') {
      return Container(
        width: 28,
        height: 20,
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          size: 16,
          color: Colors.white,
        ),
      );
    }

    return Icon(
      target.icon ?? Icons.public_rounded,
      size: 24,
      color: target.color ?? ThemeDefine.kColorBlue,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final innerBgColor = isDark
        ? ThemeDefine.kColorDarkInner
        : const Color(0xFFF1F5F9);
    final innerBorderColor = isDark
        ? ThemeDefine.kColorDarkBorder
        : const Color(0xFFE2E8F0);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Header (matches IP Info header)
            Row(
              children: [
                const Icon(
                  Icons.wifi_tethering_rounded,
                  size: 20,
                  color: ThemeDefine.kColorBlue,
                ),
                const SizedBox(width: 7),
                Text(
                  tcontext.meta.websiteTest,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                // Test All Icon Button
                Tooltip(
                  message: tcontext.meta.testAll,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(7),
                    onTap: _isTestingAll ? null : _testAllTargets,
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? ThemeDefine.kColorDarkElevated
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: _isTestingAll
                          ? SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.8,
                                color: theme.colorScheme.primary,
                              ),
                            )
                          : const Icon(
                              Icons.bolt_rounded,
                              size: 15,
                              color: ThemeDefine.kColorBlue,
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Add Target Button
                Tooltip(
                  message: tcontext.meta.addWebsite,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(7),
                    onTap: _showAddTargetDialog,
                    child: Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark
                            ? ThemeDefine.kColorDarkElevated
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 2. Content Grid / Row of Targets (matching Clash Verge style)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: innerBgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: innerBorderColor, width: 0.8),
              ),
              child: Row(
                children: _targets.map((target) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Material(
                        color: isDark
                            ? const Color(0xFF1E1E22)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => _testTarget(target),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.dividerColor.withValues(alpha: 0.2),
                                width: 0.8,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Logo
                                Container(
                                  height: 28,
                                  alignment: Alignment.center,
                                  child: _buildBrandLogo(target, isDark),
                                ),
                                const SizedBox(height: 5),
                                // Name
                                Text(
                                  target.name,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                // Action / Latency Badge
                                _buildLatencyBadge(target, tcontext),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLatencyBadge(WebsiteTarget target, Translations tcontext) {
    if (target.isTesting) {
      return const SizedBox(
        height: 16,
        child: Center(
          child: SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 1.5,
              color: ThemeDefine.kColorBlue,
            ),
          ),
        ),
      );
    }

    if (target.latency == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
        decoration: BoxDecoration(
          color: ThemeDefine.kColorBlue.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          tcontext.meta.test,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: ThemeDefine.kColorBlue,
          ),
        ),
      );
    }

    if (target.latency! < 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
        decoration: BoxDecoration(
          color: Colors.redAccent.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          tcontext.meta.timeout,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.redAccent,
          ),
        ),
      );
    }

    Color badgeColor = ThemeDefine.kColorGreenBright;
    if (target.latency! > 800) {
      badgeColor = Colors.orange;
    } else if (target.latency! > 300) {
      badgeColor = Colors.lightGreen;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${target.latency} ms',
        style: TextStyle(
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
          color: badgeColor,
          fontFamily: 'monospace',
        ),
        maxLines: 1,
      ),
    );
  }
}
