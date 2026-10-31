import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/utils/assets_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/user_agreement_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('AssetsUtils resolves localized agreement files for all 9 supported locales', () {
    const supportedLocales = [
      AppLocale.zhCn,
      AppLocale.zhTw,
      AppLocale.en,
      AppLocale.ja,
      AppLocale.ko,
      AppLocale.ru,
      AppLocale.es,
      AppLocale.ar,
      AppLocale.fa,
    ];

    for (final loc in supportedLocales) {
      final path = AssetsUtils.userAgreementPath(loc);
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: 'Agreement file $path should exist on disk');
      final content = file.readAsStringSync();
      expect(content.trim().isNotEmpty, isTrue, reason: 'Agreement file $path should not be empty');
    }
  });

  testWidgets(
    'UserAgreementScreen renders Chinese translations accurately',
    (WidgetTester tester) async {
      LocaleSettings.setLocale(AppLocale.zhCn);
      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: UserAgreementScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Chinese Header
      expect(find.text('用户协议与隐私保护'), findsOneWidget);
      expect(find.text('在使用 Wmimo 之前，请仔细阅读并同意以下条款'), findsOneWidget);

      // Verify Chinese Badges
      expect(find.text('数据零收集'), findsOneWidget);
      expect(find.text('纯本地独立运行'), findsOneWidget);
      expect(find.text('纯净无商业遥测'), findsOneWidget);

      // Verify Action Buttons
      expect(find.text('不同意并退出'), findsOneWidget);
      expect(find.text('同意并继续'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
    },
  );

  testWidgets(
    'UserAgreementScreen renders English translations accurately',
    (WidgetTester tester) async {
      LocaleSettings.setLocale(AppLocale.en);
      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: UserAgreementScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify English Header
      expect(find.text('Terms of Service & Privacy Policy'), findsOneWidget);
      expect(
        find.text('Please review and agree to the terms below to continue'),
        findsOneWidget,
      );

      // Verify English Badges
      expect(find.text('Zero-Data Collection'), findsOneWidget);
      expect(find.text('Local Execution Only'), findsOneWidget);
      expect(find.text('No Commercial Telemetry'), findsOneWidget);

      // Verify Action Buttons
      expect(find.text('Disagree & Exit'), findsOneWidget);
      expect(find.text('Agree & Continue'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
    },
  );
}
