import 'dart:math';
import 'package:flutter/material.dart';

enum SpeedTestPhase {
  idle,
  ping,
  download,
  upload,
  completed,
  stopped,
}

class SpeedTestServer {
  final String id;
  final String name;
  final String region;
  final String regionEn;
  final String icon;
  final List<String> pingUrls;
  final String downloadUrl;
  final String uploadUrl;

  const SpeedTestServer({
    required this.id,
    required this.name,
    required this.region,
    this.regionEn = '',
    required this.icon,
    required this.pingUrls,
    required this.downloadUrl,
    required this.uploadUrl,
  });

  String getDisplayRegion(bool isZh) =>
      isZh || regionEn.isEmpty ? region : regionEn;

  static const List<SpeedTestServer> presets = [
    SpeedTestServer(
      id: 'cloudflare',
      name: 'Cloudflare Anycast',
      region: '全球边缘加速 (Anycast)',
      regionEn: 'Global Anycast CDN',
      icon: '⚡',
      pingUrls: [
        'https://speed.cloudflare.com/__down?bytes=0',
        'https://cp.cloudflare.com/generate_204',
        'https://1.1.1.1/cdn-cgi/trace',
      ],
      downloadUrl: 'https://speed.cloudflare.com/__down?bytes=25000000',
      uploadUrl: 'https://speed.cloudflare.com/__up',
    ),
    SpeedTestServer(
      id: 'fast',
      name: 'Fast.com / Netflix',
      region: '流媒体专属加速骨干',
      regionEn: 'Media Streaming Backbone',
      icon: '🎬',
      pingUrls: [
        'https://api.fast.com/netflix/speedtest/v2',
        'https://speed.cloudflare.com/__down?bytes=0',
      ],
      downloadUrl: 'https://ipv4-c001-sjc001-ix.1.oca.nflxvideo.net/speedtest?size=25000000',
      uploadUrl: 'https://speed.cloudflare.com/__up',
    ),
    SpeedTestServer(
      id: 'apple',
      name: 'Apple / Akamai CDN',
      region: '全球高可用边缘节点',
      regionEn: 'Apple / Akamai Edge CDN',
      icon: '🍎',
      pingUrls: [
        'https://captive.apple.com/hotspot-detect.html',
        'https://speed.cloudflare.com/__down?bytes=0',
      ],
      downloadUrl: 'https://speed.cloudflare.com/__down?bytes=25000000',
      uploadUrl: 'https://speed.cloudflare.com/__up',
    ),
    SpeedTestServer(
      id: 'cachefly',
      name: 'CacheFly CDN',
      region: '国际骨干 CDN 节点',
      regionEn: 'Global Backbone CDN',
      icon: '🚀',
      pingUrls: [
        'https://testfile.cachefly.net/10mb.test',
        'https://speed.cloudflare.com/__down?bytes=0',
      ],
      downloadUrl: 'https://testfile.cachefly.net/100mb.test',
      uploadUrl: 'https://speed.cloudflare.com/__up',
    ),
  ];
}

class NetworkGrade {
  final String gameGrade;
  final String gameDesc;
  final Color gameColor;
  final String streamGrade;
  final String streamDesc;
  final Color streamColor;
  final String meetingGrade;
  final String meetingDesc;
  final Color meetingColor;

  const NetworkGrade({
    required this.gameGrade,
    required this.gameDesc,
    required this.gameColor,
    required this.streamGrade,
    required this.streamDesc,
    required this.streamColor,
    required this.meetingGrade,
    required this.meetingDesc,
    required this.meetingColor,
  });

