import 'dart:async';
import 'dart:io';

import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/log.dart';
import 'package:wmimo/i18n/strings.g.dart';

enum DiagnosticStatus {
  idle,
  checking,
  healthy, // Passed / Green
  warning, // Minor warning / Orange
  failed, // Problem detected / Red
}

enum DiagnosticStepId {
  physicalNetwork, // 1. 本机物理网卡与局域网网关
  dnsResolution, // 2. 本地 DNS 解析与 Fake-IP 引擎
  coreAndPort, // 3. Wmimo 内核运行与端口监听
  systemProxy, // 4. 系统代理状态与配置对齐
  internetHandshake, // 5. 代理节点与公网端到端握手
}

class DiagnosticStepResult {
  final DiagnosticStepId id;
  final String title;
  final String description;
  DiagnosticStatus status;
  String? value;
  String? detail;
  String? issue;
  String? suggestion;
  String? actionLabel;
  Future<bool> Function()? repairAction;
  int latencyMs;

  DiagnosticStepResult({
    required this.id,
    required this.title,
    required this.description,
    this.status = DiagnosticStatus.idle,
    this.value,
    this.detail,
    this.issue,
    this.suggestion,
    this.actionLabel,
    this.repairAction,
    this.latencyMs = 0,
  });

  DiagnosticStepResult copyWith({
    DiagnosticStatus? status,
    String? value,
    String? detail,
    String? issue,
    String? suggestion,
    String? actionLabel,
    Future<bool> Function()? repairAction,
    int? latencyMs,
  }) {
    return DiagnosticStepResult(
      id: id,
      title: title,
      description: description,
      status: status ?? this.status,
      value: value ?? this.value,
      detail: detail ?? this.detail,
      issue: issue ?? this.issue,
      suggestion: suggestion ?? this.suggestion,
      actionLabel: actionLabel ?? this.actionLabel,
      repairAction: repairAction ?? this.repairAction,
      latencyMs: latencyMs ?? this.latencyMs,
    );
  }
}

class DiagnosticReport {
  final int healthScore;
  final List<DiagnosticStepResult> steps;
  final DateTime timestamp;
  final String overallConclusion;
  final Duration duration;

  const DiagnosticReport({
    required this.healthScore,
    required this.steps,
    required this.timestamp,
    required this.overallConclusion,
    required this.duration,
  });

  bool get hasIssues => healthScore < 100;
  bool get hasFatalError => steps.any((s) => s.status == DiagnosticStatus.failed);
  int get issueCount => steps.where((s) => s.status == DiagnosticStatus.failed || s.status == DiagnosticStatus.warning).length;
}

class NetworkDiagnostics {
  static List<DiagnosticStepResult> initialSteps([Translations? translations]) {
    final tr = translations ?? t;
    return [
      DiagnosticStepResult(
        id: DiagnosticStepId.physicalNetwork,
        title: tr.NetCheckScreen.stepPhysical,
        description: tr.NetCheckScreen.stepPhysicalDesc,
      ),
      DiagnosticStepResult(
        id: DiagnosticStepId.dnsResolution,
        title: tr.NetCheckScreen.stepDns,
        description: tr.NetCheckScreen.stepDnsDesc,
      ),
      DiagnosticStepResult(
        id: DiagnosticStepId.coreAndPort,
        title: tr.NetCheckScreen.stepCore,
        description: tr.NetCheckScreen.stepCoreDesc,
      ),
      DiagnosticStepResult(
        id: DiagnosticStepId.systemProxy,
        title: tr.NetCheckScreen.stepProxy,
        description: tr.NetCheckScreen.stepProxyDesc,
      ),
      DiagnosticStepResult(
        id: DiagnosticStepId.internetHandshake,
        title: tr.NetCheckScreen.stepHandshake,
        description: tr.NetCheckScreen.stepHandshakeDesc,
      ),
    ];
  }

