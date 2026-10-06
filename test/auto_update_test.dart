import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/modules/auto_update_manager.dart';
import 'package:wmimo/app/utils/version_compare_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('VersionCompareUtils Tests', () {
    test('Identifies identical semantic versions', () {
      expect(VersionCompareUtils.compareVersion('1.1.6', '1.1.6'), 0);
      expect(VersionCompareUtils.compareVersion('v1.1.6', '1.1.6'), 0);
      expect(VersionCompareUtils.compareVersion('1.1.6', 'V1.1.6'), 0);
    });

    test('Compares major/minor/patch versions correctly', () {
      expect(VersionCompareUtils.compareVersion('1.1.5', '1.1.6'), -1);
      expect(VersionCompareUtils.compareVersion('1.1.6', '1.1.5'), 1);
      expect(VersionCompareUtils.compareVersion('1.2.0', '1.1.9'), 1);
      expect(VersionCompareUtils.compareVersion('2.0.0', '1.9.9'), 1);
      expect(VersionCompareUtils.compareVersion('1.1.6.1', '1.1.6'), 1);
    });

    test('Compares build numbers correctly when base versions are identical', () {
      // Hotfix build number bumps (Flutter/Android versionCode)
      expect(VersionCompareUtils.compareVersion('1.1.6+1429', '1.1.6+1430'), -1);
      expect(VersionCompareUtils.compareVersion('1.1.6+1430', '1.1.6+1429'), 1);
      expect(VersionCompareUtils.compareVersion('1.1.6+1429', '1.1.6+1429'), 0);
      expect(VersionCompareUtils.compareVersion('1.1.6', '1.1.6+1429'), -1);
      expect(VersionCompareUtils.compareVersion('1.1.6+1429', '1.1.6'), 1);

      // 4-part dot notation build numbers (e.g. 1.1.13.1436 vs 1.1.13.1437 vs 1.1.14.1501 vs 1.2.0.1501)
      expect(VersionCompareUtils.compareVersion('1.1.13.1436', '1.1.13.1437'), -1);
      expect(VersionCompareUtils.compareVersion('1.1.13.1437', '1.1.13.1436'), 1);
      expect(VersionCompareUtils.compareVersion('v1.1.13.1436', 'v1.1.13.1437'), -1);
      expect(VersionCompareUtils.compareVersion('1.1.13.1437', '1.1.13.1437'), 0);
      expect(VersionCompareUtils.compareVersion('1.1.13', '1.1.13.1437'), -1);
      expect(VersionCompareUtils.compareVersion('1.1.13.1437', '1.1.14.1501'), -1);
      expect(VersionCompareUtils.compareVersion('v1.1.14.1501', '1.1.13.1437'), 1);
      expect(VersionCompareUtils.compareVersion('1.1.14.1501', '1.1.14.1501'), 0);
      expect(VersionCompareUtils.compareVersion('1.1.14.1501', '1.2.0.1501'), -1);
      expect(VersionCompareUtils.compareVersion('v1.2.0.1501', '1.1.14.1501'), 1);
      expect(VersionCompareUtils.compareVersion('1.2.0.1501', '1.2.0.1501'), 0);
    });

    test('Semantic version changes take precedence over build numbers', () {
      expect(VersionCompareUtils.compareVersion('1.1.7+1', '1.1.6+9999'), 1);
      expect(VersionCompareUtils.compareVersion('1.1.6+9999', '1.1.7+1'), -1);
    });
  });

  group('AutoUpdateCheckVersion Extension Tests', () {
    test('Returns correct extension for current OS', () {
      final config = AutoUpdateCheckVersion();
      final ext = config.getExtension();
      if (Platform.isWindows) {
        expect(ext, '.exe');
      } else if (Platform.isAndroid) {
        expect(ext, '.apk');
      } else if (Platform.isMacOS) {
        expect(ext, '.dmg');
      } else if (Platform.isLinux) {
        expect(['.deb', '.rpm', '.AppImage'], contains(ext));
      }
    });
  });

  group('Desktop Architecture ABI Detection Tests', () {
    test('Populates ABIs correctly on desktop platforms', () async {
      await VPNService.initABI();
      final abis = VPNService.getABIs();
      expect(abis.isNotEmpty, isTrue);
      if (Platform.isWindows) {
        expect(abis.contains('x64') || abis.contains('arm64'), isTrue);
      }
    });
  });
}
