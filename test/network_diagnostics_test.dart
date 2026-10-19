import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/utils/network_diagnostics.dart';
import 'package:wmimo/i18n/strings.g.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('NetworkDiagnostics Core Tests', () {
    test('initialSteps creates exactly 5 sequential diagnostic steps', () {
      final steps = NetworkDiagnostics.initialSteps();
      expect(steps.length, 5);

      expect(steps[0].id, DiagnosticStepId.physicalNetwork);
      expect(steps[1].id, DiagnosticStepId.dnsResolution);
      expect(steps[2].id, DiagnosticStepId.coreAndPort);
      expect(steps[3].id, DiagnosticStepId.systemProxy);
      expect(steps[4].id, DiagnosticStepId.internetHandshake);

      for (final step in steps) {
        expect(step.status, DiagnosticStatus.idle);
        expect(step.title.isNotEmpty, true);
        expect(step.description.isNotEmpty, true);
      }
    });

    test('DiagnosticStepResult copyWith updates fields correctly', () {
      final initial = DiagnosticStepResult(
        id: DiagnosticStepId.coreAndPort,
        title: "Test Title",
        description: "Test Desc",
      );

      final updated = initial.copyWith(
        status: DiagnosticStatus.healthy,
        value: "Running",
        detail: "Port 7890 active",
        latencyMs: 42,
      );

      expect(updated.id, DiagnosticStepId.coreAndPort);
      expect(updated.title, "Test Title");
      expect(updated.status, DiagnosticStatus.healthy);
      expect(updated.value, "Running");
      expect(updated.detail, "Port 7890 active");
      expect(updated.latencyMs, 42);
    });

    test('DiagnosticReport metrics calculation (Perfect 100 Score)', () {
      final steps = NetworkDiagnostics.initialSteps().map((s) {
        return s.copyWith(status: DiagnosticStatus.healthy);
      }).toList();

      final report = DiagnosticReport(
        healthScore: 100,
        steps: steps,
        timestamp: DateTime.now(),
        overallConclusion: "All good",
        duration: const Duration(milliseconds: 350),
      );

      expect(report.healthScore, 100);
      expect(report.hasIssues, false);
      expect(report.hasFatalError, false);
      expect(report.issueCount, 0);
    });

    test('DiagnosticReport metrics calculation (Degraded with Warnings and Failures)', () {
      final steps = NetworkDiagnostics.initialSteps();
      steps[0] = steps[0].copyWith(status: DiagnosticStatus.healthy);
      steps[1] = steps[1].copyWith(status: DiagnosticStatus.warning, issue: "High DNS latency");
      steps[2] = steps[2].copyWith(status: DiagnosticStatus.failed, issue: "Core not responding");
      steps[3] = steps[3].copyWith(status: DiagnosticStatus.failed, issue: "Proxy zombie residue");
      steps[4] = steps[4].copyWith(status: DiagnosticStatus.healthy);

      final report = DiagnosticReport(
        healthScore: 45,
        steps: steps,
        timestamp: DateTime.now(),
        overallConclusion: "Issues detected",
        duration: const Duration(milliseconds: 500),
      );

      expect(report.healthScore, 45);
      expect(report.hasIssues, true);
      expect(report.hasFatalError, true);
      expect(report.issueCount, 3);
    });

    test('repairAllIssues executes assigned repair actions safely', () async {
      bool repairStepCalled = false;
      final stepWithRepair = DiagnosticStepResult(
        id: DiagnosticStepId.systemProxy,
        title: "System Proxy",
        description: "Desc",
        status: DiagnosticStatus.failed,
        repairAction: () async {
          repairStepCalled = true;
          return true;
        },
      );

      final report = DiagnosticReport(
        healthScore: 60,
        steps: [stepWithRepair],
        timestamp: DateTime.now(),
        overallConclusion: "Failed",
        duration: const Duration(milliseconds: 100),
      );

      final result = await NetworkDiagnostics.repairAllIssues(report);
      expect(result, true);
      expect(repairStepCalled, true);
    });

    test('flushDnsCache completes without crashing', () async {
      final result = await NetworkDiagnostics.flushDnsCache();
      expect(result, isA<bool>());
    });

    test('initialSteps supports localized titles and descriptions', () async {
      final zhLocale = await AppLocale.zhCn.build();
      final zhSteps = NetworkDiagnostics.initialSteps(zhLocale);
      expect(zhSteps[0].title, "物理网卡与网关");
      expect(zhSteps[0].description, contains("检测物理网卡状态"));

      final enLocale = await AppLocale.en.build();
      final enSteps = NetworkDiagnostics.initialSteps(enLocale);
      expect(enSteps[0].title, "Physical Network & Gateway");
      expect(enSteps[0].description, contains("Checks physical network adapter"));
    });

    test('All 9 locales contain localized step descriptions and status values', () async {
      for (final locale in AppLocale.values) {
        final tr = await locale.build();
        expect(tr.NetCheckScreen.stepPhysicalDesc.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.stepDnsDesc.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.stepCoreDesc.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.stepProxyDesc.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.stepHandshakeDesc.isNotEmpty, isTrue);

        expect(tr.NetCheckScreen.shortStepPhysical.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.shortStepDns.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.shortStepCore.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.shortStepProxy.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.shortStepHandshake.isNotEmpty, isTrue);

        expect(tr.NetCheckScreen.valNicNormal(p: '192.168.1.1').isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.valDnsNormal(p: '1.1.1.1').isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.valCoreNormal(port: '7890', mode: 'rule').isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.valProxyActive(port: '7890').isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.valHandshakeNormal(node: 'JP', delay: '50').isNotEmpty, isTrue);

        expect(tr.NetCheckScreen.conclusionPerfect.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.conclusionGood.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.conclusionWarning.isNotEmpty, isTrue);
        expect(tr.NetCheckScreen.conclusionCritical.isNotEmpty, isTrue);
      }
    });
  });
}

