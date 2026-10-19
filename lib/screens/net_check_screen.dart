// ignore_for_file: empty_catches, unused_catch_stack

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
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';

class NetCheckScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: 'NetCheckScreen');
  }

  const NetCheckScreen({super.key});

  @override
  State<NetCheckScreen> createState() => _NetCheckScreenState();
}

class _NetCheckScreenState extends LasyRenderingState<NetCheckScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Diagnostics Tab State
  bool _diagnosing = false;
  bool _repairing = false;
  DiagnosticReport? _diagnosticReport;
  List<DiagnosticStepResult> _diagnosticSteps = NetworkDiagnostics.initialSteps();
  final Set<DiagnosticStepId> _expandedSteps = {};

  // Advanced Domain Query Tab State
  final TextEditingController _domainController = TextEditingController(
    text: 'example.com',
  );
  bool _domainChecking = false;
  String _dnsResult = '';
  String _directHttpResult = '';
  String _proxyHttpResult = '';
  String _routeTableResult = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _runDiagnostics();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _domainController.dispose();
    super.dispose();
  }

  Future<void> _runDiagnostics() async {
    if (_diagnosing) return;
    setState(() {
      _diagnosing = true;
      _diagnosticSteps = NetworkDiagnostics.initialSteps();
    });

    try {
      final report = await NetworkDiagnostics.runDiagnostics(
        onStepUpdate: (updatedStep) {
          if (!mounted) return;
          setState(() {
            final idx = _diagnosticSteps.indexWhere((s) => s.id == updatedStep.id);
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
              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(tcontext.NetCheckScreen.repairing),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );

    final success = await NetworkDiagnostics.repairAllIssues(_diagnosticReport!);
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
        backgroundColor: success ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorAmber,
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
          backgroundColor: ok ? ThemeDefine.kColorGreenBright : ThemeDefine.kColorAmber,
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

  Future<void> _copyCurrentView() async {
    final tcontext = Translations.of(context);
    try {
      if (_tabController.index == 0) {
        if (_diagnosticReport != null) {
          final text = NetworkDiagnostics.formatReportForClipboard(_diagnosticReport!);
          await Clipboard.setData(ClipboardData(text: text));
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(tcontext.NetCheckScreen.detailsCopied),
                duration: const Duration(seconds: 2),
              ),
            );
          }
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
        await Clipboard.setData(ClipboardData(text: text));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tcontext.NetCheckScreen.detailsCopied),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (_) {}
  }

  // --- Domain Check Methods (Preserved) ---
  Future<void> _startDomainCheck() async {
    final domain = _domainController.text.trim();
    final tcontext = Translations.of(context);
    if (domain.isEmpty) {
      setState(() {
        _dnsResult = tcontext.NetCheckScreen.enterDomain;
        _directHttpResult = '';
        _proxyHttpResult = '';
      });
      return;
    }

    setState(() {
      _domainChecking = true;
      _dnsResult = tcontext.NetCheckScreen.checking;
      _directHttpResult = tcontext.NetCheckScreen.checking;
      _proxyHttpResult = tcontext.NetCheckScreen.checking;
      _routeTableResult = tcontext.NetCheckScreen.checking;
    });

    final dnsResult = await _checkDns(domain, tcontext);
    if (!mounted) return;
    setState(() {
      _dnsResult = dnsResult;
    });

    String directResult = "";
    final result = await ClashHttpApi.getConfigs();
    if (result.error != null) {
      directResult = result.error!.message;
    } else {
      final configs = result.data!;
      if (configs.tun.enable) {
        directResult = await _checkHttpDirect(domain, tcontext);
      } else {
        directResult = tcontext.NetCheckScreen.tunNotEnabled;
      }
    }

    if (!mounted) return;
    setState(() {
      _directHttpResult = directResult;
    });

    final proxyResult = await _checkHttpWithMixPort(domain, tcontext);
    if (!mounted) return;
    setState(() {
      _proxyHttpResult = proxyResult;
    });

    if (!Platform.isIOS) {
      final routeTableResult = await SystemUtils.getRouteTable();
      if (!mounted) return;
      setState(() {
        _routeTableResult = routeTableResult;
      });
    }

    setState(() {
      _domainChecking = false;
    });
  }

  Future<String> _checkDns(String domain, Translations tcontext) async {
    final aResult = await ClashHttpApi.dnsQuery(domain, queryType: 'A');
    final aaaaResult = await ClashHttpApi.dnsQuery(domain, queryType: 'AAAA');
    final lines = <String>[];

    if (aResult.error == null) {
      final aList = aResult.data ?? [];
      if (aList.isEmpty) {
        lines.add('A: <empty>');
      } else {
        for (var i in aList) {
          if (NetworkUtils.isPublicIp(i)) {
            lines.add('A: $i');
          } else {
            lines.add('A: $i [${tcontext.NetCheckScreen.suspectedPollution}]');
          }
        }
      }
    } else {
      lines.add(tcontext.NetCheckScreen.aQueryFailed(p: aResult.error!.message));
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
            lines.add('AAAA: $i [${tcontext.NetCheckScreen.suspectedPollution}]');
          }
        }
      }
    } else {
      lines.add(tcontext.NetCheckScreen.aaaaQueryFailed(p: aaaaResult.error!.message));
    }

    return lines.join('\n');
  }

  Future<String> _checkHttpDirect(String domain, Translations tcontext) async {
    return _checkHttp(domain, tcontext, proxyPort: null);
  }

  Future<String> _checkHttpWithMixPort(String domain, Translations tcontext) async {
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
    try {
      final uri = Uri(scheme: 'https', host: domain, path: '/');
      client = HttpClient();
      const timeout = Duration(seconds: 15);
      client.connectionTimeout = timeout;

      if (proxyPort == null) {
        client.findProxy = (uri) => 'DIRECT';
      } else {
        client.findProxy = (uri) => 'PROXY 127.0.0.1:$proxyPort';
      }

      step = "getUrl";
      final request = await client.getUrl(uri).timeout(timeout);
      request.headers.set(
        HttpHeaders.userAgentHeader,
        HttpUtils.getUserAgent(),
      );
      step = "close";
      final response = await request.close().timeout(timeout);

      final statusLine =
          'HTTP Status:${response.statusCode} ${response.reasonPhrase}'.trim();

      if (response.statusCode == 200) {
        final lines = [tcontext.NetCheckScreen.success, 'HTTP Status: 200'];
        return lines.join('\n');
      }

      final lines = [tcontext.NetCheckScreen.failed, statusLine];
      return lines.join('\n');
    } catch (err) {
      return '$step: ${err.toString()}';
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

  String _getShortStepName(DiagnosticStepId id) {
    final isZh = LocaleSettings.currentLocale.languageCode.startsWith('zh');
    switch (id) {
      case DiagnosticStepId.physicalNetwork:
        return isZh ? "网卡" : "NIC";
      case DiagnosticStepId.dnsResolution:
        return "DNS";
      case DiagnosticStepId.coreAndPort:
        return isZh ? "内核" : "Core";
      case DiagnosticStepId.systemProxy:
        return isZh ? "代理" : "Proxy";
      case DiagnosticStepId.internetHandshake:
        return isZh ? "公网" : "WAN";
    }
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    if (ModalRoute.of(context)?.canPop ?? false)
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 40,
                          height: 36,
                          child: Icon(Icons.arrow_back_ios_outlined, size: 22),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        tcontext.NetCheckScreen.title,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: tcontext.NetCheckScreen.copyDetails,
                      icon: const Icon(Icons.copy_outlined, size: 22),
                      onPressed: _copyCurrentView,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Tab Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 42,
                  decoration: BoxDecoration(
                    color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorGreyLight.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    indicator: BoxDecoration(
                      color: isDark ? ThemeDefine.kColorDarkBorder : Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    labelColor: ThemeDefine.kColorBlue,
                    unselectedLabelColor: ThemeDefine.kColorGrey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(text: tcontext.NetCheckScreen.fullDiagnosticsTab),
                      Tab(text: tcontext.NetCheckScreen.advancedCheckTab),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Tab Views
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
      ),
    );
  }

  // ==========================================
  // TAB 1: 全链路体检与智能诊断
  // ==========================================
  Widget _buildDiagnosticsTab(Translations tcontext, bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      children: [
        _buildScoreCard(tcontext, isDark),
        const SizedBox(height: 16),
        _buildTopologyStrip(isDark),
        const SizedBox(height: 16),
        ..._diagnosticSteps.map((step) => _buildStepCard(step, tcontext, isDark)),
      ],
    );
  }

  Widget _buildScoreCard(Translations tcontext, bool isDark) {
    final score = _diagnosticReport?.healthScore ?? 100;
    final scoreColor = _getScoreColor(score);
    final hasIssues = _diagnosticReport?.hasIssues ?? false;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: ThemeDefine.kCardBorderRadius,
        side: BorderSide(
          color: isDark ? ThemeDefine.kColorDarkBorder : ThemeDefine.kColorGreyLight,
        ),
      ),
      color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 76,
                  height: 76,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 7,
                        color: isDark ? Colors.white12 : Colors.grey.shade200,
                      ),
                      CircularProgressIndicator(
                        value: _diagnosing ? null : (score / 100.0),
                        strokeWidth: 7,
                        strokeCap: StrokeCap.round,
                        color: _diagnosing ? ThemeDefine.kColorBlue : scoreColor,
                      ),
                      Center(
                        child: _diagnosing
                            ? const Icon(Icons.radar, color: ThemeDefine.kColorBlue, size: 28)
                            : Text(
                                "$score",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: scoreColor,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _diagnosing
                                ? tcontext.NetCheckScreen.diagnosing
                                : _getScoreTitle(score, tcontext),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (!_diagnosing && _diagnosticReport != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: scoreColor.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "${_diagnosticReport!.healthScore} / 100",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: scoreColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _diagnosing
                            ? tcontext.NetCheckScreen.checking
                            : (hasIssues
                                ? tcontext.NetCheckScreen.issueFound(
                                    count: _diagnosticReport!.issueCount,
                                  )
                                : tcontext.NetCheckScreen.noIssue),
                        style: TextStyle(
                          fontSize: 13,
                          color: hasIssues ? ThemeDefine.kColorAmber : ThemeDefine.kColorGrey,
                        ),
                      ),
                      if (_diagnosticReport != null && !_diagnosing) ...[
                        const SizedBox(height: 4),
                        Text(
                          "${_diagnosticReport!.duration.inMilliseconds}ms • ${Platform.operatingSystem}",
                          style: TextStyle(
                            fontSize: 11,
                            color: ThemeDefine.kColorGrey.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),
            Row(
              children: [
                if (hasIssues && !_diagnosing) ...[
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeDefine.kColorBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: ThemeDefine.kButtonBorderRadius,
                        ),
                      ),
                      onPressed: _repairing ? null : _repairAll,
                      icon: _repairing
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.auto_fix_high, size: 18),
                      label: Text(
                        _repairing
                            ? tcontext.NetCheckScreen.repairing
                            : tcontext.NetCheckScreen.oneClickRepair,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: ThemeDefine.kButtonBorderRadius,
                      ),
                    ),
                    onPressed: (_diagnosing || _repairing) ? null : _runDiagnostics,
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text(
                      _diagnosticReport == null
                          ? tcontext.NetCheckScreen.startDiagnostics
                          : tcontext.NetCheckScreen.reDiagnostics,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopologyStrip(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? ThemeDefine.kColorDarkBorder : ThemeDefine.kColorGreyLight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_diagnosticSteps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Connector line
            final prevStep = _diagnosticSteps[index ~/ 2];
            final nextStep = _diagnosticSteps[(index ~/ 2) + 1];
            final isFlowActive = prevStep.status == DiagnosticStatus.healthy &&
                (nextStep.status == DiagnosticStatus.healthy ||
                    nextStep.status == DiagnosticStatus.checking);

            return Expanded(
              child: Container(
                height: 2,
                color: isFlowActive
                    ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.6)
                    : (isDark ? Colors.white12 : Colors.grey.shade300),
              ),
            );
          }

          final step = _diagnosticSteps[index ~/ 2];
          final stepColor = _getStatusColor(step.status);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: stepColor.withValues(alpha: 0.15),
                  border: Border.all(
                    color: stepColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getStepIcon(step.id),
                  size: 20,
                  color: stepColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _getShortStepName(step.id),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildStepCard(
    DiagnosticStepResult step,
    Translations tcontext,
    bool isDark,
  ) {
    final statusColor = _getStatusColor(step.status);
    final isExpanded = _expandedSteps.contains(step.id);
    final hasIssue = step.status == DiagnosticStatus.warning || step.status == DiagnosticStatus.failed;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: hasIssue
              ? statusColor.withValues(alpha: 0.6)
              : (isDark ? ThemeDefine.kColorDarkBorder : ThemeDefine.kColorGreyLight),
          width: hasIssue ? 1.5 : 1.0,
        ),
      ),
      color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
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
                      Text(
                        _getStepTitle(step.id, tcontext),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeDefine.kColorGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (step.status == DiagnosticStatus.checking) ...[
                        SizedBox(
                          width: 10,
                          height: 10,
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      Text(
                        step.status == DiagnosticStatus.healthy
                            ? "${step.latencyMs}ms"
                            : (step.status == DiagnosticStatus.checking
                                ? tcontext.NetCheckScreen.checking
                                : (step.status == DiagnosticStatus.warning
                                    ? tcontext.NetCheckScreen.scoreWarning
                                    : (step.status == DiagnosticStatus.failed
                                        ? tcontext.NetCheckScreen.scoreCritical
                                        : "..."))),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (step.value != null && step.value!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                step.value!,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ],

            // Issue / Suggestion Banner
            if (hasIssue && step.issue != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: statusColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          step.status == DiagnosticStatus.failed
                              ? Icons.error_outline
                              : Icons.warning_amber_rounded,
                          size: 18,
                          color: statusColor,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            step.issue!,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (step.suggestion != null) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 26),
                        child: Text(
                          "${tcontext.NetCheckScreen.suggestedAction}: ${step.suggestion}",
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ),
                    ],
                    if (step.actionLabel != null && step.repairAction != null) ...[
                      const SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: statusColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _repairing ? null : () => _repairSingle(step),
                          icon: const Icon(Icons.build_outlined, size: 16),
                          label: Text(
                            step.actionLabel!,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            // Technical Details Toggle
            if (step.detail != null && step.detail!.isNotEmpty) ...[
              const SizedBox(height: 8),
              InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  setState(() {
                    if (isExpanded) {
                      _expandedSteps.remove(step.id);
                    } else {
                      _expandedSteps.add(step.id);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tcontext.NetCheckScreen.details,
                        style: TextStyle(
                          fontSize: 12,
                          color: ThemeDefine.kColorBlue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 16,
                        color: ThemeDefine.kColorBlue,
                      ),
                    ],
                  ),
                ),
              ),

              if (isExpanded) ...[
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? Colors.white12 : Colors.grey.shade300,
                    ),
                  ),
                  child: SelectableText(
                    step.detail!,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TAB 2: 高级单域名排查
  // ==========================================
  Widget _buildAdvancedCheckTab(Translations tcontext, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _domainController,
            decoration: InputDecoration(
              labelText: tcontext.NetCheckScreen.domainLabel,
              hintText: 'example.com',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _domainController.clear(),
              ),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _startDomainCheck(),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: ThemeDefine.kButtonBorderRadius,
              ),
            ),
            onPressed: _domainChecking ? null : _startDomainCheck,
            child: _domainChecking
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(tcontext.NetCheckScreen.checkButton),
          ),
          const SizedBox(height: 14),
          Expanded(
            child: ListView(
              children: [
                Text(" OS: ${Platform.operatingSystem}"),
                const SizedBox(height: 12),
                _buildSection(
                  tcontext.NetCheckScreen.dnsSection,
                  _dnsResult,
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildSection(
                  tcontext.NetCheckScreen.directHttpSection,
                  _directHttpResult,
                  isDark,
                ),
                const SizedBox(height: 12),
                _buildSection(
                  tcontext.NetCheckScreen.proxyHttpSection(
                    p: ClashSettingManager.getMixedPort(),
                  ),
                  _proxyHttpResult,
                  isDark,
                ),
                if (!Platform.isIOS) ...[
                  const SizedBox(height: 12),
                  _buildSection(
                    tcontext.NetCheckScreen.routeTableSection,
                    _routeTableResult,
                    isDark,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isDark) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? ThemeDefine.kColorDarkBorder : ThemeDefine.kColorGreyLight,
        ),
      ),
      color: isDark ? ThemeDefine.kColorDarkCard : ThemeDefine.kColorLightCard,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            if (content.isNotEmpty) ...[
              const SizedBox(height: 8),
              SelectableText(
                content,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
