import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Renders a crisp, brand-accurate vector icon for latency test targets
/// and speedtest servers (Cloudflare, YouTube, OpenAI, Bilibili, Netflix,
/// GitHub, Apple, Fast.com, CacheFly, etc.)
class BrandVectorIcon extends StatelessWidget {
  final String id;
  final double size;
  final double borderRadius;
  final bool isSelected;

  const BrandVectorIcon({
    super.key,
    required this.id,
    this.size = 32.0,
    this.borderRadius = 8.0,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final cleanId = id.toLowerCase().trim();

    Widget iconContent;
    Color bgColor;

    if (cleanId.contains('cloudflare') || cleanId == 'cf') {
      bgColor = const Color(0xFFF38020);
      iconContent = CustomPaint(
        size: Size(size * 0.65, size * 0.65),
        painter: _CloudflarePainter(),
      );
    } else if (cleanId.contains('google') || cleanId.contains('youtube')) {
      bgColor = const Color(0xFFFF0000);
      iconContent = CustomPaint(
        size: Size(size * 0.55, size * 0.45),
        painter: _YouTubePainter(),
      );
    } else if (cleanId.contains('openai') || cleanId.contains('chatgpt')) {
      bgColor = const Color(0xFF10A37F);
      iconContent = CustomPaint(
        size: Size(size * 0.62, size * 0.62),
        painter: _OpenAiPainter(),
      );
    } else if (cleanId.contains('bilibili') || cleanId.contains('bili')) {
      bgColor = const Color(0xFFFB7299);
      iconContent = CustomPaint(
        size: Size(size * 0.65, size * 0.60),
        painter: _BilibiliPainter(),
      );
    } else if (cleanId.contains('netflix')) {
      bgColor = const Color(0xFF141414);
      iconContent = CustomPaint(
        size: Size(size * 0.46, size * 0.60),
        painter: _NetflixPainter(),
      );
    } else if (cleanId.contains('fast')) {
      bgColor = const Color(0xFF1F1F1F);
      iconContent = CustomPaint(
        size: Size(size * 0.65, size * 0.65),
        painter: _FastComPainter(),
      );
    } else if (cleanId.contains('github')) {
      bgColor = const Color(0xFF24292F);
      iconContent = CustomPaint(
        size: Size(size * 0.65, size * 0.65),
        painter: _GitHubPainter(),
      );
    } else if (cleanId.contains('apple') || cleanId.contains('akamai')) {
      bgColor = const Color(0xFF1C1C1E);
      iconContent = Icon(
        Icons.apple,
        size: size * 0.68,
        color: Colors.white,
      );
    } else if (cleanId.contains('cachefly')) {
      bgColor = const Color(0xFFFF5722);
      iconContent = Icon(
        Icons.rocket_launch_rounded,
        size: size * 0.58,
        color: Colors.white,
      );
    } else {
      bgColor = Colors.blueGrey.shade700;
      iconContent = Icon(
        Icons.link_rounded,
        size: size * 0.58,
        color: Colors.white,
      );
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: bgColor.withAlpha(120),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(child: iconContent),
    );
  }
}

/// Cloudflare: Cloud with a sharp lightning bolt in negative space/white
class _CloudflarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    // Draw cloud outline
    final cloudPath = Path();
    cloudPath.moveTo(w * 0.25, h * 0.75);
    cloudPath.lineTo(w * 0.82, h * 0.75);
    cloudPath.cubicTo(w * 0.95, h * 0.75, w * 1.0, h * 0.60, w * 0.88, h * 0.48);
    cloudPath.cubicTo(w * 0.90, h * 0.30, w * 0.75, h * 0.20, w * 0.60, h * 0.25);
    cloudPath.cubicTo(w * 0.50, h * 0.10, w * 0.28, h * 0.15, w * 0.22, h * 0.32);
    cloudPath.cubicTo(w * 0.08, h * 0.36, w * 0.05, h * 0.60, w * 0.18, h * 0.72);
    cloudPath.close();

    canvas.drawPath(cloudPath, paint);

    // Draw lightning bolt cutout / inner accent in orange
    final boltPaint = Paint()
      ..color = const Color(0xFFF38020)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final boltPath = Path();
    boltPath.moveTo(w * 0.54, h * 0.28);
    boltPath.lineTo(w * 0.38, h * 0.52);
    boltPath.lineTo(w * 0.50, h * 0.52);
    boltPath.lineTo(w * 0.44, h * 0.76);
    boltPath.lineTo(w * 0.64, h * 0.46);
    boltPath.lineTo(w * 0.52, h * 0.46);
    boltPath.close();

