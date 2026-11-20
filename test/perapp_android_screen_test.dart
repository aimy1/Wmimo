import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/clash_setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/perapp_android_screen.dart';

void main() {
  group('PerAppAndroidScreen UI & logic tests', () {
    setUp(() async {
      await LocaleSettings.setLocale(AppLocale.zhCn);
      final perapp = ClashSettingManager.getConfig().Extension!.Tun.perApp;
      perapp.Enable = false;
      perapp.WhiteList = false;
      perapp.PackageIds = [];
    });

    testWidgets('renders compact control card, always-visible preset/manual icons, and whitelist empty guard', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 740));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: PerAppAndroidScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar quick actions for presets & manual package add are always accessible
      expect(find.byIcon(Icons.auto_awesome_outlined), findsAtLeastNWidgets(1));
      expect(find.byIcon(Icons.add_circle_outline_rounded), findsAtLeastNWidgets(1));

      // Enable Per-App switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Whitelist / Blacklist segments appear
      expect(find.text('仅代理选中的应用'), findsOneWidget);
      expect(find.text('绕过选中的应用'), findsOneWidget);

      // Select Whitelist mode with 0 packages -> shows empty whitelist warning
      await tester.tap(find.text('仅代理选中的应用'));
      await tester.pumpAndSettle();
      expect(find.textContaining('白名单为空时不会代理任何应用'), findsOneWidget);

      // Switch to Blacklist mode -> warning disappears
      await tester.tap(find.text('绕过选中的应用'));
      await tester.pumpAndSettle();
      expect(find.textContaining('白名单为空时不会代理任何应用'), findsNothing);

      // Unmount and flush AppRouteObserver's 1ms dispose timer cleanly
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
    });
  });
}
