import 'package:wmimo/app/modules/diversion_template_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/rule_templates_add_or_edit_screen.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:flutter/material.dart';

class RuleTemplatesScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return RouteSettings(name: "RuleTemplatesScreen");
  }

  const RuleTemplatesScreen({super.key});

  @override
  State<RuleTemplatesScreen> createState() => _RuleTemplatesScreenState();
}

class _RuleTemplatesScreenState
    extends LasyRenderingState<RuleTemplatesScreen> {
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
                        tcontext.meta.ruleTemplates,
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
                        onTapAdd();
                      },
                      child: const SizedBox(
                        width: 50,
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
    final ruleTemplates = DiversionTemplateManager.getRuleTemplates();

    List<Widget> widgets = [];
    for (int i = 0; i < ruleTemplates.length; ++i) {
      widgets.add(
        SizedBox(
          key: Key(i.toString()),
          child: createWidget(i, ruleTemplates[i], windowSize),
        ),
      );
    }

    return Scrollbar(
      child: ReorderableListView(
        children: widgets,
        onReorderItem: (int oldIndex, int newIndex) {
          DiversionTemplateManager.reorderRuleTemplates(oldIndex, newIndex);
          DiversionTemplateManager.save();
          setState(() {});
        },
      ),
    );
  }

  Widget createWidget(int index, RuleTemplate current, Size windowSize) {
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
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(
                  Icons.remove_circle_outlined,
                  size: 24,
                  color: Colors.red,
                ),
                splashRadius: 20,
                tooltip: Translations.of(context).meta.remove,
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
        settings: RuleTemplatesAddOrEditScreen.routSettings(),
        builder: (context) => RuleTemplatesAddOrEditScreen(),
      ),
    );
    setState(() {});
  }

  void onTapDelete(String name) async {
    DiversionTemplateManager.removeRuleTemplateByName(name);
    DiversionTemplateManager.save();
    setState(() {});
  }

  void onTapEdit(String name) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        settings: RuleTemplatesAddOrEditScreen.routSettings(),
        builder: (context) => RuleTemplatesAddOrEditScreen(name: name),
      ),
    );
    setState(() {});
  }
}
