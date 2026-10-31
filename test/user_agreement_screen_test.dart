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
    'UserAgreementScreen renders title, privacy points, agree button and disagree button',
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
      expect(find.text('用户协议与隐私保护'), findsOneWidget);
      expect(find.text('在使用 Wmimo 之前，请仔细阅读并同意以下条款'), findsOneWidget);

      // Verify Privacy highlight badges
      expect(find.text('数据零收集'), findsOneWidget);
      expect(find.text('纯本地独立运行'), findsOneWidget);
      expect(find.text('纯净无商业遥测'), findsOneWidget);

      // Verify Action Buttons
      expect(find.text('不同意并退出'), findsOneWidget);
      expect(find.text('同意并继续'), findsOneWidget);

      // Clear widget tree and flush popRoute delayed timer
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
    },
  );
}
