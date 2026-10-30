// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

enum ConnectionSortType {
  defaultOrder,
  downloadDesc,
  uploadDesc,
  speedDesc,
  durationDesc,
  hostAsc,
}

class _TrafficSnapshot {
  final num upload;
  final num download;
  final DateTime time;
  _TrafficSnapshot(this.upload, this.download, this.time);
}

class ConnectionsScreen extends StatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "ConnectionsScreen");
  }

  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen>
    with AfterLayoutMixin {
  final TextEditingController _searchController = TextEditingController();
  Timer? _timer;
  bool _isAutoRefresh = true;
  bool _loading = false;
  String _searchKeyword = "";
  String _selectedProtocol = "ALL"; // ALL, TCP, UDP
  ConnectionSortType _sortType = ConnectionSortType.defaultOrder;

  List<ClashConnectionsTrack> _connections = [];

  // Traffic & Speed calculation
  Map<String, _TrafficSnapshot> _prevConnTraffic = {};
  Map<String, num> _connUploadSpeeds = {};
  Map<String, num> _connDownloadSpeeds = {};

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
    await _fetchConnections();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    _searchController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _stopTimer();
    if (!_isAutoRefresh) return;
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      _fetchConnections(silent: true);
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _fetchConnections({bool silent = false}) async {
    if (!silent && mounted) {
      setState(() {
        _loading = true;
      });
    }

    final started = await VPNService.getStarted();
    if (!started) {
      if (mounted) {
        setState(() {
          _connections = [];
          _loading = false;
          _prevConnTraffic.clear();
          _connUploadSpeeds.clear();
          _connDownloadSpeeds.clear();
        });
      }
      return;
    }

    final result = await ClashHttpApi.getConnections();
    if (!mounted) return;

    if (result.error == null && result.data != null) {
      final now = DateTime.now();
      final data = result.data!;

      // Calculate per-connection real-time speeds
      final Map<String, num> newUpSpeeds = {};
      final Map<String, num> newDownSpeeds = {};
      final Map<String, _TrafficSnapshot> newSnapshots = {};

      for (final conn in data.connections) {
        if (_prevConnTraffic.containsKey(conn.id)) {
          final prev = _prevConnTraffic[conn.id]!;
          final dt = now.difference(prev.time).inMilliseconds / 1000.0;
          if (dt > 0.3) {
            final upDiff = conn.upload - prev.upload;
            final downDiff = conn.download - prev.download;
            newUpSpeeds[conn.id] = upDiff > 0 ? (upDiff / dt) : 0;
            newDownSpeeds[conn.id] = downDiff > 0 ? (downDiff / dt) : 0;
          }
        }
        newSnapshots[conn.id] = _TrafficSnapshot(conn.upload, conn.download, now);
      }

      setState(() {
        _connections = data.connections;
        _prevConnTraffic = newSnapshots;
        _connUploadSpeeds = newUpSpeeds;
        _connDownloadSpeeds = newDownSpeeds;
        _loading = false;
      });
    } else {
      if (!silent) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  Future<void> _closeConnection(ClashConnectionsTrack conn) async {
    if (conn.id.isEmpty) return;
    final err = await ClashHttpApi.closeConnection(conn.id);
    if (err == null) {
      setState(() {
        _connections.removeWhere((c) => c.id == conn.id);
        _prevConnTraffic.remove(conn.id);
        _connUploadSpeeds.remove(conn.id);
        _connDownloadSpeeds.remove(conn.id);
      });
    }
  }

  Future<void> _closeAllConnections() async {
    final tcontext = Translations.of(context);
    final confirm = await DialogUtils.showConfirmDialog(
      context,
      tcontext.meta.closeAllConnections,
    );
    if (confirm != true) return;

    final err = await ClashHttpApi.closeAllConnections();
    if (err == null) {
      setState(() {
        _connections.clear();
        _prevConnTraffic.clear();
        _connUploadSpeeds.clear();
        _connDownloadSpeeds.clear();
      });
      _fetchConnections();
    }
  }

  String _formatSpeed(num bytesPerSec) {
    if (bytesPerSec <= 0) return "0 B/s";
    return "${ClashHttpApi.convertTrafficToStringDouble(bytesPerSec)}/s";
  }

  List<ClashConnectionsTrack> get _filteredConnections {
    final list = _connections.where((c) {
      if (_selectedProtocol != "ALL") {
        if (c.network.toUpperCase() != _selectedProtocol) {
          return false;
        }
      }
      if (_searchKeyword.isEmpty) return true;

      final host = c.host.toLowerCase();
      final destIp = c.destinationIP.toLowerCase();
      final sourceIp = c.sourceIP.toLowerCase();
      final rule = c.rule.toLowerCase();
      final rulePayload = c.rulePayload.toLowerCase();
      final process = c.process.toLowerCase();
      final chains = c.chains.join(' ').toLowerCase();

      return host.contains(_searchKeyword) ||
          destIp.contains(_searchKeyword) ||
          sourceIp.contains(_searchKeyword) ||
          rule.contains(_searchKeyword) ||
          rulePayload.contains(_searchKeyword) ||
          process.contains(_searchKeyword) ||
          chains.contains(_searchKeyword);
    }).toList();

    switch (_sortType) {
      case ConnectionSortType.downloadDesc:
        list.sort((a, b) => b.download.compareTo(a.download));
        break;
      case ConnectionSortType.uploadDesc:
        list.sort((a, b) => b.upload.compareTo(a.upload));
        break;
      case ConnectionSortType.speedDesc:
        list.sort((a, b) {
          final speedA = (_connDownloadSpeeds[a.id] ?? 0) + (_connUploadSpeeds[a.id] ?? 0);
          final speedB = (_connDownloadSpeeds[b.id] ?? 0) + (_connUploadSpeeds[b.id] ?? 0);
          return speedB.compareTo(speedA);
        });
        break;
      case ConnectionSortType.durationDesc:
        list.sort((a, b) => a.start.compareTo(b.start));
        break;
      case ConnectionSortType.hostAsc:
        list.sort((a, b) {
          final targetA = (a.host.isNotEmpty ? a.host : a.destinationIP).toLowerCase();
          final targetB = (b.host.isNotEmpty ? b.host : b.destinationIP).toLowerCase();
          return targetA.compareTo(targetB);
        });
        break;
      case ConnectionSortType.defaultOrder:
        list.sort((a, b) => b.start.compareTo(a.start));
        break;
    }

    return list;
  }

  String _formatDuration(String startStr) {
    if (startStr.isEmpty) return "";
    try {
      final startTime = DateTime.parse(startStr);
      final diff = DateTime.now().difference(startTime);
      if (diff.inHours > 0) {
        return "${diff.inHours}h ${diff.inMinutes % 60}m";
      }
      if (diff.inMinutes > 0) {
        return "${diff.inMinutes}m ${diff.inSeconds % 60}s";
      }
      return "${diff.inSeconds}s";
    } catch (_) {
      return "";
    }
  }

  void _showConnectionDetail(ClashConnectionsTrack conn) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tcontext = Translations.of(context);
    final uploadStr = ClashHttpApi.convertTrafficToStringDouble(conn.upload);
    final downloadStr = ClashHttpApi.convertTrafficToStringDouble(conn.download);
    final duration = _formatDuration(conn.start);
    final upSpeed = _connUploadSpeeds[conn.id] ?? 0;
    final downSpeed = _connDownloadSpeeds[conn.id] ?? 0;
    final target = conn.targetDisplay;

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: isDark ? const Color(0xFF1E1E22) : Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 540, maxHeight: 660),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Dialog Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: (conn.network == "UDP" ? Colors.orange : ThemeDefine.kColorBlue)
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          conn.network,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: conn.network == "UDP" ? Colors.orange : ThemeDefine.kColorBlue,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tcontext.meta.connectionDetails,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // Detail rows (scrollable)
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailSection(
                            title: tcontext.meta.destinationAddress,
                            content: target.isNotEmpty ? target : conn.destinationIP,
                            subContent: conn.destinationIP.isNotEmpty && conn.destinationIP != target
                                ? "IP: ${conn.destinationIP}:${conn.destinationPort}"
                                : null,
                            copyable: true,
                          ),
                          _buildDetailSection(
                            title: tcontext.meta.sourceAddress,
                            content: "${conn.sourceIP}:${conn.sourcePort}",
                            copyable: true,
                          ),
                          _buildDetailSection(
                            title: tcontext.meta.networkProtocol,
                            content: "${conn.network} / ${conn.type.isNotEmpty ? conn.type : '-'}",
                          ),
                          if (conn.process.isNotEmpty || conn.processPath.isNotEmpty)
                            _buildDetailSection(
                              title: tcontext.meta.process,
                              content: conn.process.isNotEmpty ? conn.process : "-",
                              subContent: conn.processPath.isNotEmpty ? conn.processPath : null,
                              copyable: conn.processPath.isNotEmpty,
                              copyText: conn.processPath,
                            ),
                          _buildDetailSection(
                            title: tcontext.meta.rules,
                            content: conn.rulePayload.isNotEmpty
                                ? "${conn.rule} (${conn.rulePayload})"
                                : (conn.rule.isNotEmpty ? conn.rule : "-"),
                          ),
                          _buildDetailSection(
                            title: tcontext.meta.proxyChain,
                            content: conn.chains.isNotEmpty ? conn.chains.join('  ➜  ') : "DIRECT",
                            isChain: true,
                          ),
                          _buildDetailSection(
                            title: tcontext.meta.trafficUpload,
                            content: upSpeed > 0
                                ? "$uploadStr (${_formatSpeed(upSpeed)})"
                                : uploadStr,
                          ),
                          _buildDetailSection(
                            title: tcontext.meta.trafficDownload,
                            content: downSpeed > 0
                                ? "$downloadStr (${_formatSpeed(downSpeed)})"
                                : downloadStr,
                          ),
                          _buildDetailSection(
                            title: tcontext.meta.connectionDuration,
                            content: duration.isNotEmpty ? duration : "-",
                            subContent: conn.start.isNotEmpty ? "${tcontext.meta.connectionStart}: ${conn.start}" : null,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),

                  // Action buttons
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      // Copy Host
                      OutlinedButton.icon(
                        icon: const Icon(Icons.copy_rounded, size: 14),
                        label: Text(tcontext.meta.copyHost, style: const TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          final host = conn.host.isNotEmpty ? conn.host : conn.destinationIP;
                          Clipboard.setData(ClipboardData(text: host));
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(tcontext.meta.copySuccess),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      // Copy All JSON
                      OutlinedButton.icon(
                        icon: const Icon(Icons.data_object_rounded, size: 14),
                        label: Text(tcontext.meta.copyAllDetails, style: const TextStyle(fontSize: 12)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          final jsonStr = const JsonEncoder.withIndent('  ').convert(conn.toJson());
                          Clipboard.setData(ClipboardData(text: jsonStr));
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(tcontext.meta.copySuccess),
                              duration: const Duration(seconds: 1),
                            ),
                          );
                        },
                      ),
                      // Close Connection
                      ElevatedButton.icon(
                        icon: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
                        label: Text(
                          tcontext.meta.closeThisConnection,
                          style: const TextStyle(fontSize: 12, color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          Navigator.of(ctx).pop();
                          await _closeConnection(conn);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailSection({
    required String title,
    required String content,
    String? subContent,
    bool copyable = false,
    String? copyText,
    bool isChain = false,
  }) {
    final theme = Theme.of(context);
    final textToCopy = copyText ?? content;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: SelectableText(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    fontFamilyFallback: (isChain && Platform.isWindows) ? const ['Emoji'] : null,
                  ),
                ),
              ),
              if (copyable && textToCopy.isNotEmpty)
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: textToCopy));
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(Translations.of(context).meta.copySuccess),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ),
            ],
          ),
          if (subContent != null && subContent.isNotEmpty) ...[
            const SizedBox(height: 2),
            SelectableText(
              subContent,
              style: TextStyle(
                fontSize: 11.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }

  PopupMenuItem<ConnectionSortType> _buildSortMenuItem(
    ConnectionSortType sortType,
    String label,
  ) {
    final isSelected = _sortType == sortType;
    return PopupMenuItem<ConnectionSortType>(
      value: sortType,
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_rounded : Icons.circle_outlined,
            size: 16,
            color: isSelected ? ThemeDefine.kColorBlue : Colors.transparent,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? ThemeDefine.kColorBlue : null,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = _filteredConnections;

    final actions = [
      // Sort Menu Button
      PopupMenuButton<ConnectionSortType>(
        tooltip: tcontext.meta.sort,
        iconSize: 20,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 34, minHeight: 34),
        style: IconButton.styleFrom(
          minimumSize: const Size(34, 34),
          fixedSize: const Size(34, 34),
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        icon: Icon(
          Icons.sort_rounded,
          size: 20,
          color: _sortType != ConnectionSortType.defaultOrder
              ? ThemeDefine.kColorBlue
              : theme.colorScheme.onSurface.withValues(alpha: 0.85),
        ),
        onSelected: (sort) {
          HapticFeedback.selectionClick();
          setState(() {
            _sortType = sort;
          });
        },
        itemBuilder: (context) => [
          _buildSortMenuItem(ConnectionSortType.defaultOrder, tcontext.meta.sortDefault),
          _buildSortMenuItem(ConnectionSortType.downloadDesc, tcontext.meta.sortByDownload),
          _buildSortMenuItem(ConnectionSortType.uploadDesc, tcontext.meta.sortByUpload),
          _buildSortMenuItem(ConnectionSortType.speedDesc, tcontext.meta.sortBySpeed),
          _buildSortMenuItem(ConnectionSortType.durationDesc, tcontext.meta.sortByDuration),
          _buildSortMenuItem(ConnectionSortType.hostAsc, tcontext.meta.sortByHost),
        ],
      ),
      // Auto-refresh toggle
      IconButton(
        tooltip: _isAutoRefresh ? tcontext.meta.pause : tcontext.meta.resume,
        icon: Icon(
          _isAutoRefresh
              ? Icons.pause_circle_outline_rounded
              : Icons.play_circle_outline_rounded,
          color: _isAutoRefresh
              ? ThemeDefine.kColorBlue
              : theme.colorScheme.onSurface.withValues(alpha: 0.55),
        ),
        onPressed: () {
          HapticFeedback.selectionClick();
          setState(() {
            _isAutoRefresh = !_isAutoRefresh;
            if (_isAutoRefresh) {
              _startTimer();
            } else {
              _stopTimer();
            }
          });
        },
      ),
      // Manual refresh button
      IconButton(
        tooltip: tcontext.meta.refresh,
        icon: _loading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.refresh_rounded),
        onPressed: () {
          HapticFeedback.selectionClick();
          _fetchConnections();
        },
      ),
      // Close all connections button (always visible, disabled when empty)
      IconButton(
        tooltip: tcontext.meta.closeAllConnections,
        icon: Icon(
          Icons.delete_sweep_outlined,
          color: _connections.isNotEmpty
              ? Colors.redAccent
              : theme.colorScheme.onSurface.withValues(alpha: 0.25),
        ),
        onPressed: _connections.isNotEmpty
            ? () {
                HapticFeedback.lightImpact();
                _closeAllConnections();
              }
            : null,
      ),
    ];

    return Scaffold(
      appBar: WmimoAppBar(
        title: tcontext.meta.connections,
        badge: Container(
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
            "${filtered.length}/${_connections.length}",
            style: const TextStyle(
              color: ThemeDefine.kColorBlue,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: actions,
      ),
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: Column(
            children: [
              // Search bar and protocol filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: WmimoSearchBar(
                        controller: _searchController,
                        hintText: tcontext.meta.searchConnections,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Protocol selector
                    _buildProtocolChip("ALL"),
                    const SizedBox(width: 4),
                    _buildProtocolChip("TCP"),
                    const SizedBox(width: 4),
                    _buildProtocolChip("UDP"),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Connections list
              Expanded(
                child: filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.hub_outlined,
                              size: 52,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _connections.isEmpty
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
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final conn = filtered[index];
                          return _buildConnectionItem(conn);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProtocolChip(String protocol) {
    final isSelected = _selectedProtocol == protocol;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          setState(() {
            _selectedProtocol = protocol;
          });
        },
        child: AnimatedContainer(
          duration: ThemeDefine.duration(const Duration(milliseconds: 160)),
          curve: ThemeDefine.kCurveStandard,
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 11),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? ThemeDefine.kColorBlue
                : (isDark ? const Color(0xFF262629) : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected
                  ? ThemeDefine.kColorBlue
                  : theme.dividerColor.withValues(alpha: 0.25),
              width: 0.8,
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: ThemeDefine.duration(const Duration(milliseconds: 160)),
            curve: ThemeDefine.kCurveStandard,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : theme.colorScheme.onSurface.withValues(alpha: 0.75),
            ),
            child: Text(protocol),
          ),
        ),
      ),
    );
  }

  Widget _buildConnectionItem(ClashConnectionsTrack conn) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final duration = _formatDuration(conn.start);
    final uploadStr = ClashHttpApi.convertTrafficToStringDouble(conn.upload);
    final downloadStr = ClashHttpApi.convertTrafficToStringDouble(conn.download);
    final target = conn.targetDisplay;
    final process = conn.process.isNotEmpty ? conn.process : conn.type;
    final chain = conn.chains.isNotEmpty ? conn.chains.join(' → ') : "";
    final downSpeed = _connDownloadSpeeds[conn.id] ?? 0;
    final upSpeed = _connUploadSpeeds[conn.id] ?? 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: isDark ? 0.2 : 0.4),
          width: 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showConnectionDetail(conn),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Network badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: (conn.network == "UDP" ? Colors.orange : ThemeDefine.kColorBlue)
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        conn.network,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: conn.network == "UDP" ? Colors.orange : ThemeDefine.kColorBlue,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Target Host / IP
                    Expanded(
                      child: Text(
                        target.isNotEmpty ? target : conn.destinationIP,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (duration.isNotEmpty)
                      Text(
                        duration,
                        style: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    const SizedBox(width: 6),
                    // Close connection button
                    InkWell(
                      borderRadius: BorderRadius.circular(6),
                      onTap: () => _closeConnection(conn),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Details row
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          if (process.isNotEmpty) ...[
                            InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: () {
                                _searchController.text = process;
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.terminal_rounded,
                                    size: 13,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      process,
                                      style: TextStyle(
                                        fontSize: 11.5,
                                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (conn.rule.isNotEmpty) ...[
                            Flexible(
                              child: InkWell(
                                borderRadius: BorderRadius.circular(4),
                                onTap: () {
                                  _searchController.text = conn.rule;
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.alt_route_rounded,
                                      size: 13,
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        conn.rulePayload.isNotEmpty
                                            ? "${conn.rule}(${conn.rulePayload})"
                                            : conn.rule,
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Traffic & Speed transferred
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (upSpeed > 0 || downSpeed > 0) ...[
                          if (upSpeed > 0) ...[
                            const Icon(Icons.arrow_upward_rounded, size: 12, color: Colors.orangeAccent),
                            Text(
                              _formatSpeed(upSpeed),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            const SizedBox(width: 6),
                          ],
                          if (downSpeed > 0) ...[
                            const Icon(Icons.arrow_downward_rounded, size: 12, color: ThemeDefine.kColorGreenBright),
                            Text(
                              _formatSpeed(downSpeed),
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: ThemeDefine.kColorGreenBright,
                              ),
                            ),
                          ],
                        ] else ...[
                          const Icon(Icons.arrow_upward_rounded, size: 12, color: Colors.orangeAccent),
                          Text(
                            uploadStr,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.arrow_downward_rounded, size: 12, color: ThemeDefine.kColorGreenBright),
                          Text(
                            downloadStr,
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                if (chain.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      chain,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
