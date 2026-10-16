import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/screens/widgets/brand_vector_icon.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BrandVectorIcon Tests', () {
    final brands = [
      'cloudflare',
      'cf',
      'google',
      'youtube',
      'openai',
      'chatgpt',
      'bilibili',
      'bili',
      'netflix',
      'fast',
      'github',
      'apple',
      'akamai',
      'cachefly',
      'custom',
      'unknown-provider',
    ];

    for (final brand in brands) {
      testWidgets('Renders $brand icon cleanly without errors', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: BrandVectorIcon(
                  id: brand,
                  size: 32,
                  isSelected: true,
                ),
              ),
            ),
          ),
        );

        expect(find.byType(BrandVectorIcon), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('Custom sizes and unselected state work as expected', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: BrandVectorIcon(
                id: 'cloudflare',
                size: 16,
                isSelected: false,
              ),
            ),
          ),
        ),
      );

      final iconFinder = find.byType(BrandVectorIcon);
      expect(iconFinder, findsOneWidget);
      final RenderBox box = tester.renderObject(iconFinder);
      expect(box.size.width, 16);
      expect(box.size.height, 16);
    });
  });
}
