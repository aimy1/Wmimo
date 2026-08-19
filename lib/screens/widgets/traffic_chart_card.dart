import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:wmimo/app/clash/clash_http_api.dart';
import 'package:wmimo/i18n/strings.g.dart';
import 'package:wmimo/screens/theme_config.dart';
import 'package:wmimo/screens/theme_define.dart';

class TrafficDataRecord {
  final DateTime time;
  final double upload;   // bytes per second
  final double download; // bytes per second

  TrafficDataRecord({
    required this.time,
    required this.upload,
    required this.download,
  });
}

class TrafficChartCard extends StatefulWidget {
  final List<TrafficDataRecord> history;
  final bool isConnected;
  final ValueNotifier<int> tickNotifier;

  const TrafficChartCard({
    super.key,
    required this.history,
    required this.isConnected,
    required this.tickNotifier,
  });

  @override
  State<TrafficChartCard> createState() => _TrafficChartCardState();
}

class _TrafficChartCardState extends State<TrafficChartCard> {
  Offset? _hoverPosition;
  int _selectedMinutes = 10; // 5, 10, 30, 60

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tcontext = Translations.of(context);

    final uploadColor = const Color(0xFFF59E0B);
    final downloadColor = const Color(0xFF38BDF8);
    final chartBgColor = isDark ? const Color(0xFF161922) : const Color(0xFFF1F5F9);
    final borderColor = isDark ? const Color(0xFF2E3440) : const Color(0xFFE2E8F0);

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
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Title Header
            Row(
              children: [
                // Speedometer Gauge icon with orange gradient badge
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
                    ),
                    borderRadius: BorderRadius.circular(9),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.35),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.speed_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  tcontext.meta.trafficStats,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const Spacer(),
                // Connection status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.isConnected
                        ? ThemeDefine.kColorGreenBright.withValues(
                            alpha: isDark ? 0.15 : 0.1,
                          )
                        : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: widget.isConnected
                          ? ThemeDefine.kColorGreenBright.withValues(alpha: 0.35)
                          : theme.dividerColor.withValues(alpha: 0.3),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: widget.isConnected
                              ? ThemeDefine.kColorGreenBright
                              : const Color(0xFF94A3B8),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.isConnected
                            ? tcontext.meta.realtimeMonitor
                            : tcontext.meta.disconnected,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: widget.isConnected
                              ? ThemeDefine.kColorGreenBright
                              : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Chart Box
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: chartBgColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: borderColor,
                  width: 0.8,
                ),
              ),
              child: Stack(
                children: [
                  // Main Chart Painter
                  Positioned.fill(
                    child: ValueListenableBuilder<int>(
                      valueListenable: widget.tickNotifier,
                      builder: (context, _, __) {
                        return MouseRegion(
                          onHover: (event) {
                            setState(() {
                              _hoverPosition = event.localPosition;
                            });
                          },
                          onExit: (_) {
                            setState(() {
                              _hoverPosition = null;
                            });
                          },
                          child: GestureDetector(
                            onPanUpdate: (details) {
                              setState(() {
                                _hoverPosition = details.localPosition;
                              });
                            },
                            onPanEnd: (_) {
                              setState(() {
                                _hoverPosition = null;
                              });
                            },
                            child: CustomPaint(
                              painter: ClashVergeChartPainter(
                                history: widget.history,
                                uploadColor: uploadColor,
                                downloadColor: downloadColor,
                                isDark: isDark,
                                hoverPosition: _hoverPosition,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Top-Left: Time range pill selector
                  Positioned(
                    top: 8,
                    left: 44,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (isDark ? const Color(0xFF2E3440) : const Color(0xFFE2E8F0))
                            .withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        "$_selectedMinutes 分钟",
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                  ),

                  // Top-Right: Upload & Download Legends
                  Positioned(
                    top: 8,
                    right: 12,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "上传",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: uploadColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          "下载",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: downloadColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom Status Footers
                  Positioned(
                    bottom: 3,
                    left: 12,
                    child: Text(
                      "Points: ${widget.history.length} | FPS: 60",
                      style: TextStyle(
                        fontSize: 9,
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 3,
                    right: 12,
                    child: Text(
                      "Linear",
                      style: TextStyle(
                        fontSize: 9,
                        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.35),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ClashVergeChartPainter extends CustomPainter {
  final List<TrafficDataRecord> history;
  final Color uploadColor;
  final Color downloadColor;
  final bool isDark;
  final Offset? hoverPosition;

  ClashVergeChartPainter({
    required this.history,
    required this.uploadColor,
    required this.downloadColor,
    required this.isDark,
    this.hoverPosition,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const leftPadding = 42.0;
    const rightPadding = 12.0;
    const topPadding = 24.0;
    const bottomPadding = 22.0;

    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    if (chartWidth <= 0 || chartHeight <= 0) return;

    // Calculate max value with minimum scale 20 KB/s
    double maxVal = 1024 * 20;
    for (var p in history) {
      if (p.upload > maxVal) maxVal = p.upload;
      if (p.download > maxVal) maxVal = p.download;
    }

    final gridColor = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.07);
    final labelColor = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.4);

    final gridPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 0.8;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);

    // 1. Draw 3 Horizontal Grid lines & Y-Axis labels
    final yRatios = [0.0, 0.5, 1.0]; // top, mid, bottom
    for (var r in yRatios) {
      final y = topPadding + (r * chartHeight);
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(size.width - rightPadding, y),
        gridPaint,
      );

      // Y-axis text
      String label = "";
      if (r == 0.0) {
        label = ClashHttpApi.convertTrafficToStringDouble(maxVal);
      } else if (r == 0.5) {
        label = ClashHttpApi.convertTrafficToStringDouble(maxVal / 2);
      } else {
        label = "0";
      }

      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          fontSize: 8.5,
          fontWeight: FontWeight.w600,
          color: labelColor,
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(leftPadding - textPainter.width - 4, y - textPainter.height / 2),
      );
    }

    // 2. Draw Curves if history has data
    if (history.length >= 2) {
      final stepX = chartWidth / (history.length - 1);

      double getY(double val) {
        final ratio = (val / maxVal).clamp(0.0, 1.0);
        return topPadding + chartHeight - (ratio * chartHeight);
      }

      // Draw Download (Blue) Curve & Fill
      _drawCurve(
        canvas: canvas,
        history: history.map((p) => p.download).toList(),
        stepX: stepX,
        leftPadding: leftPadding,
        topPadding: topPadding,
        chartHeight: chartHeight,
        getY: getY,
        color: downloadColor,
        isDark: isDark,
      );

      // Draw Upload (Orange) Curve & Fill
      _drawCurve(
        canvas: canvas,
        history: history.map((p) => p.upload).toList(),
        stepX: stepX,
        leftPadding: leftPadding,
        topPadding: topPadding,
        chartHeight: chartHeight,
        getY: getY,
        color: uploadColor,
        isDark: isDark,
      );

      // 3. Draw X-Axis Time Ticks
      final timeFormatter = DateFormat("HH:mm");
      final tickCount = 6;
      for (int i = 0; i < tickCount; i++) {
        final ratio = i / (tickCount - 1);
        final dataIndex = (ratio * (history.length - 1)).round().clamp(0, history.length - 1);
        final timeStr = timeFormatter.format(history[dataIndex].time);
        final x = leftPadding + (ratio * chartWidth);

        textPainter.text = TextSpan(
          text: timeStr,
          style: TextStyle(
            fontSize: 8.5,
            color: labelColor,
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(x - textPainter.width / 2, topPadding + chartHeight + 4),
        );
      }

      // 4. Draw Interactive Hover Tooltip and Vertical Line
      if (hoverPosition != null &&
          hoverPosition!.dx >= leftPadding &&
          hoverPosition!.dx <= size.width - rightPadding &&
          hoverPosition!.dy >= topPadding &&
          hoverPosition!.dy <= topPadding + chartHeight) {
        final relativeX = hoverPosition!.dx - leftPadding;
        final index = (relativeX / stepX).round().clamp(0, history.length - 1);
        final point = history[index];
        final snapX = leftPadding + (index * stepX);

        // Dashed vertical line
        final dashPaint = Paint()
          ..color = (isDark ? Colors.white70 : Colors.black87).withValues(alpha: 0.5)
          ..strokeWidth = 1.0;
        double dashY = topPadding;
        while (dashY < topPadding + chartHeight) {
          canvas.drawLine(
            Offset(snapX, dashY),
            Offset(snapX, math.min(dashY + 4, topPadding + chartHeight)),
            dashPaint,
          );
          dashY += 7;
        }

        // Dot on curves
        final upY = getY(point.upload);
        final downY = getY(point.download);

        canvas.drawCircle(Offset(snapX, upY), 3.5, Paint()..color = uploadColor);
        canvas.drawCircle(Offset(snapX, upY), 1.5, Paint()..color = Colors.white);

        canvas.drawCircle(Offset(snapX, downY), 3.5, Paint()..color = downloadColor);
        canvas.drawCircle(Offset(snapX, downY), 1.5, Paint()..color = Colors.white);

        // Tooltip Card
        final exactTimeFormatter = DateFormat("HH:mm:ss");
        final timeExact = exactTimeFormatter.format(point.time);

        final tipTitle = TextSpan(
          text: "$timeExact\n",
          style: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w600,
            color: Colors.white70,
          ),
        );
        final tipUp = TextSpan(
          text: "↑ ${ClashHttpApi.convertTrafficToStringDouble(point.upload)}/s\n",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: uploadColor,
          ),
        );
        final tipDown = TextSpan(
          text: "↓ ${ClashHttpApi.convertTrafficToStringDouble(point.download)}/s",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: downloadColor,
          ),
        );

        textPainter.text = TextSpan(children: [tipTitle, tipUp, tipDown]);
        textPainter.layout();

        final tooltipWidth = textPainter.width + 16;
        final tooltipHeight = textPainter.height + 10;

        double tooltipX = snapX + 10;
        if (tooltipX + tooltipWidth > size.width - rightPadding) {
          tooltipX = snapX - tooltipWidth - 10;
        }
        double tooltipY = hoverPosition!.dy - tooltipHeight / 2;
        tooltipY = tooltipY.clamp(topPadding, topPadding + chartHeight - tooltipHeight);

        final tooltipRect = RRect.fromRectAndRadius(
          Rect.fromLTWH(tooltipX, tooltipY, tooltipWidth, tooltipHeight),
          const Radius.circular(6),
        );

        final tooltipBgPaint = Paint()
          ..color = const Color(0xFF1E222D).withValues(alpha: 0.92)
          ..style = PaintingStyle.fill;
        final tooltipBorderPaint = Paint()
          ..color = Colors.white.withValues(alpha: 0.15)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.8;

        canvas.drawRRect(tooltipRect, tooltipBgPaint);
        canvas.drawRRect(tooltipRect, tooltipBorderPaint);

        textPainter.paint(canvas, Offset(tooltipX + 8, tooltipY + 5));
      }
    }
  }

  void _drawCurve({
    required Canvas canvas,
    required List<double> history,
    required double stepX,
    required double leftPadding,
    required double topPadding,
    required double chartHeight,
    required double Function(double) getY,
    required Color color,
    required bool isDark,
  }) {
    if (history.length < 2) return;

    final path = Path();
    final fillPath = Path();

    final firstX = leftPadding;
    final firstY = getY(history.first);

    path.moveTo(firstX, firstY);
    fillPath.moveTo(firstX, topPadding + chartHeight);
    fillPath.lineTo(firstX, firstY);

    for (int i = 1; i < history.length; i++) {
      final prevX = leftPadding + ((i - 1) * stepX);
      final prevY = getY(history[i - 1]);
      final currX = leftPadding + (i * stepX);
      final currY = getY(history[i]);

      final midX = (prevX + currX) / 2;
      path.cubicTo(midX, prevY, midX, currY, currX, currY);
      fillPath.cubicTo(midX, prevY, midX, currY, currX, currY);
    }

    fillPath.lineTo(leftPadding + ((history.length - 1) * stepX), topPadding + chartHeight);
    fillPath.close();

    // Fill gradient
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: isDark ? 0.32 : 0.22),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(leftPadding, topPadding, (history.length - 1) * stepX, chartHeight))
      ..style = PaintingStyle.fill;
    canvas.drawPath(fillPath, fillPaint);

    // Stroke line
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant ClashVergeChartPainter oldDelegate) => true;
}
