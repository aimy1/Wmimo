import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/user_agreement_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    LocaleSettings.setLocale(AppLocale.zhCn);
  });

  testWidgets(
    'UserAgreementScreen renders title, privacy points and agree button',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: UserAgreementScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Title & Subtitle
      expect(find.text('您的隐私很重要'), findsOneWidget);
      expect(find.text('透明、无痕、完全本地化运行'), findsOneWidget);

      // Verify Privacy points
      expect(find.text('严格零日志'), findsOneWidget);
      expect(find.text('完全本地执行'), findsOneWidget);
      expect(find.text('纯净透明无遥测'), findsOneWidget);

      // Verify Agree and Continue button
      expect(find.text('接受并继续'), findsOneWidget);

      // Clear widget tree and flush popRoute delayed timer
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
    },
  );
}
