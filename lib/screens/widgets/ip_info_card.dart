import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wmimo/app/utils/ip_info_helper.dart';

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
  IpInfoData? _ipInfo;
  bool _loading = false;
  bool _maskIp = false;
  int _countdown = 300;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _fetchIpInfo();
    _startTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        _countdown = 300;
        _fetchIpInfo();
      }
    });
  }

  @override
  void didUpdateWidget(covariant IpInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isConnected != widget.isConnected) {
      _countdown = 300;
      _fetchIpInfo();
    }
  }

  Future<void> _fetchIpInfo() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });

    final info = await IpInfoHelper.fetchIpInfo(
      proxyPort: widget.isConnected ? widget.mixedPort : null,
      isProxy: widget.isConnected,
    );

    if (!mounted) return;
    setState(() {
      _loading = false;
      if (info != null) {
        _ipInfo = info;
      }
    });
  }

  String _formatIp(String rawIp) {
    if (!_maskIp) return rawIp;
    final parts = rawIp.split('.');
    if (parts.length == 4) {
      return "${parts[0]}.***.***.${parts[3]}";
    }
    if (rawIp.contains(':')) {
      final colons = rawIp.split(':');
      if (colons.length > 2) {
        return "${colons.first}:****:****:${colons.last}";
      }
    }
    return rawIp;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final labelStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      color: isDark ? Colors.white70 : Colors.black87,
    );
    final footerStyle = TextStyle(
      fontSize: 11.5,
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.5),
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: theme.dividerColor.withValues(alpha: 0.35),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header: Location icon + Title + Refresh Button
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F).withValues(alpha: isDark ? 0.8 : 0.2),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF38BDF8),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "IP 信息",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _loading
                      ? null
                      : () {
                          _countdown = 300;
                          _fetchIpInfo();
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: _loading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.refresh_rounded,
                            size: 22,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // 2. Two-Column Grid Content
            if (_loading && _ipInfo == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "正在获取 IP 信息...",
                        style: TextStyle(
                          fontSize: 13,
                          color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_ipInfo != null) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Country, IP, ASN
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Country with Flag
                        Row(
                          children: [
                            Text(
                              _ipInfo!.flagEmoji,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                _ipInfo!.country.isNotEmpty ? _ipInfo!.country : "-",
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // IP Address + Mask toggle & Copy
                        Row(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: _ipInfo!.ip));
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("IP 地址已复制到剪贴板"),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Text(
                                "IP: ${_formatIp(_ipInfo!.ip)}",
                                style: labelStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "monospace",
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
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
                                  color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // ASN
                        Text(
                          "自治域: ${_ipInfo!.asn.isNotEmpty ? _ipInfo!.asn : '-'}",
                          style: labelStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  // Right Column: ISP, Org, Location, Timezone
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "服务商: ${_ipInfo!.isp.isNotEmpty ? _ipInfo!.isp : '-'}",
                          style: labelStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "组织: ${_ipInfo!.org.isNotEmpty ? _ipInfo!.org : '-'}",
                          style: labelStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "位置: ${_ipInfo!.locationCityRegion}",
                          style: labelStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "时区: ${_ipInfo!.timezone.isNotEmpty ? _ipInfo!.timezone : '-'}",
                          style: labelStyle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ] else
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _fetchIpInfo,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "点击检测当前 IP 信息",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 14),

            // 3. Footer: Auto refresh countdown on left, Coordinates on right
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "自动刷新: ${_countdown}s",
                  style: footerStyle,
                ),
                if (_ipInfo != null && _ipInfo!.coordinatesString.isNotEmpty)
                  Text(
                    _ipInfo!.coordinatesString,
                    style: footerStyle,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
