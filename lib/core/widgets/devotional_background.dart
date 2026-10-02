import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import 'tilak_chandlo_mark.dart';

class DevotionalBackground extends StatelessWidget {
  const DevotionalBackground({
    super.key,
    required this.child,
    this.dark = false,
    this.showMandala = true,
    this.showTilakPattern = true,
  });

  final Widget child;
  final bool dark;
  final bool showMandala;
  final bool showTilakPattern;

  @override
  Widget build(BuildContext context) {
    final tilakAlpha = dark ? 0.09 : 0.13;
    final chandloAlpha = dark ? 0.08 : 0.12;

    return Container(
      decoration: BoxDecoration(
        gradient: dark ? AppColors.templeGradientDark : AppColors.templeGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (showMandala)
            Positioned.fill(
              child: CustomPaint(
                painter: _MandalaPainter(
                  color: (dark ? AppColors.gold : AppColors.primary)
                      .withValues(alpha: dark ? 0.04 : 0.05),
                ),
              ),
            ),
          if (showTilakPattern)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _TilakScatterPainter(
                    tilakColor: AppColors.tilakYellow.withValues(alpha: tilakAlpha),
                    chandloColor: AppColors.chandloRed.withValues(alpha: chandloAlpha),
                  ),
                ),
              ),
            ),
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.glowGold,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}

class _MandalaPainter extends CustomPainter {
  _MandalaPainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.35);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 1; i <= 6; i++) {
      canvas.drawCircle(center, 40.0 * i, paint);
    }
    for (var i = 0; i < 12; i++) {
      final angle = (i * 30) * math.pi / 180;
      canvas.drawLine(
        center,
        Offset(
          center.dx + 240 * math.cos(angle),
          center.dy + 240 * math.sin(angle),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MandalaPainter oldDelegate) => oldDelegate.color != color;
}

/// Soft grid of tiny tilak-chandlo marks behind screen content.
class _TilakScatterPainter extends CustomPainter {
  _TilakScatterPainter({
    required this.tilakColor,
    required this.chandloColor,
  });

  final Color tilakColor;
  final Color chandloColor;

  static const double _markW = 12;
  static const double _markH = 17;
  static const double _stepX = 42;
  static const double _stepY = 52;

  @override
  void paint(Canvas canvas, Size size) {
    final cols = (size.width / _stepX).ceil() + 2;
    final rows = (size.height / _stepY).ceil() + 2;

    final tilakPaint = Paint()
      ..color = tilakColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _markW * 0.22
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final chandloPaint = Paint()
      ..color = chandloColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = TilakChandloPainter.buildTilakPath(const Size(_markW, _markH));

    for (var row = 0; row < rows; row++) {
      for (var col = 0; col < cols; col++) {
        // Dense staggered grid — skip only every 3rd for slight breathing room
        if ((row * 2 + col) % 3 == 0) continue;

        final seed = (row * 31 + col * 17) & 0xffff;
        final jitterX = ((seed % 11) - 5) * 1.1;
        final jitterY = (((seed ~/ 11) % 11) - 5) * 1.0;
        final rot = (((seed % 9) - 4) / 4.0) * 0.14; // ±~8°

        final x = col * _stepX - _stepX * 0.2 + (row.isOdd ? _stepX * 0.4 : 0) + jitterX;
        final y = row * _stepY - _stepY * 0.15 + jitterY;

        canvas.save();
        canvas.translate(x + _markW / 2, y + _markH / 2);
        canvas.rotate(rot);
        canvas.translate(-_markW / 2, -_markH / 2);
        canvas.drawPath(path, tilakPaint);

        final stroke = _markW * 0.22;
        final leftX = stroke / 2;
        final rightX = _markW - stroke / 2;
        final innerGap = rightX - leftX - stroke;
        final radius = (innerGap * 0.42).clamp(1.0, _markW);
        canvas.drawCircle(Offset(_markW / 2, _markH * 0.55), radius, chandloPaint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant _TilakScatterPainter oldDelegate) =>
      oldDelegate.tilakColor != tilakColor || oldDelegate.chandloColor != chandloColor;
}
