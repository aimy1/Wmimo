import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';

class _LanguageOption {
  final AppLocale locale;
  final String nativeName;
  final String englishName;
  final String flag;

  const _LanguageOption({
    required this.locale,
    required this.nativeName,
    required this.englishName,
    required this.flag,
  });
}

class LanguageSettingsScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "LanguageSettingsScreen");
  }

  final bool canPop;
  final bool? canGoBack;
  final String Function()? nextText;

  const LanguageSettingsScreen({
    super.key,
    required this.canPop,
    required this.canGoBack,
    this.nextText,
  });

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState
    extends LasyRenderingState<LanguageSettingsScreen> {
  final FocusNode _focusNodeNext = FocusNode();

  static const List<_LanguageOption> _languages = [
    _LanguageOption(
      locale: AppLocale.zhCn,
      nativeName: '简体中文',
      englishName: 'Simplified Chinese',
      flag: '🇨🇳',
    ),
    _LanguageOption(
      locale: AppLocale.zhTw,
      nativeName: '繁體中文',
      englishName: 'Traditional Chinese',
      flag: '🇹🇼',
    ),
    _LanguageOption(
      locale: AppLocale.en,
      nativeName: 'English',
      englishName: 'English (US)',
      flag: '🇺🇸',
    ),
    _LanguageOption(
      locale: AppLocale.ja,
      nativeName: '日本語',
      englishName: 'Japanese',
      flag: '🇯🇵',
    ),
    _LanguageOption(
      locale: AppLocale.ko,
      nativeName: '한국어',
      englishName: 'Korean',
      flag: '🇰🇷',
    ),
    _LanguageOption(
      locale: AppLocale.ru,
      nativeName: 'Русский',
      englishName: 'Russian',
      flag: '🇷🇺',
    ),
    _LanguageOption(
      locale: AppLocale.es,
      nativeName: 'Español',
      englishName: 'Spanish',
      flag: '🇪🇸',
    ),
    _LanguageOption(
      locale: AppLocale.fa,
      nativeName: 'فارسی',
      englishName: 'Persian',
      flag: '🇮🇷',
    ),
    _LanguageOption(
      locale: AppLocale.ar,
      nativeName: 'العربية',
      englishName: 'Arabic',
      flag: '🇸🇦',
    ),
  ];

  @override
  void dispose() {
    _focusNodeNext.dispose();
    super.dispose();
    SettingManager.save();
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    var setting = SettingManager.getConfig();
    return PopScope(
      canPop: widget.canPop,
      child: Scaffold(
        appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
        body: Focus(
          onKeyEvent: onKeyEvent,
          canRequestFocus: false,
          skipTraversal: true,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.canGoBack == true
                            ? InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () => Navigator.pop(context),
                                child: const SizedBox(
                                  width: 40,
                                  height: 36,
                                  child: Icon(
                                    Icons.arrow_back_ios_outlined,
                                    size: 20,
                                  ),
                                ),
                              )
                            : const SizedBox(width: 40, height: 36),
                        Expanded(
                          child: Text(
                            tcontext.meta.language,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: ThemeConfig.kFontWeightTitle,
                              fontSize: ThemeConfig.kFontSizeTitle,
                            ),
                          ),
                        ),
                        widget.nextText != null
                            ? SizedBox(
                                height: 36,
                                child: InkWell(
                                  autofocus: setting.ui.tvMode,
                                  focusNode: _focusNodeNext,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Center(
                                    child: Text(
                                      widget.nextText!.call(),
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight:
                                            ThemeConfig.kFontWeightListItem,
                                        fontSize: ThemeConfig.kFontSizeListItem,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(width: 40),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _loadListView()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  KeyEventResult onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowRight:
          if (widget.nextText != null) {
            _focusNodeNext.requestFocus();
            return KeyEventResult.handled;
          }
      }
    }
    return KeyEventResult.ignored;
  }

  Widget _loadListView() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      itemCount: _languages.length,
      itemBuilder: (BuildContext context, int index) {
        return createWidget(_languages[index]);
      },
    );
  }

  Widget createWidget(_LanguageOption item) {
    final isSelected = LocaleSettings.currentLocale == item.locale;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected
            ? ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.2 : 0.1)
            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => onTapItem(item),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? ThemeDefine.kColorBlue
                    : theme.dividerColor.withValues(alpha: 0.2),
                width: isSelected ? 1.5 : 0.8,
              ),
            ),
            child: Row(
              children: [
                Text(
                  item.flag,
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: Platform.isWindows ? 'Emoji' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.nativeName,
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isSelected ? ThemeDefine.kColorBlue : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.englishName,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: ThemeDefine.kColorBlue,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onTapItem(_LanguageOption item) async {
    setState(() {});
    SettingManager.getConfig().languageTag = item.locale.languageTag;
    SettingManager.save();
    await LocaleSettings.setLocale(item.locale);
    if (widget.nextText == null) {
      if (!mounted) {
        return;
      }
      Navigator.pop(context);
    }
  }
}
