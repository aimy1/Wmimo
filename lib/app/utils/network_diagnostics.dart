import 'dart:async';
import 'dart:io';

import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/app/utils/log.dart';

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
  static List<DiagnosticStepResult> initialSteps() {
    return [
      DiagnosticStepResult(
        id: DiagnosticStepId.physicalNetwork,
        title: "物理网卡与网关连通",
        description: "检测物理网卡状态、本机局域网 IP 与本地网关连通性",
      ),
      DiagnosticStepResult(
        id: DiagnosticStepId.dnsResolution,
        title: "DNS 解析与 Fake-IP",
        description: "验证本地域名解析链路耗时与内核 DNS 响应状态",
      ),
      DiagnosticStepResult(
        id: DiagnosticStepId.coreAndPort,
        title: "核心进程与端口占用",
        description: "检测 Mihomo 进程存活状态与 Mixed-Port/API 端口监听",
      ),
      DiagnosticStepResult(
        id: DiagnosticStepId.systemProxy,
        title: "系统代理配置与状态",
        description: "验证系统底层代理是否正确对齐并排查残留断网隐患",
      ),
      DiagnosticStepResult(
        id: DiagnosticStepId.internetHandshake,
        title: "公网代理链路握手",
        description: "通过激活代理节点向全球 CDN 测定实际端到端延迟与可用性",
      ),
    ];
  }

  /// Runs the full 5-level diagnostics pipeline sequentially
  static Future<DiagnosticReport> runDiagnostics({
    void Function(DiagnosticStepResult step)? onStepUpdate,
  }) async {
    final startTime = DateTime.now();
    final steps = initialSteps();

    // Step 1: Physical Network & Gateway
    steps[0].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[0]);
    steps[0] = await _checkPhysicalNetwork(steps[0]);
    onStepUpdate?.call(steps[0]);

    // Step 2: DNS Resolution
    steps[1].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[1]);
    steps[1] = await _checkDnsResolution(steps[1]);
    onStepUpdate?.call(steps[1]);

    // Step 3: Core & Port
    steps[2].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[2]);
    steps[2] = await _checkCoreAndPort(steps[2]);
    onStepUpdate?.call(steps[2]);

    // Step 4: System Proxy
    steps[3].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[3]);
    steps[3] = await _checkSystemProxy(steps[3]);
    onStepUpdate?.call(steps[3]);

    // Step 5: Internet Handshake
    steps[4].status = DiagnosticStatus.checking;
    onStepUpdate?.call(steps[4]);
    steps[4] = await _checkInternetHandshake(steps[4]);
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
      conclusion = "全链路极佳！所有网络节点与代理配置均正常畅通。";
    } else if (score >= 80) {
      conclusion = "链路基本正常，检测到部分非致命延迟或警告，建议查看详情。";
    } else if (score >= 50) {
      conclusion = "检测到部分网络或代理环节异常，请使用下方【一键修复】恢复。";
    } else {
      conclusion = "严重网络受阻！本地网络未连通或代理内核遭遇阻断。";
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
  static Future<DiagnosticStepResult> _checkPhysicalNetwork(DiagnosticStepResult base) async {
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
          value: "未找到可用网络接口",
          detail: "NetworkInterface.list() 返回空或仅有未配置的链路本地地址 (169.254.x.x)",
          issue: "本机网卡未连接到任何网络（网线拔出、Wi-Fi 未连或飞行模式）",
          suggestion: "请检查电脑物理网线连接、Wi-Fi 无线网络或网络适配器状态",
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
          value: "局域网 IP 已获取，但外部网关握手超时",
          detail: "已检测到网络接口:\n${validIps.join('\n')}\n向外网公共网关发起握手超时",
          issue: "电脑已接入局域网，但无法访问外部基础路由（可能受限于校园网/酒店认证或路由器断网）",
          suggestion: "请检查路由器光纤指示灯，或打开浏览器确认是否需要 Web 登录认证",
          latencyMs: totalMs,
        );
      }

      return base.copyWith(
        status: DiagnosticStatus.healthy,
        value: "网卡连接正常 (${validIps.first})",
        detail: "已分配网络接口:\n${validIps.join('\n')}\n网关连通性探测耗时: ${latency}ms",
        latencyMs: latency,
      );
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.failed,
        value: "网络接口检查异常",
        detail: e.toString(),
        issue: "检测本地物理网卡时发生异常: $e",
        suggestion: "尝试在系统设置中禁用并重新启用网络适配器",
        latencyMs: sw.elapsedMilliseconds,
      );
    }
  }

  /// 2. DNS Resolution & Fake-IP Engine
  static Future<DiagnosticStepResult> _checkDnsResolution(DiagnosticStepResult base) async {
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
          value: "DNS 查询返回空列表",
          detail: "系统 DNS 无法解析 dns.alidns.com",
          issue: "本地域名解析服务未响应，可能存在 DNS 污染或网关劫持",
          suggestion: "建议重置系统 DNS 或在 Wmimo 中启用智能加密 DNS (DoH/DoT)",
          actionLabel: "刷新系统 DNS 缓存",
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
          coreDnsInfo = "内核 DNS 正常解析: ${query.data!.join(', ')}";
        }
      }

      sw.stop();
      return base.copyWith(
        status: dnsLatency > 800 ? DiagnosticStatus.warning : DiagnosticStatus.healthy,
        value: "DNS 响应正常 (${addresses.first.address})",
        detail: "系统 DNS 解析耗时: ${dnsLatency}ms\n解析结果: ${addresses.map((a) => a.address).join(', ')}${coreDnsInfo.isNotEmpty ? '\n$coreDnsInfo' : ''}",
        latencyMs: dnsLatency,
        suggestion: dnsLatency > 800 ? "DNS 解析耗时偏长，建议开启 Smart Encrypted DNS 加速" : null,
      );
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.failed,
        value: "DNS 查询超时或失败",
        detail: e.toString(),
        issue: "本地 DNS 解析失败，系统无法将域名转换为 IP 地址",
        suggestion: "点击一键刷新系统 DNS 缓存，或在 Wmimo 设置中启用加密 DNS",
        actionLabel: "一键刷新 DNS 缓存",
        repairAction: flushDnsCache,
        latencyMs: sw.elapsedMilliseconds,
      );
    }
  }

  /// 3. Mihomo Core Process & Port Listening
  static Future<DiagnosticStepResult> _checkCoreAndPort(DiagnosticStepResult base) async {
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
          value: "端口 $mixedPort / $apiPort 已被外部程序占用",
          detail: "Wmimo 核心未启动，但本地端口已被外部进程监听 (混合端口: $mixedPortOpen, API: $apiPortOpen)",
          issue: "检测到端口冲突！其他代理软件（如 Clash Verge, v2rayN, Sing-box）或系统服务正在占用本应用端口",
          suggestion: "请完全退出其他代理客户端，或在 Wmimo 设置中修改端口号",
          actionLabel: "尝试重启并强制接管",
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
          value: "核心服务未运行",
          detail: "VPNService.getStarted() 返回 false",
          issue: "Wmimo 内核进程当前处于停止状态",
          suggestion: "点击主界面连接开关或点击下方【启动核心】",
          actionLabel: "启动核心进程",
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
          value: "内核进程无响应 (API 端口通讯失败)",
          detail: "REST Controller 报错: ${configResult.error!.message}",
          issue: "内核进程发生僵死或 API Secret 鉴权失配",
          suggestion: "建议点击【一键重启内核】恢复服务",
          actionLabel: "一键重启内核",
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
        value: "核心运行良好 (混合端口: ${cfg.mixed_port}, 模式: ${cfg.mode})",
        detail: "Mihomo 内核进程正常存活\nMixed-Port: ${cfg.mixed_port}\nController API: $apiPort\nTUN 模式: ${cfg.tun.enable ? '已启用' : '未开启'}",
        latencyMs: sw.elapsedMilliseconds,
      );
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.failed,
        value: "核心检测异常",
        detail: e.toString(),
        issue: "检测核心与端口发生未知异常: $e",
        suggestion: "尝试重启核心或重装服务驱动",
        actionLabel: "重启核心",
        repairAction: () async {
          final res = await VPNService.restart(const Duration(seconds: 5));
          return res == null;
        },
        latencyMs: sw.elapsedMilliseconds,
      );
    }
  }

  /// 4. System Proxy Alignment & Zombie Proxy Check
  static Future<DiagnosticStepResult> _checkSystemProxy(DiagnosticStepResult base) async {
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
          value: "检测到残留系统代理（导致断网）",
          detail: "核心已停止，但系统代理注册表依然处于开启状态 (指向 127.0.0.1:$mixedPort)",
          issue: "这是导致电脑断网的最常见原因！残留的系统代理将流量转发到未启动的端口",
          suggestion: "点击下方【一键清理并重置系统代理】，即可立即恢复网络正常上网",
          actionLabel: "一键清理并重置代理",
          repairAction: VPNService.resetAndCleanSystemProxy,
          latencyMs: sw.elapsedMilliseconds,
        );
      }

      // Case B: User wants system proxy, but it failed to apply or was overridden
      if (isCoreRunning && autoSetExpected && !actualEnabled) {
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: "系统代理未能成功启用",
          detail: "设置中已开启系统代理，但操作系统底层网络设置仍为未启用状态",
          issue: "系统代理配置未生效，可能被第三方安全软件拦截或权限受限",
          suggestion: "点击下方按钮尝试重新注册并强制应用系统代理",
          actionLabel: "重新应用系统代理",
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
          value: "系统代理已生效 (127.0.0.1:$mixedPort)",
          detail: "系统代理已准确指向当前 Wmimo 混合端口\n自动设置系统代理: 开启\n底层生效状态: 已激活",
          latencyMs: sw.elapsedMilliseconds,
        );
      } else {
        return base.copyWith(
          status: DiagnosticStatus.healthy,
          value: "系统代理未启用（当前走直连/TUN/手动模式）",
          detail: "系统代理当前处于关闭状态，网络流量不经过系统代理端口",
          latencyMs: sw.elapsedMilliseconds,
        );
      }
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.warning,
        value: "系统代理状态读取警告",
        detail: e.toString(),
        issue: "读取系统代理设置时产生非致命异常",
        suggestion: "如遇浏览器无法上网，可点击一键重置系统代理",
        actionLabel: "重置系统代理",
        repairAction: VPNService.resetAndCleanSystemProxy,
        latencyMs: sw.elapsedMilliseconds,
      );
    }
  }

  /// 5. Proxy Node & Internet Handshake (Cloudflare 204)
  static Future<DiagnosticStepResult> _checkInternetHandshake(DiagnosticStepResult base) async {
    final sw = Stopwatch()..start();
    try {
      final isStarted = await VPNService.getStarted();
      if (!isStarted) {
        sw.stop();
        return base.copyWith(
          status: DiagnosticStatus.warning,
          value: "核心未启动，跳过公网握手测试",
          detail: "需先启动核心方可进行代理端到端公网握手",
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
        final errMsg = delayRes.error?.message ?? "握手超时";
        return base.copyWith(
          status: DiagnosticStatus.failed,
          value: "当前节点 [$activeNode] 握手失败 ($errMsg)",
          detail: "目标: https://cp.cloudflare.com/generate_204\n活跃节点: $activeNode\n错误: $errMsg",
          issue: "当前选中的代理节点无法连接外部互联网，数据包握手失败或被阻断",
          suggestion: "该节点可能正在维护或不可达，请切换至其他可用节点",
          latencyMs: sw.elapsedMilliseconds,
        );
      }

      final delay = delayRes.data!;
      final isWarning = delay > 500;

      return base.copyWith(
        status: isWarning ? DiagnosticStatus.warning : DiagnosticStatus.healthy,
        value: "公网握手畅通 ($activeNode • ${delay}ms)",
        detail: "测试目标: Cloudflare Anycast (generate_204)\n当前激活节点: $activeNode\n往返延迟: ${delay}ms",
        suggestion: isWarning ? "节点延迟稍高 (${delay}ms)，建议测速选择更近的边缘节点" : null,
        latencyMs: delay,
      );
    } catch (e) {
      sw.stop();
      return base.copyWith(
        status: DiagnosticStatus.failed,
        value: "公网握手发生异常",
        detail: e.toString(),
        issue: "测试公网端到端连通性时发生错误: $e",
        suggestion: "检查节点配置或更换测速目标",
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
