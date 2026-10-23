import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';
import 'package:wmimo/screens/widgets/wmimo_app_bar.dart';

class DonateScreen extends LasyRenderingStatefulWidget {
  static RouteSettings routSettings() {
    return const RouteSettings(name: "DonateScreen");
  }

  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() => _DonateScreenState();
}

class _DonateScreenState extends LasyRenderingState<DonateScreen> {
  static const String walletAddress =
      "0xce0c3a1d7d8547eb7effd887095da438b89e3edd70e7c7e7927c244c2dd7f345";
  static const String networkName = "APTOS";
  static const String currency = "USDT";

  bool _isCopied = false;

  void _copyAddress() {
    HapticFeedback.selectionClick();
    final t = Translations.of(context);
    Clipboard.setData(const ClipboardData(text: walletAddress));
    setState(() {
      _isCopied = true;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.meta.donateAddressCopied,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final innerBgColor = isDark
        ? ThemeDefine.kColorDarkInner
        : const Color(0xFFF1F5F9).withValues(alpha: 0.85);
    final innerBorderColor = isDark
        ? ThemeDefine.kColorDarkBorder
        : const Color(0xFFE2E8F0);

    return Scaffold(
      appBar: WmimoAppBar(
        title: Text(tcontext.meta.donateTitle),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: theme.dividerColor.withValues(alpha: 0.35),
                    width: 0.8,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header Row (matches TrafficChartCard & IpInfoCard)
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF0EA5E9)
                                      .withValues(alpha: 0.32),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              tcontext.meta.donate,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.2,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeDefine.kColorGreenBright.withValues(
                                alpha: isDark ? 0.15 : 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: ThemeDefine.kColorGreenBright
                                    .withValues(alpha: 0.35),
                                width: 0.8,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: ThemeDefine.kColorGreenBright,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  "$currency · $networkName",
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    color: ThemeDefine.kColorGreenBright,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tcontext.meta.donateThankYou,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.62),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 2. Inner QR Code + 2-Column Spec Box
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(12, 14, 12, 10),
                        decoration: BoxDecoration(
                          color: innerBgColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: innerBorderColor,
                            width: 0.8,
                          ),
                        ),
                        child: Column(
                          children: [
                            // Crisp White QR Frame
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 0.8,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.asset(
                                  "assets/images/donate_qr.png",
                                  width: 144,
                                  height: 144,
                                  fit: BoxFit.contain,
                                  filterQuality: FilterQuality.medium,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Divider(
                              height: 1,
                              thickness: 0.8,
                              color: theme.dividerColor.withValues(alpha: 0.25),
                            ),
                            const SizedBox(height: 8),
                            // 2-Column Token & Network Grid
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildSpecCell(
                                      context: context,
                                      icon: Icons.monetization_on_outlined,
                                      iconColor: ThemeDefine.kColorGreenBright,
                                      label: tcontext.meta.tokenCurrency,
                                      value: currency,
                                    ),
                                  ),
                                  Container(
                                    width: 0.8,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    color: theme.dividerColor
                                        .withValues(alpha: 0.25),
                                  ),
                                  Expanded(
                                    child: _buildSpecCell(
                                      context: context,
                                      icon: Icons.hub_outlined,
                                      iconColor: ThemeDefine.kColorBlueLight,
                                      label: tcontext.meta.networkChain,
                                      value: networkName,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 3. One-Click Deposit Address Box (No Duplicate Bottom Button)
                      InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: _copyAddress,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: innerBgColor,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isCopied
                                  ? ThemeDefine.kColorGreenBright
                                      .withValues(alpha: 0.6)
                                  : innerBorderColor,
                              width: 0.8,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.account_balance_wallet_outlined,
                                    size: 13,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.55),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      tcontext.meta.depositAddress,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (_isCopied
                                              ? ThemeDefine.kColorGreenBright
                                              : ThemeDefine.kColorBlue)
                                          .withValues(
                                        alpha: isDark ? 0.18 : 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          _isCopied
                                              ? Icons.check_rounded
                                              : Icons.copy_rounded,
                                          size: 12,
                                          color: _isCopied
                                              ? ThemeDefine.kColorGreenBright
                                              : ThemeDefine.kColorBlue,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _isCopied
                                              ? tcontext.meta.copySuccess
                                              : tcontext.meta.clickToCopy,
                                          style: TextStyle(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w600,
                                            color: _isCopied
                                                ? ThemeDefine.kColorGreenBright
                                                : ThemeDefine.kColorBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 7),
                              Text(
                                walletAddress,
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "monospace",
                                  letterSpacing: 0.25,
                                  height: 1.35,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.88),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // 4. Compact Footer Tip
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 1.5),
                            child: Icon(
                              Icons.info_outline_rounded,
                              size: 13,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.45),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              tcontext.meta.donateTip,
                              style: TextStyle(
                                fontSize: 11,
                                height: 1.35,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.48),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSpecCell({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 12, color: iconColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.58),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2.5),
        Text(
          value,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.92),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
