import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/app/modules/diversion_template_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/geo_assets_screen.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:wmimo/screens/rule_providers_add_or_edit_screen.dart';

class RuleProvidersScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return RouteSettings(name: "RuleProvidersScreen");
  }

  const RuleProvidersScreen({super.key});

  @override
  State<RuleProvidersScreen> createState() => _RuleProvidersScreenState();
}

class _RuleProvidersScreenState
    extends LasyRenderingState<RuleProvidersScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const SizedBox(
                        width: 50,
                        height: 30,
                        child: Icon(Icons.arrow_back_ios_outlined, size: 26),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        tcontext.meta.ruleProviders,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            settings: GeoAssetsScreen.routSettings(),
                            builder: (context) => const GeoAssetsScreen(),
                          ),
                        );
                      },
                      child: const SizedBox(
                        width: 44,
                        height: 30,
                        child: Icon(Icons.public, size: 24),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        onTapAdd();
                      },
                      child: const SizedBox(
                        width: 44,
                        height: 30,
                        child: Icon(Icons.add_outlined, size: 26),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
                  child: _loadListView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loadListView() {
    Size windowSize = MediaQuery.of(context).size;
    final ruleProviders = DiversionTemplateManager.getRuleProviders();

    List<Widget> widgets = [];
    for (int i = 0; i < ruleProviders.length; ++i) {
      widgets.add(
        SizedBox(
          key: Key(i.toString()),
          child: createWidget(i, ruleProviders[i], windowSize),
        ),
      );
    }
    return Scrollbar(
      child: ReorderableListView(
        children: widgets,
        onReorderItem: (int oldIndex, int newIndex) {
          DiversionTemplateManager.reorderRuleProvider(oldIndex, newIndex);
          DiversionTemplateManager.save();
          setState(() {});
        },
      ),
    );
  }

  Widget createWidget(int index, RuleProvider current, Size windowSize) {
    final tcontext = Translations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      child: Material(
        borderRadius: ThemeDefine.kBorderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          height: ThemeConfig.kListItemHeight2,
          child: Row(
            children: [
              Expanded(
                child: InkWell(
                  borderRadius: ThemeDefine.kBorderRadius,
                  onTap: () {
                    onTapEdit(current.name);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      current.name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: ThemeConfig.kFontSizeGroupItem,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(
                  Icons.sync,
                  size: 22,
                  color: Colors.blueAccent,
                ),
                splashRadius: 20,
                onPressed: () async {
                  final err = await ClashHttpApi.updateRuleProvider(current.name);
                  if (!context.mounted) return;
                  final ok = err == null;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ok
                          ? "${current.name}: ${tcontext.dns.updateSuccess}"
                          : "${current.name}: ${err.message}"),
                      backgroundColor: ok
                          ? ThemeDefine.kColorGreenBright
                          : ThemeDefine.kColorRed,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outlined,
                  size: 24,
                  color: Colors.red,
                ),
                splashRadius: 20,
                tooltip: tcontext.meta.remove,
                onPressed: () async {
                  onTapDelete(current.name);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onTapAdd() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: RuleProvidersAddOrEditScreen.routSettings(),
        builder: (context) => RuleProvidersAddOrEditScreen(),
      ),
    );
    setState(() {});
  }

  void onTapDelete(String name) async {
    DiversionTemplateManager.removeRuleProviderByName(name);
    DiversionTemplateManager.save();
    setState(() {});
  }

  void onTapEdit(String name) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: RuleProvidersAddOrEditScreen.routSettings(),
        builder: (context) => RuleProvidersAddOrEditScreen(name: name),
      ),
    );
    setState(() {});
  }
}
