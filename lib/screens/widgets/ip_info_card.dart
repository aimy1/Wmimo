import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/modules/biz.dart';
import 'package:wmimo/app/modules/setting_manager.dart';
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
  late bool _isCollapsed;
  int _countdown = 240;
  Timer? _countdownTimer;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _isCollapsed = SettingManager.getConfig().ui.collapseIpInfo;
    SettingManager.onHomeCardsChanged.add(_onHomeCardsChanged);
    Biz.onEventProxySelected.add(_onProxyNodeChanged);
    _startAutoRefreshTimer();
    _fetchCurrentInfo();
  }

  @override
  void dispose() {
    SettingManager.onHomeCardsChanged.remove(_onHomeCardsChanged);
    Biz.onEventProxySelected.remove(_onProxyNodeChanged);
    _countdownTimer?.cancel();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onHomeCardsChanged() {
    if (!mounted) return;
    final current = SettingManager.getConfig().ui.collapseIpInfo;
    if (_isCollapsed != current) {
      setState(() {
        _isCollapsed = current;
      });
    }
  }

  void _startAutoRefreshTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_countdown > 1) {
          _countdown--;
        } else {
          _countdown = 240;
          _fetchCurrentInfo();
        }
      });
    });
  }

  void _onProxyNodeChanged(String nodeName) {
    if (!mounted) return;
    setState(() {
      _countdown = 240;
    });
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () {
      if (mounted) {
        _fetchCurrentInfo();
      }
    });
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
      _countdown = 240;
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
            // 1. Card Header
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
                // Current Mode Status Toggle
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
                const SizedBox(width: 6),
                InkWell(
                  borderRadius: BorderRadius.circular(6),
                  onTap: () {
                    setState(() {
                      _isCollapsed = !_isCollapsed;
                      SettingManager.getConfig().ui.collapseIpInfo = _isCollapsed;
                      SettingManager.save();
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: Icon(
                      _isCollapsed
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      size: 20,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),
            if (_isCollapsed) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                child: Row(
                  children: [
                    if (currentInfo != null) ...[
                      Text(
                        currentInfo.flagEmoji,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        currentInfo.country.isNotEmpty
                            ? currentInfo.country
                            : (currentInfo.countryCode.isNotEmpty
                                ? currentInfo.countryCode.toUpperCase()
                                : 'Unknown'),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _formatIp(currentInfo.ip),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'monospace',
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ] else ...[
                      Text(
                        widget.isConnected ? tcontext.meta.connecting : tcontext.meta.disconnected,
                        style: TextStyle(
                          fontSize: 11.5,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 8),

              // 2. Body Content
              if (_loading && currentInfo == null)
              Container(
                constraints: const BoxConstraints(minHeight: 96),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 26),
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
            else if (currentInfo != null)
              Container(
                constraints: const BoxConstraints(minHeight: 96),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: innerBgColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: innerBorderColor,
                    width: 0.8,
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isTwoCol = constraints.maxWidth >= 240;
                    final leftCol = _buildLeftColumn(
                      context: context,
                      theme: theme,
                      isDark: isDark,
                      currentInfo: currentInfo,
                    );
                    final rightCol = _buildRightColumn(
                      context: context,
                      theme: theme,
                      currentInfo: currentInfo,
                    );

                    if (isTwoCol) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: leftCol),
                          const SizedBox(width: 8),
                          Expanded(child: rightCol),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          leftCol,
                          const SizedBox(height: 6),
                          rightCol,
                        ],
                      );
                    }
                  },
                ),
              )
            else
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: _fetchCurrentInfo,
                child: Container(
                  constraints: const BoxConstraints(minHeight: 96),
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
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn({
    required BuildContext context,
    required ThemeData theme,
    required bool isDark,
    required IpInfoData currentInfo,
  }) {
    final tcontext = Translations.of(context);
    final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.55);
    final valueColor = theme.colorScheme.onSurface.withValues(alpha: 0.9);

    final countryName = currentInfo.country.isNotEmpty
        ? currentInfo.country
        : (currentInfo.countryCode.isNotEmpty ? currentInfo.countryCode.toUpperCase() : 'Unknown');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. Country & Flag
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.5),
          child: Row(
            children: [
              Text(
                currentInfo.flagEmoji,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.1,
                  fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  countryName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),

        // 2. IP Address with Eye & Copy
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Flexible(
                child: Text(
                  _formatIp(currentInfo.ip),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    letterSpacing: 0.2,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              _buildMiniActionButton(
                context: context,
                isDark: isDark,
                icon: _maskIp ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _maskIp = !_maskIp;
                  });
                },
              ),
              const SizedBox(width: 3),
              _buildMiniActionButton(
                context: context,
                isDark: isDark,
                icon: Icons.copy_rounded,
                onTap: () => _copyIp(currentInfo.ip),
              ),
            ],
          ),
        ),

        // 3. 自治系统 (ASN)
        _buildInfoLine(
          label: tcontext.meta.ipAsn,
          value: currentInfo.asn.isNotEmpty ? currentInfo.asn : '-',
          labelColor: labelColor,
          valueColor: valueColor,
        ),

        // 4. 自动刷新倒计时
        _buildInfoLine(
          label: tcontext.meta.autoRefresh,
          value: '${_countdown}s',
          labelColor: labelColor,
          valueColor: theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildRightColumn({
    required BuildContext context,
    required ThemeData theme,
    required IpInfoData currentInfo,
  }) {
    final tcontext = Translations.of(context);
    final labelColor = theme.colorScheme.onSurface.withValues(alpha: 0.55);
    final valueColor = theme.colorScheme.onSurface.withValues(alpha: 0.9);

    final ispDisplay = (currentInfo.isp.isNotEmpty ? currentInfo.isp : currentInfo.org).isNotEmpty
        ? (currentInfo.isp.isNotEmpty ? currentInfo.isp : currentInfo.org)
        : '-';

    final orgDisplay = (currentInfo.org.isNotEmpty ? currentInfo.org : currentInfo.isp).isNotEmpty
        ? (currentInfo.org.isNotEmpty ? currentInfo.org : currentInfo.isp)
        : '-';

    final locationDisplay = currentInfo.locationCityRegion.isNotEmpty
        ? currentInfo.locationCityRegion
        : '-';

    final timezoneDisplay = currentInfo.timezone.isNotEmpty
        ? currentInfo.timezone
        : (currentInfo.timezoneUtc.isNotEmpty ? currentInfo.timezoneUtc : '-');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 1. 服务商
        _buildInfoLine(
          label: tcontext.meta.ipIsp,
          value: ispDisplay,
          labelColor: labelColor,
          valueColor: valueColor,
        ),

        // 2. 组织
        _buildInfoLine(
          label: tcontext.meta.ipOrg,
          value: orgDisplay,
          labelColor: labelColor,
          valueColor: valueColor,
        ),

        // 3. 位置
        _buildInfoLine(
          label: tcontext.meta.ipLocation,
          value: locationDisplay,
          labelColor: labelColor,
          valueColor: valueColor,
        ),

        // 4. 时区
        _buildInfoLine(
          label: tcontext.meta.ipTimezone,
          value: timezoneDisplay,
          labelColor: labelColor,
          valueColor: valueColor,
        ),
      ],
    );
  }

  Widget _buildInfoLine({
    required String label,
    required String value,
    required Color labelColor,
    required Color valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 11,
              color: labelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                color: valueColor,
                fontWeight: FontWeight.w600,
                fontFamilyFallback: Platform.isWindows ? const ['Emoji'] : null,
              ),
            ),
          ),
        ],
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
      borderRadius: BorderRadius.circular(5),
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Icon(
          icon,
          size: 12,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
        ),
      ),
    );
  }
}
