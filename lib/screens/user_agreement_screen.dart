import 'dart:io';

import 'package:flutter/material.dart';
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
  String _res = "";

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isChinese = LocaleSettings.currentLocale.languageCode.startsWith('zh');
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
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 20,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildHeader(tcontext, isDark, isChinese),
                                const SizedBox(height: 22),
                                _buildContentCard(isDark, isChinese),
                                const SizedBox(height: 24),
                                _buildConfirmButton(tcontext),
                              ],
                            ),
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

  Widget _buildHeader(Translations tcontext, bool isDark, bool isChinese) {
    return Column(
      children: [
        // App Logo Badge with glowing border
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark
                  ? ThemeDefine.kColorBlue.withValues(alpha: 0.35)
                  : ThemeDefine.kColorBlue.withValues(alpha: 0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: ThemeDefine.kColorBlue.withValues(
                  alpha: isDark ? 0.25 : 0.15,
                ),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.5),
            child: Image.asset(
              'assets/images/app_icon_256.png',
              width: 64,
              height: 64,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          tcontext.UserAgreementScreen.privacyFirst,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          isChinese ? "透明、无痕、完全本地化运行" : "Transparent, Private, Fully Local",
          style: TextStyle(
            fontSize: 13,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContentCard(bool isDark, bool isChinese) {
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
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary Highlight
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ThemeDefine.kColorBlue.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.verified_user_rounded,
                  color: ThemeDefine.kColorBlue,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: FutureBuilder<String>(
                  future: getData(),
                  builder: (context, snapshot) {
                    final data = snapshot.data ?? (isChinese ? "本应用 (Wmimo) 不会收集任何数据" : "This app (Wmimo) does not collect any data");
                    return Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        data,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.45,
                          color: isDark ? Colors.white : const Color(0xFF0F172A),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Divider(
            height: 1,
            thickness: 0.8,
            color: isDark
                ? ThemeDefine.kColorDarkBorder
                : const Color(0xFFF1F5F9),
          ),
          const SizedBox(height: 18),
          // Privacy Points
          _buildPrivacyPoint(
            icon: Icons.history_toggle_off_rounded,
            title: isChinese ? "严格零日志" : "Strict Zero-Log Policy",
            desc: isChinese
                ? "本地绝不记录、更不会上传您的任何访问历史、DNS 查询或浏览隐私数据。"
                : "No browsing history, DNS queries, or user traffic are recorded or uploaded.",
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _buildPrivacyPoint(
            icon: Icons.memory_rounded,
            title: isChinese ? "完全本地执行" : "Local-Only Execution",
            desc: isChinese
                ? "所有路由分流决策与代理隧道连接，均在您的本机环境完全自主运行。"
                : "All routing decisions and proxy tunnels execute entirely on your local machine.",
            isDark: isDark,
          ),
          const SizedBox(height: 14),
          _buildPrivacyPoint(
            icon: Icons.privacy_tip_outlined,
            title: isChinese ? "纯净透明无遥测" : "Zero Telemetry & Tracking",
            desc: isChinese
                ? "不内嵌任何第三方商业遥测、数据分析或广告追踪 SDK，守护您的数据主权。"
                : "Free of third-party telemetry, analytics, or advertising SDKs.",
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacyPoint({
    required IconData icon,
    required String title,
    required String desc,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Icon(
            icon,
            size: 18,
            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
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

  Widget _buildConfirmButton(Translations tcontext) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: ThemeDefine.kColorBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          tcontext.UserAgreementScreen.agreeAndContinue,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  Future<String> getData() async {
    if (_res.isNotEmpty) {
      return _res;
    }
    final isChinese = LocaleSettings.currentLocale.languageCode.startsWith('zh');

    _res = await AssetsUtils.loadUserAgreement(isChinese);
    return _res;
  }
}
