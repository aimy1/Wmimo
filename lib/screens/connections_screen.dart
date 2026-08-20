// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/dialog_utils.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';

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

  ClashConnections? _connectionsData;
  List<ClashConnectionsTrack> _connections = [];

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
          _connectionsData = null;
          _connections = [];
          _loading = false;
        });
      }
      return;
    }

    final result = await ClashHttpApi.getConnections();
    if (!mounted) return;

    if (result.error == null && result.data != null) {
      setState(() {
        _connectionsData = result.data;
        _connections = result.data!.connections;
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
      });
      _fetchConnections();
    }
  }

  List<ClashConnectionsTrack> get _filteredConnections {
    return _connections.where((c) {
      if (_selectedProtocol != "ALL") {
        if (c.network.toUpperCase() != _selectedProtocol) {
          return false;
        }
      }
      if (_searchKeyword.isEmpty) return true;

      final host = c.host.toLowerCase();
      final destIp = c.destinationIP.toLowerCase();
      final rule = c.rule.toLowerCase();
      final rulePayload = c.rulePayload.toLowerCase();
      final process = c.process.toLowerCase();
      final chains = c.chains.join(' ').toLowerCase();

      return host.contains(_searchKeyword) ||
          destIp.contains(_searchKeyword) ||
          rule.contains(_searchKeyword) ||
          rulePayload.contains(_searchKeyword) ||
          process.contains(_searchKeyword) ||
          chains.contains(_searchKeyword);
    }).toList();
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

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final filtered = _filteredConnections;

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
                            tcontext.meta.connections,
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
                              "${filtered.length}/${_connections.length}",
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
                    // Auto-refresh toggle
                    Tooltip(
                      message: _isAutoRefresh ? tcontext.meta.pause : tcontext.meta.resume,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            _isAutoRefresh = !_isAutoRefresh;
                            if (_isAutoRefresh) {
                              _startTimer();
                            } else {
                              _stopTimer();
                            }
                          });
                        },
                        child: SizedBox(
                          width: 36,
                          height: 30,
                          child: Icon(
                            _isAutoRefresh
                                ? Icons.pause_circle_outline
                                : Icons.play_circle_outline,
                            size: 22,
                            color: _isAutoRefresh
                                ? ThemeDefine.kColorBlue
                                : theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                    // Manual refresh button
                    Tooltip(
                      message: tcontext.meta.refresh,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => _fetchConnections(),
                        child: SizedBox(
                          width: 36,
                          height: 30,
                          child: _loading
                              ? const Center(
                                  child: SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                )
                              : const Icon(Icons.refresh, size: 22),
                        ),
                      ),
                    ),
                    // Close all connections button
                    if (_connections.isNotEmpty)
                      Tooltip(
                        message: tcontext.meta.closeAllConnections,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: _closeAllConnections,
                          child: const SizedBox(
                            width: 36,
                            height: 30,
                            child: Icon(
                              Icons.delete_sweep_outlined,
                              size: 24,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (_connectionsData != null) ...[
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_upward_rounded, size: 13, color: Colors.orangeAccent),
                      const SizedBox(width: 2),
                      Text(
                        ClashHttpApi.convertTrafficToStringDouble(_connectionsData!.uploadTotal),
                        style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.arrow_downward_rounded, size: 13, color: ThemeDefine.kColorGreenBright),
                      const SizedBox(width: 2),
                      Text(
                        ClashHttpApi.convertTrafficToStringDouble(_connectionsData!.downloadTotal),
                        style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                      if (_connectionsData!.memory > 0) ...[
                        const Spacer(),
                        const Icon(Icons.memory_rounded, size: 13, color: ThemeDefine.kColorBlue),
                        const SizedBox(width: 2),
                        Text(
                          ClashHttpApi.convertTrafficToStringDouble(_connectionsData!.memory),
                          style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 10),

              // Search bar and protocol filter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
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
                            hintText: tcontext.meta.searchConnections,
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
            _selectedProtocol = protocol;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            protocol,
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

  Widget _buildConnectionItem(ClashConnectionsTrack conn) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final duration = _formatDuration(conn.start);
    final uploadStr = ClashHttpApi.convertTrafficToStringDouble(conn.upload);
    final downloadStr = ClashHttpApi.convertTrafficToStringDouble(conn.download);
    final target = conn.targetDisplay;
    final process = conn.process.isNotEmpty ? conn.process : conn.type;
    final chain = conn.chains.isNotEmpty ? conn.chains.join(' → ') : "";

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151D2E) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withValues(alpha: 0.4),
          width: 0.8,
        ),
      ),
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
                  padding: const EdgeInsets.all(2),
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
              if (process.isNotEmpty) ...[
                Icon(
                  Icons.terminal_rounded,
                  size: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  process,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (conn.rule.isNotEmpty) ...[
                Icon(
                  Icons.alt_route_rounded,
                  size: 13,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(width: 4),
                Text(
                  conn.rulePayload.isNotEmpty
                      ? "${conn.rule}(${conn.rulePayload})"
                      : conn.rule,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
              const Spacer(),
              // Traffic transferred
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
