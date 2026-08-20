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
  bool _userScrolledUp = false;
  int _newLogsWhilePaused = 0;
  String _searchKeyword = "";
  String _selectedLevel = "ALL"; // ALL, INFO, WARN, ERROR, DEBUG
  final List<ClashLog> _logs = [];
  Timer? _batchUpdateTimer;
  final List<ClashLog> _pendingLogs = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchKeyword = _searchController.text.trim().toLowerCase();
      });
    });

    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final max = _scrollController.position.maxScrollExtent;
      final current = _scrollController.position.pixels;
      if (max - current > 120) {
        if (!_userScrolledUp) {
          setState(() {
            _userScrolledUp = true;
          });
        }
      } else {
        if (_userScrolledUp) {
          setState(() {
            _userScrolledUp = false;
            _newLogsWhilePaused = 0;
          });
        }
      }
    });
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await _startLogStream();
  }

  @override
  void dispose() {
    _batchUpdateTimer?.cancel();
    _stopLogStream();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _startLogStream() async {
    _stopLogStream();
    final started = await VPNService.getStarted();
    if (!started) {
      await _loadFileLogs();
      return;
    }

    try {
      final stream = ClashHttpApi.getLogsStream(level: "debug");
      _logSubscription = stream.listen(
        (log) {
          if (!mounted) return;
          if (!_isStreaming) return;

          _pendingLogs.add(log);
          if (_userScrolledUp) {
            _newLogsWhilePaused++;
          }

          _scheduleBatchUpdate();
        },
        onError: (_) {
          _loadFileLogs();
        },
      );
    } catch (_) {
      await _loadFileLogs();
    }
  }

  void _scheduleBatchUpdate() {
    if (_batchUpdateTimer?.isActive == true) return;
    _batchUpdateTimer = Timer(const Duration(milliseconds: 120), () {
      if (!mounted || _pendingLogs.isEmpty) return;
      setState(() {
        _logs.addAll(_pendingLogs);
        _pendingLogs.clear();
        if (_logs.length > 2000) {
          _logs.removeRange(0, _logs.length - 2000);
        }
      });

      if (_autoScroll && !_userScrolledUp && _scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _loadFileLogs() async {
    try {
      final logPath = await PathUtils.serviceLogFilePath();
      final file = File(logPath);
      if (await file.exists()) {
        final lines = await file.readAsLines();
        final recent = lines.length > 500 ? lines.sublist(lines.length - 500) : lines;
        if (!mounted) return;
        setState(() {
          _logs.clear();
          for (var line in recent) {
            if (line.trim().isEmpty) continue;
            final l = ClashLog();
            final lower = line.toLowerCase();
            if (lower.contains("level=error") || lower.contains("error") || lower.contains("fatal")) {
              l.type = "error";
            } else if (lower.contains("level=warning") || lower.contains("warn")) {
              l.type = "warning";
            } else if (lower.contains("level=debug") || lower.contains("[debug]")) {
              l.type = "debug";
            } else {
              l.type = "info";
            }
            l.payload = line;
            _logs.add(l);
          }
        });
        if (_autoScroll && _scrollController.hasClients) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
            }
          });
        }
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
        final level = l.type.toUpperCase();
        if (_selectedLevel == "WARN" && (level == "WARNING" || level == "WARN")) {
          // match
        } else if (level != _selectedLevel) {
          return false;
        }
      }
      if (_searchKeyword.isEmpty) return true;
      return l.payload.toLowerCase().contains(_searchKeyword) ||
          l.type.toLowerCase().contains(_searchKeyword);
    }).toList();
  }

  Map<String, int> get _levelCounts {
    int info = 0;
    int warn = 0;
    int error = 0;
    int debug = 0;

    for (var l in _logs) {
      final t = l.type.toLowerCase();
      if (t == "error" || t == "fatal") {
        error++;
      } else if (t == "warning" || t == "warn") {
        warn++;
      } else if (t == "debug") {
        debug++;
      } else {
        info++;
      }
    }
    return {
      "ALL": _logs.length,
      "INFO": info,
      "WARN": warn,
      "ERROR": error,
      "DEBUG": debug,
    };
  }

  Color _getLevelColor(String type) {
    switch (type.toLowerCase()) {
      case "error":
      case "fatal":
        return const Color(0xFFEF4444);
      case "warning":
      case "warn":
        return const Color(0xFFF59E0B);
      case "info":
        return const Color(0xFF3B82F6);
      case "debug":
        return const Color(0xFFA855F7);
      default:
        return const Color(0xFF64748B);
    }
  }

  String _formatTime(DateTime time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    final s = time.second.toString().padLeft(2, '0');
    final ms = (time.millisecond).toString().padLeft(3, '0');
    return "$h:$m:$s.$ms";
  }

  Future<void> _copyAllLogs() async {
    final tcontext = Translations.of(context);
    final text = _filteredLogs.map((l) => "[${l.type.toUpperCase()}] ${l.payload}").join('\n');
    if (text.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tcontext.meta.copySuccess),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogDetail(ClashLog log) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _getLevelColor(log.type);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      log.type.toUpperCase(),
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatTime(log.time),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Content box
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: SelectableText(
                  log.payload,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12.5,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        await Clipboard.setData(ClipboardData(text: log.payload));
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(tcontext.meta.copiedLogContent),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy_rounded, size: 18),
                      label: Text(tcontext.meta.copyLog),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      setState(() {
        _userScrolledUp = false;
        _newLogsWhilePaused = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = _filteredLogs;
    final counts = _levelCounts;

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
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 36,
                          height: 32,
                          child: Icon(Icons.arrow_back_ios_outlined, size: 20),
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
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeDefine.kColorBlue.withValues(
                                alpha: isDark ? 0.25 : 0.12,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${filtered.length}",
                              style: const TextStyle(
                                color: ThemeDefine.kColorBlue,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Auto-scroll toggle
                    Tooltip(
                      message: _autoScroll
                          ? tcontext.meta.autoScrollEnabled
                          : tcontext.meta.autoScrollDisabled,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _autoScroll = !_autoScroll;
                            if (_autoScroll) {
                              _scrollToBottom();
                            }
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: _autoScroll
                                ? ThemeDefine.kColorBlue.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.vertical_align_bottom_rounded,
                            size: 20,
                            color: _autoScroll
                                ? ThemeDefine.kColorBlue
                                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Pause/Resume Stream
                    Tooltip(
                      message: _isStreaming
                          ? tcontext.meta.pauseLogs
                          : tcontext.meta.resumeLogs,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _isStreaming = !_isStreaming;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: !_isStreaming
                                ? Colors.orange.withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            _isStreaming
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            size: 20,
                            color: _isStreaming
                                ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Copy all logs
                    Tooltip(
                      message: tcontext.meta.copy,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: _copyAllLogs,
                        child: const SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(Icons.copy_rounded, size: 19),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // Clear logs
                    Tooltip(
                      message: tcontext.meta.clear,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _logs.clear();
                            _pendingLogs.clear();
                            _newLogsWhilePaused = 0;
                          });
                        },
                        child: const SizedBox(
                          width: 32,
                          height: 32,
                          child: Icon(Icons.delete_outline_rounded, size: 20),
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
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "${tcontext.meta.search}${tcontext.meta.searchLogsHint}",
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        style: const TextStyle(fontSize: 12.5),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Level Filter Chips with Live Counters
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildLevelChip("ALL", counts["ALL"] ?? 0),
                          const SizedBox(width: 6),
                          _buildLevelChip("INFO", counts["INFO"] ?? 0, color: const Color(0xFF3B82F6)),
                          const SizedBox(width: 6),
                          _buildLevelChip("WARN", counts["WARN"] ?? 0, color: const Color(0xFFF59E0B)),
                          const SizedBox(width: 6),
                          _buildLevelChip("ERROR", counts["ERROR"] ?? 0, color: const Color(0xFFEF4444)),
                          const SizedBox(width: 6),
                          _buildLevelChip("DEBUG", counts["DEBUG"] ?? 0, color: const Color(0xFFA855F7)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Logs Console View
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0B1120) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.35),
                          width: 0.8,
                        ),
                      ),
                      child: filtered.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.terminal_rounded,
                                    size: 48,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    _logs.isEmpty
                                        ? tcontext.meta.noLogsPrompt
                                        : tcontext.meta.noFilterResults,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final log = filtered[index];
                                return _buildLogItem(log);
                              },
                            ),
                    ),

                    // Floating Jump-to-Bottom Banner (When user scrolled up and new logs arrive)
                    if (_userScrolledUp)
                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(20),
                            color: ThemeDefine.kColorBlue,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: _scrollToBottom,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.arrow_downward_rounded, size: 16, color: Colors.white),
                                    const SizedBox(width: 6),
                                    Text(
                                      _newLogsWhilePaused > 0
                                          ? "${tcontext.meta.scrollToLatest} ${tcontext.meta.newLogsCount(p: _newLogsWhilePaused.toString())}"
                                          : tcontext.meta.scrollToBottom,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelChip(String level, int count, {Color? color}) {
    final isSelected = _selectedLevel == level;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final chipColor = color ?? ThemeDefine.kColorBlue;

    return Material(
      color: isSelected
          ? chipColor
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
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                level,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0.5),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.25)
                      : (isDark ? Colors.black26 : Colors.black12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  "$count",
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogItem(ClashLog log) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final color = _getLevelColor(log.type);
    final timeStr = _formatTime(log.time);

    // Extract sub-tags like [TCP], [UDP], [DNS], [Rule], [Match]
    String? categoryTag;
    final lower = log.payload.toLowerCase();
    if (lower.contains("[dns]")) {
      categoryTag = "DNS";
    } else if (lower.contains("[tcp]")) {
      categoryTag = "TCP";
    } else if (lower.contains("[udp]")) {
      categoryTag = "UDP";
    } else if (lower.contains("[rule]") || lower.contains("match rule")) {
      categoryTag = "RULE";
    } else if (lower.contains("[process]")) {
      categoryTag = "PROC";
    }

    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: () => _showLogDetail(log),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timestamp
            Text(
              timeStr,
              style: TextStyle(
                fontSize: 10,
                fontFamily: 'monospace',
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            const SizedBox(width: 6),

            // Level Tag Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0.5),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                log.type.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
            const SizedBox(width: 4),

            // Category tag (DNS, TCP, UDP, etc.)
            if (categoryTag != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 0.5),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.blueGrey.withValues(alpha: 0.25)
                      : Colors.blueGrey.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  categoryTag,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade800,
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],

            // Log Payload Content
            Expanded(
              child: Text(
                log.payload,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  height: 1.35,
                  color: log.type.toLowerCase() == "error"
                      ? Colors.redAccent
                      : (isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B)),
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
