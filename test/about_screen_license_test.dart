import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/about_screen.dart';
import 'package:wmimo/screens/license_screen.dart';

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
            applicationVersion: 'v1.3.5.1521',
            initialPackages: samplePackages,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Summary banner & badges
    expect(find.text('Wmimo'), findsOneWidget);
    expect(find.text('v1.3.5.1521'), findsOneWidget);
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
}
