import 'dart:async';
import 'dart:io';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_define.dart';

class WebsiteTarget {
  final String id;
  String name;
  String url;
  String? iconUrl;
  IconData? icon;
  Color? color;
  int? latency;
  bool isTesting;

  WebsiteTarget({
    required this.id,
    required this.name,
    required this.url,
    this.iconUrl,
    this.icon,
    this.color,
    this.latency,
    this.isTesting = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'icon_url': iconUrl,
  };

  factory WebsiteTarget.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString();
    final name = json['name']?.toString() ?? '';
    final url = json['url']?.toString() ?? '';
    final iconUrl = json['icon_url']?.toString();
    final match = matchBrand(name, url);
    return WebsiteTarget(
      id: id,
      name: name,
      url: url,
      iconUrl: iconUrl,
      icon: match.icon,
      color: match.color,
    );
  }

  String get effectiveIconUrl {
    if (iconUrl != null && iconUrl!.trim().isNotEmpty) {
      return iconUrl!.trim();
    }
    final uri = Uri.tryParse(url);
    if (uri != null && uri.host.isNotEmpty) {
      return 'https://www.google.com/s2/favicons?domain=${uri.host}&sz=64';
    }
    return '';
  }

  static ({IconData icon, Color? color}) matchBrand(String name, String url) {
    final lowerName = name.toLowerCase();
    final uri = Uri.tryParse(url);
    final host = uri?.host.toLowerCase() ?? url.toLowerCase();

    if (host.contains('apple.com') || lowerName == 'apple') {
      return (icon: Icons.apple, color: null);
    }
    if (host.contains('github.com') || lowerName == 'github') {
      return (icon: Icons.code_rounded, color: null);
    }
    if (host.contains('google.') || lowerName == 'google') {
      return (icon: Icons.travel_explore_rounded, color: const Color(0xFF4285F4));
    }
    if (host.contains('youtube.com') || lowerName == 'youtube') {
      return (icon: Icons.play_arrow_rounded, color: const Color(0xFFFF0000));
    }
    // Check Netflix before Twitter/x.com to prevent "netflix.com" matching "x.com" substring
    if (host.contains('netflix.com') || lowerName.contains('netflix')) {
      return (icon: Icons.movie_rounded, color: const Color(0xFFE50914));
    }
    if (host.contains('bilibili.com') || lowerName.contains('bilibili')) {
      return (icon: Icons.tv_rounded, color: const Color(0xFF00AEEC));
    }
    if (host.contains('baidu.com') || lowerName.contains('baidu')) {
      return (icon: Icons.search_rounded, color: const Color(0xFF2932E1));
    }
    if (host == 'x.com' || host == 'twitter.com' || host.endsWith('.x.com') || host.endsWith('.twitter.com') || lowerName == 'twitter' || lowerName == 'x') {
      return (icon: Icons.close_rounded, color: null);
    }
    if (host.contains('t.me') || host.contains('telegram') || lowerName.contains('telegram')) {
      return (icon: Icons.send_rounded, color: const Color(0xFF0088CC));
    }
    if (host.contains('chatgpt.com') || host.contains('openai.com') || lowerName.contains('chatgpt') || lowerName.contains('openai')) {
      return (icon: Icons.smart_toy_rounded, color: const Color(0xFF10A37F));
    }
    if (host.contains('cloudflare.com') || host.contains('1.1.1.1') || lowerName.contains('cloudflare')) {
      return (icon: Icons.cloud_rounded, color: const Color(0xFFF38020));
    }
    return (icon: Icons.public_rounded, color: ThemeDefine.kColorBlue);
  }

