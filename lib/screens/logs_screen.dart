// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/utils/path_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class LogsScreen extends StatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "LogsScreen");
  }

  static String normalizeLevel(String rawType) {
    final t = rawType.trim().toLowerCase();
    if (t == "error" || t == "fatal") return "ERROR";
    if (t == "warning" || t == "warn") return "WARN";
    if (t == "debug") return "DEBUG";
    return "INFO";
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

  Timer? _reconnectTimer;

  @override
  void dispose() {
    _batchUpdateTimer?.cancel();
    _reconnectTimer?.cancel();
    _stopLogStream();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  static String normalizeLevel(String rawType) {
    final t = rawType.trim().toLowerCase();
    if (t == "error" || t == "fatal") return "ERROR";
    if (t == "warning" || t == "warn") return "WARN";
    if (t == "debug") return "DEBUG";
    return "INFO";
  }

  Future<void> _startLogStream() async {
    _stopLogStream();

    // 1. Always load recent historical logs from file first so the view is never empty
    await _loadFileLogs();

    // 2. Connect real-time stream if VPN service is running
    final started = await VPNService.getStarted();
    if (started) {
      _connectStream();
    }
  }

  void _connectStream() {
    _stopLogStream();
    if (!_isStreaming || !mounted) return;

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
          _scheduleStreamReconnect();
        },
        onDone: () {
          _scheduleStreamReconnect();
        },
        cancelOnError: true,
      );
    } catch (_) {
      _scheduleStreamReconnect();
    }
  }

  void _scheduleStreamReconnect() {
    if (!mounted || !_isStreaming) return;
    if (_reconnectTimer?.isActive == true) return;
    _reconnectTimer = Timer(const Duration(seconds: 3), () async {
      if (!mounted || !_isStreaming) return;
      final started = await VPNService.getStarted();
      if (started) {
        _connectStream();
      }
    });
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
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      }
    });
  }

  Future<void> _loadFileLogs() async {
    try {
      final logs = await _readRecentLogsFromFile();
      if (!mounted) return;
      setState(() {
        _logs.clear();
        _logs.addAll(logs);
      });
      if (_autoScroll && _scrollController.hasClients) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
          }
        });
      }
    } catch (_) {}
  }

  Future<List<ClashLog>> _readRecentLogsFromFile() async {
    final List<ClashLog> loaded = [];
    try {
      final logPath = await PathUtils.serviceLogFilePath();
      final file = File(logPath);
      if (await file.exists()) {
        final parsed = await _parseLinesFromTail(file);
        if (parsed.isNotEmpty) return parsed;
      }

      // Fallback to std error file if core log doesn't exist or is empty
      final errPath = await PathUtils.serviceStdErrorFilePath();
      final errFile = File(errPath);
      if (await errFile.exists()) {
        return await _parseLinesFromTail(errFile);
      }
    } catch (_) {}
    return loaded;
  }

  static Future<List<ClashLog>> _parseLinesFromTail(File file) async {
    final List<ClashLog> logs = [];
    try {
      final length = await file.length();
      if (length == 0) return logs;

      List<String> lines;
      const int maxReadBytes = 384 * 1024; // 384 KB
      if (length > maxReadBytes) {
        final raf = await file.open(mode: FileMode.read);
        try {
          await raf.setPosition(length - maxReadBytes);
          final bytes = await raf.read(maxReadBytes);
          final text = utf8.decode(bytes, allowMalformed: true);
          lines = const LineSplitter().convert(text);
          if (lines.isNotEmpty) {
            lines.removeAt(0); // discard incomplete line
          }
        } finally {
          await raf.close();
        }
      } else {
        lines = await file.readAsLines();
      }

      final recent = lines.length > 500 ? lines.sublist(lines.length - 500) : lines;
      for (final line in recent) {
        if (line.trim().isEmpty) continue;
        logs.add(ClashLog.fromLogLine(line));
      }
    } catch (_) {}
    return logs;
  }

  void _stopLogStream() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _logSubscription?.cancel();
    _logSubscription = null;
  }

  List<ClashLog> get _filteredLogs {
    return _logs.where((l) {
      if (_selectedLevel != "ALL") {
        if (normalizeLevel(l.type) != _selectedLevel) {
          return false;
        }
      }
      if (_searchKeyword.isEmpty) return true;
      final kw = _searchKeyword;
      return l.payload.toLowerCase().contains(kw) ||
          normalizeLevel(l.type).toLowerCase().contains(kw);
    }).toList();
  }

  Map<String, int> get _levelCounts {
    int info = 0;
    int warn = 0;
    int error = 0;
    int debug = 0;

    for (var l in _logs) {
      switch (normalizeLevel(l.type)) {
        case "ERROR":
          error++;
          break;
        case "WARN":
          warn++;
          break;
        case "DEBUG":
          debug++;
          break;
        case "INFO":
        default:
          info++;
          break;
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
    switch (normalizeLevel(type)) {
      case "ERROR":
        return const Color(0xFFEF4444);
      case "WARN":
        return const Color(0xFFF59E0B);
      case "INFO":
        return const Color(0xFF3B82F6);
      case "DEBUG":
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

  String _formatFullDateTime(DateTime time) {
    final y = time.year.toString();
    final mo = time.month.toString().padLeft(2, '0');
    final d = time.day.toString().padLeft(2, '0');
    return "$y-$mo-$d ${_formatTime(time)}";
  }

  Future<void> _copyAllLogs() async {
    final tcontext = Translations.of(context);
    final text = _filteredLogs
        .map((l) => "[${_formatTime(l.time)}] [${normalizeLevel(l.type)}] ${l.payload}")
        .join('\n');
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
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final level = normalizeLevel(log.type);
    final color = _getLevelColor(level);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? const Color(0xFF141416) : Colors.white,
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
                      level,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatFullDateTime(log.time),
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
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
                constraints: const BoxConstraints(maxHeight: 360),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF262629) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.2),
                  ),
                ),
                child: SingleChildScrollView(
                  child: SelectableText(
                    log.payload,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12.5,
                      height: 1.5,
                    ),
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

    final actions = [
      // Refresh / Reload
      IconButton(
        tooltip: tcontext.meta.refresh,
        icon: const Icon(Icons.refresh_rounded, size: 20),
        onPressed: () {
          HapticFeedback.selectionClick();
          _startLogStream();
        },
      ),
      // Auto-scroll toggle
      IconButton(
        tooltip: _autoScroll
            ? tcontext.meta.autoScrollEnabled
            : tcontext.meta.autoScrollDisabled,
        icon: Icon(
          Icons.vertical_align_bottom_rounded,
          color: _autoScroll
              ? ThemeDefine.kColorBlue
              : theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
        onPressed: () {
          HapticFeedback.selectionClick();
          setState(() {
            _autoScroll = !_autoScroll;
            if (_autoScroll) {
              _scrollToBottom();
            }
          });
        },
      ),
      // Pause/Resume Stream
      IconButton(
        tooltip: _isStreaming
            ? tcontext.meta.pauseLogs
            : tcontext.meta.resumeLogs,
        icon: Icon(
          _isStreaming
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
          color: _isStreaming
              ? theme.colorScheme.onSurface.withValues(alpha: 0.6)
              : Colors.orange,
        ),
        onPressed: () {
          HapticFeedback.selectionClick();
          setState(() {
            _isStreaming = !_isStreaming;
            if (_isStreaming) {
              _connectStream();
            } else {
              _stopLogStream();
            }
          });
        },
      ),
      // Copy all logs
      IconButton(
        tooltip: tcontext.meta.copy,
        icon: const Icon(Icons.copy_rounded, size: 20),
        onPressed: () {
          HapticFeedback.selectionClick();
          _copyAllLogs();
        },
      ),
      // Clear logs
      IconButton(
        tooltip: tcontext.meta.clear,
        icon: const Icon(Icons.delete_outline_rounded, size: 22),
        onPressed: () {
          HapticFeedback.lightImpact();
          setState(() {
            _logs.clear();
            _pendingLogs.clear();
            _newLogsWhilePaused = 0;
          });
        },
      ),
    ];

    return Scaffold(
      appBar: WmimoAppBar(
        title: tcontext.meta.coreLog,
        badge: Container(
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
        actions: actions,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
          child: Column(
            children: [

              // Search bar and level filters
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF262629)
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
                          : RefreshIndicator(
                              onRefresh: _startLogStream,
                              child: ListView.builder(
                                controller: _scrollController,
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final log = filtered[index];
                                  return _buildLogItem(log);
                                },
                              ),
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
          : (isDark ? const Color(0xFF262629) : const Color(0xFFF1F5F9)),
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
    final level = normalizeLevel(log.type);
    final color = _getLevelColor(level);
    final timeStr = _formatTime(log.time);

    // Extract sub-tags like [TCP], [UDP], [DNS], [Rule], [Match], [Sniffer]
    String? categoryTag;
    Color? tagColor;
    final lower = log.payload.toLowerCase();
    if (lower.contains("[dns]")) {
      categoryTag = "DNS";
      tagColor = const Color(0xFF06B6D4);
    } else if (lower.contains("[tcp]")) {
      categoryTag = "TCP";
      tagColor = const Color(0xFF3B82F6);
    } else if (lower.contains("[udp]")) {
      categoryTag = "UDP";
      tagColor = const Color(0xFF8B5CF6);
    } else if (lower.contains("[rule]") || lower.contains("match rule")) {
      categoryTag = "RULE";
      tagColor = const Color(0xFF10B981);
    } else if (lower.contains("[process]")) {
      categoryTag = "PROC";
      tagColor = const Color(0xFFF59E0B);
    } else if (lower.contains("[sniffer]")) {
      categoryTag = "SNIFF";
      tagColor = const Color(0xFFEC4899);
    }

    // Strip leading [tag] if present so it's not duplicated next to categoryTag badge
    var displayPayload = log.payload;
    if (categoryTag != null) {
      final tagPrefix = "[$categoryTag]";
      if (displayPayload.toLowerCase().startsWith(tagPrefix.toLowerCase())) {
        displayPayload = displayPayload.substring(tagPrefix.length).trimLeft();
      }
    }

    Color textColor;
    if (level == "ERROR") {
      textColor = const Color(0xFFEF4444);
    } else if (level == "WARN") {
      textColor = isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706);
    } else {
      textColor = isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B);
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
                level,
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
                  color: (tagColor ?? Colors.blueGrey).withValues(alpha: isDark ? 0.2 : 0.12),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  categoryTag,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w700,
                    color: tagColor ?? (isDark ? Colors.blueGrey.shade200 : Colors.blueGrey.shade800),
                  ),
                ),
              ),
              const SizedBox(width: 4),
            ],

            // Log Payload Content
            Expanded(
              child: Text(
                displayPayload,
                style: TextStyle(
                  fontSize: 11,
                  fontFamily: 'monospace',
                  height: 1.35,
                  color: textColor,
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
