import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/clash/clash_config.dart';
import 'package:wmimo/app/utils/proxy_node_loader.dart';
import 'package:wmimo/app/utils/subscription_converter.dart';

String generateMockClashYaml(int nodeCount) {
  final sb = StringBuffer();
  sb.writeln('mixed-port: 7890');
  sb.writeln('allow-lan: false');
  sb.writeln('mode: rule');
  sb.writeln('log-level: info\n');
  sb.writeln('proxies:');

  final regions = ['香港 HK', '日本 JP', '美国 US', '新加坡 SG', '德国 DE', '英国 UK'];
  final protocols = ['vmess', 'ss', 'vless', 'trojan'];

  for (int i = 1; i <= nodeCount; i++) {
    final region = regions[i % regions.length];
    final proto = protocols[i % protocols.length];
    sb.writeln('  - name: "$region - HighSpeed Node $i"');
    sb.writeln('    type: $proto');
    sb.writeln('    server: 192.168.1.${(i % 254) + 1}');
    sb.writeln('    port: ${1000 + (i % 9000)}');
    if (proto == 'vmess' || proto == 'vless') {
      sb.writeln('    uuid: 12345678-1234-1234-1234-${i.toString().padLeft(12, '0')}');
      sb.writeln('    alterId: 0');
      sb.writeln('    cipher: auto');
    } else if (proto == 'ss') {
      sb.writeln('    cipher: aes-128-gcm');
      sb.writeln('    password: password_$i');
    } else {
      sb.writeln('    password: password_$i');
    }
  }

  return sb.toString();
}

void main() {
  group('Subscription Parsing & Scale Benchmarks', () {
    setUpAll(() {
      // Warm up parser
      final warmup = generateMockClashYaml(20);
      ProxyNodeLoader.parseProfileContent(warmup);
    });

    test('Small Scale (50 nodes): parsing latency under 30ms', () {
      final yaml = generateMockClashYaml(50);
      final sw = Stopwatch()..start();
      final nodes = ProxyNodeLoader.parseProfileContent(yaml);
      sw.stop();
      final elapsedMs = sw.elapsedMicroseconds / 1000.0;
      final proxyNodes = nodes.where((n) =>
          !ClashProtocolType.isGroupType(n.type) &&
          n.name != "DIRECT" &&
          n.name != "REJECT").toList();
      // ignore: avoid_print
      print('[BENCHMARK] 50 nodes: ${elapsedMs.toStringAsFixed(2)} ms (${proxyNodes.length} proxies, ${nodes.length - proxyNodes.length} groups)');
      expect(proxyNodes.length, equals(50));
      expect(elapsedMs, lessThan(100.0));
    });

    test('Medium Scale (500 nodes): parsing latency under 80ms', () {
      final yaml = generateMockClashYaml(500);
      final sw = Stopwatch()..start();
      final nodes = ProxyNodeLoader.parseProfileContent(yaml);
      sw.stop();
      final elapsedMs = sw.elapsedMicroseconds / 1000.0;
      final proxyNodes = nodes.where((n) =>
          !ClashProtocolType.isGroupType(n.type) &&
          n.name != "DIRECT" &&
          n.name != "REJECT").toList();
      // ignore: avoid_print
      print('[BENCHMARK] 500 nodes: ${elapsedMs.toStringAsFixed(2)} ms (${proxyNodes.length} proxies)');
      expect(proxyNodes.length, equals(500));
      expect(elapsedMs, lessThan(200.0));
    });

    test('Large Scale (2,000 nodes): parsing latency under 200ms', () {
      final yaml = generateMockClashYaml(2000);
      final sw = Stopwatch()..start();
      final nodes = ProxyNodeLoader.parseProfileContent(yaml);
      sw.stop();
      final elapsedMs = sw.elapsedMicroseconds / 1000.0;
      final proxyNodes = nodes.where((n) =>
          !ClashProtocolType.isGroupType(n.type) &&
          n.name != "DIRECT" &&
          n.name != "REJECT").toList();
      // ignore: avoid_print
      print('[BENCHMARK] 2,000 nodes: ${elapsedMs.toStringAsFixed(2)} ms (${proxyNodes.length} proxies)');
      expect(proxyNodes.length, equals(2000));
      expect(elapsedMs, lessThan(500.0));
    });

    test('Stress Scale (5,000 nodes): parsing latency under 450ms', () {
      final yaml = generateMockClashYaml(5000);
      final sw = Stopwatch()..start();
      final nodes = ProxyNodeLoader.parseProfileContent(yaml);
      sw.stop();
      final elapsedMs = sw.elapsedMicroseconds / 1000.0;
      final proxyNodes = nodes.where((n) =>
          !ClashProtocolType.isGroupType(n.type) &&
          n.name != "DIRECT" &&
          n.name != "REJECT").toList();
      final throughput = (5000 / (sw.elapsedMicroseconds / 1000000.0)).toStringAsFixed(0);
      // ignore: avoid_print
      print('[BENCHMARK] 5,000 nodes: ${elapsedMs.toStringAsFixed(2)} ms ($throughput nodes/s)');
      expect(proxyNodes.length, equals(5000));
      expect(elapsedMs, lessThan(1000.0));
    });

    test('Fast path: isClashYaml detects valid configuration in sub-millisecond', () {
      final yaml = generateMockClashYaml(1000);
      final sw = Stopwatch()..start();
      final isClash = SubscriptionConverter.isClashYaml(yaml);
      sw.stop();
      final elapsedMs = sw.elapsedMicroseconds / 1000.0;
      // ignore: avoid_print
      print('[BENCHMARK] isClashYaml (1,000 nodes): ${elapsedMs.toStringAsFixed(3)} ms (result: $isClash)');
      expect(isClash, isTrue);
      expect(elapsedMs, lessThan(5.0));
    });
  });
}
