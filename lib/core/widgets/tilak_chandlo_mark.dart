import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Swaminarayan tilak-chandlo mark — yellow U + red chandlo.
///
/// When [animate] is true: draws the U path, then scales in the chandlo, then soft pulse.
class TilakChandloMark extends StatefulWidget {
  const TilakChandloMark({
    super.key,
    this.size = 96,
    this.showGlow = true,
    this.filled = false,
    this.animate = true,
    this.repeatPulse = true,
  });

  final double size;
  final bool showGlow;
  final bool filled;
  final bool animate;
  final bool repeatPulse;

  @override
  State<TilakChandloMark> createState() => _TilakChandloMarkState();
}

class _TilakChandloMarkState extends State<TilakChandloMark>
    with TickerProviderStateMixin {
  late final AnimationController _draw;
  late final AnimationController _pulse;
  late final Animation<double> _pathProgress;
  late final Animation<double> _chandloScale;
  late final Animation<double> _chandloOpacity;

  @override
  void initState() {
    super.initState();
    _draw = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _pathProgress = CurvedAnimation(
      parent: _draw,
      curve: const Interval(0.0, 0.62, curve: Curves.easeInOutCubic),
    );
    _chandloScale = Tween(begin: 0.2, end: 1.0).animate(
      CurvedAnimation(
        parent: _draw,
        curve: const Interval(0.55, 0.88, curve: Curves.elasticOut),
      ),
    );
    _chandloOpacity = CurvedAnimation(
      parent: _draw,
      curve: const Interval(0.55, 0.75, curve: Curves.easeOut),
    );

    if (widget.animate) {
      _draw.forward().whenComplete(() {
        if (mounted && widget.repeatPulse) {
          _pulse.repeat(reverse: true);
        }
      });
    } else {
      _draw.value = 1;
      if (widget.repeatPulse) _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _draw.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mark = AnimatedBuilder(
      animation: Listenable.merge([_draw, _pulse]),
      builder: (_, __) {
        final pulse = widget.repeatPulse ? 0.85 + _pulse.value * 0.15 : 1.0;
        return CustomPaint(
          size: Size(widget.size * 0.62, widget.size),
          painter: TilakChandloPainter(
            pathProgress: _pathProgress.value,
            chandloScale: _chandloScale.value * pulse,
            chandloOpacity: _chandloOpacity.value,
            showGlow: widget.showGlow,
          ),
        );
      },
    );

    if (!widget.filled) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: Center(child: mark),
      );
    }

    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.tilakGlow,
        boxShadow: widget.showGlow
            ? [
                BoxShadow(
                  color: AppColors.glowSaffron,
                  blurRadius: widget.size * 0.2,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Center(child: mark),
    );
  }
}

/// Exact-style painter: yellow arms + bottom arc + red chandlo.
class TilakChandloPainter extends CustomPainter {
  TilakChandloPainter({
    this.pathProgress = 1,
    this.chandloScale = 1,
    this.chandloOpacity = 1,
    this.showGlow = true,
  });

  final double pathProgress;
  final double chandloScale;
  final double chandloOpacity;
  final bool showGlow;

  static Path buildTilakPath(Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = w * 0.22;
    final inset = stroke / 2;

    // Inner channel width between arm centers
    final leftX = inset;
    final rightX = w - inset;
    final topY = inset * 0.4;
    // Bottom of straight arms before the arc
    final armBottom = h * 0.62;

    final path = Path();
    // Left arm down
    path.moveTo(leftX, topY);
    path.lineTo(leftX, armBottom);
    // Bottom semicircle (outside of U)
    path.arcToPoint(
      Offset(rightX, armBottom),
      radius: Radius.circular((rightX - leftX) / 2),
      clockwise: false,
    );
    // Right arm up
    path.lineTo(rightX, topY);
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stroke = w * 0.22;

    final tilakPaint = Paint()
      ..color = AppColors.tilakYellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final fullPath = buildTilakPath(size);
    final metrics = fullPath.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final totalLen = metrics.fold<double>(0, (s, m) => s + m.length);
    var remaining = totalLen * pathProgress.clamp(0.0, 1.0);

    for (final metric in metrics) {
      final take = math.min(remaining, metric.length);
      if (take <= 0) break;
      final extract = metric.extractPath(0, take);
      canvas.drawPath(extract, tilakPaint);
      remaining -= take;
    }

    if (chandloOpacity <= 0.01) return;

    // Chandlo sits in lower half of the U opening
    final leftX = stroke / 2;
    final rightX = w - stroke / 2;
    final innerGap = rightX - leftX - stroke;
    final radius = (innerGap * 0.42).clamp(2.0, w);
    final cx = w / 2;
    final cy = h * 0.55;

    canvas.save();
    canvas.translate(cx, cy);
    canvas.scale(chandloScale);
    canvas.translate(-cx, -cy);

    if (showGlow) {
      canvas.drawCircle(
        Offset(cx, cy),
        radius * 1.35,
        Paint()
          ..color = AppColors.glowChandlo.withValues(alpha: 0.45 * chandloOpacity)
          ..maskFilter = const ui.MaskFilter.blur(ui.BlurStyle.normal, 8),
      );
    }

    final chandlo = Paint()
      ..shader = ui.Gradient.radial(
        Offset(cx - radius * 0.25, cy - radius * 0.3),
        radius * 1.4,
        [
          const Color(0xFFFF5252).withValues(alpha: chandloOpacity),
          AppColors.chandloRed.withValues(alpha: chandloOpacity),
          const Color(0xFFB71C1C).withValues(alpha: chandloOpacity),
        ],
        const [0.0, 0.55, 1.0],
      );

    canvas.drawCircle(Offset(cx, cy), radius, chandlo);

    // Soft highlight
    canvas.drawCircle(
      Offset(cx - radius * 0.28, cy - radius * 0.28),
      radius * 0.22,
      Paint()..color = Colors.white.withValues(alpha: 0.28 * chandloOpacity),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant TilakChandloPainter oldDelegate) =>
      oldDelegate.pathProgress != pathProgress ||
      oldDelegate.chandloScale != chandloScale ||
      oldDelegate.chandloOpacity != chandloOpacity ||
      oldDelegate.showGlow != showGlow;
}
