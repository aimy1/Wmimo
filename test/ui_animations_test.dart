import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/animated_indexed_stack.dart';

class _StatefulCounterTab extends StatefulWidget {
  final String label;
  const _StatefulCounterTab({super.key, required this.label});

  @override
  State<_StatefulCounterTab> createState() => _StatefulCounterTabState();
}

class _StatefulCounterTabState extends State<_StatefulCounterTab> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => count++),
      child: Text('${widget.label}:$count'),
    );
  }
}

void main() {
  test('ThemeDefine exposes unified motion tokens', () {
    expect(ThemeDefine.kDurationMicro, const Duration(milliseconds: 150));
    expect(ThemeDefine.kDurationState, const Duration(milliseconds: 200));
    expect(ThemeDefine.kDurationView, const Duration(milliseconds: 220));
    expect(ThemeDefine.kCurveStandard, Curves.easeOutCubic);
    expect(ThemeDefine.kCurveEmphasized, Curves.easeOutQuart);
    expect(ThemeDefine.kCurveView, Curves.fastOutSlowIn);
  });

  testWidgets(
    'AnimatedIndexedStack preserves child state and animates fade/slide on tab change',
    (tester) async {
      int currentIndex = 0;
      late StateSetter setHostState;

      await tester.pumpWidget(
        MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              return Scaffold(
                body: AnimatedIndexedStack(
                  index: currentIndex,
                  children: const [
                    _StatefulCounterTab(key: ValueKey('tab0'), label: 'TabA'),
                    _StatefulCounterTab(key: ValueKey('tab1'), label: 'TabB'),
                  ],
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('TabA:0'), findsOneWidget);
      await tester.tap(find.text('TabA:0'));
      await tester.pump();
      expect(find.text('TabA:1'), findsOneWidget);

      // Switch to tab 1
      setHostState(() {
        currentIndex = 1;
      });
      await tester.pump();

      final fadeTransition = tester.widget<FadeTransition>(
        find.descendant(
          of: find.byType(AnimatedIndexedStack),
          matching: find.byType(FadeTransition),
        ),
      );
      expect(fadeTransition.opacity.value, lessThan(1.0));

      // Mid-animation frame
      await tester.pump(const Duration(milliseconds: 90));
      expect(fadeTransition.opacity.value, greaterThan(0.0));
      expect(fadeTransition.opacity.value, lessThan(1.0));

      // Complete animation
      await tester.pumpAndSettle();
      expect(fadeTransition.opacity.value, 1.0);
      expect(find.text('TabB:0'), findsOneWidget);

      // Switch back to tab 0 and verify state was preserved
      setHostState(() {
        currentIndex = 0;
      });
      await tester.pumpAndSettle();
      expect(find.text('TabA:1'), findsOneWidget);
    },
  );

  testWidgets(
    'AnimatedIndexedStack respects MediaQuery disableAnimations',
    (tester) async {
      int currentIndex = 0;
      late StateSetter setHostState;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(disableAnimations: true),
              child: child!,
            );
          },
          home: StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              return Scaffold(
                body: AnimatedIndexedStack(
                  index: currentIndex,
                  children: const [
                    Text('Page 0'),
                    Text('Page 1'),
                  ],
                ),
              );
            },
          ),
        ),
      );

      setHostState(() {
        currentIndex = 1;
      });
      await tester.pump();

      final fadeTransition = tester.widget<FadeTransition>(
        find.descendant(
          of: find.byType(AnimatedIndexedStack),
          matching: find.byType(FadeTransition),
        ),
      );
      expect(fadeTransition.opacity.value, 1.0);
    },
  );
}
