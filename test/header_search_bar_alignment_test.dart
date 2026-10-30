import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

void main() {
  group('Header & Search Bar Alignment across Screens', () {
    testWidgets(
      'WmimoAppBar and WmimoSearchBar share exact 16px left alignment and 38px search height',
      (tester) async {
        final controller = TextEditingController();
        addTearDown(controller.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              appBar: WmimoAppBar(
                title: '代理',
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.refresh_rounded),
                  ),
                ],
              ),
              body: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: WmimoSearchBar(
                          controller: controller,
                          hintText: '搜索节点 (名称/地区/正则)',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        final titleRect = tester.getRect(find.text('代理'));
        final searchBarFinder = find.byType(WmimoSearchBar);
        final searchBarRect = tester.getRect(searchBarFinder);

        // Both title and search bar start at exact x = 16.0
        expect(titleRect.left, 16.0);
        expect(searchBarRect.left, 16.0);

        // Search bar height is strictly 38.0 and top is 52.0 (AppBar) + 4.0 = 56.0
        expect(searchBarRect.height, 38.0);
        expect(searchBarRect.top, 56.0);
      },
    );

    test('All 9 locales define consistent searchProxies, searchProfiles, searchConnections', () async {
      for (final locale in AppLocale.values) {
        final t = await locale.build();
        expect(t.meta.searchProxies.trim(), isNotEmpty);
        expect(t.meta.searchProfiles.trim(), isNotEmpty);
        expect(t.meta.searchConnections.trim(), isNotEmpty);
        expect(t.meta.searchRules.trim(), isNotEmpty);
      }
    });
  });
}
