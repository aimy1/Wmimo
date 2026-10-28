import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/setting_manager.dart';

void main() {
  group('SideBySideLayout Setting Tests', () {
    test('SettingConfigItemUI defaults sideBySideLayout to true', () {
      final ui = SettingConfigItemUI();
      expect(ui.sideBySideLayout, isTrue);
    });

    test('SettingConfigItemUI serializes and deserializes sideBySideLayout', () {
      final ui = SettingConfigItemUI();
      ui.sideBySideLayout = false;
      final json = ui.toJson();
      expect(json['side_by_side_layout'], isFalse);

      final restored = SettingConfigItemUI.fromJsonStatic(json);
      expect(restored.sideBySideLayout, isFalse);
    });

    test('SettingConfigItemUI falls back to true if key is omitted in json', () {
      final restored = SettingConfigItemUI.fromJsonStatic({});
      expect(restored.sideBySideLayout, isTrue);
    });

    test('SettingManager notifies sideBySideLayout change listeners', () {
      int callCount = 0;
      void listener() {
        callCount++;
      }

      SettingManager.onSideBySideLayoutChanged.add(listener);
      SettingManager.notifySideBySideLayoutChanged();
      expect(callCount, equals(1));

      SettingManager.onSideBySideLayoutChanged.remove(listener);
      SettingManager.notifySideBySideLayoutChanged();
      expect(callCount, equals(1));
    });
  });
}
