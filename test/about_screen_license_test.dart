import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/utils/assets_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/about_screen.dart';
import 'package:wmimo/screens/license_screen.dart';
import 'package:wmimo/screens/user_agreement_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AboutScreen openSourceLicense has valid push options to LicenseScreen',
      (WidgetTester tester) async {
    late BuildContext capturedContext;

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: Builder(
            builder: (context) {
              capturedContext = context;
              return const SizedBox();
            },
          ),
        ),
      ),
    );

    final t = Translations.of(capturedContext);

    final state = AboutScreenState();
    final groups = await state.getGroupOptions(capturedContext);
    final licenseOption = groups
        .expand((g) => g.options)
        .firstWhere((o) => o.pushOptions?.name == t.meta.openSourceLicense);

    expect(licenseOption.pushOptions, isNotNull);
    expect(licenseOption.pushOptions!.text, 'GPL-3.0');
    expect(licenseOption.pushOptions!.onPush, isNotNull);

    final privacyOption = groups
        .expand((g) => g.options)
        .firstWhere((o) => o.pushOptions?.name == t.meta.privacyPolicy);

    expect(privacyOption.pushOptions, isNotNull);
    expect(privacyOption.pushOptions!.onPush, isNotNull);
  });

  testWidgets(
      'LicenseScreen renders summary banner, filters packages, and switches details',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1024, 768));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final samplePackages = <LicensePackageGroup>[
      const LicensePackageGroup(
        packageName: '_fe_analyzer_shared',
        entries: <LicenseEntry>[
          LicenseEntryWithLineBreaks(
            <String>['_fe_analyzer_shared'],
            'Copyright 2019, the Dart project authors.\nBSD-3-Clause License.',
          ),
        ],
      ),
      const LicensePackageGroup(
        packageName: 'abseil-cpp',
        entries: <LicenseEntry>[
          LicenseEntryWithLineBreaks(
            <String>['abseil-cpp'],
            'Apache License Version 2.0\nAbseil C++ Common Libraries.',
          ),
          LicenseEntryWithLineBreaks(
            <String>['abseil-cpp'],
            'Additional notice for abseil-cpp.',
          ),
        ],
      ),
    ];

    await tester.pumpWidget(
      TranslationProvider(
        child: MaterialApp(
          home: LicenseScreen(
            applicationName: 'Wmimo',
            applicationVersion: 'v1.4.1.1527',
            initialPackages: samplePackages,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Summary banner & badges
    expect(find.text('Wmimo'), findsOneWidget);
    expect(find.text('v1.4.1.1527'), findsOneWidget);
    expect(
      find.text('GNU General Public License v3.0 (GPL-3.0-or-later)'),
      findsOneWidget,
    );

    // First package selected by default
    expect(find.text('_fe_analyzer_shared'), findsWidgets);
    expect(
      find.textContaining('Copyright 2019, the Dart project authors.'),
      findsOneWidget,
    );

    // Select second package with multiple licenses
    await tester.tap(find.text('abseil-cpp').first);
    await tester.pumpAndSettle();

    expect(find.text('License #1'), findsOneWidget);
    expect(find.text('License #2'), findsOneWidget);
    expect(
      find.textContaining('Abseil C++ Common Libraries.'),
      findsOneWidget,
    );

    // Filter via search bar
    await tester.enterText(find.byType(TextField), 'abseil');
    await tester.pumpAndSettle();

    expect(find.text('1/2'), findsWidgets);
    expect(find.text('abseil-cpp'), findsWidgets);
  });

  group('Privacy Policy UI tests', () {
    setUp(() async {
      await LocaleSettings.setLocale(AppLocale.zhCn);
    });

    testWidgets(
        'Privacy Policy viewing mode renders localized header, copy action, and loads privacy policy asset path',
        (WidgetTester tester) async {
      for (final locale in AppLocale.values) {
        expect(AssetsUtils.privacyPolicyPath(locale), startsWith('assets/txts/privacy_policy_'));
        expect(AssetsUtils.userAgreementPath(locale), startsWith('assets/txts/user_agreement_'));
      }
      expect(
        AssetsUtils.privacyPolicyPath(AppLocale.zhCn),
        'assets/txts/privacy_policy_cn.txt',
      );
      expect(
        AssetsUtils.privacyPolicyPath(AppLocale.en),
        'assets/txts/privacy_policy_en.txt',
      );

      await tester.binding.setSurfaceSize(const Size(420, 840));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: UserAgreementScreen(
              isViewingOnly: true,
              isPrivacyPolicy: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final zh = AppLocale.zhCn.buildSync();
      expect(find.text(zh.meta.privacyPolicy), findsOneWidget);
      expect(find.text(zh.UserAgreementScreen.privacySubtitle), findsOneWidget);
      expect(find.text(zh.meta.copy), findsOneWidget);
      expect(find.text(zh.meta.close), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 10));
    });
  });
}
