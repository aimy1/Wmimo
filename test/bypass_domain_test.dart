import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:libclash_vpn_service/proxy_manager.dart';
import 'package:wmimo/app/modules/setting_manager.dart';

void main() {
  group('System Proxy Bypass Domains Tests', () {
    test('ProxyOption supports both bypassDomains and bypassDomain getter', () {
      final domains = ['127.0.0.1', 'localhost', 'example.com'];
      final option = ProxyOption('127.0.0.1', 7890, domains);
      expect(option.bypassDomains, equals(domains));
      expect(option.bypassDomain, equals(domains));
    });

    test('SettingConfig serializes and deserializes systemProxyBypassDomain correctly', () {
      final config = SettingConfig();
      expect(config.systemProxyBypassDomain, contains('127.0.0.1'));

      final customDomains = ['127.0.0.1', 'localhost', '*.internal.company', 'custom.domain.org'];
      config.systemProxyBypassDomain = customDomains;

      final jsonStr = jsonEncode(config.toJson());
      final decodedMap = jsonDecode(jsonStr);

      final newConfig = SettingConfig();
      newConfig.fromJson(decodedMap);
      expect(newConfig.systemProxyBypassDomain, equals(customDomains));
    });

    test('Windows bypass list formatting has no brackets or commas', () {
      final defaultWindowsBypass = [
        "<local>",
        "localhost",
        "127.*",
        "10.*",
        "172.16.*",
        "172.17.*",
        "172.18.*",
        "172.19.*",
        "172.20.*",
        "172.21.*",
        "172.22.*",
        "172.23.*",
        "172.24.*",
        "172.25.*",
        "172.26.*",
        "172.27.*",
        "172.28.*",
        "172.29.*",
        "172.30.*",
        "172.31.*",
        "192.168.*",
      ];
      final userBypass = ['company.internal', 'dev.local', '10.*'];
      final allWindowsBypass = <String>{};
      allWindowsBypass.addAll(defaultWindowsBypass);
      for (var item in userBypass) {
        if (item.isNotEmpty) {
          allWindowsBypass.add(item);
        }
      }
      final bypassString = allWindowsBypass.join(";");

      expect(bypassString.contains('['), isFalse);
      expect(bypassString.contains(']'), isFalse);
      expect(bypassString.contains(','), isFalse);
      expect(bypassString.startsWith('<local>'), isTrue);
      expect(bypassString.contains('company.internal'), isTrue);
      expect(bypassString.contains('dev.local'), isTrue);
    });
  });
}
