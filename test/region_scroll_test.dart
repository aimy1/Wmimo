import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Test pointerScroll and mouse drag on horizontal controller', (tester) async {
    final controller = ScrollController();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Listener(
            onPointerSignal: (pointerSignal) {
              if (pointerSignal is PointerScrollEvent) {
                final delta = pointerSignal.scrollDelta.dy != 0
                    ? pointerSignal.scrollDelta.dy
                    : pointerSignal.scrollDelta.dx;
                if (delta != 0 && controller.hasClients) {
                  controller.position.pointerScroll(delta);
                }
              }
            },
            child: ScrollConfiguration(
              behavior: const MaterialScrollBehavior().copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: ListView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: 50,
                itemBuilder: (context, index) => SizedBox(
                  width: 100,
                  child: Text('Item $index'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(controller.offset, 0.0);

    // 1. Test vertical mouse wheel scroll
    await tester.sendEventToBinding(
      const PointerScrollEvent(
        position: Offset(50, 50),
        scrollDelta: Offset(0, 120),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.offset, 120.0);

    // 2. Test mouse drag gesture
    final gesture = await tester.startGesture(const Offset(200, 50), kind: PointerDeviceKind.mouse);
    await gesture.moveBy(const Offset(-100, 0));
    await tester.pump();
    await gesture.up();
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(120.0));
  });
}
