import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/utils/assets_utils.dart';
import 'package:wmimo/app/utils/move_to_background_utils.dart';
import 'package:wmimo/app/utils/platform_utils.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/desktop_window_caption_bar.dart';
import 'package:wmimo/screens/widgets/framework.dart';

class UserAgreementScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "UserAgreementScreen");
  }

  const UserAgreementScreen({super.key});

  @override
  State<UserAgreementScreen> createState() => _UserAgreementScreenState();
}

class _UserAgreementScreenState
    extends LasyRenderingState<UserAgreementScreen> {
  final ScrollController _scrollController = ScrollController();
  String _res = "";

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onDisagreeAndExit() async {
    try {
      await ServicesBinding.instance.exitApplication(AppExitType.required);
    } catch (_) {}
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? ThemeDefine.kColorDarkBg : ThemeDefine.kColorLightBg;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (Platform.isAndroid || Platform.isIOS) {
          MoveToBackgroundUtils.moveToBackground();
        }
      },
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
              top: -60,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 380,
                  height: 240,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        ThemeDefine.kColorBlue.withValues(
                          alpha: isDark ? 0.16 : 0.10,
                        ),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                if (PlatformUtils.isPC())
                  const DesktopWindowCaptionBar(showLeadingLogo: true),
                Expanded(
                  child: SafeArea(
                    top: !PlatformUtils.isPC(),
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 640),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            child: _buildMainCard(tcontext, isDark),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainCard(Translations tcontext, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : const Color(0xFFE2E8F0),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.25)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header section
          _buildHeader(tcontext, isDark),
          const SizedBox(height: 16),
          // Scrollable Terms Body
          _buildTermsBox(tcontext, isDark),
          const SizedBox(height: 16),
          // Highlights Badges Row
          _buildHighlightsRow(tcontext, isDark),
          const SizedBox(height: 20),
          // Action Buttons: Disagree & Exit vs Agree & Continue
          _buildActionButtons(tcontext, isDark),
        ],
      ),
    );
  }

  Widget _buildHeader(Translations tcontext, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // App Logo Badge
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? ThemeDefine.kColorBlue.withValues(alpha: 0.35)
                  : ThemeDefine.kColorBlue.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeDefine.kColorBlue.withValues(
                  alpha: isDark ? 0.22 : 0.12,
                ),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12.5),
            child: Image.asset(
              'assets/images/app_icon_256.png',
              width: 46,
              height: 46,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tcontext.UserAgreementScreen.privacyFirst,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                tcontext.UserAgreementScreen.subtitle,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark
                      ? const Color(0xFF94A3B8)
                      : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTermsBox(Translations tcontext, bool isDark) {
    return Container(
      height: 250,
      decoration: BoxDecoration(
        color: isDark ? ThemeDefine.kColorDarkInner : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark
              ? ThemeDefine.kColorDarkBorder
              : const Color(0xFFE2E8F0),
          width: 0.9,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FutureBuilder<String>(
              future: getData(),
              builder: (context, snapshot) {
                final text = snapshot.data ?? tcontext.UserAgreementScreen.loading;
                return Text(
                  text,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.6,
                    color: isDark
                        ? const Color(0xFFCBD5E1)
                        : const Color(0xFF334155),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightsRow(Translations tcontext, bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildHighlightBadge(
          icon: Icons.shield_outlined,
          label: tcontext.UserAgreementScreen.zeroData,
          isDark: isDark,
        ),
        _buildHighlightBadge(
          icon: Icons.offline_bolt_outlined,
          label: tcontext.UserAgreementScreen.localExecution,
          isDark: isDark,
        ),
        _buildHighlightBadge(
          icon: Icons.verified_user_outlined,
          label: tcontext.UserAgreementScreen.zeroTelemetry,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildHighlightBadge({
    required IconData icon,
    required String label,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.12 : 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ThemeDefine.kColorBlue.withValues(alpha: isDark ? 0.25 : 0.20),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: ThemeDefine.kColorBlue,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(Translations tcontext, bool isDark) {
    return Row(
      children: [
        // Disagree & Exit
        Expanded(
          flex: 1,
          child: OutlinedButton(
            onPressed: _onDisagreeAndExit,
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark
                  ? const Color(0xFFF87171)
                  : const Color(0xFFDC2626),
              backgroundColor: isDark
                  ? const Color(0xFF1F1414)
                  : const Color(0xFFFEF2F2),
              side: BorderSide(
                color: isDark
                    ? const Color(0xFF452222)
                    : const Color(0xFFFECACA),
                width: 1,
              ),
              elevation: 0,
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeDefine.kRadiusMedium),
              ),
            ),
            child: Text(
              tcontext.UserAgreementScreen.disagreeAndExit,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Agree & Continue
        Expanded(
          flex: 1,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeDefine.kColorBlue,
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(0, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeDefine.kRadiusMedium),
              ),
            ),
            child: Text(
              tcontext.UserAgreementScreen.agreeAndContinue,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<String> getData() async {
    if (_res.isNotEmpty) {
      return _res;
    }
    _res = await AssetsUtils.loadUserAgreement();
    return _res;
  }
}