  /// Runs the full 5-level diagnostics pipeline sequentially
  static Future<DiagnosticReport> runDiagnostics({
    Translations? translations,
    void Function(DiagnosticStepResult step)? onStepUpdate,
  }) async {
    final tr = translations ?? t;
    final startTime = DateTime.now();
    final steps = initialSteps(tr);

    // Step 1: Physical Network & Gateway
    steps[0].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[0]);
    steps[0] = await _checkPhysicalNetwork(steps[0], tr);
    onStepUpdate?.call(steps[0]);

    // Step 2: DNS Resolution
    steps[1].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[1]);
    steps[1] = await _checkDnsResolution(steps[1], tr);
    onStepUpdate?.call(steps[1]);

    // Step 3: Core & Port
    steps[2].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[2]);
    steps[2] = await _checkCoreAndPort(steps[2], tr);
    onStepUpdate?.call(steps[2]);

    // Step 4: System Proxy
    steps[3].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[3]);
    steps[3] = await _checkSystemProxy(steps[3], tr);
    onStepUpdate?.call(steps[3]);

    // Step 5: Internet Handshake
    steps[4].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[4]);
    steps[4] = await _checkInternetHandshake(steps[4], tr);
    onStepUpdate?.call(steps[4]);

    final duration = DateTime.now().difference(startTime);

    // Calculate score
    int score = 100;
    for (final s in steps) {
      if (s.status == DiagnosticStatus.failed) {
        if (s.id == DiagnosticStepId.physicalNetwork) {
          score -= 35;
        } else if (s.id == DiagnosticStepId.coreAndPort) {
          score -= 25;
        } else if (s.id == DiagnosticStepId.internetHandshake) {
          score -= 25;
        } else {
          score -= 20;
        }
      } else if (s.status == DiagnosticStatus.warning) {
        score -= 10;
      }
    }
    if (score < 0) score = 0;

    String conclusion;
    if (score == 100) {
      conclusion = tr.NetCheckScreen.conclusionPerfect;
    } else if (score >= 80) {
      conclusion = tr.NetCheckScreen.conclusionGood;
    } else if (score >= 50) {
      conclusion = tr.NetCheckScreen.conclusionWarning;
    } else {
      conclusion = tr.NetCheckScreen.conclusionCritical;
    }

    return DiagnosticReport(
      healthScore: score,
      steps: steps,
      timestamp: DateTime.now(),
      overallConclusion: conclusion,
      duration: duration,
    );
  }

  /// 1. Physical Network & Gateway
  static Future<DiagnosticStepResult> _checkPhysicalNetwork(
    DiagnosticStepResult base,
    Translations tr,
  ) async {
    final sw = Stopwatch()..start();
    try {
      final interfaces = await NetworkInterface.list(
        includeLoopback: false,
        type: InternetAddressType.IPv4,
      );

      final validIps = <String>[];
      for (final iface in interfaces) {
        for (final addr in iface.addresses) {
          final ip = addr.address;
          if (!ip.startsWith('127.') && !ip.startsWith('169.254.')) {
            validIps.add("${iface.name}: $ip");
          }
        }
      }

      if (validIps.isEmpty) {
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: tr.NetCheckScreen.valNicNone,
          detail: "NetworkInterface.list() returned empty or only 169.254.x.x",
          issue: tr.NetCheckScreen.issueNicDisconnected,
          suggestion: tr.NetCheckScreen.suggestNicCheck,
        );
      }

      // Test socket connectivity to public IP on DNS port 53 (very fast TCP/Socket handshake)
      bool gatewayReachable = false;
      int latency = 0;
      for (final targetIp in ['223.5.5.5', '114.114.114.114', '1.1.1.1']) {
        try {
          final socketSw = Stopwatch()..start();
          final socket = await Socket.connect(targetIp, 53, timeout: const Duration(milliseconds: 1500));
          socket.destroy();
          socketSw.stop();
          gatewayReachable = true;
          latency = socketSw.elapsedMilliseconds;
          break;
        } catch (_) {}
      }

      sw.stop();
      final totalMs = sw.elapsedMilliseconds;

      if (!gatewayReachable) {
        return base.copyWith(
          status: DiagnosticStatus.warning,
          value: tr.NetCheckScreen.valNicGatewayTimeout,
          detail: "${validIps.join('\n')}\nGateway probe timed out (${totalMs}ms)",
          issue: tr.NetCheckScreen.issueNicGatewayUnreachable,
          suggestion: tr.NetCheckScreen.suggestNicGateway,
          latencyMs: totalMs,
        );
      }

      return base.copyWith(
        status: DiagnosticStatus.healthy,
        value: tr.NetCheckScreen.valNicNormal(p: validIps.first),
        detail: "${validIps.join('\n')}\nGateway latency: ${latency}ms",
        latencyMs: latency,
      );
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.failed,
        value: tr.NetCheckScreen.valNicError,
        detail: e.toString(),
        issue: "$e",
        suggestion: tr.NetCheckScreen.suggestNicReset,
        latencyMs: sw.elapsedMilliseconds,
      );
    }
  }

  /// 2. DNS Resolution & Fake-IP Engine
  static Future<DiagnosticStepResult> _checkDnsResolution(
    DiagnosticStepResult base,
    Translations tr,
  ) async {
    final sw = Stopwatch()..start();
    try {
      final lookupSw = Stopwatch()..start();
      final addresses = await InternetAddress.lookup('dns.alidns.com')
          .timeout(const Duration(seconds: 3));
      lookupSw.stop();

      final dnsLatency = lookupSw.elapsedMilliseconds;

      if (addresses.isEmpty) {
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: tr.NetCheckScreen.valDnsEmpty,
          detail: "System DNS failed to resolve dns.alidns.com",
          issue: tr.NetCheckScreen.issueDnsPollution,
          suggestion: tr.NetCheckScreen.suggestDnsReset,
          actionLabel: tr.NetCheckScreen.actionFlushDns,
          repairAction: flushDnsCache,
          latencyMs: dnsLatency,
        );
      }

      // Also check Mihomo internal DNS if core is started
      String coreDnsInfo = "";
      final isStarted = await VPNService.getStarted();
      if (isStarted) {
        final query = await ClashHttpApi.dnsQuery('cp.cloudflare.com', queryType: 'A');
        if (query.error == null && query.data != null && query.data!.isNotEmpty) {
          coreDnsInfo = "Core DNS: ${query.data!.join(', ')}";
        }
      }

      sw.stop();
      return base.copyWith(
        status: dnsLatency > 800 ? DiagnosticStatus.warning : DiagnosticStatus.healthy,
        value: tr.NetCheckScreen.valDnsNormal(p: addresses.first.address),
        detail: "DNS latency: ${dnsLatency}ms\nAddresses: ${addresses.map((a) => a.address).join(', ')}${coreDnsInfo.isNotEmpty ? '\n$coreDnsInfo' : ''}",
        latencyMs: dnsLatency,
        suggestion: dnsLatency > 800 ? tr.NetCheckScreen.suggestDnsSlow : null,
      );
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.failed,
        value: tr.NetCheckScreen.valDnsTimeout,
        detail: e.toString(),
        issue: tr.NetCheckScreen.issueDnsFailed,
        suggestion: tr.NetCheckScreen.suggestDnsFlush,
        actionLabel: tr.NetCheckScreen.actionFlushDns,
        repairAction: flushDnsCache,
        latencyMs: sw.elapsedMilliseconds,
      );
    }
  }

  /// 3. Mihomo Core Process & Port Listening
  static Future<DiagnosticStepResult> _checkCoreAndPort(
    DiagnosticStepResult base,
    Translations tr,
  ) async {
    final sw = Stopwatch()..start();
    try {
      final isStarted = await VPNService.getStarted();
      final mixedPort = ClashSettingManager.getMixedPort();
      final apiPort = ClashSettingManager.getControlPort();

      // Test port sockets
      bool mixedPortOpen = false;
      try {
        final sock = await Socket.connect('127.0.0.1', mixedPort, timeout: const Duration(milliseconds: 600));
        sock.destroy();
        mixedPortOpen = true;
      } catch (_) {}

      bool apiPortOpen = false;
      try {
        final sock = await Socket.connect('127.0.0.1', apiPort, timeout: const Duration(milliseconds: 600));
        sock.destroy();
        apiPortOpen = true;
      } catch (_) {}

      sw.stop();

      // Scenario A: Core not started by Wmimo, but ports are occupied by another app
      if (!isStarted && (mixedPortOpen || apiPortOpen)) {
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: tr.NetCheckScreen.valCorePortConflict(p: '$mixedPort / $apiPort'),
          detail: "Core stopped, but port occupied (Mixed: $mixedPortOpen, API: $apiPortOpen)",
          issue: tr.NetCheckScreen.issueCorePortConflict,
          suggestion: tr.NetCheckScreen.suggestCoreChangePort,
          actionLabel: tr.NetCheckScreen.actionRestartCore,
          repairAction: () async {
            final res = await VPNService.restart(const Duration(seconds: 5));
            return res == null;
          },
          latencyMs: sw.elapsedMilliseconds,
        );
      }

      // Scenario B: Core not started
      if (!isStarted) {
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: tr.NetCheckScreen.valCoreNotRunning,
          detail: "VPNService.getStarted() == false",
          issue: tr.NetCheckScreen.issueCoreStopped,
          suggestion: tr.NetCheckScreen.suggestCoreStart,
          actionLabel: tr.NetCheckScreen.actionStartCore,
          repairAction: () async {
            final res = await VPNService.start(const Duration(seconds: 10));
            return res == null;
          },
          latencyMs: sw.elapsedMilliseconds,
        );
      }

      // Scenario C: Core is supposed to be running, verify API responsiveness
      final configResult = await ClashHttpApi.getConfigs();
      if (configResult.error != null) {
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: tr.NetCheckScreen.valCoreApiFailed,
          detail: "REST Controller: ${configResult.error!.message}",
          issue: tr.NetCheckScreen.issueCoreFrozen,
          suggestion: tr.NetCheckScreen.suggestCoreRestart,
          actionLabel: tr.NetCheckScreen.actionRestartCore,
          repairAction: () async {
            final res = await VPNService.restart(const Duration(seconds: 5));
            return res == null;
          },
          latencyMs: sw.elapsedMilliseconds,
        );
      }

      final cfg = configResult.data!;
      return base.copyWith(
        status: DiagnosticStatus.healthy,
        value: tr.NetCheckScreen.valCoreNormal(port: cfg.mixed_port.toString(), mode: cfg.mode),
        detail: "Mihomo active\nMixed-Port: ${cfg.mixed_port}\nAPI: $apiPort\nTUN: ${cfg.tun.enable}",
        latencyMs: sw.elapsedMilliseconds,
      );
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.failed,
        value: tr.NetCheckScreen.valCoreError,
        detail: e.toString(),
        issue: "$e",
        suggestion: tr.NetCheckScreen.suggestCoreReinstall,
        actionLabel: tr.NetCheckScreen.actionRestartCore,
        repairAction: () async {
          final res = await VPNService.restart(const Duration(seconds: 5));
          return res == null;
        },
        latencyMs: sw.elapsedMilliseconds,
      );
    }
  }

  /// 4. System Proxy Alignment & Zombie Proxy Check
  static Future<DiagnosticStepResult> _checkSystemProxy(
    DiagnosticStepResult base,
    Translations tr,
  ) async {
    final sw = Stopwatch()..start();
    try {
      final isCoreRunning = await VPNService.getStarted();
      final autoSetExpected = SettingManager.getConfig().autoSetSystemProxy;
      final actualEnabled = await VPNService.getSystemProxyEnable();
      final mixedPort = ClashSettingManager.getMixedPort();

      sw.stop();

      // Case A: Zombie residual system proxy (Core stopped, but OS proxy still ON!)
      if (!isCoreRunning && actualEnabled) {
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: tr.NetCheckScreen.valProxyZombie,
          detail: "Core stopped, but system proxy enabled (127.0.0.1:$mixedPort)",
          issue: tr.NetCheckScreen.issueProxyZombie,
          suggestion: tr.NetCheckScreen.suggestProxyReset,
          actionLabel: tr.NetCheckScreen.actionResetProxy,
          repairAction: VPNService.resetAndCleanSystemProxy,
          latencyMs: sw.elapsedMilliseconds,
        );
      }

      // Case B: User wants system proxy, but it failed to apply or was overridden
      if (isCoreRunning && autoSetExpected && !actualEnabled) {
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: tr.NetCheckScreen.valProxyFailed,
          detail: "Expected system proxy ON, but OS reports OFF",
          issue: tr.NetCheckScreen.issueProxyBlocked,
          suggestion: tr.NetCheckScreen.suggestProxyReapply,
          actionLabel: tr.NetCheckScreen.actionReapplyProxy,
          repairAction: () async {
            await VPNService.setSystemProxy(true);
            return await VPNService.getSystemProxyEnable();
          },
          latencyMs: sw.elapsedMilliseconds,
        );
      }

      // Case C: Matched & Healthy
      if (actualEnabled) {
        return base.copyWith(
          status: DiagnosticStatus.healthy,
          value: tr.NetCheckScreen.valProxyActive(port: mixedPort.toString()),
          detail: "System proxy: 127.0.0.1:$mixedPort\nAuto-set: $autoSetExpected\nActive: true",
          latencyMs: sw.elapsedMilliseconds,
        );
      } else {
        return base.copyWith(
          status: DiagnosticStatus.healthy,
          value: tr.NetCheckScreen.valProxyDisabled,
          detail: "System proxy disabled (Direct/TUN/Manual)",
          latencyMs: sw.elapsedMilliseconds,
        );
      }
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.warning,
        value: tr.NetCheckScreen.valProxyWarning,
        detail: e.toString(),
        issue: tr.NetCheckScreen.issueProxyRead,
        suggestion: tr.NetCheckScreen.suggestProxyReset,
        actionLabel: tr.NetCheckScreen.actionResetProxy,
        repairAction: VPNService.resetAndCleanSystemProxy,
        latencyMs: sw.elapsedMilliseconds,
      );
    }
  }

  /// 5. Proxy Node & Internet Handshake (Cloudflare 204)
  static Future<DiagnosticStepResult> _checkInternetHandshake(
    DiagnosticStepResult base,
    Translations tr,
  ) async {
    final sw = Stopwatch()..start();
    try {
      final isStarted = await VPNService.getStarted();
      if (!isStarted) {
        sw.stop();
        return base.copyWith(
          status: DiagnosticStatus.warning,
          value: tr.NetCheckScreen.valHandshakeSkipped,
          detail: "Core is not started, handshake skipped",
          latencyMs: sw.elapsedMilliseconds,
        );
      }

      // Find active proxy node
      final proxiesRes = await ClashHttpApi.getProxies();
      String activeNode = "GLOBAL";
      if (proxiesRes.error == null && proxiesRes.data != null) {
        final proxies = proxiesRes.data!;
        for (final p in proxies) {
          if (p.name == "GLOBAL" || p.name == "Proxy" || p.name == "节点选择") {
            if (p.now.isNotEmpty) {
              activeNode = p.now;
              break;
            }
          }
        }
      }

      final delayRes = await ClashHttpApi.getDelay(
        activeNode,
        url: 'https://cp.cloudflare.com/generate_204',
        timeout: const Duration(seconds: 4),
      );

      sw.stop();

      if (delayRes.error != null || delayRes.data == null || delayRes.data! <= 0) {
        final errMsg = delayRes.error?.message ?? "Timeout";
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: tr.NetCheckScreen.valHandshakeFailed(node: activeNode, err: errMsg),
          detail: "Target: https://cp.cloudflare.com/generate_204\nNode: $activeNode\nError: $errMsg",
          issue: tr.NetCheckScreen.issueHandshakeBlocked,
          suggestion: tr.NetCheckScreen.suggestHandshakeSwitch,
          latencyMs: sw.elapsedMilliseconds,
        );
      }

      final delay = delayRes.data!;
      final isWarning = delay > 500;

      return base.copyWith(
        status: isWarning ? DiagnosticStatus.warning : DiagnosticStatus.healthy,
        value: tr.NetCheckScreen.valHandshakeNormal(node: activeNode, delay: delay.toString()),
        detail: "Target: Cloudflare Anycast (generate_204)\nNode: $activeNode\nRoundtrip: ${delay}ms",
        suggestion: isWarning ? tr.NetCheckScreen.suggestHandshakeSlow(delay: delay.toString()) : null,
        latencyMs: delay,
      );
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.failed,
        value: tr.NetCheckScreen.valHandshakeError,
        detail: e.toString(),
        issue: "$e",
        suggestion: tr.NetCheckScreen.suggestHandshakeCheck,
        latencyMs: sw.elapsedMilliseconds,
      );
    }
  }

  /// One-click repair for all detected issues in sequence
  static Future<bool> repairAllIssues(DiagnosticReport report) async {
    bool anyRepaired = false;
    for (final step in report.steps) {
      if (step.status == DiagnosticStatus.failed || step.status == DiagnosticStatus.warning) {
        if (step.repairAction != null) {
          try {
            await step.repairAction!();
            anyRepaired = true;
          } catch (e) {
            Log.w("NetworkDiagnostics repairAction error: $e");
          }
        }
      }
    }
    return anyRepaired;
  }

  /// Platform-specific DNS cache flush
  static Future<bool> flushDnsCache() async {
    try {
      if (Platform.isWindows) {
        await Process.run('ipconfig', ['/flushdns']);
      } else if (Platform.isMacOS) {
        await Process.run('dscacheutil', ['-flushcache']);
        await Process.run('killall', ['-HUP', 'mDNSResponder']);
      } else if (Platform.isLinux) {
        await Process.run('systemd-resolve', ['--flush-caches']);
      }
      return true;
    } catch (e) {
      Log.w("flushDnsCache error: $e");
      return false;
    }
  }

  /// Formats the complete diagnostic report into a structured string for clipboard/sharing
  static String formatReportForClipboard(DiagnosticReport report) {
    final buffer = StringBuffer();
    buffer.writeln("=== Wmimo Network Diagnostics Report ===");
    buffer.writeln("Score: ${report.healthScore}/100 (${report.overallConclusion})");
    buffer.writeln("Time: ${report.timestamp.toIso8601String()}");
    buffer.writeln("Duration: ${report.duration.inMilliseconds}ms");
    buffer.writeln("OS: ${Platform.operatingSystem} ${Platform.operatingSystemVersion}");
    buffer.writeln("========================================\n");

    for (int i = 0; i < report.steps.length; i++) {
      final step = report.steps[i];
      final statusStr = step.status == DiagnosticStatus.healthy
          ? "[OK]"
          : step.status == DiagnosticStatus.warning
              ? "[WARNING]"
              : step.status == DiagnosticStatus.failed
                  ? "[FAILED]"
                  : "[PENDING]";
      buffer.writeln("${i + 1}. ${step.title} $statusStr (${step.latencyMs}ms)");
      if (step.value != null && step.value!.isNotEmpty) {
        buffer.writeln("   Summary: ${step.value}");
      }
      if (step.issue != null && step.issue!.isNotEmpty) {
        buffer.writeln("   Issue: ${step.issue}");
      }
      if (step.suggestion != null && step.suggestion!.isNotEmpty) {
        buffer.writeln("   Suggestion: ${step.suggestion}");
      }
      if (step.detail != null && step.detail!.isNotEmpty) {
        buffer.writeln("   Details:\n   ${step.detail!.replaceAll('\n', '\n   ')}");
      }
      buffer.writeln();
    }
    return buffer.toString().trim();
  }
}
