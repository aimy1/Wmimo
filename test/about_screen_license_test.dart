import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/about_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('AboutScreen openSourceLicense has valid push options to license page',
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
  });
}