  factory NetworkGrade.calculate({
    required double ping,
    required double jitter,
    required double download,
    required double upload,
    bool isZh = true,
  }) {
    String gGrade;
    String gDesc;
    Color gColor;
    if (ping > 0 && ping <= 45 && jitter <= 10) {
      gGrade = isZh ? 'S 级' : 'S Tier';
      gDesc = isZh ? '职业电竞级 / 极速丝滑' : 'Pro Esports / Ultra Smooth';
      gColor = const Color(0xFF10B981);
    } else if (ping > 0 && ping <= 85 && jitter <= 20) {
      gGrade = isZh ? 'A 级' : 'A Tier';
      gDesc = isZh ? '稳定顺畅 / 主流竞技无压力' : 'Stable & Smooth / Flawless';
      gColor = const Color(0xFF00E5FF);
    } else if (ping > 0 && ping <= 160) {
      gGrade = isZh ? 'B 级' : 'B Tier';
      gDesc = isZh ? '略有延迟 / 轻度休闲可用' : 'Minor Latency / Casual Gaming';
      gColor = const Color(0xFFF59E0B);
    } else {
      gGrade = isZh ? 'C 级' : 'C Tier';
      gDesc = isZh ? '延迟偏高 / 建议切换优质节点' : 'High Latency / Better Node Needed';
      gColor = const Color(0xFFEF4444);
    }

    String sGrade;
    String sDesc;
    Color sColor;
    if (download >= 80) {
      sGrade = isZh ? '8K 超清' : '8K Ultra HD';
      sDesc = isZh ? '极速秒开 / 蓝光无损画质' : 'Instant Load / Lossless Quality';
      sColor = const Color(0xFF8B5CF6);
    } else if (download >= 30) {
      sGrade = isZh ? '4K 臻彩' : '4K UHD';
      sDesc = isZh ? '秒播无阻 / 杜比视界' : 'Smooth Playback / Dolby Vision';
      sColor = const Color(0xFF00E5FF);
    } else if (download >= 12) {
      sGrade = '1080P';
      sDesc = isZh ? '高清流畅 / 无缝播放' : 'Full HD / Seamless Playback';
      sColor = const Color(0xFF10B981);
    } else {
      sGrade = isZh ? '标清' : 'SD';
      sDesc = isZh ? '轻微缓冲 / 适合基础网页' : 'Minor Buffering / Basic Web';
      sColor = const Color(0xFFF59E0B);
    }

    String mGrade;
    String mDesc;
    Color mColor;
    if (upload >= 20 && jitter <= 15) {
      mGrade = isZh ? '极佳' : 'Excellent';
      mDesc = isZh ? '高清多方视讯 / 桌面演示无延迟' : 'HD Video Calling / Zero Lag';
      mColor = const Color(0xFF10B981);
    } else if (upload >= 6 && jitter <= 30) {
      mGrade = isZh ? '良好' : 'Good';
      mDesc = isZh ? '日常语音视频清晰连贯' : 'Clear & Consistent Voice/Video';
      mColor = const Color(0xFF00E5FF);
    } else {
      mGrade = isZh ? '一般' : 'Fair';
      mDesc = isZh ? '上行较慢 / 建议优先音频' : 'Slow Upload / Audio Preferred';
      mColor = const Color(0xFFF59E0B);
    }

    return NetworkGrade(
      gameGrade: gGrade,
      gameDesc: gDesc,
      gameColor: gColor,
      streamGrade: sGrade,
      streamDesc: sDesc,
      streamColor: sColor,
      meetingGrade: mGrade,
      meetingDesc: mDesc,
      meetingColor: mColor,
    );
  }
}

class SpeedTestRecord {
  final DateTime time;
  final String nodeName;
  final double ping;
  final double jitter;
  final double downloadSpeed;
  final double uploadSpeed;
  final bool isProxy;
  final String serverName;

  SpeedTestRecord({
    required this.time,
    required this.nodeName,
    required this.ping,
    required this.jitter,
    required this.downloadSpeed,
    required this.uploadSpeed,
    required this.isProxy,
    this.serverName = 'Cloudflare',
  });

  Map<String, dynamic> toJson() => {
    'time': time.millisecondsSinceEpoch,
    'nodeName': nodeName,
    'ping': ping,
    'jitter': jitter,
    'downloadSpeed': downloadSpeed,
    'uploadSpeed': uploadSpeed,
    'isProxy': isProxy,
    'serverName': serverName,
  };

