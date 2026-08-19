// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';

class LogsScreen extends StatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "LogsScreen");
  }

  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> with AfterLayoutMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  StreamSubscription<ClashLog>? _logSubscription;
  bool _isStreaming = true;
  bool _autoScroll = true;
  String _searchKeyword = "";
  String _selectedLevel = "ALL"; // ALL, INFO, WARNING, ERROR, DEBUG
  final List<ClashLog> _logs = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchKeyword = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _startLogStream();
  }

  @override
  void dispose() {
    _stopLogStream();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startLogStream() async {
    _stopLogStream();
    final started = await VPNService.getStarted();
    if (!started) {
      // Fallback to reading file logs if not running
      await _loadFileLogs();
      return;
    }

    try {
      final stream = ClashHttpApi.getLogsStream(level: "debug");
      _logSubscription = stream.listen(
        (log) {
          if (!mounted) return;
          if (!_isStreaming) return;
          setState(() {
            _logs.add(log);
            if (_logs.length > 500) {
              _logs.removeRange(0, _logs.length - 500);
            }
          });
          if (_autoScroll && _scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent + 60,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          }
        },
        onError: (_) {
          _loadFileLogs();
        },
      );
    } catch (_) {
      await _loadFileLogs();
    }
  }

  Future<void> _loadFileLogs() async {
    try {
      final logPath = await PathUtils.serviceLogFilePath();
      final file = File(logPath);
      if (await file.exists()) {
        final lines = await file.readAsLines();
        final recent = lines.length > 200 ? lines.sublist(lines.length - 200) : lines;
        if (!mounted) return;
        setState(() {
          _logs.clear();
          for (var line in recent) {
            if (line.trim().isEmpty) continue;
            final l = ClashLog();
            if (line.toLowerCase().contains("err") || line.toLowerCase().contains("fatal")) {
              l.type = "error";
            } else if (line.toLowerCase().contains("warn")) {
              l.type = "warning";
            } else {
              l.type = "info";
            }
            l.payload = line;
            _logs.add(l);
          }
        });
      }
    } catch (_) {}
  }

  void _stopLogStream() {
    _logSubscription?.cancel();
    _logSubscription = null;
  }

  List<ClashLog> get _filteredLogs {
    return _logs.where((l) {
      if (_selectedLevel != "ALL") {
        if (l.type.toUpperCase() != _selectedLevel) {
          return false;
        }
      }
      if (_searchKeyword.isEmpty) return true;
      return l.payload.toLowerCase().contains(_searchKeyword) ||
          l.type.toLowerCase().contains(_searchKeyword);
    }).toList();
  }

  Color _getLevelColor(String type) {
    switch (type.toLowerCase()) {
      case "error":
      case "fatal":
        return Colors.redAccent;
      case "warning":
      case "warn":
        return Colors.amber;
      case "info":
        return ThemeDefine.kColorBlue;
      case "debug":
        return Colors.purpleAccent;
      default:
        return Colors.blueGrey;
    }
  }

  String _formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
  }

  Future<void> _copyAllLogs() async {
    final tcontext = Translations.of(context);
    final text = _filteredLogs.map((l) => "[${l.type.toUpperCase()}] ${l.payload}").join('\n');
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    DialogUtils.showAlertDialog(context, tcontext.meta.copySuccess);
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = _filteredLogs;

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
                    if (ModalRoute.of(context)?.canPop ?? false)
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 36,
                          height: 30,
                          child: Icon(Icons.arrow_back_ios_outlined, size: 22),
                        ),
                      ),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            tcontext.meta.coreLog,
                            style: const TextStyle(
                              fontWeight: ThemeConfig.kFontWeightTitle,
                              fontSize: ThemeConfig.kFontSizeTitle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeDefine.kColorBlue.withValues(
                                alpha: isDark ? 0.25 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${filtered.length}",
                              style: const TextStyle(
                                color: ThemeDefine.kColorBlue,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Auto-scroll toggle
                    Tooltip(
                      message: "Auto scroll",
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _autoScroll = !_autoScroll;
                          });
                        },
                        child: SizedBox(
                          width: 36,
                          height: 30,
                          child: Icon(
                            Icons.vertical_align_bottom_rounded,
                            size: 22,
                            color: _autoScroll
                                ? ThemeDefine.kColorBlue
                                : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                    // Pause/Resume Stream
                    Tooltip(
                      message: _isStreaming ? "Pause stream" : "Resume stream",
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _isStreaming = !_isStreaming;
                          });
                        },
                        child: SizedBox(
                          width: 36,
                          height: 30,
                          child: Icon(
                            _isStreaming
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                            size: 22,
                            color: _isStreaming
                                ? ThemeDefine.kColorBlue
                                : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ),
                      ),
                    ),
                    // Copy all logs
                    Tooltip(
                      message: tcontext.meta.copy,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _copyAllLogs,
                        child: const SizedBox(
                          width: 36,
                          height: 30,
                          child: Icon(Icons.copy_rounded, size: 20),
                        ),
                      ),
                    ),
                    // Clear logs
                    Tooltip(
                      message: tcontext.meta.clear,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _logs.clear();
                          });
                        },
                        child: const SizedBox(
                          width: 36,
                          height: 30,
                          child: Icon(Icons.delete_outline, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Search bar and level filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: tcontext.meta.search,
                          hintStyle: TextStyle(
                            fontSize: 12.5,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 18,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                          suffixIcon: _searchKeyword.isNotEmpty
                              ? InkWell(
                                  onTap: () => _searchController.clear(),
                                  child: const Icon(Icons.clear, size: 16),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 9),
                        ),
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildLevelChip("ALL"),
                          const SizedBox(width: 6),
                          _buildLevelChip("INFO"),
                          const SizedBox(width: 6),
                          _buildLevelChip("WARNING"),
                          const SizedBox(width: 6),
                          _buildLevelChip("ERROR"),
                          const SizedBox(width: 6),
                          _buildLevelChip("DEBUG"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Logs console list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 52,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _logs.isEmpty
                                  ? tcontext.meta.none
                                  : tcontext.meta.noFilterResults,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.dividerColor.withValues(alpha: 0.4),
                            width: 0.8,
                          ),
                        ),
                        child: ListView.builder(
                          controller: _scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final log = filtered[index];
                            return _buildLogItem(log);
                          },
                        ),
                      ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelChip(String level) {
    final isSelected = _selectedLevel == level;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isSelected
          ? ThemeDefine.kColorBlue
          : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          setState(() {
            _selectedLevel = level;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          child: Text(
            level,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(ClashLog log) {
    final theme = Theme.of(context);
    final color = _getLevelColor(log.type);
    final timeStr = _formatTime(log.time);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeStr,
            style: TextStyle(
              fontSize: 10.5,
              fontFamily: 'monospace',
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              log.type.toUpperCase(),
              style: TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              log.payload,
              style: const TextStyle(
                fontSize: 11.5,
                fontFamily: 'monospace',
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
