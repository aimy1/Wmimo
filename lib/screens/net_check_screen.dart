// ignore_for_file: empty_catches

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/utils/http_utils.dart';
import 'package:wmimo/app/utils/network_diagnostics.dart';
import 'package:wmimo/app/utils/network_utils.dart';
import 'package:wmimo/app/utils/system_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class NetCheckScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: 'NetCheckScreen');
  }

  /// Normalizes user input (URL or host:port/path) into a clean domain/host string.
  static String normalizeDomainInput(String raw) {
    var trimmed = raw.trim();
    if (trimmed.contains('://')) {
      trimmed = Uri.tryParse(trimmed)?.host ?? trimmed;
    } else if (trimmed.contains('/')) {
      trimmed = trimmed.split('/').first;
    }
    if (trimmed.contains(':')) {
      trimmed = trimmed.split(':').first;
    }
    return trimmed.trim();
  }

  final bool autoStart;

  const NetCheckScreen({
    super.key,
    this.autoStart = true,
  });

  @override
  State<NetCheckScreen> createState() => _NetCheckScreenState();
}

enum _ProbeCardState {
  idle,
  checking,
  success,
  warning,
  error,
}

class _NetCheckScreenState extends LasyRenderingState<NetCheckScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Diagnostics Tab State
  bool _diagnosing = false;
  bool _repairing = false;
  DiagnosticReport? _diagnosticReport;
  List<DiagnosticStepResult> _diagnosticSteps =
      NetworkDiagnostics.initialSteps();
  final Set<DiagnosticStepId> _expandedSteps = {};

  // Advanced Domain Query Tab State
  final TextEditingController _domainController = TextEditingController(
    text: 'cloudflare.com',
  );
  bool _domainChecking = false;
  bool _hasRunDomainCheck = false;
  bool _routeTableExpanded = false;
  String _dnsResult = '';
  String _directHttpResult = '';
  String _proxyHttpResult = '';
  String _routeTableResult = '';

  static const List<String> _kPresetDomains = [
    'cloudflare.com',
    'github.com',
    'google.com',
    'baidu.com',
    'apple.com',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _runDiagnostics();
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _runDiagnostics() async {
    if (_diagnosing) return;
    final tcontext = Translations.of(context);
    setState(() {
      _diagnosing = true;
      _diagnosticSteps = NetworkDiagnostics.initialSteps(tcontext);
    });

    try {
      final report = await NetworkDiagnostics.runDiagnostics(
        translations: tcontext,
        onStepUpdate: (updatedStep) {
          if (!mounted) return;
          setState(() {
            final idx =
                _diagnosticSteps.indexWhere((s) => s.id == updatedStep.id);
            if (idx != -1) {
              _diagnosticSteps[idx] = updatedStep;
            }
          });
        },
      );

      if (!mounted) return;
      setState(() {
        _diagnosticReport = report;
        _diagnosticSteps = report.steps;
        _diagnosing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _diagnosing = false;
      });
    }
  }

  Future<void> _repairAll() async {
    if (_diagnosticReport == null || _repairing || _diagnosing) return;
    final tcontext = Translations.of(context);
    setState(() {
      _repairing = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Text(tcontext.NetCheckScreen.repairing),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    final success =
        await NetworkDiagnostics.repairAllIssues(_diagnosticReport!);
    if (!mounted) return;

    setState(() {
      _repairing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? tcontext.NetCheckScreen.repairSuccess
              : tcontext.NetCheckScreen.repairFailed,
        ),
        backgroundColor:
            success ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorAmber,
        duration: const Duration(seconds: 3),
      ),
    );

    await _runDiagnostics();
  }

  Future<void> _repairSingle(DiagnosticStepResult step) async {
    if (step.repairAction == null || _repairing || _diagnosing) return;
    final tcontext = Translations.of(context);
    setState(() {
      _repairing = true;
    });

    try {
      final ok = await step.repairAction!();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ok
                ? tcontext.NetCheckScreen.repairSuccess
                : tcontext.NetCheckScreen.repairFailed,
          ),
          backgroundColor:
              ok ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorAmber,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("${tcontext.NetCheckScreen.failed}: $e"),
          backgroundColor: ThemeDefine.kColorRed,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _repairing = false;
        });
        await _runDiagnostics();
      }
    }
  }

  Future<void> _copyTextWithToast(String text) async {
    if (text.trim().isEmpty) return;
    final tcontext = Translations.of(context);
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tcontext.NetCheckScreen.detailsCopied),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _copyCurrentView() async {
    try {
      if (_tabController.index == 0) {
        if (_diagnosticReport != null) {
          final text =
              NetworkDiagnostics.formatReportForClipboard(_diagnosticReport!);
          await _copyTextWithToast(text);
        }
      } else {
        final text = [
          "Domain: ${_domainController.text.trim()}",
          "OS: ${Platform.operatingSystem}",
          '1. DNS:',
          _dnsResult,
          '2. HTTP Via TUN:',
          _directHttpResult,
          '3. HTTP Via Proxy:',
          _proxyHttpResult,
          if (!Platform.isIOS) ...[
            '4. Route Table:',
            _routeTableResult,
          ],
        ].join('\n\n');
        await _copyTextWithToast(text);
      }
    } catch (_) {}
  }

  // --- Domain Check Methods ---
  Future<void> _startDomainCheck() async {
    final domain = NetCheckScreen.normalizeDomainInput(_domainController.text);
    final tcontext = Translations.of(context);
    if (domain.isEmpty) {
      setState(() {
        _hasRunDomainCheck = true;
        _dnsResult = tcontext.NetCheckScreen.enterDomain;
        _directHttpResult = '';
        _proxyHttpResult = '';
      });
      return;
    }
    if (domain != _domainController.text.trim()) {
      _domainController.text = domain;
    }

    setState(() {
      _domainChecking = true;
      _hasRunDomainCheck = true;
      _dnsResult = tcontext.NetCheckScreen.checking;
      _directHttpResult = tcontext.NetCheckScreen.checking;
      _proxyHttpResult = tcontext.NetCheckScreen.checking;
      _routeTableResult = tcontext.NetCheckScreen.checking;
    });

    await Future.wait<void>([
      () async {
        final dnsResult = await _checkDns(domain, tcontext);
        if (!mounted) return;
        setState(() {
          _dnsResult = dnsResult;
        });
      }(),
      () async {
        String directResult = "";
        final result = await ClashHttpApi.getConfigs();
        if (result.error != null) {
          directResult = result.error!.message;
        } else if (result.data!.tun.enable) {
          directResult = await _checkHttpDirect(domain, tcontext);
        } else {
          directResult = tcontext.NetCheckScreen.tunNotEnabled;
        }
        if (!mounted) return;
        setState(() {
          _directHttpResult = directResult;
        });
      }(),
      () async {
        final proxyResult = await _checkHttpWithMixPort(domain, tcontext);
        if (!mounted) return;
        setState(() {
          _proxyHttpResult = proxyResult;
        });
      }(),
      if (!Platform.isIOS)
        () async {
          final routeTableResult = await SystemUtils.getRouteTable();
          if (!mounted) return;
          setState(() {
            _routeTableResult = routeTableResult;
          });
        }(),
    ]);

    if (!mounted) return;
    setState(() {
      _domainChecking = false;
    });
  }

  Future<String> _checkDns(String domain, Translations tcontext) async {
    final sw = Stopwatch()..start();
    final results = await Future.wait([
      ClashHttpApi.dnsQuery(domain, queryType: 'A'),
      ClashHttpApi.dnsQuery(domain, queryType: 'AAAA'),
    ]);
    sw.stop();
    final aResult = results[0];
    final aaaaResult = results[1];
    final lines = <String>['Elapsed: ${sw.elapsedMilliseconds}ms'];

    if (aResult.error == null) {
      final aList = aResult.data ?? [];
      if (aList.isEmpty) {
        lines.add('A: <empty>');
      } else {
        for (var i in aList) {
          if (NetworkDiagnostics.isFakeIp(i)) {
            lines.add('A: $i [Fake-IP]');
          } else if (NetworkUtils.isPublicIp(i)) {
            lines.add('A: $i');
          } else {
            lines.add(
              'A: $i [${tcontext.NetCheckScreen.suspectedPollution}]',
            );
          }
        }
      }
    } else {
      lines.add(
        tcontext.NetCheckScreen.aQueryFailed(p: aResult.error!.message),
      );
    }

    if (aaaaResult.error == null) {
      final aaaaList = aaaaResult.data ?? [];
      if (aaaaList.isEmpty) {
        lines.add('AAAA: <empty>');
      } else {
        for (var i in aaaaList) {
          if (NetworkUtils.isPublicIp(i)) {
            lines.add('AAAA: $i');
          } else {
            lines.add(
              'AAAA: $i [${tcontext.NetCheckScreen.suspectedPollution}]',
            );
          }
        }
      }
    } else {
      lines.add(
        tcontext.NetCheckScreen.aaaaQueryFailed(p: aaaaResult.error!.message),
      );
    }

    return lines.join('\n');
  }

  Future<String> _checkHttpDirect(String domain, Translations tcontext) async {
    return _checkHttp(domain, tcontext, proxyPort: null);
  }

  Future<String> _checkHttpWithMixPort(
    String domain,
    Translations tcontext,
  ) async {
    final mixPort = ClashSettingManager.getMixedPort();
    return _checkHttp(domain, tcontext, proxyPort: mixPort);
  }

  Future<String> _checkHttp(
    String domain,
    Translations tcontext, {
    int? proxyPort,
  }) async {
    HttpClient? client;
    String step = "";
    final sw = Stopwatch()..start();
    try {
      final uri = Uri(scheme: 'https', host: domain, path: '/');
      client = HttpClient();
      const timeout = Duration(seconds: 10);
      client.connectionTimeout = timeout;

      if (proxyPort == null) {
        client.findProxy = (uri) => 'DIRECT';
      } else {
        client.findProxy = (uri) => 'PROXY 127.0.0.1:$proxyPort';
      }

      step = "getUrl";
      final request = await client.getUrl(uri).timeout(timeout);
      request.followRedirects = false;
      request.headers.set(
        HttpHeaders.userAgentHeader,
        HttpUtils.getUserAgent(),
      );
      step = "close";
      final response = await request.close().timeout(timeout);
      await response.drain<void>();
      sw.stop();

      final statusLine =
          'HTTP Status: ${response.statusCode} ${response.reasonPhrase}'.trim();
      final elapsedLine = 'Latency: ${sw.elapsedMilliseconds}ms';

      if (response.statusCode >= 200 && response.statusCode < 400) {
        return [
          tcontext.NetCheckScreen.success,
          statusLine,
          elapsedLine,
        ].join('\n');
      }

      return [
        tcontext.NetCheckScreen.failed,
        statusLine,
        elapsedLine,
      ].join('\n');
    } catch (err) {
      sw.stop();
      return '$step (${sw.elapsedMilliseconds}ms): ${err.toString()}';
    } finally {
      client?.close(force: true);
    }
  }

  // --- UI Helpers ---
  Color _getStatusColor(DiagnosticStatus status) {
    switch (status) {
      case DiagnosticStatus.healthy:
        return ThemeDefine.kColorGreenBright;
      case DiagnosticStatus.warning:
        return ThemeDefine.kColorAmber;
      case DiagnosticStatus.failed:
        return ThemeDefine.kColorRed;
      case DiagnosticStatus.checking:
        return ThemeDefine.kColorBlue;
      case DiagnosticStatus.idle:
        return ThemeDefine.kColorGrey;
    }
  }

  IconData _getStatusBadgeIcon(DiagnosticStatus status) {
    switch (status) {
      case DiagnosticStatus.healthy:
        return Icons.check_circle_rounded;
      case DiagnosticStatus.warning:
        return Icons.warning_amber_rounded;
      case DiagnosticStatus.failed:
        return Icons.cancel_rounded;
      case DiagnosticStatus.checking:
        return Icons.sync_rounded;
      case DiagnosticStatus.idle:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return ThemeDefine.kColorGreenBright;
    if (score >= 80) return ThemeDefine.kColorBlue;
    if (score >= 60) return ThemeDefine.kColorAmber;
    return ThemeDefine.kColorRed;
  }

  String _getScoreTitle(int score, Translations tcontext) {
    if (score >= 95) return tcontext.NetCheckScreen.scorePerfect;
    if (score >= 80) return tcontext.NetCheckScreen.scoreGood;
    if (score >= 60) return tcontext.NetCheckScreen.scoreWarning;
    return tcontext.NetCheckScreen.scoreCritical;
  }

  String _getStepTitle(DiagnosticStepId id, Translations tcontext) {
    switch (id) {
      case DiagnosticStepId.physicalNetwork:
        return tcontext.NetCheckScreen.stepPhysical;
      case DiagnosticStepId.dnsResolution:
        return tcontext.NetCheckScreen.stepDns;
      case DiagnosticStepId.coreAndPort:
        return tcontext.NetCheckScreen.stepCore;
      case DiagnosticStepId.systemProxy:
        return tcontext.NetCheckScreen.stepProxy;
      case DiagnosticStepId.internetHandshake:
        return tcontext.NetCheckScreen.stepHandshake;
    }
  }

  IconData _getStepIcon(DiagnosticStepId id) {
    switch (id) {
      case DiagnosticStepId.physicalNetwork:
        return Icons.lan_outlined;
      case DiagnosticStepId.dnsResolution:
        return Icons.dns_outlined;
      case DiagnosticStepId.coreAndPort:
        return Icons.memory_outlined;
      case DiagnosticStepId.systemProxy:
        return Icons.vpn_lock_outlined;
      case DiagnosticStepId.internetHandshake:
        return Icons.public_outlined;
    }
  }

  String _getShortStepName(DiagnosticStepId id, Translations tcontext) {
    switch (id) {
      case DiagnosticStepId.physicalNetwork:
        return tcontext.NetCheckScreen.shortStepPhysical;
      case DiagnosticStepId.dnsResolution:
        return tcontext.NetCheckScreen.shortStepDns;
      case DiagnosticStepId.coreAndPort:
        return tcontext.NetCheckScreen.shortStepCore;
      case DiagnosticStepId.systemProxy:
        return tcontext.NetCheckScreen.shortStepProxy;
      case DiagnosticStepId.internetHandshake:
        return tcontext.NetCheckScreen.shortStepHandshake;
    }
  }

  String _getStepDescription(DiagnosticStepId id, Translations tcontext) {
    switch (id) {
      case DiagnosticStepId.physicalNetwork:
        return tcontext.NetCheckScreen.stepPhysicalDesc;
      case DiagnosticStepId.dnsResolution:
        return tcontext.NetCheckScreen.stepDnsDesc;
      case DiagnosticStepId.coreAndPort:
        return tcontext.NetCheckScreen.stepCoreDesc;
      case DiagnosticStepId.systemProxy:
        return tcontext.NetCheckScreen.stepProxyDesc;
      case DiagnosticStepId.internetHandshake:
        return tcontext.NetCheckScreen.stepHandshakeDesc;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isBusy = _tabController.index == 0
        ? (_diagnosing || _repairing)
        : _domainChecking;

    return Scaffold(
      appBar: WmimoAppBar(
        title: tcontext.NetCheckScreen.title,
        badge: Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
            color: ThemeDefine.kColorBlue.withValues(
              alpha: isDark ? 0.2 : 0.1,
            ),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: ThemeDefine.kColorBlue.withValues(alpha: 0.3),
              width: 0.8,
            ),
          ),
          child: Text(
            Platform.operatingSystem.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              fontFamily: 'monospace',
              color: ThemeDefine.kColorBlue,
              letterSpacing: 0.4,
            ),
          ),
        ),
        actions: [
          IconButton(
            tooltip: _tabController.index == 0
                ? tcontext.NetCheckScreen.reDiagnostics
                : tcontext.NetCheckScreen.checkButton,
            icon: isBusy
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: ThemeDefine.kColorBlue,
                    ),
                  )
                : const Icon(Icons.refresh_rounded, size: 20),
            onPressed: isBusy
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    if (_tabController.index == 0) {
                      _runDiagnostics();
                    } else {
                      _startDomainCheck();
                    }
                  },
          ),
          IconButton(
            tooltip: tcontext.NetCheckScreen.copyDetails,
            icon: const Icon(Icons.copy_all_rounded, size: 20),
            onPressed: () {
              HapticFeedback.selectionClick();
              _copyCurrentView();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 6),
            _buildSegmentedTabBar(tcontext, isDark),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildDiagnosticsTab(tcontext, isDark),
                  _buildAdvancedCheckTab(tcontext, isDark),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSegmentedTabBar(Translations tcontext, bool isDark) {
    final issueCount = _diagnosticReport?.issueCount ?? 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 44,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isDark
              ? ThemeDefine.kColorDarkInner
              : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isDark
                ? ThemeDefine.kColorDarkBorder
                : const Color(0xFFE2E8F0),
            width: 0.8,
          ),
        ),
        child: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            color: isDark ? ThemeDefine.kColorDarkElevated : Colors.white,
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.04),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          labelColor: ThemeDefine.kColorBlue,
          unselectedLabelColor: isDark ? Colors.white60 : const Color(0xFF64748B),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.radar_rounded, size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      tcontext.NetCheckScreen.fullDiagnosticsTab,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (!_diagnosing && issueCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: (_diagnosticReport?.hasFatalError ?? false)
                            ? ThemeDefine.kColorRed
                            : ThemeDefine.kColorAmber,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$issueCount',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.travel_explore_rounded, size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      tcontext.NetCheckScreen.advancedCheckTab,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 1: 全链路体检与智能诊断
  // ==========================================
  Widget _buildDiagnosticsTab(Translations tcontext, bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _buildScoreCard(tcontext, isDark),
        const SizedBox(height: 12),
        _buildTopologyStrip(isDark, tcontext),
        const SizedBox(height: 12),
        for (int i = 0; i < _diagnosticSteps.length; i++)
          _buildStepCard(_diagnosticSteps[i], i + 1, tcontext, isDark),
      ],
    );
  }

  Widget _buildScoreCard(Translations tcontext, bool isDark) {
    final score = _diagnosticReport?.healthScore ?? 100;
    final scoreColor =
        _diagnosing ? ThemeDefine.kColorBlue : _getScoreColor(score);
    final hasIssues = _diagnosticReport?.hasIssues ?? false;
    final completedSteps = _diagnosticSteps
        .where(
          (s) =>
              s.status != DiagnosticStatus.idle &&
              s.status != DiagnosticStatus.checking,
        )
        .length;
    final healthySteps = _diagnosticSteps
        .where((s) => s.status == DiagnosticStatus.healthy)
        .length;
    final issueSteps = _diagnosticSteps
        .where(
          (s) =>
              s.status == DiagnosticStatus.warning ||
              s.status == DiagnosticStatus.failed,
        )
        .length;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: hasIssues && !_diagnosing
              ? scoreColor.withValues(alpha: 0.45)
              : (isDark
                  ? ThemeDefine.kColorDarkBorder
                  : ThemeDefine.kColorGreyLight),
          width: hasIssues && !_diagnosing ? 1.2 : 0.8,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            scoreColor.withValues(alpha: isDark ? 0.10 : 0.06),
            isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Radial Score Gauge
              Container(
                width: 82,
                height: 82,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: scoreColor.withValues(alpha: isDark ? 0.12 : 0.08),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 6.5,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.06),
                    ),
                    CircularProgressIndicator(
                      value: _diagnosing
                          ? (completedSteps > 0
                              ? completedSteps / _diagnosticSteps.length
                              : null)
                          : (score / 100.0),
                      strokeWidth: 6.5,
                      strokeCap: StrokeCap.round,
                      color: scoreColor,
                    ),
                    Center(
                      child: _diagnosing
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.radar_rounded,
                                  color: ThemeDefine.kColorBlue,
                                  size: 22,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "$completedSteps/${_diagnosticSteps.length}",
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
                                    color: ThemeDefine.kColorBlue,
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "$score",
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w800,
                                    height: 1.05,
                                    color: scoreColor,
                                  ),
                                ),
                                Text(
                                  tcontext.NetCheckScreen.healthScore,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white54
                                        : Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Status Summary & Conclusion
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            _diagnosing
                                ? tcontext.NetCheckScreen.diagnosing
                                : _getScoreTitle(score, tcontext),
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color: scoreColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _diagnosing
                                ? tcontext.NetCheckScreen.checking
                                : (hasIssues
                                    ? tcontext.NetCheckScreen.issueFound(
                                        count: _diagnosticReport!.issueCount,
                                      )
                                    : tcontext.NetCheckScreen.noIssue),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: scoreColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _diagnosing
                          ? "${tcontext.NetCheckScreen.checking} ($completedSteps/${_diagnosticSteps.length})"
                          : (_diagnosticReport?.overallConclusion ??
                              tcontext.NetCheckScreen.noIssue),
                      style: TextStyle(
                        fontSize: 12.5,
                        height: 1.35,
                        color: isDark ? Colors.white70 : const Color(0xFF475569),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Telemetry Metric Chips Row
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        _buildMetricPill(
                          icon: Icons.check_circle_outline_rounded,
                          label: "$healthySteps/${_diagnosticSteps.length}",
                          color: ThemeDefine.kColorGreenBright,
                          isDark: isDark,
                        ),
                        if (issueSteps > 0)
                          _buildMetricPill(
                            icon: Icons.warning_amber_rounded,
                            label: tcontext.NetCheckScreen.issueFound(
                              count: issueSteps,
                            ),
                            color: (_diagnosticReport?.hasFatalError ?? false)
                                ? ThemeDefine.kColorRed
                                : ThemeDefine.kColorAmber,
                            isDark: isDark,
                          ),
                        if (_diagnosticReport != null && !_diagnosing)
                          _buildMetricPill(
                            icon: Icons.timer_outlined,
                            label:
                                "${_diagnosticReport!.duration.inMilliseconds}ms",
                            color: ThemeDefine.kColorBlue,
                            isDark: isDark,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
            height: 1,
            color: isDark
                ? ThemeDefine.kColorDarkBorder
                : const Color(0xFFE2E8F0),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (hasIssues && !_diagnosing) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeDefine.kColorBlue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: ThemeDefine.kButtonBorderRadius,
                      ),
                    ),
                    onPressed: _repairing ? null : _repairAll,
                    icon: _repairing
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.auto_fix_high_rounded, size: 17),
                    label: Text(
                      _repairing
                          ? tcontext.NetCheckScreen.repairing
                          : tcontext.NetCheckScreen.oneClickRepair,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    side: BorderSide(
                      color: isDark
                          ? ThemeDefine.kColorDarkBorder
                          : const Color(0xFFCBD5E1),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: ThemeDefine.kButtonBorderRadius,
                    ),
                  ),
                  onPressed:
                      (_diagnosing || _repairing) ? null : _runDiagnostics,
                  icon: const Icon(Icons.refresh_rounded, size: 17),
                  label: Text(
                    _diagnosticReport == null
                        ? tcontext.NetCheckScreen.startDiagnostics
                        : tcontext.NetCheckScreen.reDiagnostics,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.10),
        borderRadius: BorderRadius.circular(7),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.7,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopologyStrip(bool isDark, Translations tcontext) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : ThemeDefine.kColorGreyLight,
          width: 0.8,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(_diagnosticSteps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final prevStep = _diagnosticSteps[index ~/ 2];
            final nextStep = _diagnosticSteps[(index ~/ 2) + 1];
            final isFlowHealthy = prevStep.status == DiagnosticStatus.healthy &&
                nextStep.status == DiagnosticStatus.healthy;
            final isFlowActive = prevStep.status == DiagnosticStatus.healthy &&
                nextStep.status == DiagnosticStatus.checking;
            final hasFlowError = prevStep.status == DiagnosticStatus.failed ||
                nextStep.status == DiagnosticStatus.failed;

            final lineColor = isFlowHealthy
                ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.65)
                : (isFlowActive
                    ? ThemeDefine.kColorBlue.withValues(alpha: 0.65)
                    : (hasFlowError
                        ? ThemeDefine.kColorRed.withValues(alpha: 0.4)
                        : (isDark ? Colors.white12 : Colors.grey.shade300)));

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Container(
                  height: 2.2,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: lineColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final step = _diagnosticSteps[stepIndex];
          final stepColor = _getStatusColor(step.status);
          final isSelected = _expandedSteps.contains(step.id);

          return InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              if (step.detail == null || step.detail!.isEmpty) return;
              HapticFeedback.selectionClick();
              setState(() {
                if (isSelected) {
                  _expandedSteps.remove(step.id);
                } else {
                  _expandedSteps.add(step.id);
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      AnimatedContainer(
                        duration: ThemeDefine.durationState,
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: stepColor.withValues(
                            alpha: isSelected ? 0.24 : 0.12,
                          ),
                          border: Border.all(
                            color: stepColor,
                            width: isSelected ? 2.2 : 1.6,
                          ),
                        ),
                        child: Icon(
                          _getStepIcon(step.id),
                          size: 18,
                          color: stepColor,
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: -2,
                        child: Container(
                          padding: const EdgeInsets.all(1.5),
                          decoration: BoxDecoration(
                            color: isDark
                                ? ThemeDefine.kColorDarkCard
                                : Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: step.status == DiagnosticStatus.checking
                              ? SizedBox(
                                  width: 11,
                                  height: 11,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.6,
                                    color: stepColor,
                                  ),
                                )
                              : Icon(
                                  _getStatusBadgeIcon(step.status),
                                  size: 12,
                                  color: stepColor,
                                ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _getShortStepName(step.id, tcontext),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected
                          ? stepColor
                          : (isDark ? Colors.white70 : Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    step.status == DiagnosticStatus.checking ||
                            step.status == DiagnosticStatus.idle
                        ? '...'
                        : '${step.latencyMs}ms',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w600,
                      color: stepColor.withValues(alpha: 0.85),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepCard(
    DiagnosticStepResult step,
    int stepNumber,
    Translations tcontext,
    bool isDark,
  ) {
    final statusColor = _getStatusColor(step.status);
    final isExpanded = _expandedSteps.contains(step.id);
    final hasIssue = step.status == DiagnosticStatus.warning ||
        step.status == DiagnosticStatus.failed;
    final hasDetail = step.detail != null && step.detail!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: hasIssue
              ? statusColor.withValues(alpha: 0.55)
              : (isDark
                  ? ThemeDefine.kColorDarkBorder
                  : ThemeDefine.kColorGreyLight),
          width: hasIssue ? 1.3 : 0.8,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: hasDetail
              ? () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    if (isExpanded) {
                      _expandedSteps.remove(step.id);
                    } else {
                      _expandedSteps.add(step.id);
                    }
                  });
                }
              : null,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Row
                Row(
                  children: [
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.25),
                          width: 0.8,
                        ),
                      ),
                      child: Icon(
                        _getStepIcon(step.id),
                        size: 20,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.07)
                                      : Colors.black.withValues(alpha: 0.05),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  '0$stepNumber',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white60
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 7),
                              Flexible(
                                child: Text(
                                  _getStepTitle(step.id, tcontext),
                                  style: const TextStyle(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Text(
                            _getStepDescription(step.id, tcontext),
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: ThemeDefine.kColorGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (step.status == DiagnosticStatus.checking) ...[
                            SizedBox(
                              width: 10,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.6,
                                color: statusColor,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ] else ...[
                            Icon(
                              _getStatusBadgeIcon(step.status),
                              size: 12,
                              color: statusColor,
                            ),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            step.status == DiagnosticStatus.healthy
                                ? "${step.latencyMs}ms"
                                : (step.status == DiagnosticStatus.checking
                                    ? tcontext.NetCheckScreen.checking
                                    : (step.status == DiagnosticStatus.warning
                                        ? tcontext.NetCheckScreen.scoreWarning
                                        : (step.status ==
                                                DiagnosticStatus.failed
                                            ? tcontext
                                                .NetCheckScreen.scoreCritical
                                            : "..."))),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (hasDetail) ...[
                      const SizedBox(width: 4),
                      Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: ThemeDefine.kColorGrey,
                      ),
                    ],
                  ],
                ),

                // Structured Result Readout Bar
                if (step.value != null && step.value!.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? ThemeDefine.kColorDarkInner
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: isDark
                            ? ThemeDefine.kColorDarkBorder
                            : const Color(0xFFE2E8F0),
                        width: 0.7,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            step.value!,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.88)
                                  : const Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Issue / Suggestion Banner
                if (hasIssue && step.issue != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.09),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: statusColor.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              step.status == DiagnosticStatus.failed
                                  ? Icons.error_outline_rounded
                                  : Icons.warning_amber_rounded,
                              size: 17,
                              color: statusColor,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                step.issue!,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (step.suggestion != null) ...[
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${tcontext.NetCheckScreen.suggestedAction}: ${step.suggestion}",
                              style: TextStyle(
                                fontSize: 12,
                                height: 1.35,
                                color: isDark ? Colors.white70 : Colors.black87,
                              ),
                            ),
                          ),
                        ],
                        if (step.actionLabel != null &&
                            step.repairAction != null) ...[
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: statusColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 7,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: _repairing
                                  ? null
                                  : () => _repairSingle(step),
                              icon: const Icon(
                                Icons.build_circle_outlined,
                                size: 15,
                              ),
                              label: Text(
                                step.actionLabel!,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],

                // Collapsible Technical Telemetry Drawer
                if (hasDetail && isExpanded) ...[
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(11, 8, 8, 10),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF101012)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(9),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.1)
                            : const Color(0xFFCBD5E1),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.terminal_rounded,
                              size: 13,
                              color: ThemeDefine.kColorBlue,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              tcontext.NetCheckScreen.details,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: ThemeDefine.kColorBlue,
                              ),
                            ),
                            const Spacer(),
                            InkWell(
                              borderRadius: BorderRadius.circular(6),
                              onTap: () => _copyTextWithToast(step.detail!),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.copy_rounded,
                                      size: 12,
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.black54,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      tcontext.NetCheckScreen.copyDetails,
                                      style: TextStyle(
                                        fontSize: 10.5,
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        SelectableText(
                          step.detail!,
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11.5,
                            height: 1.45,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.85)
                                : const Color(0xFF334155),
                          ),
                        ),
                      ],
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

  // ==========================================
  // TAB 2: 高级单域名排查
  // ==========================================
  Widget _buildAdvancedCheckTab(Translations tcontext, bool isDark) {
    final mixedPort = ClashSettingManager.getMixedPort();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      children: [
        _buildDomainConsoleCard(tcontext, isDark, mixedPort),
        const SizedBox(height: 12),
        _buildProbeCard(
          indexLabel: '01',
          icon: Icons.dns_outlined,
          title: tcontext.NetCheckScreen.dnsSection,
          content: _dnsResult,
          state: _evaluateDnsProbeState(_dnsResult, tcontext),
          latencyBadge: _extractLatency(_dnsResult),
          tcontext: tcontext,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _buildProbeCard(
          indexLabel: '02',
          icon: Icons.shield_outlined,
          title: tcontext.NetCheckScreen.directHttpSection,
          content: _directHttpResult,
          state: _evaluateHttpProbeState(_directHttpResult, tcontext),
          latencyBadge: _extractLatency(_directHttpResult),
          tcontext: tcontext,
          isDark: isDark,
        ),
        const SizedBox(height: 10),
        _buildProbeCard(
          indexLabel: '03',
          icon: Icons.swap_horiz_rounded,
          title: tcontext.NetCheckScreen.proxyHttpSection(p: mixedPort),
          content: _proxyHttpResult,
          state: _evaluateHttpProbeState(_proxyHttpResult, tcontext),
          latencyBadge: _extractLatency(_proxyHttpResult),
          tcontext: tcontext,
          isDark: isDark,
        ),
        if (!Platform.isIOS) ...[
          const SizedBox(height: 10),
          _buildRouteTableCard(tcontext, isDark),
        ],
      ],
    );
  }

  Widget _buildDomainConsoleCard(
    Translations tcontext,
    bool isDark,
    int mixedPort,
  ) {
    final currentDomain =
        NetCheckScreen.normalizeDomainInput(_domainController.text);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: ThemeDefine.kCardBorderRadius,
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : ThemeDefine.kColorGreyLight,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark
                        ? ThemeDefine.kColorDarkInner
                        : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: isDark
                          ? ThemeDefine.kColorDarkBorder
                          : const Color(0xFFCBD5E1),
                      width: 0.8,
                    ),
                  ),
                  child: TextField(
                    controller: _domainController,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'monospace',
                    ),
                    decoration: InputDecoration(
                      hintText: 'example.com',
                      labelText: tcontext.NetCheckScreen.domainLabel,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      prefixIcon: const Icon(
                        Icons.language_rounded,
                        size: 18,
                        color: ThemeDefine.kColorBlue,
                      ),
                      suffixIcon: _domainController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close_rounded, size: 16),
                              onPressed: () {
                                setState(() {
                                  _domainController.clear();
                                });
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 11,
                      ),
                    ),
                    textInputAction: TextInputAction.search,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) => _startDomainCheck(),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 42,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeDefine.kColorBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                  onPressed: _domainChecking ? null : _startDomainCheck,
                  icon: _domainChecking
                      ? const SizedBox(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.play_arrow_rounded, size: 18),
                  label: Text(
                    tcontext.NetCheckScreen.checkButton,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Preset Target Domains
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _kPresetDomains.map((domain) {
              final isSelected = currentDomain == domain;
              return InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _domainChecking
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        _domainController.text = domain;
                        _startDomainCheck();
                      },
                child: AnimatedContainer(
                  duration: ThemeDefine.durationMicro,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 4.5,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? ThemeDefine.kColorBlue.withValues(
                            alpha: isDark ? 0.22 : 0.12,
                          )
                        : (isDark
                            ? ThemeDefine.kColorDarkInner
                            : const Color(0xFFF1F5F9)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? ThemeDefine.kColorBlue.withValues(alpha: 0.45)
                          : (isDark
                              ? ThemeDefine.kColorDarkBorder
                              : const Color(0xFFE2E8F0)),
                      width: 0.8,
                    ),
                  ),
                  child: Text(
                    domain,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontFamily: 'monospace',
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? ThemeDefine.kColorBlue
                          : (isDark ? Colors.white70 : const Color(0xFF475569)),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 10),
          // Environment Info Strip
          Row(
            children: [
              _buildMetricPill(
                icon: Icons.desktop_windows_outlined,
                label: "OS: ${Platform.operatingSystem.toUpperCase()}",
                color: ThemeDefine.kColorBlue,
                isDark: isDark,
              ),
              const SizedBox(width: 8),
              _buildMetricPill(
                icon: Icons.hub_outlined,
                label: "127.0.0.1:$mixedPort",
                color: ThemeDefine.kColorGreenBright,
                isDark: isDark,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _ProbeCardState _evaluateDnsProbeState(
    String content,
    Translations tcontext,
  ) {
    if (_domainChecking && content == tcontext.NetCheckScreen.checking) {
      return _ProbeCardState.checking;
    }
    if (content.isEmpty) return _ProbeCardState.idle;
    if (content == tcontext.NetCheckScreen.enterDomain) {
      return _ProbeCardState.warning;
    }
    if (content.contains(tcontext.NetCheckScreen.suspectedPollution)) {
      return _ProbeCardState.warning;
    }
    if (content.contains('A: ') && !content.contains('A: <empty>')) {
      return _ProbeCardState.success;
    }
    return _ProbeCardState.error;
  }

  _ProbeCardState _evaluateHttpProbeState(
    String content,
    Translations tcontext,
  ) {
    if (_domainChecking && content == tcontext.NetCheckScreen.checking) {
      return _ProbeCardState.checking;
    }
    if (content.isEmpty) return _ProbeCardState.idle;
    if (content == tcontext.NetCheckScreen.tunNotEnabled) {
      return _ProbeCardState.warning;
    }
    if (content.startsWith(tcontext.NetCheckScreen.success)) {
      return _ProbeCardState.success;
    }
    return _ProbeCardState.error;
  }

  String? _extractLatency(String content) {
    final match = RegExp(r'(?:Elapsed|Latency):\s*(\d+ms)').firstMatch(content);
    if (match != null) return match.group(1);
    final errMatch = RegExp(r'\((\d+ms)\):').firstMatch(content);
    return errMatch?.group(1);
  }

  Color _getProbeStateColor(_ProbeCardState state) {
    switch (state) {
      case _ProbeCardState.success:
        return ThemeDefine.kColorGreenBright;
      case _ProbeCardState.warning:
        return ThemeDefine.kColorAmber;
      case _ProbeCardState.error:
        return ThemeDefine.kColorRed;
      case _ProbeCardState.checking:
        return ThemeDefine.kColorBlue;
      case _ProbeCardState.idle:
        return ThemeDefine.kColorGrey;
    }
  }

  String _getProbeStateLabel(_ProbeCardState state, Translations tcontext) {
    switch (state) {
      case _ProbeCardState.success:
        return tcontext.NetCheckScreen.success;
      case _ProbeCardState.warning:
        return tcontext.NetCheckScreen.scoreWarning;
      case _ProbeCardState.error:
        return tcontext.NetCheckScreen.failed;
      case _ProbeCardState.checking:
        return tcontext.NetCheckScreen.checking;
      case _ProbeCardState.idle:
        return tcontext.NetCheckScreen.checkButton;
    }
  }

  Widget _buildProbeCard({
    required String indexLabel,
    required IconData icon,
    required String title,
    required String content,
    required _ProbeCardState state,
    required String? latencyBadge,
    required Translations tcontext,
    required bool isDark,
  }) {
    final stateColor = _getProbeStateColor(state);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: (state == _ProbeCardState.error ||
                  state == _ProbeCardState.warning)
              ? stateColor.withValues(alpha: 0.45)
              : (isDark
                  ? ThemeDefine.kColorDarkBorder
                  : ThemeDefine.kColorGreyLight),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, size: 18, color: stateColor),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.07)
                      : Colors.black.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  indexLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (latencyBadge != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: ThemeDefine.kColorBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    latencyBadge,
                    style: const TextStyle(
                      fontSize: 10.5,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      color: ThemeDefine.kColorBlue,
                    ),
                  ),
                ),
              ],
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: stateColor.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (state == _ProbeCardState.checking) ...[
                      SizedBox(
                        width: 10,
                        height: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                          color: stateColor,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    Text(
                      _getProbeStateLabel(state, tcontext),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: stateColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (content.isNotEmpty &&
                  state != _ProbeCardState.checking &&
                  state != _ProbeCardState.idle) ...[
                const SizedBox(width: 4),
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () => _copyTextWithToast(content),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.copy_rounded,
                      size: 14,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark
                  ? ThemeDefine.kColorDarkInner
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: isDark
                    ? ThemeDefine.kColorDarkBorder
                    : const Color(0xFFE2E8F0),
                width: 0.7,
              ),
            ),
            child: SelectableText(
              content.isNotEmpty
                  ? content
                  : (_hasRunDomainCheck
                      ? '-'
                      : '${tcontext.NetCheckScreen.enterDomain} • ${tcontext.NetCheckScreen.checkButton}'),
              style: TextStyle(
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.45,
                color: content.isNotEmpty
                    ? (isDark
                        ? Colors.white.withValues(alpha: 0.88)
                        : const Color(0xFF1E293B))
                    : ThemeDefine.kColorGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteTableCard(Translations tcontext, bool isDark) {
    final hasContent = _routeTableResult.isNotEmpty &&
        _routeTableResult != tcontext.NetCheckScreen.checking;
    final linesCount =
        hasContent ? _routeTableResult.trim().split('\n').length : 0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : ThemeDefine.kColorGreyLight,
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: hasContent
                ? () {
                    setState(() {
                      _routeTableExpanded = !_routeTableExpanded;
                    });
                  }
                : null,
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: ThemeDefine.kColorBlue.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.alt_route_rounded,
                    size: 18,
                    color: ThemeDefine.kColorBlue,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.07)
                        : Colors.black.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '04',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    tcontext.NetCheckScreen.routeTableSection,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (linesCount > 0) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 2.5,
                    ),
                    decoration: BoxDecoration(
                      color: ThemeDefine.kColorBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$linesCount lines',
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w700,
                        color: ThemeDefine.kColorBlue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(6),
                    onTap: () => _copyTextWithToast(_routeTableResult),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    _routeTableExpanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: ThemeDefine.kColorGrey,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _routeTableExpanded ? 460 : 160,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF101012)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(9),
                border: Border.all(
                  color: isDark
                      ? ThemeDefine.kColorDarkBorder
                      : const Color(0xFFE2E8F0),
                  width: 0.7,
                ),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _routeTableResult.isNotEmpty
                      ? _routeTableResult
                      : (_hasRunDomainCheck
                          ? '-'
                          : '${tcontext.NetCheckScreen.enterDomain} • ${tcontext.NetCheckScreen.checkButton}'),
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    height: 1.4,
                    color: _routeTableResult.isNotEmpty
                        ? (isDark
                            ? Colors.white.withValues(alpha: 0.85)
                            : const Color(0xFF334155))
                        : ThemeDefine.kColorGrey,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