  factory SpeedTestRecord.fromJson(Map<String, dynamic> map) {
    return SpeedTestRecord(
      time: DateTime.fromMillisecondsSinceEpoch(
        map['time'] as int? ?? DateTime.now().millisecondsSinceEpoch,
      ),
      nodeName: map['nodeName'] as String? ?? '',
      ping: (map['ping'] as num?)?.toDouble() ?? 0.0,
      jitter: (map['jitter'] as num?)?.toDouble() ?? 0.0,
      downloadSpeed: (map['downloadSpeed'] as num?)?.toDouble() ?? 0.0,
      uploadSpeed: (map['uploadSpeed'] as num?)?.toDouble() ?? 0.0,
      isProxy: map['isProxy'] as bool? ?? true,
      serverName: map['serverName'] as String? ?? 'Cloudflare',
    );
  }
}

/// Official Ookla Speedtest Piecewise Scale Mapping
double speedToProgress(double speed) {
  if (speed <= 0) return 0.0;
  if (speed <= 1.0) return (speed / 1.0) * 0.08;
  if (speed <= 5.0) return 0.08 + ((speed - 1.0) / 4.0) * 0.12;
  if (speed <= 10.0) return 0.20 + ((speed - 5.0) / 5.0) * 0.12;
  if (speed <= 50.0) return 0.32 + ((speed - 10.0) / 40.0) * 0.20;
  if (speed <= 100.0) return 0.52 + ((speed - 50.0) / 50.0) * 0.16;
  if (speed <= 250.0) return 0.68 + ((speed - 100.0) / 150.0) * 0.14;
  if (speed <= 500.0) return 0.82 + ((speed - 250.0) / 250.0) * 0.10;
  if (speed <= 1000.0) return 0.92 + ((speed - 500.0) / 500.0) * 0.08;
  return 1.0;
}

/// The Authentic Speedtest Dial & Needle Painter
class SpeedtestDialPainter extends CustomPainter {
  final double progress;
  final Color color;
  final bool isDark;
  final SpeedTestPhase phase;

  SpeedtestDialPainter({
    required this.progress,
    required this.color,
    required this.isDark,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    const startAngle = 135.0 * (pi / 180.0);
    const sweepTotalAngle = 270.0 * (pi / 180.0);

    // 1. Background Track Arc
    final bgPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepTotalAngle,
      false,
      bgPaint,
    );

    // 2. Speedtest Major & Minor Radial Ticks + Labels
    final majorTicks = [
      {'val': 0.0, 'label': '0'},
      {'val': 1.0, 'label': '1'},
      {'val': 5.0, 'label': '5'},
      {'val': 10.0, 'label': '10'},
      {'val': 50.0, 'label': '50'},
      {'val': 100.0, 'label': '100'},
      {'val': 250.0, 'label': '250'},
      {'val': 500.0, 'label': '500'},
      {'val': 1000.0, 'label': '1G'},
    ];

    final majorTickPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.28)
      ..strokeWidth = 1.5;

    for (final tick in majorTicks) {
      final val = tick['val'] as double;
      final label = tick['label'] as String;
      final fraction = speedToProgress(val);
      final angle = startAngle + sweepTotalAngle * fraction;

      final innerR = radius - 10;
      final outerR = radius - 3;

      final p1 = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      final p2 = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );
      canvas.drawLine(p1, p2, majorTickPaint);

