import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/utils/ip_info_helper.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_define.dart';

class IpInfoCard extends StatefulWidget {
  final bool isConnected;
  final int? mixedPort;

  const IpInfoCard({
    super.key,
    required this.isConnected,
    this.mixedPort,
  });

  @override
  State<IpInfoCard> createState() => _IpInfoCardState();
}

class _IpInfoCardState extends State<IpInfoCard> {
  IpInfoData? _proxyIpInfo;
  IpInfoData? _directIpInfo;
  bool _showDirect = false;
  bool _loading = false;
  bool _maskIp = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _fetchCurrentInfo();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant IpInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isConnected != widget.isConnected) {
      _debounceTimer?.cancel();
      if (!widget.isConnected) {
        _showDirect = true;
      } else {
        _showDirect = false;
      }

      final delay = widget.isConnected
          ? const Duration(milliseconds: 1200)
          : const Duration(milliseconds: 150);
      _debounceTimer = Timer(delay, () {
        if (mounted) {
          _fetchCurrentInfo();
        }
      });
    }
  }

  IpInfoData? get _currentInfo => _isProxyModeActive ? _proxyIpInfo : _directIpInfo;

  bool get _isProxyModeActive => widget.isConnected && !_showDirect;

  Future<void> _fetchCurrentInfo() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });

    final isProxy = _isProxyModeActive;
    final port = isProxy ? widget.mixedPort : null;
    final info = await IpInfoHelper.fetchIpInfo(
      isProxy: isProxy,
      proxyPort: port,
    );

    if (!mounted) return;
    setState(() {
      if (isProxy) {
        _proxyIpInfo = info;
      } else {
        _directIpInfo = info;
      }
      _loading = false;
    });
  }

  void _copyIp(String ip) {
    HapticFeedback.selectionClick();
    Clipboard.setData(ClipboardData(text: ip));
    final tcontext = Translations.of(context);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(tcontext.meta.ipCopied),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  String _formatIp(String ip) {
    if (!_maskIp) return ip;
    final parts = ip.split('.');
    if (parts.length == 4) {
      return '${parts[0]}.${parts[1]}.*.*';
    }
    final colonParts = ip.split(':');
    if (colonParts.length > 2) {
      return '${colonParts[0]}:${colonParts[1]}:****:****';
    }
    return '***.***.***.***';
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentInfo = _currentInfo;
    final isProxy = _isProxyModeActive;

    final innerBgColor = isDark
        ? ThemeDefine.kColorDarkInner
        : const Color(0xFFF1F5F9);
    final gridBgColor = isDark
        ? ThemeDefine.kColorDarkInner
        : const Color(0xFFF1F5F9).withValues(alpha: 0.8);
    final innerBorderColor = isDark
        ? ThemeDefine.kColorDarkBorder
        : const Color(0xFFE2E8F0);

    final statusColor = isProxy
        ? ThemeDefine.kColorGreenBright
        : ThemeDefine.kColorBlue;

    return Card(
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
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Card Header (matches TrafficChartCard header style)
            Row(
              children: [
                Icon(
                  Icons.public_rounded,
                  size: 20,
                  color: ThemeDefine.kColorBlue,
                ),
                const SizedBox(width: 7),
                Text(
                  tcontext.meta.ipInfo,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                // Current Mode Status (Scheme 1: pure text + status dot, borderless & background-less)
                InkWell(
                  borderRadius: BorderRadius.circular(4),
                  onTap: widget.isConnected
                      ? () {
                          HapticFeedback.selectionClick();
                          setState(() {
                            _showDirect = !_showDirect;
                          });
                          if (_currentInfo == null) {
                            _fetchCurrentInfo();
                          }
                        }
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          isProxy ? tcontext.meta.ipProxy : tcontext.meta.ipDirect,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: statusColor,
                          ),
                        ),
                        if (widget.isConnected) ...[
                          const SizedBox(width: 3),
                          Icon(
                            Icons.swap_horiz_rounded,
                            size: 13,
                            color: statusColor,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Refresh Button
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: _loading ? null : _fetchCurrentInfo,
                  child: Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDark
                          ? ThemeDefine.kColorDarkElevated
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.3),
                        width: 0.8,
                      ),
                    ),
                    child: _loading
                        ? SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(
                              strokeWidth: 1.8,
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : Icon(
                            Icons.refresh_rounded,
                            size: 14.5,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 2. Body Content
            if (_loading && currentInfo == null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 22),
                decoration: BoxDecoration(
                  color: innerBgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: innerBorderColor, width: 0.8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tcontext.meta.ipFetching,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              )
            else if (currentInfo != null) ...[
              // 2a. Inner IP Hero Banner Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: innerBgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: innerBorderColor,
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    // Country Flag & Code
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          currentInfo.flagEmoji,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.1,
                            fontFamily: Platform.isWindows ? 'Emoji' : null,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          currentInfo.countryCode.isNotEmpty
                              ? currentInfo.countryCode.toUpperCase()
                              : 'IP',
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    // Monospace IP Address
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: () => _copyIp(currentInfo.ip),
                              child: Text(
                                _formatIp(currentInfo.ip),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: 'monospace',
                                  letterSpacing: 0.3,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // IPv4 / IPv6 tag
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: (isDark ? Colors.white : Colors.black)
                                  .withValues(alpha: 0.07),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              currentInfo.ipType,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'monospace',
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Mask / Unmask Button
                    _buildMiniActionButton(
                      context: context,
                      isDark: isDark,
                      icon: _maskIp
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _maskIp = !_maskIp;
                        });
                      },
                    ),
                    const SizedBox(width: 5),
                    // Copy IP Button
                    _buildMiniActionButton(
                      context: context,
                      isDark: isDark,
                      icon: Icons.copy_rounded,
                      onTap: () => _copyIp(currentInfo.ip),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // 2b. 2x2 Structured Metadata Grid (matches TrafficChartCard bottom stat container)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  color: gridBgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: theme.dividerColor.withValues(alpha: 0.25),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildGridItem(
                              context: context,
                              icon: Icons.place_outlined,
                              iconColor: const Color(0xFF38BDF8),
                              label: tcontext.meta.ipLocation,
                              value: "${currentInfo.flagEmoji} ${currentInfo.locationString}",
                            ),
                          ),
                          _buildVerticalDivider(theme),
                          Expanded(
                            child: _buildGridItem(
                              context: context,
                              icon: Icons.dns_outlined,
                              iconColor: const Color(0xFF818CF8),
                              label: tcontext.meta.ipIsp,
                              value: (currentInfo.isp.isNotEmpty
                                      ? currentInfo.isp
                                      : currentInfo.org)
                                  .isNotEmpty
                                  ? (currentInfo.isp.isNotEmpty
                                      ? currentInfo.isp
                                      : currentInfo.org)
                                  : '-',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Divider(
                        height: 1,
                        thickness: 0.8,
                        color: theme.dividerColor.withValues(alpha: 0.22),
                      ),
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildGridItem(
                              context: context,
                              icon: Icons.hub_outlined,
                              iconColor: const Color(0xFF10B981),
                              label: tcontext.meta.ipAsn,
                              value: currentInfo.asn.isNotEmpty
                                  ? currentInfo.asn
                                  : '-',
                            ),
                          ),
                          _buildVerticalDivider(theme),
                          Expanded(
                            child: _buildGridItem(
                              context: context,
                              icon: Icons.schedule_rounded,
                              iconColor: const Color(0xFFF59E0B),
                              label: tcontext.meta.ipTimezone,
                              value: currentInfo.timezoneDisplay.isNotEmpty
                                  ? currentInfo.timezoneDisplay
                                  : (currentInfo.formattedCoordinates.isNotEmpty
                                      ? currentInfo.formattedCoordinates
                                      : '-'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: _fetchCurrentInfo,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    color: innerBgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: innerBorderColor, width: 0.8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.refresh_rounded,
                        size: 15,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        tcontext.meta.ipTapToFetch,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniActionButton({
    required BuildContext context,
    required bool isDark,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(6),
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 13.5,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
        ),
      ),
    );
  }

  Widget _buildVerticalDivider(ThemeData theme) {
    return Container(
      width: 0.8,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      color: theme.dividerColor.withValues(alpha: 0.25),
    );
  }

  Widget _buildGridItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 11.5, color: iconColor),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10,
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
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.9),
            fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
