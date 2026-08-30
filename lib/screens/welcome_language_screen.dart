// ignore_for_file: unused_catch_stack

import 'package:flutter/material.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
import 'package:wmimo/i18n/strings.g.dart';
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

class WelcomeLanguageScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "WelcomeLanguageScreen");
  }

  const WelcomeLanguageScreen({super.key});

  @override
  State<WelcomeLanguageScreen> createState() => _WelcomeLanguageScreenState();
}

class _WelcomeLanguageScreenState
    extends LasyRenderingState<WelcomeLanguageScreen> {
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
      flag: '🇭🇰',
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

  late AppLocale _selectedLocale;

  @override
  void initState() {
    super.initState();
    _selectedLocale = LocaleSettings.currentLocale;
    if (!_languages.any((l) => l.locale == _selectedLocale)) {
      final tag = SettingManager.getConfig().languageTag;
      final matched = _languages.where((l) => l.locale.languageTag == tag);
      if (matched.isNotEmpty) {
        _selectedLocale = matched.first.locale;
      } else {
        _selectedLocale = AppLocale.zhCn;
      }
    }
  }

  Future<void> _onSelectLocale(_LanguageOption item) async {
    setState(() {
      _selectedLocale = item.locale;
    });
    await LocaleSettings.setLocale(item.locale);
  }

  Future<void> _onConfirm() async {
    SettingManager.getConfig().languageTag = _selectedLocale.languageTag;
    SettingManager.save();
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? ThemeDefine.kColorDarkBg : ThemeDefine.kColorLightBg;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: PreferredSize(
          preferredSize: Size.zero,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        body: Stack(
          children: [
            // Ambient Radial Glow in Background
            Positioned(
              top: -80,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 360,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.18 : 0.12),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 22),
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        _buildHeader(tcontext, isDark),
                        const SizedBox(height: 14),
                        // Language Selection Grid
                        Expanded(
                          child: _buildLanguageGrid(isDark),
                        ),
                        const SizedBox(height: 12),
                        // Confirm Button
                        _buildConfirmButton(tcontext),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Translations tcontext, bool isDark) {
    return Column(
      children: [
        // App Logo Badge with glowing border
        Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF151D2E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark
                  ? ThemeDefine.kColorBlue.withValues(alpha: 0.35)
                  : ThemeDefine.kColorBlue.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.25 : 0.15),
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/images/app_icon_128.png',
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.language_rounded,
              size: 38,
              color: ThemeDefine.kColorBlue,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Pill Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.15 : 0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: ThemeDefine.kColorBlue.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.auto_awesome,
                size: 13,
                color: ThemeDefine.kColorBlue,
              ),
              const SizedBox(width: 5),
              Text(
                tcontext.WelcomeLanguageScreen.welcomeTitle,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: ThemeDefine.kColorBlue,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          tcontext.WelcomeLanguageScreen.selectLanguage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            tcontext.WelcomeLanguageScreen.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.6)
                  : Colors.black.withValues(alpha: 0.55),
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageGrid(bool isDark) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 420;
        final crossAxisCount = isWide ? 2 : 1;
        final childAspectRatio = isWide ? 2.85 : 4.4;

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: _languages.length,
          itemBuilder: (context, index) {
            final item = _languages[index];
            final isSelected = item.locale == _selectedLocale;

            final cardBg = isSelected
                ? (isDark
                    ? ThemeDefine.kColorBlue.withValues(alpha: 0.16)
                    : ThemeDefine.kColorBlue.withValues(alpha: 0.08))
                : (isDark ? const Color(0xFF151D2E) : Colors.white);

            final borderColor = isSelected
                ? ThemeDefine.kColorBlue
                : (isDark
                    ? ThemeDefine.kColorDarkBorder
                    : ThemeDefine.kColorGreyLight.withValues(alpha: 0.8));

            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onSelectLocale(item),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: borderColor,
                      width: isSelected ? 1.8 : 1.0,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: ThemeDefine.kColorBlue.withValues(
                            alpha: isDark ? 0.22 : 0.12,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        )
                      else
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: isDark ? 0.15 : 0.03,
                          ),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Flag Avatar
                      Container(
                        width: 38,
                        height: 38,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.06)
                              : Colors.black.withValues(alpha: 0.04),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          item.flag,
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Text Info
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.nativeName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isSelected
                                    ? (isDark
                                        ? ThemeDefine.kColorBlueLight
                                        : ThemeDefine.kColorBlueDark)
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 1.5),
                            Text(
                              item.englishName,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.45)
                                    : Colors.black.withValues(alpha: 0.45),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Selection Indicator Checkmark
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ThemeDefine.kColorBlue
                              : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? ThemeDefine.kColorBlue
                                : (isDark
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : Colors.black.withValues(alpha: 0.2)),
                            width: 1.5,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check_rounded,
                                size: 15,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildConfirmButton(Translations tcontext) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [
            ThemeDefine.kColorBlue,
            ThemeDefine.kColorBlueDark,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ThemeDefine.kColorBlue.withValues(alpha: 0.35),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          shadowColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        onPressed: _onConfirm,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              tcontext.WelcomeLanguageScreen.start,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward_rounded,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