    canvas.drawPath(boltPath, boltPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// YouTube: Iconic red pill with central white triangle play button
class _YouTubePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final playPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    // Centered equilateral play triangle
    final playPath = Path();
    playPath.moveTo(w * 0.38, h * 0.18);
    playPath.lineTo(w * 0.72, h * 0.50);
    playPath.lineTo(w * 0.38, h * 0.82);
    playPath.close();

    canvas.drawPath(playPath, playPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// OpenAI / ChatGPT: Crisp 6-fold flower spiral
class _OpenAiPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.11
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width * 0.38;

    for (int i = 0; i < 6; i++) {
      final angle = i * (math.pi / 3);
      final x1 = center.dx + r * 0.4 * math.cos(angle);
      final y1 = center.dy + r * 0.4 * math.sin(angle);
      final x2 = center.dx + r * math.cos(angle + 0.5);
      final y2 = center.dy + r * math.sin(angle + 0.5);
      final x3 = center.dx + r * 0.7 * math.cos(angle + 1.1);
      final y3 = center.dy + r * 0.7 * math.sin(angle + 1.1);

      final path = Path()
        ..moveTo(x1, y1)
        ..quadraticBezierTo(x2, y2, x3, y3);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bilibili: Iconic TV with cute top antennas and facial screen
class _BilibiliPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.10
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // Antennas
    canvas.drawLine(Offset(w * 0.35, h * 0.28), Offset(w * 0.18, h * 0.05), strokePaint);
    canvas.drawLine(Offset(w * 0.65, h * 0.28), Offset(w * 0.82, h * 0.05), strokePaint);

    // TV body
    final tvRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, h * 0.24, w, h * 0.72),
      Radius.circular(w * 0.20),
    );
    canvas.drawRRect(tvRect, whitePaint);

    // Face / screen inside TV in pink
    final pinkPaint = Paint()
      ..color = const Color(0xFFFB7299)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final eyeRadius = w * 0.07;
    // Left eye
    canvas.drawCircle(Offset(w * 0.33, h * 0.56), eyeRadius, pinkPaint);
    // Right eye
    canvas.drawCircle(Offset(w * 0.67, h * 0.56), eyeRadius, pinkPaint);

    // Mouth (smile)
    final mouthPaint = Paint()
      ..color = const Color(0xFFFB7299)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.06
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final mouthPath = Path()
      ..moveTo(w * 0.44, h * 0.66)
      ..quadraticBezierTo(w * 0.50, h * 0.74, w * 0.56, h * 0.66);
    canvas.drawPath(mouthPath, mouthPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Netflix: Iconic 'N' ribbon with central diagonal
class _NetflixPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final redDarkPaint = Paint()
      ..color = const Color(0xFFB81D24)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final redBrightPaint = Paint()
      ..color = const Color(0xFFE50914)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final colWidth = w * 0.32;

    // Left vertical bar
    canvas.drawRect(Rect.fromLTWH(0, 0, colWidth, h), redDarkPaint);

    // Right vertical bar
    canvas.drawRect(Rect.fromLTWH(w - colWidth, 0, colWidth, h), redDarkPaint);

    // Diagonal ribbon
    final diagonalPath = Path()
      ..moveTo(0, 0)
      ..lineTo(colWidth, 0)
      ..lineTo(w, h)
      ..lineTo(w - colWidth, h)
      ..close();

    canvas.drawPath(diagonalPath, redBrightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Fast.com: Speedometer with needle
class _FastComPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h * 0.55);
    final radius = w * 0.42;

    final gaugePaint = Paint()
      ..color = Colors.white.withAlpha(160)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.10
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // Gauge arc from 135 deg to 405 deg (270 deg span)
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.5,
      false,
      gaugePaint,
    );

    // Active speed arc (red/cyan)
    final activePaint = Paint()
      ..color = const Color(0xFFE50914)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.10
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      math.pi * 1.0,
      false,
      activePaint,
    );

    // Needle
    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.08
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawLine(
      center,
      Offset(center.dx + radius * 0.65 * math.cos(math.pi * 1.7),
             center.dy + radius * 0.65 * math.sin(math.pi * 1.7)),
      needlePaint,
    );

    // Center pivot
    final pivotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, w * 0.10, pivotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// GitHub: Invertocat silhouette
class _GitHubPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(w * 0.50, h * 0.28);
    path.lineTo(w * 0.34, h * 0.28);
    path.lineTo(w * 0.20, h * 0.12);
    path.cubicTo(w * 0.14, h * 0.35, w * 0.15, h * 0.58, w * 0.24, h * 0.74);
    path.cubicTo(w * 0.32, h * 0.90, w * 0.42, h * 0.95, center.dx, h * 0.95);
    path.cubicTo(w * 0.58, h * 0.95, w * 0.68, h * 0.90, w * 0.76, h * 0.74);
    path.cubicTo(w * 0.85, h * 0.58, w * 0.86, h * 0.35, w * 0.80, h * 0.12);
    path.lineTo(w * 0.66, h * 0.28);
    path.close();

    canvas.drawPath(path, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
