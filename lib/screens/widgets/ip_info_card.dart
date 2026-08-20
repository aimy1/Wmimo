import 'dart:async';
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
  IpInfoData? _ipInfo;
  bool _loading = false;
  bool _maskIp = false;

  @override
  void initState() {
    super.initState();
    _fetchIpInfo();
  }

  @override
  void didUpdateWidget(covariant IpInfoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isConnected != widget.isConnected) {
      _fetchIpInfo();
    }
  }

  Future<void> _fetchIpInfo() async {
    if (!mounted) return;
    setState(() {
      _loading = true;
    });

    final port = widget.isConnected ? widget.mixedPort : null;
    final info = await IpInfoHelper.fetchIpInfo(
      isProxy: widget.isConnected,
      proxyPort: port,
    );

    if (!mounted) return;
    setState(() {
      _ipInfo = info;
      _loading = false;
    });
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
    final labelTitleStyle = TextStyle(
      fontSize: 12.5,
      fontWeight: FontWeight.w500,
      color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.6),
    );
    final labelValueStyle = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: isDark ? Colors.white : Colors.black87,
    );

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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 1. Header: Location icon + Title + Refresh Button
            Row(
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A5F).withValues(alpha: isDark ? 0.8 : 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: Color(0xFF38BDF8),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  tcontext.meta.ipInfo,
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _loading ? null : _fetchIpInfo,
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: _loading
                        ? const SizedBox(
                            width: 17,
                            height: 17,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Icons.refresh_rounded,
                            size: 20,
                            color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.7),
                          ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 2. Simplified Content Area
            if (_loading && _ipInfo == null)
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
            else if (_ipInfo != null) ...[
              // Line 1: IP Address + Mask + Copy
              Row(
                children: [
                  Text("IP: ", style: labelTitleStyle),
                  InkWell(
                    borderRadius: BorderRadius.circular(4),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: _ipInfo!.ip));
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(tcontext.meta.ipCopied),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Text(
                      _formatIp(_ipInfo!.ip),
                      style: labelValueStyle.copyWith(
                        fontWeight: FontWeight.w600,
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
                ],
              ),
              const SizedBox(height: 8),

              // Line 2: Location
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${tcontext.meta.ipLocation}: ", style: labelTitleStyle),
                  Text(_ipInfo!.flagEmoji, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      _ipInfo!.locationString,
                      style: labelValueStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Line 3: ISP / ASN
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${tcontext.meta.ipIsp}: ", style: labelTitleStyle),
                  Expanded(
                    child: Text(
                      [
                        _ipInfo!.isp.isNotEmpty ? _ipInfo!.isp : _ipInfo!.org,
                        if (_ipInfo!.asn.isNotEmpty) "(${_ipInfo!.asn})"
                      ].where((s) => s.isNotEmpty).join(' '),
                      style: labelValueStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ] else
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: _fetchIpInfo,
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
