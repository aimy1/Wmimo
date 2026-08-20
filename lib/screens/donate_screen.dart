import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';
import 'package:wmimo/screens/widgets/framework.dart';

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
    final t = Translations.of(context);
    Clipboard.setData(const ClipboardData(text: walletAddress));
    setState(() {
      _isCopied = true;
    });

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.favorite_rounded, color: Colors.pinkAccent, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                t.meta.donateAddressCopied,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

    final cardBgColor = isDark ? ThemeDefine.kColorDarkCard : Colors.white;
    final innerBoxBgColor =
        isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC);
    final borderColor =
        theme.dividerColor.withValues(alpha: isDark ? 0.25 : 0.12);

    return Scaffold(
      appBar: PreferredSize(preferredSize: Size.zero, child: AppBar()),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
          child: Column(
            children: [
              // 1. Top Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (ModalRoute.of(context)?.canPop ?? false)
                      InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () => Navigator.pop(context),
                        child: const SizedBox(
                          width: 36,
                          height: 30,
                          child: Icon(Icons.arrow_back_ios_outlined, size: 20),
                        ),
                      )
                    else
                      const SizedBox(width: 36, height: 30),
                    Expanded(
                      child: Text(
                        tcontext.meta.donateTitle,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: ThemeConfig.kFontWeightTitle,
                          fontSize: ThemeConfig.kFontSizeTitle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 36, height: 30),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // 2. Main Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // A. Cute Thank You Greeting Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              color: ThemeDefine.kColorBlue.withValues(
                                alpha: isDark ? 0.12 : 0.08,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: ThemeDefine.kColorBlue.withValues(
                                  alpha: isDark ? 0.22 : 0.16,
                                ),
                                width: 0.8,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text("☕", style: TextStyle(fontSize: 16)),
                                    const SizedBox(width: 6),
                                    Text(
                                      tcontext.meta.donate,
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w700,
                                        color: ThemeDefine.kColorBlue,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Text("✨", style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  tcontext.meta.donateThankYou,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    height: 1.5,
                                    color: isDark
                                        ? const Color(0xFFCBD5E1)
                                        : const Color(0xFF475569),
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // B. Unified Master Donation Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: cardBgColor,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: borderColor,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.2 : 0.04,
                                  ),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // QR Code Container
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                      width: 1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      "assets/images/donate_qr.png",
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Token & Network Chips
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildBadge(
                                      icon: Icons.monetization_on_rounded,
                                      label: "${tcontext.meta.tokenCurrency}: $currency",
                                      color: const Color(0xFF10B981),
                                      isDark: isDark,
                                    ),
                                    const SizedBox(width: 10),
                                    _buildBadge(
                                      icon: Icons.hub_rounded,
                                      label: "${tcontext.meta.networkChain}: $networkName",
                                      color: ThemeDefine.kColorBlue,
                                      isDark: isDark,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                const Divider(height: 1, thickness: 0.8),
                                const SizedBox(height: 16),

                                // Deposit Address Box
                                Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(14),
                                    onTap: _copyAddress,
                                    child: Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: innerBoxBgColor,
                                        borderRadius: BorderRadius.circular(14),
                                        border: Border.all(
                                          color: _isCopied
                                              ? ThemeDefine.kColorBlue
                                              : borderColor,
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                tcontext.meta.depositAddress,
                                                style: TextStyle(
                                                  fontSize: 11.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: theme
                                                      .colorScheme.onSurface
                                                      .withValues(alpha: 0.55),
                                                ),
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    _isCopied
                                                        ? Icons.check_circle_rounded
                                                        : Icons.copy_rounded,
                                                    size: 13,
                                                    color: _isCopied
                                                        ? const Color(0xFF10B981)
                                                        : ThemeDefine.kColorBlue,
                                                  ),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    _isCopied
                                                        ? tcontext.meta.copySuccess
                                                        : tcontext.meta.clickToCopy,
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      fontWeight: FontWeight.w600,
                                                      color: _isCopied
                                                          ? const Color(0xFF10B981)
                                                          : ThemeDefine.kColorBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          SelectableText(
                                            walletAddress,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontFamily: "monospace",
                                              letterSpacing: 0.3,
                                              height: 1.4,
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.85),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Copy Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 44,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeDefine.kColorBlue,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: _copyAddress,
                                    icon: Icon(
                                      _isCopied
                                          ? Icons.check_rounded
                                          : Icons.copy_rounded,
                                      size: 16,
                                    ),
                                    label: Text(
                                      _isCopied
                                          ? tcontext.meta.copySuccess
                                          : tcontext.meta.copyAddressBtn,
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // C. Bottom Tip
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              tcontext.meta.donateTip,
                              style: TextStyle(
                                fontSize: 11.5,
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.45),
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withValues(alpha: isDark ? 0.3 : 0.2),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
