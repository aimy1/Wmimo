import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/widgets/text_field.dart';

void main() {
  group('TV Mode Refactoring - Key Navigation & Detection Tests', () {
    tearDown(() {
      SettingConfigItemUI.detectedAndroidTv = false;
      SettingManager.getConfig().ui.tvMode = false;
      SettingManager.notifyTvModeChanged();
    });

    test('Recognizes TV remote D-pad confirmation keys', () {
      expect(TextFieldEx.isTvConfirmKey(LogicalKeyboardKey.select), isTrue);
      expect(TextFieldEx.isTvConfirmKey(LogicalKeyboardKey.enter), isTrue);
      expect(TextFieldEx.isTvConfirmKey(LogicalKeyboardKey.numpadEnter), isTrue);
      expect(TextFieldEx.isTvConfirmKey(LogicalKeyboardKey.gameButtonA), isTrue);
      expect(TextFieldEx.isTvConfirmKey(LogicalKeyboardKey.space), isTrue);
      expect(TextFieldEx.isTvConfirmKey(LogicalKeyboardKey.arrowUp), isFalse);
    });

    test('Maps D-pad arrow keys to focus traversal directions', () {
      expect(
        TextFieldEx.arrowToTraversalDirection(LogicalKeyboardKey.arrowUp),
        TraversalDirection.up,
      );
      expect(
        TextFieldEx.arrowToTraversalDirection(LogicalKeyboardKey.arrowDown),
        TraversalDirection.down,
      );
      expect(
        TextFieldEx.arrowToTraversalDirection(LogicalKeyboardKey.arrowLeft),
        TraversalDirection.left,
      );
      expect(
        TextFieldEx.arrowToTraversalDirection(LogicalKeyboardKey.arrowRight),
        TraversalDirection.right,
      );
      expect(
        TextFieldEx.arrowToTraversalDirection(LogicalKeyboardKey.select),
        isNull,
      );
    });

    test('SettingManager.notifyTvModeChanged syncs TextFieldEx.popupEdit and fires listeners', () {
      int notifyCount = 0;
      void listener() => notifyCount++;

      SettingManager.onTvModeChanged.add(listener);
      try {
        SettingManager.getConfig().ui.tvMode = true;
        SettingManager.notifyTvModeChanged();
        expect(TextFieldEx.popupEdit, isTrue);
        expect(notifyCount, 1);

        SettingManager.getConfig().ui.tvMode = false;
        SettingManager.notifyTvModeChanged();
        expect(TextFieldEx.popupEdit, isFalse);
        expect(notifyCount, 2);
      } finally {
        SettingManager.onTvModeChanged.remove(listener);
      }
    });

    test('SettingConfigItemUI.maybeTv reflects native Android TV detection', () {
      SettingConfigItemUI.detectedAndroidTv = true;
      expect(SettingConfigItemUI.maybeTv(), isTrue);
      SettingConfigItemUI.detectedAndroidTv = false;
    });

    test('All 9 locales contain non-empty tvMode and tvModeTips translations', () async {
      for (final locale in AppLocale.values) {
        final tr = await locale.build();
        expect(tr.meta.tvMode.trim().isNotEmpty, isTrue);
        expect(tr.meta.tvModeTips.trim().isNotEmpty, isTrue);
      }
    });

    testWidgets('Tapping TextFieldEx in TV Mode opens only a single popup dialog', (tester) async {
      SettingManager.getConfig().ui.tvMode = true;
      SettingManager.notifyTvModeChanged();
      final controller = TextEditingController(text: 'initial');

      await tester.pumpWidget(
        TranslationProvider(
          child: MaterialApp(
            home: Scaffold(
              body: TextFieldEx(
                controller: controller,
                title: 'Server Address',
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextFieldEx));
      await tester.pumpAndSettle();

      // Verify exactly one AlertDialog opened (no double dialog stacking)
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Server Address'), findsOneWidget);

      // Tap Cancel and verify dialog closes cleanly
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}
