import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/app/utils/app_utils.dart';
import 'package:wmimo/screens/widgets/desktop_window_caption_bar.dart';

void main() {
  group('Scheme A Immersive Borderless Window Caption Bar Tests', () {
    testWidgets(
      'Renders drag region and window control buttons on desktop',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: const Scaffold(
              body: Column(
                children: [
                  DesktopWindowCaptionBar(),
                ],
              ),
            ),
          ),
        );

        expect(find.byType(DesktopWindowCaptionBar), findsOneWidget);
        expect(find.byType(DesktopDragArea), findsOneWidget);

        if (Platform.isWindows || Platform.isLinux) {
          expect(find.byKey(const ValueKey('window_btn_minimize')), findsOneWidget);
          expect(find.byKey(const ValueKey('window_btn_maximize')), findsOneWidget);
          expect(find.byKey(const ValueKey('window_btn_close')), findsOneWidget);

          // Tap buttons safely (wrapped in try-catch for test environment)
          await tester.tap(find.byKey(const ValueKey('window_btn_minimize')));
          await tester.pump();
          await tester.tap(find.byKey(const ValueKey('window_btn_maximize')));
          await tester.pump();
          await tester.tap(find.byKey(const ValueKey('window_btn_close')));
          await tester.pump();
        }
      },
    );

    testWidgets(
      'Displays app title when showLeadingLogo is enabled for narrow window mode',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: const Scaffold(
              body: Column(
                children: [
                  DesktopWindowCaptionBar(showLeadingLogo: true),
                ],
              ),
            ),
          ),
        );

        if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
          expect(find.text(AppUtils.getName()), findsOneWidget);
        }
      },
    );

    testWidgets(
      'Close button highlights with crimson red on mouse hover',
      (tester) async {
        if (!Platform.isWindows && !Platform.isLinux) return;

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: const Scaffold(
              body: Column(
                children: [
                  DesktopWindowCaptionBar(),
                ],
              ),
            ),
          ),
        );

        final closeBtnFinder = find.byKey(const ValueKey('window_btn_close'));
        expect(closeBtnFinder, findsOneWidget);

        final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await gesture.addPointer(location: Offset.zero);
        addTearDown(gesture.removePointer);

        await gesture.moveTo(tester.getCenter(closeBtnFinder));
        await tester.pumpAndSettle();

        final container = tester.widget<Container>(
          find.descendant(
            of: closeBtnFinder,
            matching: find.byType(Container),
          ),
        );
        final boxDeco = container.decoration as BoxDecoration?;
        expect(boxDeco?.color ?? container.color, const Color(0xFFE81123));
      },
    );
  });
}
