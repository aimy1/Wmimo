import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/widgets/home_cards_manager_sheet.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    final ui = SettingManager.getConfig().ui;
    ui.showTrafficChart = true;
    ui.showWebsiteTest = true;
    ui.showIpInfo = true;
    ui.showSubscription = true;
    ui.showQuickActions = true;
    ui.collapseTrafficChart = false;
    ui.collapseWebsiteTest = false;
    ui.collapseIpInfo = false;
    ui.collapseSubscription = false;
    ui.collapseQuickActions = false;
    ui.sideBySideLayout = true;
    ui.maskIp = true;
  });

  group('HomeCardsManagerSheet Tests', () {
    testWidgets('Renders HomeCardsManagerSheet in dialog mode with proper width',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: Scaffold(
              body: Center(
                child: HomeCardsManagerSheet(isDialog: true),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final t = Translations.of(tester.element(find.byType(HomeCardsManagerSheet)));

      // Find Dialog container
      expect(find.byType(HomeCardsManagerSheet), findsOneWidget);
      expect(find.text(t.meta.homeCardsManage), findsOneWidget);
      expect(find.text(t.meta.collapseAllCards), findsOneWidget);
      expect(find.text(t.meta.expandAllCards), findsOneWidget);
      expect(find.text(t.meta.resetDefaultCards), findsOneWidget);

      // Verify switches
      expect(find.byType(Switch), findsNWidgets(5)); // 5 dashboard cards
      expect(tester.takeException(), isNull);
    });

    testWidgets('Quick action pills collapse, expand, and reset cards properly',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: Scaffold(
              body: Center(
                child: HomeCardsManagerSheet(isDialog: true),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final t = Translations.of(tester.element(find.byType(HomeCardsManagerSheet)));
      final ui = SettingManager.getConfig().ui;
      expect(ui.collapseTrafficChart, isFalse);

      // Tap 'Collapse All'
      await tester.tap(find.text(t.meta.collapseAllCards));
      await tester.pumpAndSettle();

      expect(ui.collapseTrafficChart, isTrue);
      expect(ui.collapseWebsiteTest, isTrue);
      expect(ui.collapseIpInfo, isTrue);
      expect(ui.collapseSubscription, isTrue);
      expect(ui.collapseQuickActions, isTrue);

      // Tap 'Expand All'
      await tester.tap(find.text(t.meta.expandAllCards));
      await tester.pumpAndSettle();

      expect(ui.collapseTrafficChart, isFalse);
      expect(ui.collapseWebsiteTest, isFalse);
      expect(ui.collapseIpInfo, isFalse);
      expect(ui.collapseSubscription, isFalse);
      expect(ui.collapseQuickActions, isFalse);
    });

    testWidgets('Cards display drag handles and reset restores default order',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final ui = SettingManager.getConfig().ui;
      ui.homeCardsOrder = ['quick_tools', 'plan_usage', 'ip_info', 'web_test', 'traffic'];

      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: Scaffold(
              body: Center(
                child: HomeCardsManagerSheet(isDialog: true),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final t = Translations.of(tester.element(find.byType(HomeCardsManagerSheet)));

      // Verify drag handles are present for each of the 5 cards
      expect(find.byIcon(Icons.drag_indicator_rounded), findsNWidgets(5));

      // Ensure visible and tap Reset Defaults
      final resetFinder = find.text(t.meta.resetDefaultCards);
      await tester.ensureVisible(resetFinder);
      await tester.pumpAndSettle();
      await tester.tap(resetFinder);
      await tester.pumpAndSettle();

      // Verify order restored to default
      expect(ui.homeCardsOrder, equals(SettingConfigItemUI.kDefaultHomeCardsOrder));
    });

    testWidgets('Dragging card handle updates homeCardsOrder',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final ui = SettingManager.getConfig().ui;
      ui.homeCardsOrder = ['traffic', 'web_test', 'ip_info', 'plan_usage', 'quick_tools'];

      await tester.pumpWidget(
        TranslationProvider(
          child: const MaterialApp(
            home: Scaffold(
              body: Center(
                child: HomeCardsManagerSheet(isDialog: true),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final firstHandle = find.byIcon(Icons.drag_indicator_rounded).first;
      await tester.drag(firstHandle, const Offset(0, 150));
      await tester.pumpAndSettle();

      expect(ui.homeCardsOrder.length, 5);
      expect(ui.homeCardsOrder.first != 'traffic' || ui.homeCardsOrder[1] == 'traffic', isTrue);
    });

    test('SettingConfigItemUI maskIp defaults to true and serializes properly', () {
      final ui = SettingConfigItemUI();
      expect(ui.maskIp, isTrue);

      final json = ui.toJson();
      expect(json['mask_ip'], isTrue);

      final ui2 = SettingConfigItemUI();
      ui2.fromJson({'mask_ip': false});
      expect(ui2.maskIp, isFalse);

      final ui3 = SettingConfigItemUI();
      ui3.fromJson({});
      expect(ui3.maskIp, isTrue);
    });
  });
}