  static List<WebsiteTarget> getDefaultTargets() {
    return [
      WebsiteTarget(
        id: 'apple',
        name: 'Apple',
        url: 'https://captive.apple.com/hotspot-detect.html',
        iconUrl: '',
        icon: Icons.apple,
      ),
      WebsiteTarget(
        id: 'github',
        name: 'GitHub',
        url: 'https://github.com',
        iconUrl: '',
        icon: Icons.code_rounded,
      ),
      WebsiteTarget(
        id: 'google',
        name: 'Google',
        url: 'https://www.google.com/generate_204',
        iconUrl: '',
        icon: Icons.travel_explore_rounded,
        color: const Color(0xFF4285F4),
      ),
      WebsiteTarget(
        id: 'youtube',
        name: 'YouTube',
        url: 'https://www.youtube.com/generate_204',
        iconUrl: '',
        icon: Icons.play_arrow_rounded,
        color: const Color(0xFFFF0000),
      ),
    ];
  }
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
  static const int kMaxWebsiteTargets = 6;
  late List<WebsiteTarget> _targets;
  bool _isTestingAll = false;
  Offset _lastTapPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _loadTargets();
  }

  void _loadTargets() {
    final saved = SettingManager.getConfig().websiteTestTargets;
    if (saved != null && saved.isNotEmpty) {
      _targets = saved.map((m) => WebsiteTarget.fromJson(m)).take(kMaxWebsiteTargets).toList();
    } else {
      _targets = WebsiteTarget.getDefaultTargets().take(kMaxWebsiteTargets).toList();
    }
  }

  Future<void> _saveTargets() async {
    final list = _targets.map((t) => t.toJson()).toList();
    SettingManager.getConfig().websiteTestTargets = list;
    await SettingManager.save();
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
    if (_isTestingAll || !mounted || _targets.isEmpty) return;
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

  void _showContextMenu(WebsiteTarget target, Offset globalPosition) async {
    HapticFeedback.mediumImpact();
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final RenderBox? overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    final overlaySize = overlay?.size ?? MediaQuery.of(context).size;
    final pos = globalPosition == Offset.zero
        ? Offset(overlaySize.width / 2, overlaySize.height / 2)
        : globalPosition;

    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(pos.dx, pos.dy, 0, 0),
        Offset.zero & overlaySize,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? const Color(0xFF232328) : Colors.white,
      elevation: 8,
      items: [
        PopupMenuItem<String>(
          value: 'test',
          height: 38,
          child: Row(
            children: [
              const Icon(Icons.bolt_rounded, size: 18, color: ThemeDefine.kColorBlue),
              const SizedBox(width: 9),
              Text(
                tcontext.meta.test,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'edit',
          height: 38,
          child: Row(
            children: [
              Icon(
                Icons.edit_outlined,
                size: 17,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
              ),
              const SizedBox(width: 9),
              Text(
                tcontext.meta.edit,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'delete',
          height: 38,
          child: Row(
            children: [
              const Icon(Icons.delete_outline_rounded, size: 17, color: Colors.redAccent),
              const SizedBox(width: 9),
              Text(
                tcontext.meta.remove,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    if (!mounted || selected == null) return;
    if (selected == 'test') {
      _testTarget(target);
    } else if (selected == 'edit') {
      _showEditTargetDialog(target);
    } else if (selected == 'delete') {
      _showDeleteTargetDialog(target);
    }
  }

  void _showAddTargetDialog() {
    final tcontext = Translations.of(context);
    if (_targets.length >= kMaxWebsiteTargets) {
      DialogUtils.showAlertDialog(
        context,
        tcontext.meta.maxWebsitesReached,
        showCopy: false,
        showFAQ: false,
      );
      return;
    }
    final nameController = TextEditingController();
    final urlController = TextEditingController(text: 'https://');
    final iconController = TextEditingController();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final presets = [
      (name: 'Google', url: 'https://www.google.com/generate_204', iconUrl: ''),
      (name: 'YouTube', url: 'https://www.youtube.com/generate_204', iconUrl: ''),
      (name: 'GitHub', url: 'https://github.com', iconUrl: ''),
      (name: 'Apple', url: 'https://captive.apple.com/hotspot-detect.html', iconUrl: ''),
      (name: 'Bilibili', url: 'https://www.bilibili.com', iconUrl: ''),
      (name: 'Baidu', url: 'https://www.baidu.com', iconUrl: ''),
      (name: 'ChatGPT', url: 'https://chatgpt.com', iconUrl: ''),
      (name: 'Telegram', url: 'https://t.me', iconUrl: ''),
      (name: 'Netflix', url: 'https://www.netflix.com', iconUrl: ''),
      (name: 'X', url: 'https://x.com', iconUrl: ''),
      (name: 'Cloudflare', url: 'https://1.1.1.1', iconUrl: ''),
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final previewTarget = WebsiteTarget(
              id: 'preview',
              name: nameController.text.trim(),
              url: urlController.text.trim(),
              iconUrl: iconController.text.trim(),
            );

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark ? ThemeDefine.kColorDarkInner : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: _buildBrandLogo(previewTarget, isDark),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    tcontext.meta.addTestWebsite,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SizedBox(
                width: 360,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick Presets
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: presets.map((p) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              setDialogState(() {
                                nameController.text = p.name;
                                urlController.text = p.url;
                                iconController.text = p.iconUrl;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: isDark ? ThemeDefine.kColorDarkElevated : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: theme.dividerColor.withValues(alpha: 0.25),
                                  width: 0.6,
                                ),
                              ),
                              child: Text(
                                p.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: nameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: tcontext.meta.websiteNameHint,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                        ),
                        onChanged: (_) => setDialogState(() {}),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: urlController,
                        decoration: InputDecoration(
                          labelText: tcontext.meta.websiteUrl,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                        ),
                        onChanged: (_) => setDialogState(() {}),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: iconController,
                        decoration: InputDecoration(
                          labelText: "图标地址 (留空自动获取 Favicon)",
                          hintText: "https://.../favicon.ico",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                        ),
                        onChanged: (_) => setDialogState(() {}),
                      ),
                    ],
                  ),
                ),
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
                    final customIcon = iconController.text.trim();
                    if (name.isNotEmpty && url.startsWith('http')) {
                      if (_targets.length >= kMaxWebsiteTargets) {
                        Navigator.pop(ctx);
                        return;
                      }
                      final match = WebsiteTarget.matchBrand(name, url);
                      setState(() {
                        _targets.add(
                          WebsiteTarget(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            name: name,
                            url: url,
                            iconUrl: customIcon.isNotEmpty ? customIcon : null,
                            icon: match.icon,
                            color: match.color,
                          ),
                        );
                      });
                      _saveTargets();
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(tcontext.meta.ok),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditTargetDialog(WebsiteTarget target) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final nameController = TextEditingController(text: target.name);
    final urlController = TextEditingController(text: target.url);
    final iconController = TextEditingController(text: target.iconUrl ?? '');

    final presets = [
      (name: 'Google', url: 'https://www.google.com/generate_204', iconUrl: ''),
      (name: 'YouTube', url: 'https://www.youtube.com/generate_204', iconUrl: ''),
      (name: 'GitHub', url: 'https://github.com', iconUrl: ''),
      (name: 'Apple', url: 'https://captive.apple.com/hotspot-detect.html', iconUrl: ''),
      (name: 'Bilibili', url: 'https://www.bilibili.com', iconUrl: ''),
      (name: 'Baidu', url: 'https://www.baidu.com', iconUrl: ''),
      (name: 'ChatGPT', url: 'https://chatgpt.com', iconUrl: ''),
      (name: 'Telegram', url: 'https://t.me', iconUrl: ''),
      (name: 'Netflix', url: 'https://www.netflix.com', iconUrl: ''),
      (name: 'X', url: 'https://x.com', iconUrl: ''),
      (name: 'Cloudflare', url: 'https://1.1.1.1', iconUrl: ''),
    ];

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final previewTarget = WebsiteTarget(
              id: target.id,
              name: nameController.text.trim(),
              url: urlController.text.trim(),
              iconUrl: iconController.text.trim(),
            );

            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark ? ThemeDefine.kColorDarkInner : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: _buildBrandLogo(previewTarget, isDark),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${tcontext.meta.edit} - ${target.name}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SizedBox(
                width: 360,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: presets.map((p) {
                          return InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              setDialogState(() {
                                nameController.text = p.name;
                                urlController.text = p.url;
                                iconController.text = p.iconUrl;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3.5),
                              decoration: BoxDecoration(
                                color: isDark ? ThemeDefine.kColorDarkElevated : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: theme.dividerColor.withValues(alpha: 0.25),
                                  width: 0.6,
                                ),
                              ),
                              child: Text(
                                p.name,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 14),

                      TextField(
                        controller: nameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          labelText: tcontext.meta.websiteNameHint,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                        ),
                        onChanged: (_) => setDialogState(() {}),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: urlController,
                        decoration: InputDecoration(
                          labelText: tcontext.meta.websiteUrl,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                        ),
                        onChanged: (_) => setDialogState(() {}),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: iconController,
                        decoration: InputDecoration(
                          labelText: "图标地址 (留空自动获取 Favicon)",
                          hintText: "https://.../favicon.ico",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                          isDense: true,
                        ),
                        onChanged: (_) => setDialogState(() {}),
                      ),
                    ],
                  ),
                ),
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
                    final customIcon = iconController.text.trim();
                    if (name.isNotEmpty && url.startsWith('http')) {
                      setState(() {
                        target.name = name;
                        target.url = url;
                        target.iconUrl = customIcon.isNotEmpty ? customIcon : null;
                        target.latency = null;
                        final match = WebsiteTarget.matchBrand(name, url);
                        target.icon = match.icon;
                        target.color = match.color;
                      });
                      _saveTargets();
                      Navigator.pop(ctx);
                    }
                  },
                  child: Text(tcontext.meta.ok),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showDeleteTargetDialog(WebsiteTarget target) {
    final tcontext = Translations.of(context);
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 22),
              const SizedBox(width: 8),
              Text(
                tcontext.meta.removeConfirm,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Text(
            "${target.name}\n${target.url}",
            style: const TextStyle(fontSize: 13, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(tcontext.meta.cancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                setState(() {
                  _targets.removeWhere((t) => t.id == target.id);
                });
                _saveTargets();
                Navigator.pop(ctx);
              },
              child: Text(tcontext.meta.remove),
            ),
          ],
        );
      },
    );
  }

  bool _isKnownBrand(WebsiteTarget target) {
    final lowerName = target.name.toLowerCase();
    final uri = Uri.tryParse(target.url);
    final host = uri?.host.toLowerCase() ?? target.url.toLowerCase();

    return host.contains('apple.com') || lowerName == 'apple' || target.id == 'apple' ||
        host.contains('github.com') || lowerName == 'github' || target.id == 'github' ||
        host.contains('google.') || lowerName == 'google' || target.id == 'google' ||
        host.contains('youtube.com') || lowerName == 'youtube' || target.id == 'youtube' ||
        host.contains('netflix.com') || lowerName.contains('netflix') ||
        host.contains('bilibili.com') || lowerName.contains('bilibili') ||
        host.contains('baidu.com') || lowerName.contains('baidu') ||
        host == 'x.com' || host == 'twitter.com' || host.endsWith('.x.com') || host.endsWith('.twitter.com') || lowerName == 'twitter' || lowerName == 'x' ||
        host.contains('t.me') || host.contains('telegram') || lowerName.contains('telegram') ||
        host.contains('chatgpt.com') || host.contains('openai.com') || lowerName.contains('chatgpt') || lowerName.contains('openai') ||
        host.contains('cloudflare.com') || host.contains('1.1.1.1') || lowerName.contains('cloudflare');
  }

  Widget _buildBrandLogo(WebsiteTarget target, bool isDark) {
    final customUrl = target.iconUrl?.trim() ?? '';
    final hasUserCustomIcon = customUrl.isNotEmpty && !customUrl.contains('google.com/s2/favicons');

    // 1. If user provided an explicit custom image URL, load it
    if (hasUserCustomIcon) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: FastCachedImage(
          url: customUrl,
          width: 24,
          height: 24,
          cacheWidth: 64,
          cacheHeight: 64,
          fit: BoxFit.contain,
          fadeInDuration: const Duration(milliseconds: 100),
          loadingBuilder: (context, progress) => _buildBrandFallback(target, isDark),
          errorBuilder: (context, error, stackTrace) => _buildBrandFallback(target, isDark),
        ),
      );
    }

    // 2. For known presets/brands, use native pixel-perfect vector logo (100% offline & robust in all regions)
    if (_isKnownBrand(target)) {
      return _buildBrandFallback(target, isDark);
    }

    // 3. For custom websites, try fetching favicon from network with fallback
    final iconUrl = target.effectiveIconUrl;
    if (iconUrl.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: FastCachedImage(
          url: iconUrl,
          width: 24,
          height: 24,
          cacheWidth: 64,
          cacheHeight: 64,
          fit: BoxFit.contain,
          fadeInDuration: const Duration(milliseconds: 100),
          loadingBuilder: (context, progress) => _buildBrandFallback(target, isDark),
          errorBuilder: (context, error, stackTrace) => _buildBrandFallback(target, isDark),
        ),
      );
    }

    return _buildBrandFallback(target, isDark);
  }

  Widget _buildBrandFallback(WebsiteTarget target, bool isDark) {
    final lowerName = target.name.toLowerCase();
    final lowerUrl = target.url.toLowerCase();
    final uri = Uri.tryParse(target.url);
    final host = uri?.host.toLowerCase() ?? lowerUrl;

    // 1. Apple: Official crisp monochrome vector
    if (host.contains('apple.com') || lowerName == 'apple' || target.id == 'apple') {
      return Icon(
        Icons.apple,
        size: 26,
        color: isDark ? Colors.white : Colors.black87,
      );
    }

    // 2. GitHub: Official Invertocat silhouette
    if (host.contains('github.com') || lowerName == 'github' || target.id == 'github') {
      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? Colors.white : const Color(0xFF24292F),
          shape: BoxShape.circle,
        ),
        child: CustomPaint(
          size: const Size(16, 16),
          painter: _GithubLogoPainter(
            color: isDark ? const Color(0xFF24292F) : Colors.white,
          ),
        ),
      );
    }

    // 3. Google: Crisp classic bold G badge
    if (host.contains('google.') || lowerName == 'google' || target.id == 'google') {
      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: const Text(
          'G',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w900,
            color: Color(0xFF4285F4),
            fontFamily: 'Roboto',
          ),
        ),
      );
    }

    // 4. YouTube: Official red play badge
    if (host.contains('youtube.com') || lowerName == 'youtube' || target.id == 'youtube') {
      return Container(
        width: 26,
        height: 18,
        decoration: BoxDecoration(
          color: const Color(0xFFFF0000),
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Icon(
          Icons.play_arrow_rounded,
          size: 14,
          color: Colors.white,
        ),
      );
    }

    // 5. Netflix: Official bold red N on black (checked BEFORE x.com)
    if (host.contains('netflix.com') || lowerName.contains('netflix')) {
      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Text(
          'N',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: Color(0xFFE50914),
            fontFamily: 'Arial',
            letterSpacing: -0.5,
          ),
        ),
      );
    }

    // 6. Bilibili: Official cute TV mascot with antennae & face
    if (host.contains('bilibili.com') || lowerName.contains('bilibili')) {
      return Container(
        width: 25,
        height: 25,
        alignment: Alignment.center,
        child: const CustomPaint(
          size: Size(22, 20),
          painter: _BilibiliLogoPainter(),
        ),
      );
    }

    // 7. Baidu: Baidu blue badge with bold white "度"
    if (host.contains('baidu.com') || lowerName.contains('baidu')) {
      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF2932E1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          '度',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.1,
          ),
        ),
      );
    }

    // 8. ChatGPT / OpenAI: Official 6-petal geometric spiral knot
    if (host.contains('chatgpt.com') || host.contains('openai.com') || lowerName.contains('chatgpt') || lowerName.contains('openai')) {
      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Color(0xFF10A37F),
          shape: BoxShape.circle,
        ),
        child: const CustomPaint(
          size: Size(15, 15),
          painter: _OpenAiLogoPainter(color: Colors.white),
        ),
      );
    }

    // 9. Telegram: Paper plane on blue circle
    if (host.contains('t.me') || host.contains('telegram') || lowerName.contains('telegram')) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFF0088CC),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.send_rounded,
          size: 13,
          color: Colors.white,
        ),
      );
    }

    // 10. Twitter / X: Bold mathematical 𝕏 on dark badge
    if (host == 'x.com' || host == 'twitter.com' || host.endsWith('.x.com') || host.endsWith('.twitter.com') || lowerName == 'twitter' || lowerName == 'x') {
      return Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2E) : Colors.black,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          '𝕏',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontFamily: 'sans-serif',
          ),
        ),
      );
    }

    // 11. Cloudflare: Official Cloudflare orange cloud
    if (host.contains('cloudflare.com') || host.contains('1.1.1.1') || lowerName.contains('cloudflare')) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(
          color: Color(0xFFF38020),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.cloud_rounded,
          size: 14,
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

  Widget _buildTargetItem(
    WebsiteTarget target,
    bool isDark,
    ThemeData theme,
    Translations tcontext,
  ) {
    return Material(
      color: isDark ? const Color(0xFF1E1E22) : Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: Listener(
        onPointerDown: (event) {
          _lastTapPosition = event.position;
        },
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => _testTarget(target),
          onTapDown: (details) {
            _lastTapPosition = details.globalPosition;
          },
          onSecondaryTapDown: (details) {
            _lastTapPosition = details.globalPosition;
          },
          onSecondaryTapUp: (details) {
            _showContextMenu(target, details.globalPosition);
          },
          onLongPress: () {
            _showContextMenu(target, _lastTapPosition);
          },
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
    final isAtLimit = _targets.length >= kMaxWebsiteTargets;

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
                    onTap: _isTestingAll || _targets.isEmpty ? null : _testAllTargets,
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
                  message: isAtLimit
                      ? tcontext.meta.maxWebsitesReached
                      : tcontext.meta.addWebsite,
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
                          color: theme.dividerColor.withValues(alpha: isAtLimit ? 0.15 : 0.3),
                          width: 0.8,
                        ),
                      ),
                      child: Icon(
                        Icons.add_rounded,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(alpha: isAtLimit ? 0.35 : 0.7),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 2. Content Grid / Row of Targets (with PC right-click & Mobile long-press)
            Container(
              constraints: const BoxConstraints(minHeight: 96),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: innerBgColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: innerBorderColor, width: 0.8),
              ),
              child: _targets.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              tcontext.meta.noMatchingProfiles,
                              style: TextStyle(
                                fontSize: 12,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () {
                                setState(() {
                                  _targets = WebsiteTarget.getDefaultTargets();
                                });
                                _saveTargets();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                child: Text(
                                  tcontext.meta.reset,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: ThemeDefine.kColorBlue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final total = _targets.length;
                        final columns = constraints.maxWidth > 560
                            ? (total <= 6 ? total : 4)
                            : (total <= 4 ? total : (constraints.maxWidth > 340 ? 3 : 2));
                        final itemWidth =
                            ((constraints.maxWidth - (columns - 1) * 8) / columns).floorToDouble();
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: _targets.map((target) {
                            return SizedBox(
                              width: itemWidth,
                              child: _buildTargetItem(target, isDark, theme, tcontext),
                            );
                          }).toList(),
                        );
                      },
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

class _GithubLogoPainter extends CustomPainter {
  final Color color;
  const _GithubLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final scale = size.width / 16.0;
    canvas.save();
    canvas.scale(scale, scale);

    final path = Path()
      ..moveTo(8, 0)
      ..cubicTo(3.58, 0, 0, 3.58, 0, 8)
      ..cubicTo(0, 11.54, 2.29, 14.53, 5.47, 15.59)
      ..cubicTo(5.87, 15.66, 6.02, 15.42, 6.02, 15.21)
      ..cubicTo(6.02, 15.02, 6.01, 14.39, 6.01, 13.72)
      ..cubicTo(3.79, 14.2, 3.32, 12.65, 3.32, 12.65)
      ..cubicTo(2.95, 11.73, 2.43, 11.48, 2.43, 11.48)
      ..cubicTo(1.71, 10.99, 2.49, 11.0, 2.49, 11.0)
      ..cubicTo(3.29, 11.06, 3.71, 11.82, 3.71, 11.82)
      ..cubicTo(4.42, 13.04, 5.58, 12.69, 6.03, 12.48)
      ..cubicTo(6.1, 11.96, 6.31, 11.61, 6.54, 11.41)
      ..cubicTo(4.77, 11.21, 2.91, 10.52, 2.91, 7.48)
      ..cubicTo(2.91, 6.61, 3.22, 5.91, 3.73, 5.36)
      ..cubicTo(3.65, 5.16, 3.38, 4.35, 3.81, 3.26)
      ..cubicTo(3.81, 3.26, 4.48, 3.05, 6.0, 4.08)
      ..cubicTo(6.64, 3.9, 7.32, 3.81, 8.0, 3.81)
      ..cubicTo(8.68, 3.81, 9.36, 3.9, 10.0, 4.08)
      ..cubicTo(11.52, 3.05, 12.19, 3.26, 12.19, 3.26)
      ..cubicTo(12.62, 4.35, 12.35, 5.16, 12.27, 5.36)
      ..cubicTo(12.78, 5.91, 13.09, 6.61, 13.09, 7.48)
      ..cubicTo(13.09, 10.53, 11.22, 11.21, 9.44, 11.4)
      ..cubicTo(9.74, 11.66, 10.0, 12.16, 10.0, 12.92)
      ..cubicTo(10.0, 14.02, 9.99, 14.9, 9.99, 15.21)
      ..cubicTo(9.99, 15.42, 10.13, 15.67, 10.54, 15.59)
      ..cubicTo(13.71, 14.53, 16.0, 11.53, 16.0, 8.0)
      ..cubicTo(16.0, 3.58, 12.42, 0, 8.0, 0)
      ..close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GithubLogoPainter oldDelegate) => oldDelegate.color != color;
}

class _BilibiliLogoPainter extends CustomPainter {
  const _BilibiliLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final antPaint = Paint()
      ..color = const Color(0xFF00AEEC)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final bodyPaint = Paint()
      ..color = const Color(0xFF00AEEC)
      ..style = PaintingStyle.fill;
    final facePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final smilePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    // Antennae
    canvas.drawLine(
      Offset(size.width * 0.35, size.height * 0.25),
      Offset(size.width * 0.2, size.height * 0.05),
      antPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.65, size.height * 0.25),
      Offset(size.width * 0.8, size.height * 0.05),
      antPaint,
    );

    // Body
    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, size.height * 0.22, size.width, size.height * 0.78),
      const Radius.circular(5.5),
    );
    canvas.drawRRect(bodyRect, bodyPaint);

    // Eyes
    canvas.drawCircle(Offset(size.width * 0.32, size.height * 0.58), 1.6, facePaint);
    canvas.drawCircle(Offset(size.width * 0.68, size.height * 0.58), 1.6, facePaint);

    // Smile
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.68),
        width: 4.5,
        height: 2.8,
      ),
      0,
      3.14159,
      false,
      smilePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _OpenAiLogoPainter extends CustomPainter {
  final Color color;
  const _OpenAiLogoPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final center = Offset(size.width / 2, size.height / 2);
    final double r = size.width * 0.42;

    for (int i = 0; i < 6; i++) {
      final double angle = i * (3.141592653589793 / 3);
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(angle);
      final path = Path()
        ..moveTo(0, -r)
        ..lineTo(r * 0.45, -r * 0.78)
        ..lineTo(r * 0.78, -r * 0.16)
        ..lineTo(r * 0.4, 0.12)
        ..lineTo(0, -r * 0.22);
      canvas.drawPath(path, stroke);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _OpenAiLogoPainter oldDelegate) => oldDelegate.color != color;
}
