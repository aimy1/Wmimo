import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/settings_screen.dart';
import 'package:wmimo/screens/widgets/home_cards_manager_sheet.dart';

void main() {
  group('SettingsScreen & HomeCardsManagerSheet tests', () {
    setUp(() async {
      await LocaleSettings.setLocale(AppLocale.zhCn);
    });

    test('SettingConfigItemUI defaults autoOrientation to true', () {
      final ui = SettingConfigItemUI();
      expect(ui.autoOrientation, isTrue);

      ui.autoOrientation = false;
      ui.fromJson({});
      expect(ui.autoOrientation, isTrue);
    });

    testWidgets(
      'SettingsScreen renders 4 platform-tiered sections without duplicate joinUs row',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(420, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          TranslationProvider(
            child: const MaterialApp(
              home: Scaffold(
                body: SingleChildScrollView(
                  child: SettingsScreen(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final zh = AppLocale.zhCn.buildSync();

        // 4 organized section headers
        expect(find.text(zh.meta.sectionGeneral), findsOneWidget);
        expect(find.text(zh.meta.sectionRoutingTools), findsOneWidget);
        expect(find.text(zh.meta.sectionData), findsOneWidget);
        expect(find.text(zh.meta.sectionSupport), findsOneWidget);

        // Surfaced entries
        expect(find.text(zh.meta.settingApp), findsOneWidget);
        expect(find.text(zh.meta.settingCore), findsOneWidget);
        expect(find.textContaining('Beta'), findsAtLeastNWidgets(1));
        expect(find.text(zh.dns.geoAssetsTitle), findsOneWidget);
        expect(find.text(zh.meta.networkDiagnostics), findsOneWidget);
        expect(find.text(zh.meta.coreLog), findsOneWidget);
        expect(find.text(zh.meta.about), findsOneWidget);

        // Duplicate top-level joinUs was consolidated into AboutScreen
        expect(find.text(zh.meta.joinUs), findsNothing);
      },
    );

    testWidgets(
      'HomeCardsManagerSheet has no top-right X close button and closes when tapping blank area',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          TranslationProvider(
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => const HomeCardsManagerSheet(isDialog: false),
                        );
                      },
                      child: const Text('Open'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Open'));
        await tester.pumpAndSettle();

        final zh = AppLocale.zhCn.buildSync();
        expect(find.text(zh.meta.homeCardsManage), findsOneWidget);

        // Top-right close X icon is removed
        expect(find.byIcon(Icons.close_rounded), findsNothing);
        expect(find.byIcon(Icons.close), findsNothing);

        // Tapping inside the sheet title keeps the sheet open
        await tester.tap(find.text(zh.meta.homeCardsManage));
        await tester.pumpAndSettle();
        expect(find.text(zh.meta.homeCardsManage), findsOneWidget);

        // Tapping blank space near top of viewport closes the sheet
        await tester.tapAt(const Offset(20, 40));
        await tester.pumpAndSettle();
        expect(find.text(zh.meta.homeCardsManage), findsNothing);
      },
    );

    testWidgets(
      'HomeCardsManagerSheet dialog mode also has no X close button and dismisses on barrier tap',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(900, 800));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          TranslationProvider(
            child: MaterialApp(
              home: Scaffold(
                body: Builder(
                  builder: (context) => Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          builder: (_) => const HomeCardsManagerSheet(isDialog: true),
                        );
                      },
                      child: const Text('OpenDialog'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('OpenDialog'));
        await tester.pumpAndSettle();

        final zh = AppLocale.zhCn.buildSync();
        expect(find.text(zh.meta.homeCardsManage), findsOneWidget);
        expect(find.byIcon(Icons.close_rounded), findsNothing);
        expect(find.byIcon(Icons.close), findsNothing);

        // Tap outside the centered 480px dialog closes it
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();
        expect(find.text(zh.meta.homeCardsManage), findsNothing);
      },
    );
  });
}
