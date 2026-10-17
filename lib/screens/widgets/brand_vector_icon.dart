import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Renders a crisp, brand-accurate pure vector icon for latency test targets
/// and speedtest servers (Cloudflare, Google, YouTube, OpenAI, Bilibili, Netflix,
/// Fast.com, GitHub, Apple, Akamai, CacheFly, Custom, etc.)
/// 
/// 100% pure Canvas vector paths — zero external font glyph dependencies,
/// completely immune to font-missing square box (tofu) rendering artifacts.
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
        painter: const _CloudflarePainter(),
      );
    } else if (cleanId.contains('youtube')) {
      bgColor = const Color(0xFFFF0000);
      iconContent = CustomPaint(
        size: Size(size * 0.60, size * 0.48),
        painter: const _YouTubePainter(),
      );
    } else if (cleanId.contains('google')) {
      bgColor = const Color(0xFFFFFFFF);
      iconContent = CustomPaint(
        size: Size(size * 0.62, size * 0.62),
        painter: const _GooglePainter(),
      );
    } else if (cleanId.contains('openai') || cleanId.contains('chatgpt')) {
      bgColor = const Color(0xFF10A37F);
      iconContent = CustomPaint(
        size: Size(size * 0.64, size * 0.64),
        painter: const _OpenAiPainter(),
      );
    } else if (cleanId.contains('bilibili') || cleanId.contains('bili')) {
      bgColor = const Color(0xFFFB7299);
      iconContent = CustomPaint(
        size: Size(size * 0.65, size * 0.62),
        painter: const _BilibiliPainter(),
      );
    } else if (cleanId.contains('netflix')) {
      bgColor = const Color(0xFF141414);
      iconContent = CustomPaint(
        size: Size(size * 0.50, size * 0.62),
        painter: const _NetflixPainter(),
      );
    } else if (cleanId.contains('fast')) {
      bgColor = const Color(0xFF262626);
      iconContent = CustomPaint(
        size: Size(size * 0.65, size * 0.65),
        painter: const _FastComPainter(),
      );
    } else if (cleanId.contains('github')) {
      bgColor = const Color(0xFF24292F);
      iconContent = CustomPaint(
        size: Size(size * 0.65, size * 0.65),
        painter: const _GitHubPainter(),
      );
    } else if (cleanId.contains('apple')) {
      bgColor = const Color(0xFF1C1C1E);
      iconContent = CustomPaint(
        size: Size(size * 0.58, size * 0.65),
        painter: const _ApplePainter(),
      );
    } else if (cleanId.contains('akamai')) {
      bgColor = const Color(0xFF003057);
      iconContent = CustomPaint(
        size: Size(size * 0.65, size * 0.65),
        painter: const _AkamaiPainter(),
      );
    } else if (cleanId.contains('cachefly')) {
      bgColor = const Color(0xFFFF5722);
      iconContent = CustomPaint(
        size: Size(size * 0.62, size * 0.62),
        painter: const _CacheFlyPainter(),
      );
    } else {
      bgColor = const Color(0xFF455A64);
      iconContent = CustomPaint(
        size: Size(size * 0.60, size * 0.60),
        painter: const _CustomLinkPainter(),
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

/// Cloudflare: Authentic dual cloud vector silhouette without lightning storm distortion
class _CloudflarePainter extends CustomPainter {
  const _CloudflarePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(w * 0.18, h * 0.74);
    path.lineTo(w * 0.84, h * 0.74);
    path.cubicTo(w * 0.94, h * 0.74, w * 0.98, h * 0.62, w * 0.90, h * 0.52);
    path.cubicTo(w * 0.92, h * 0.38, w * 0.80, h * 0.30, w * 0.68, h * 0.34);
    path.cubicTo(w * 0.60, h * 0.20, w * 0.40, h * 0.18, w * 0.30, h * 0.32);
    path.cubicTo(w * 0.18, h * 0.34, w * 0.08, h * 0.46, w * 0.10, h * 0.58);
    path.cubicTo(w * 0.06, h * 0.66, w * 0.10, h * 0.74, w * 0.18, h * 0.74);
    path.close();

    canvas.drawPath(path, whitePaint);

    final orangePaint = Paint()
      ..color = const Color(0xFFF38020)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final gapPath = Path();
    gapPath.moveTo(w * 0.74, h * 0.74);
    gapPath.lineTo(w * 0.70, h * 0.62);
    gapPath.cubicTo(w * 0.68, h * 0.56, w * 0.60, h * 0.54, w * 0.54, h * 0.58);
    gapPath.cubicTo(w * 0.50, h * 0.62, w * 0.46, h * 0.74, w * 0.46, h * 0.74);
    gapPath.close();

    canvas.drawPath(gapPath, orangePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Google: Authentic 4-color 'G' (Blue, Green, Yellow, Red)
class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w * 0.40;
    final strokeWidth = w * 0.18;

    final rect = Rect.fromCircle(center: center, radius: radius);

    Paint makePaint(Color color, {bool stroke = true}) => Paint()
      ..color = color
      ..style = stroke ? PaintingStyle.stroke : PaintingStyle.fill
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = true;

    // Blue horizontal bar
    final barPaint = makePaint(const Color(0xFF4285F4), stroke: false);
    final barRect = Rect.fromLTWH(
      center.dx,
      center.dy - strokeWidth / 2,
      radius + strokeWidth / 2,
      strokeWidth,
    );
    canvas.drawRect(barRect, barPaint);

    // Blue arc (top-right to right edge: 315 deg to 45 deg)
    canvas.drawArc(rect, -math.pi * 0.25, math.pi * 0.50, false, makePaint(const Color(0xFF4285F4)));

    // Green arc (bottom: 45 deg to 135 deg)
    canvas.drawArc(rect, math.pi * 0.25, math.pi * 0.50, false, makePaint(const Color(0xFF34A853)));

    // Yellow arc (bottom-left to top-left: 135 deg to 225 deg)
    canvas.drawArc(rect, math.pi * 0.75, math.pi * 0.50, false, makePaint(const Color(0xFFFBBC05)));

    // Red arc (top: 225 deg to 315 deg)
    canvas.drawArc(rect, math.pi * 1.25, math.pi * 0.50, false, makePaint(const Color(0xFFEA4335)));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// YouTube: Iconic red pill with centered white play triangle
class _YouTubePainter extends CustomPainter {
  const _YouTubePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final playPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final w = size.width;
    final h = size.height;

    final playPath = Path();
    playPath.moveTo(w * 0.38, h * 0.22);
    playPath.lineTo(w * 0.72, h * 0.50);
    playPath.lineTo(w * 0.38, h * 0.78);
    playPath.close();

    canvas.drawPath(playPath, playPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// OpenAI / ChatGPT: Crisp 6-fold interlocking geometric spiral
class _OpenAiPainter extends CustomPainter {
  const _OpenAiPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final center = Offset(w / 2, size.height / 2);
    final r = w * 0.38;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.085
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    for (int i = 0; i < 6; i++) {
      final angle = i * (math.pi / 3);
      final path = Path();

      final start = Offset(
        center.dx + r * 0.30 * math.cos(angle + math.pi / 6),
        center.dy + r * 0.30 * math.sin(angle + math.pi / 6),
      );
      final p1 = Offset(
        center.dx + r * 0.85 * math.cos(angle + 0.30),
        center.dy + r * 0.85 * math.sin(angle + 0.30),
      );
      final p2 = Offset(
        center.dx + r * 0.95 * math.cos(angle + 0.75),
        center.dy + r * 0.95 * math.sin(angle + 0.75),
      );
      final p3 = Offset(
        center.dx + r * 0.50 * math.cos(angle + 0.95),
        center.dy + r * 0.50 * math.sin(angle + 0.95),
      );

      path.moveTo(start.dx, start.dy);
      path.lineTo(p1.dx, p1.dy);
      path.arcToPoint(p2, radius: Radius.circular(r * 0.28));
      path.lineTo(p3.dx, p3.dy);

      canvas.drawPath(path, strokePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Bilibili: Iconic TV with 45° antennas, 2 angled feet, and cute smiling face
class _BilibiliPainter extends CustomPainter {
  const _BilibiliPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final whiteFill = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final whiteStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.085
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    // Antennas
    canvas.drawLine(Offset(w * 0.36, h * 0.25), Offset(w * 0.20, h * 0.08), whiteStroke);
    canvas.drawLine(Offset(w * 0.64, h * 0.25), Offset(w * 0.80, h * 0.08), whiteStroke);

    // TV legs at bottom
    canvas.drawLine(Offset(w * 0.24, h * 0.76), Offset(w * 0.16, h * 0.90), whiteStroke);
    canvas.drawLine(Offset(w * 0.76, h * 0.76), Offset(w * 0.84, h * 0.90), whiteStroke);

    // TV body
    final tvRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.04, h * 0.22, w * 0.92, h * 0.58),
      Radius.circular(w * 0.18),
    );
    canvas.drawRRect(tvRect, whiteFill);

    final pinkFill = Paint()
      ..color = const Color(0xFFFB7299)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Left eye
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.30, h * 0.44, w * 0.08, w * 0.12),
        Radius.circular(w * 0.04),
      ),
      pinkFill,
    );

    // Right eye
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.62, h * 0.44, w * 0.08, w * 0.12),
        Radius.circular(w * 0.04),
      ),
      pinkFill,
    );

    // Smile mouth
    final mouthStroke = Paint()
      ..color = const Color(0xFFFB7299)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final mouthPath = Path()
      ..moveTo(w * 0.44, h * 0.56)
      ..quadraticBezierTo(w * 0.50, h * 0.64, w * 0.56, h * 0.56);
    canvas.drawPath(mouthPath, mouthStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Netflix: Ribbon 'N' with signature arched bottom and 3D folding shadow
class _NetflixPainter extends CustomPainter {
  const _NetflixPainter();

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

    final colW = w * 0.32;

    // Left vertical bar with arched bottom
    final leftPath = Path()
      ..moveTo(0, 0)
      ..lineTo(colW, 0)
      ..lineTo(colW, h * 0.94)
      ..quadraticBezierTo(colW * 0.5, h * 0.98, 0, h)
      ..close();
    canvas.drawPath(leftPath, redDarkPaint);

    // Right vertical bar with arched bottom
    final rightPath = Path()
      ..moveTo(w - colW, 0)
      ..lineTo(w, 0)
      ..lineTo(w, h)
      ..quadraticBezierTo(w - colW * 0.5, h * 0.98, w - colW, h * 0.94)
      ..close();
    canvas.drawPath(rightPath, redDarkPaint);

    // Diagonal ribbon with depth shadow
    final diagonalPath = Path()
      ..moveTo(0, 0)
      ..lineTo(colW, 0)
      ..lineTo(w, h * 0.94)
      ..quadraticBezierTo(w - colW * 0.5, h * 0.98, w - colW, h)
      ..close();

    canvas.save();
    final shadowPaint = Paint()
      ..color = Colors.black.withAlpha(90)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);
    canvas.drawPath(diagonalPath, shadowPaint);
    canvas.restore();

    canvas.drawPath(diagonalPath, redBrightPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Fast.com: Speedometer with crisp track, active red arc, and precision needle
class _FastComPainter extends CustomPainter {
  const _FastComPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final center = Offset(w / 2, h * 0.55);
    final radius = w * 0.40;

    final trackPaint = Paint()
      ..color = Colors.white.withAlpha(70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.80,
      math.pi * 1.40,
      false,
      trackPaint,
    );

    final activePaint = Paint()
      ..color = const Color(0xFFE50914)
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.09
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.80,
      math.pi * 0.95,
      false,
      activePaint,
    );

    final needlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.075
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final needleAngle = math.pi * 1.70;
    canvas.drawLine(
      center,
      Offset(center.dx + radius * 0.70 * math.cos(needleAngle),
             center.dy + radius * 0.70 * math.sin(needleAngle)),
      needlePaint,
    );

    canvas.drawCircle(center, w * 0.09, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// GitHub: Authentic Invertocat silhouette with distinct head, cat ears, and tentacles
class _GitHubPainter extends CustomPainter {
  const _GitHubPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();
    path.moveTo(w * 0.50, h * 0.24);
    path.cubicTo(w * 0.44, h * 0.24, w * 0.38, h * 0.26, w * 0.34, h * 0.28);
    path.lineTo(w * 0.20, h * 0.12);
    path.cubicTo(w * 0.20, h * 0.24, w * 0.22, h * 0.34, w * 0.24, h * 0.42);
    path.cubicTo(w * 0.22, h * 0.52, w * 0.26, h * 0.62, w * 0.32, h * 0.66);
    path.lineTo(w * 0.30, h * 0.76);
    path.cubicTo(w * 0.22, h * 0.78, w * 0.20, h * 0.88, w * 0.32, h * 0.88);
    path.cubicTo(w * 0.42, h * 0.88, w * 0.46, h * 0.82, w * 0.50, h * 0.82);
    path.cubicTo(w * 0.54, h * 0.82, w * 0.58, h * 0.88, w * 0.68, h * 0.88);
    path.cubicTo(w * 0.80, h * 0.88, w * 0.78, h * 0.78, w * 0.70, h * 0.76);
    path.lineTo(w * 0.68, h * 0.66);
    path.cubicTo(w * 0.74, h * 0.62, w * 0.78, h * 0.52, w * 0.76, h * 0.42);
    path.cubicTo(w * 0.78, h * 0.34, w * 0.80, h * 0.24, w * 0.80, h * 0.12);
    path.lineTo(w * 0.66, h * 0.28);
    path.cubicTo(w * 0.62, h * 0.26, w * 0.56, h * 0.24, w * 0.50, h * 0.24);
    path.close();

    canvas.drawPath(path, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Apple: Pure vector bitten apple logo with angled leaf
class _ApplePainter extends CustomPainter {
  const _ApplePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // Leaf
    final leafPath = Path();
    leafPath.moveTo(w * 0.52, h * 0.22);
    leafPath.cubicTo(w * 0.52, h * 0.14, w * 0.59, h * 0.06, w * 0.68, h * 0.05);
    leafPath.cubicTo(w * 0.68, h * 0.13, w * 0.61, h * 0.21, w * 0.52, h * 0.22);
    leafPath.close();
    canvas.drawPath(leafPath, whitePaint);

    // Apple body with bite cutout
    final bodyPath = Path();
    bodyPath.moveTo(w * 0.50, h * 0.31);
    bodyPath.cubicTo(w * 0.44, h * 0.26, w * 0.32, h * 0.26, w * 0.24, h * 0.34);
    bodyPath.cubicTo(w * 0.12, h * 0.46, w * 0.14, h * 0.72, w * 0.28, h * 0.88);
    bodyPath.cubicTo(w * 0.34, h * 0.95, w * 0.44, h * 0.95, w * 0.50, h * 0.90);
    bodyPath.cubicTo(w * 0.56, h * 0.95, w * 0.66, h * 0.95, w * 0.72, h * 0.88);
    bodyPath.cubicTo(w * 0.80, h * 0.78, w * 0.84, h * 0.64, w * 0.85, h * 0.58);
    bodyPath.cubicTo(w * 0.73, h * 0.58, w * 0.68, h * 0.44, w * 0.77, h * 0.36);
    bodyPath.cubicTo(w * 0.72, h * 0.28, w * 0.58, h * 0.26, w * 0.50, h * 0.31);
    bodyPath.close();

    canvas.drawPath(bodyPath, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Akamai: Authentic global edge CDN dynamic wave with speed accent
class _AkamaiPainter extends CustomPainter {
  const _AkamaiPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Orange crest wave
    final orangePaint = Paint()
      ..color = const Color(0xFFFF8200)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final orangeWave = Path();
    orangeWave.moveTo(w * 0.15, h * 0.65);
    orangeWave.cubicTo(w * 0.30, h * 0.35, w * 0.65, h * 0.20, w * 0.85, h * 0.30);
    orangeWave.cubicTo(w * 0.65, h * 0.32, w * 0.38, h * 0.46, w * 0.25, h * 0.70);
    orangeWave.close();
    canvas.drawPath(orangeWave, orangePaint);

    // Cyan under-wave
    final bluePaint = Paint()
      ..color = const Color(0xFF00A3E0)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final blueWave = Path();
    blueWave.moveTo(w * 0.20, h * 0.75);
    blueWave.cubicTo(w * 0.35, h * 0.50, w * 0.65, h * 0.42, w * 0.82, h * 0.50);
    blueWave.cubicTo(w * 0.65, h * 0.52, w * 0.42, h * 0.62, w * 0.30, h * 0.80);
    blueWave.close();
    canvas.drawPath(blueWave, bluePaint);

    // Speed dot
    final whiteDot = Paint()..color = Colors.white;
    canvas.drawCircle(Offset(w * 0.82, h * 0.30), w * 0.065, whiteDot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// CacheFly: Vector supersonic rocket with porthole and exhaust
class _CacheFlyPainter extends CustomPainter {
  const _CacheFlyPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final rocket = Path();
    rocket.moveTo(w * 0.82, h * 0.18);
    rocket.cubicTo(w * 0.78, h * 0.30, w * 0.60, h * 0.45, w * 0.42, h * 0.58);
    rocket.lineTo(w * 0.32, h * 0.54);
    rocket.lineTo(w * 0.38, h * 0.66);
    rocket.lineTo(w * 0.34, h * 0.72);
    rocket.lineTo(w * 0.46, h * 0.68);
    rocket.lineTo(w * 0.58, h * 0.74);
    rocket.lineTo(w * 0.54, h * 0.64);
    rocket.cubicTo(w * 0.68, h * 0.48, w * 0.82, h * 0.30, w * 0.82, h * 0.18);
    rocket.close();
    canvas.drawPath(rocket, whitePaint);

    final windowPaint = Paint()..color = const Color(0xFFFF5722);
    canvas.drawCircle(Offset(w * 0.62, h * 0.38), w * 0.065, windowPaint);

    final flamePaint = Paint()
      ..color = const Color(0xFFFFD54F)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;
    final flame = Path();
    flame.moveTo(w * 0.36, h * 0.70);
    flame.lineTo(w * 0.18, h * 0.84);
    flame.lineTo(w * 0.30, h * 0.76);
    flame.close();
    canvas.drawPath(flame, flamePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom Link: Vector interlocked chain loops
class _CustomLinkPainter extends CustomPainter {
  const _CustomLinkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final strokePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.11
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path1 = Path();
    path1.moveTo(w * 0.38, h * 0.22);
    path1.lineTo(w * 0.58, h * 0.22);
    path1.arcToPoint(Offset(w * 0.58, h * 0.52), radius: Radius.circular(w * 0.15));
    path1.lineTo(w * 0.38, h * 0.52);
    path1.arcToPoint(Offset(w * 0.38, h * 0.22), radius: Radius.circular(w * 0.15));

    final path2 = Path();
    path2.moveTo(w * 0.42, h * 0.48);
    path2.lineTo(w * 0.62, h * 0.48);
    path2.arcToPoint(Offset(w * 0.62, h * 0.78), radius: Radius.circular(w * 0.15));
    path2.lineTo(w * 0.42, h * 0.78);
    path2.arcToPoint(Offset(w * 0.42, h * 0.48), radius: Radius.circular(w * 0.15));

    canvas.save();
    canvas.translate(w / 2, h / 2);
    canvas.rotate(-math.pi / 4);
    canvas.translate(-w / 2, -h / 2);

    canvas.drawPath(path1, strokePaint);
    canvas.drawPath(path2, strokePaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