      // Major tick text label
      final textSpan = TextSpan(
        text: label,
        style: TextStyle(
          color: (isDark ? Colors.white : Colors.black)
              .withValues(alpha: 0.45),
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
        ),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final textR = radius - 20;
      final textX = center.dx + textR * cos(angle) - textPainter.width / 2;
      final textY = center.dy + textR * sin(angle) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(textX, textY));
    }

    // Minor ticks
    final minorTickPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.12)
      ..strokeWidth = 1.0;

    for (int i = 0; i <= 36; i++) {
      final fraction = i / 36.0;
      final angle = startAngle + sweepTotalAngle * fraction;
      final innerR = radius - 6;
      final outerR = radius - 3;

      final p1 = Offset(
        center.dx + innerR * cos(angle),
        center.dy + innerR * sin(angle),
      );
      final p2 = Offset(
        center.dx + outerR * cos(angle),
        center.dy + outerR * sin(angle),
      );
      canvas.drawLine(p1, p2, minorTickPaint);
    }

    // 3. Active Filled Arc (Trails from 0 up to needle)
    final clampedProgress = progress.clamp(0.0, 1.0);
    final activeAngle = sweepTotalAngle * clampedProgress;

    if (activeAngle > 0.005) {
      final activeArcPaint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        activeAngle,
        false,
        activeArcPaint,
      );
    }

    // 4. The Authentic Speedtest Needle
    final needleAngle = startAngle + sweepTotalAngle * progress;
    final needleLength = radius - 24;

    final needleTip = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );

    final perpAngle = needleAngle + pi / 2;
    const baseWidth = 3.2;

    final pLeft = Offset(
      center.dx + baseWidth * cos(perpAngle),
      center.dy + baseWidth * sin(perpAngle),
    );
    final pRight = Offset(
      center.dx - baseWidth * cos(perpAngle),
      center.dy - baseWidth * sin(perpAngle),
    );

    // Counterweight tail
    const tailLength = 12.0;
    final tailPoint = Offset(
      center.dx - tailLength * cos(needleAngle),
      center.dy - tailLength * sin(needleAngle),
    );

    final needlePath = Path()
      ..moveTo(needleTip.dx, needleTip.dy)
      ..lineTo(pLeft.dx, pLeft.dy)
      ..lineTo(tailPoint.dx, tailPoint.dy)
      ..lineTo(pRight.dx, pRight.dy)
      ..close();

    final needlePaint = Paint()
      ..color = (progress > 0.01) ? color : (isDark ? Colors.white70 : Colors.black45)
      ..style = PaintingStyle.fill;
    canvas.drawPath(needlePath, needlePaint);

    // 5. Center Hub Disc
    final hubOuterPaint = Paint()
      ..color = isDark ? const Color(0xFF262629) : const Color(0xFFF1F5F9)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 9, hubOuterPaint);

    final hubBorderPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, 9, hubBorderPaint);

    final hubCenterPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 3.5, hubCenterPaint);
  }

  @override
  bool shouldRepaint(covariant SpeedtestDialPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.isDark != isDark ||
        oldDelegate.phase != phase;
  }
}

class SpeedChartPainter extends CustomPainter {
  final List<double> downloadSamples;
  final List<double> uploadSamples;
  final bool isDark;

  SpeedChartPainter({
    required this.downloadSamples,
    required this.uploadSamples,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08)
      ..strokeWidth = 0.8;

    for (final ratio in [0.25, 0.5, 0.75, 1.0]) {
      final y = size.height * ratio;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    double maxVal = 10.0;
    for (final v in downloadSamples) {
      if (v > maxVal) maxVal = v;
    }
    for (final v in uploadSamples) {
      if (v > maxVal) maxVal = v;
    }

    _drawSeries(canvas, size, downloadSamples, maxVal, const Color(0xFF00E5FF));
    _drawSeries(canvas, size, uploadSamples, maxVal, const Color(0xFF8B5CF6));
  }

  void _drawSeries(
    Canvas canvas,
    Size size,
    List<double> samples,
    double maxVal,
    Color color,
  ) {
    if (samples.length < 2) return;

    final path = Path();
    final fillPath = Path();
    final stepX = size.width / max(samples.length - 1, 1);

    for (int i = 0; i < samples.length; i++) {
      final x = i * stepX;
      final normalized = (samples[i] / maxVal).clamp(0.0, 1.0);
      final y = size.height - normalized * (size.height - 6) - 3;
      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo((samples.length - 1) * stepX, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.25),
          color.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant SpeedChartPainter oldDelegate) {
    return oldDelegate.isDark != isDark ||
        oldDelegate.downloadSamples.length != downloadSamples.length ||
        oldDelegate.uploadSamples.length != uploadSamples.length;
  }
}
