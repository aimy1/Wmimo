import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/utils/ip_info_helper.dart';
import 'package:wmimo/i18n/strings.g.dart';

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
  bool _expanded = false;
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
      // Reset view to default when disconnected
      if (!widget.isConnected) {
        _showDirect = true;
      } else {
        _showDirect = false;
      }

      // On connect, delay slightly (1.2s) so Mihomo core finishes upstream proxy handshake
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required Widget content,
    required TextStyle titleStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 13.5,
            color: titleStyle.color?.withValues(alpha: 0.65),
          ),
          const SizedBox(width: 4),
          Text("$label: ", style: titleStyle),
          Expanded(child: content),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tcontext = Translations.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelTitleStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6),
    );
    final labelValueStyle = TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white : Colors.black87,
    );

    final currentInfo = _currentInfo;
    final isProxy = _isProxyModeActive;

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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Header: Location icon + Title + Outbound Badge + Toggle/Refresh
            Row(
              children: [
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F).withValues(alpha: isDark ? 0.8 : 0.2),
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF38BDF8),
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  tcontext.meta.ipInfo,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(width: 6),
                // Outbound Type Pill Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isProxy ? const Color(0xFF10B981) : const Color(0xFF3B82F6))
                        .withValues(alpha: isDark ? 0.25 : 0.12),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: (isProxy ? const Color(0xFF10B981) : const Color(0xFF3B82F6))
                          .withValues(alpha: 0.35),
                      width: 0.6,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isProxy ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isProxy ? tcontext.meta.ipProxy : tcontext.meta.ipDirect,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isProxy ? const Color(0xFF10B981) : const Color(0xFF3B82F6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (widget.isConnected) ...[
                  // Switch between Proxy Exit and Local Direct
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      setState(() {
                        _showDirect = !_showDirect;
                      });
                      if (_currentInfo == null) {
                        _fetchCurrentInfo();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.swap_horiz_rounded,
                            size: 13,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            _showDirect ? tcontext.meta.ipProxy : tcontext.meta.ipDirect,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                ],
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _loading ? null : _fetchCurrentInfo,
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: _loading
                        ? const SizedBox(
                            width: 15,
                            height: 15,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.refresh_rounded,
                            size: 18,
                            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.7),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // 2. Content Area
            if (_loading && currentInfo == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        tcontext.meta.ipFetching,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (currentInfo != null) ...[
              // Line 1: IP Hero Row (IP + Type Badge + Mask + Copy)
              Row(
                children: [
                  Text("IP: ", style: labelTitleStyle),
                  Flexible(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4),
                      onTap: () => _copyIp(currentInfo.ip),
                      child: Text(
                        _formatIp(currentInfo.ip),
                        style: labelValueStyle.copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          fontFamily: "monospace",
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // IPv4 / IPv6 Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      currentInfo.ipType,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.7),
                        fontFamily: "monospace",
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      setState(() {
                        _maskIp = !_maskIp;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        _maskIp
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        size: 15,
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => _copyIp(currentInfo.ip),
                    child: Padding(
                      padding: const EdgeInsets.all(2),
                      child: Icon(
                        Icons.copy_rounded,
                        size: 14,
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Line 2: Location
              _buildInfoRow(
                icon: Icons.public_rounded,
                label: tcontext.meta.ipLocation,
                titleStyle: labelTitleStyle,
                content: Row(
                  children: [
                    Text(
                      currentInfo.flagEmoji,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: Platform.isWindows ? 'Emoji' : null,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        currentInfo.locationString,
                        style: labelValueStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Line 3: ISP & ASN
              _buildInfoRow(
                icon: Icons.dns_rounded,
                label: tcontext.meta.ipIsp,
                titleStyle: labelTitleStyle,
                content: Text(
                  [
                    currentInfo.isp.isNotEmpty ? currentInfo.isp : currentInfo.org,
                    if (currentInfo.asn.isNotEmpty) "(${currentInfo.asn})"
                  ].where((s) => s.isNotEmpty).join(' '),
                  style: labelValueStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Expandable Detailed Fields
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                crossFadeState: _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ASN
                    if (currentInfo.asn.isNotEmpty)
                      _buildInfoRow(
                        icon: Icons.hub_rounded,
                        label: tcontext.meta.ipAsn,
                        titleStyle: labelTitleStyle,
                        content: Text(
                          currentInfo.asn,
                          style: labelValueStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Organization (if distinct from ISP)
                    if (currentInfo.org.isNotEmpty && currentInfo.org != currentInfo.isp)
                      _buildInfoRow(
                        icon: Icons.business_rounded,
                        label: tcontext.meta.ipOrg,
                        titleStyle: labelTitleStyle,
                        content: Text(
                          currentInfo.org,
                          style: labelValueStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Timezone
                    if (currentInfo.timezoneDisplay.isNotEmpty)
                      _buildInfoRow(
                        icon: Icons.schedule_rounded,
                        label: tcontext.meta.ipTimezone,
                        titleStyle: labelTitleStyle,
                        content: Text(
                          currentInfo.timezoneDisplay,
                          style: labelValueStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Coordinates
                    if (currentInfo.formattedCoordinates.isNotEmpty)
                      _buildInfoRow(
                        icon: Icons.explore_rounded,
                        label: tcontext.meta.ipCoordinates,
                        titleStyle: labelTitleStyle,
                        content: Text(
                          currentInfo.formattedCoordinates,
                          style: labelValueStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ),

              // Expand/Collapse Toggle Button
              Center(
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    setState(() {
                      _expanded = !_expanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _expanded ? tcontext.meta.ipLessDetails : tcontext.meta.ipMoreDetails,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.primary.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(
                          _expanded
                              ? Icons.keyboard_arrow_up_rounded
                              : Icons.keyboard_arrow_down_rounded,
                          size: 15,
                          color: theme.colorScheme.primary.withValues(alpha: 0.85),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ] else
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _fetchCurrentInfo,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
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
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
