import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:animated_digit/animated_digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../constants/asset_constants.dart';
import '../constants/mantra_constants.dart';
import 'tilak_chandlo_mark.dart';

class DeityImage extends StatelessWidget {
  const DeityImage({
    super.key,
    required this.deityId,
    this.size = 120,
    this.selected = false,
  });

  final String deityId;
  final double size;
  final bool selected;

  bool get _useTilak =>
      deityId == 'swaminarayan' ||
      deityId == 'pramukh_swami' ||
      deityId == 'mahant_swami' ||
      deityId == 'bhagatji' ||
      deityId == 'shastriji' ||
      deityId == 'gunatitanand' ||
      deityId == 'yogiji';

  @override
  Widget build(BuildContext context) {
    final deity = MantraConstants.deityById(deityId);
    final symbol = deity?.symbol ?? '॥';
    final name = deity?.nameHi ?? deityId;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        gradient: _useTilak ? null : AppColors.saffronGlow,
        border: Border.all(
          color: selected ? AppColors.saffron : AppColors.saffron.withValues(alpha: 0.35),
          width: selected ? 3 : 1.5,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: AppColors.glowSaffron,
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: AppColors.maroon.withValues(alpha: 0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Center(
        child: _useTilak
            ? TilakChandloMark(
                size: size * 0.72,
                showGlow: false,
                filled: false,
                animate: size >= 90,
                repeatPulse: selected && size >= 90,
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    symbol,
                    style: TextStyle(
                      fontSize: size * 0.28,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (size >= 80)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size * 0.1,
                          color: Colors.white.withValues(alpha: 0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}

class AnimatedCounter extends StatelessWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.enableSeparator = true,
  });

  final int value;
  final TextStyle? style;
  final bool enableSeparator;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final textStyle = style ?? AppTextStyles.counter(dark: dark);
    return AnimatedDigitWidget(
      value: value,
      textStyle: textStyle,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      enableSeparator: enableSeparator,
      separateSymbol: ',',
    );
  }
}

class ProgressRing extends StatelessWidget {
  const ProgressRing({
    super.key,
    required this.progress,
    this.size = 140,
    this.stroke = 8,
    this.child,
  });

  final double progress;
  final double size;
  final double stroke;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _RingPainter(value, stroke),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.progress, this.stroke);
  final double progress;
  final double stroke;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - stroke) / 2;
    final bg = Paint()
      ..color = AppColors.cardBorder.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    final fg = Paint()
      ..shader = AppColors.saffronGlow.createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bg);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      fg,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.stroke != stroke;
}

class JapButton extends StatefulWidget {
  const JapButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.hint,
    this.size = 140,
  });

  final VoidCallback onTap;
  final String label;
  final String hint;
  final double size;

  @override
  State<JapButton> createState() => _JapButtonState();
}

class _JapButtonState extends State<JapButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    await _controller.forward();
    await _controller.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.saffronGlow,
            boxShadow: [
              BoxShadow(
                color: AppColors.glowSaffron,
                blurRadius: 24,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('॥', style: TextStyle(fontSize: 20, color: Colors.white)),
              Text(
                widget.label,
                style: AppTextStyles.title(color: Colors.white),
              ),
              Text(
                widget.hint,
                style: AppTextStyles.caption(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MalaWidget extends StatefulWidget {
  const MalaWidget({
    super.key,
    required this.beadPosition,
    this.totalBeads = 108,
    this.size = 260,
    this.flipHorizontal = false,
  });

  final int beadPosition;
  final int totalBeads;
  final double size;
  final bool flipHorizontal;

  @override
  State<MalaWidget> createState() => _MalaWidgetState();
}

class _MalaWidgetState extends State<MalaWidget> with TickerProviderStateMixin {
  late final AnimationController _move;
  late final AnimationController _pulse;
  late Animation<double> _beadAnim;
  ui.Image? _beadImage;

  int get _n => widget.totalBeads;

  @override
  void initState() {
    super.initState();
    final start = (widget.beadPosition % _n).toDouble();
    _move = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _beadAnim = AlwaysStoppedAnimation(start);
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _loadBeadImage();
  }

  Future<void> _loadBeadImage() async {
    try {
      final data = await rootBundle.load(AssetConstants.rudrakshaBead);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      if (!mounted) return;
      setState(() => _beadImage = frame.image);
    } catch (e) {
      debugPrint('Rudraksha bead image load failed: $e');
    }
  }

  @override
  void didUpdateWidget(covariant MalaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.beadPosition == widget.beadPosition &&
        oldWidget.totalBeads == widget.totalBeads) {
      return;
    }

    final prev = oldWidget.beadPosition % _n;
    final next = widget.beadPosition % _n;
    var begin = _move.isAnimating ? (_beadAnim.value % _n) : prev.toDouble();
    var end = next.toDouble();

    if (next < prev && prev - next > _n / 2) {
      end = (next + _n).toDouble();
    } else if (next > prev && next - prev > _n / 2) {
      begin = prev.toDouble();
      end = next.toDouble();
    }

    final steps = (end - begin).abs().clamp(1.0, 12.0);
    _beadAnim = Tween<double>(begin: begin, end: end).animate(
      CurvedAnimation(parent: _move, curve: Curves.easeOutCubic),
    );
    _move
      ..duration = Duration(milliseconds: (400 + steps * 70).round().clamp(400, 900))
      ..forward(from: 0);
  }

  @override
  void dispose() {
    _move.dispose();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final w = widget.size;
    final h = widget.size * 1.18;
    return SizedBox(
      width: w,
      height: h,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: widget.flipHorizontal ? -1.0 : 1.0),
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeInOutCubic,
        builder: (_, scaleX, child) => Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(scaleX, 1, 1),
          child: child,
        ),
        child: AnimatedBuilder(
          animation: Listenable.merge([_move, _pulse]),
          builder: (_, __) {
            final visual = _beadAnim.value % _n;
            return CustomPaint(
              painter: _MalaPainter(
                beadPosition: visual < 0 ? visual + _n : visual,
                totalBeads: _n,
                pulse: _pulse.value,
                beadImage: _beadImage,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MalaPainter extends CustomPainter {
  _MalaPainter({
    required this.beadPosition,
    required this.totalBeads,
    this.pulse = 0,
    this.beadImage,
  });

  final double beadPosition;
  final int totalBeads;
  final double pulse;
  final ui.Image? beadImage;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.52);
    // Slightly larger oval so bigger beads have room
    final rx = size.width * 0.36;
    final ry = size.height * 0.41;

    const meruAngle = -math.pi / 2;
    const meruHalfGap = 0.13;
    final beadSpan = 2 * math.pi - 2 * meruHalfGap;
    final startAngle = meruAngle + meruHalfGap;

    canvas.drawOval(
      Rect.fromCenter(center: center, width: rx * 2, height: ry * 2),
      Paint()
        ..color = AppColors.chandloRed.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round,
    );

    Offset ovalPoint(double angle) => Offset(
          center.dx + rx * math.cos(angle),
          center.dy + ry * math.sin(angle),
        );

    double angleForIndex(double index) {
      return startAngle + beadSpan * (index / totalBeads);
    }

    // Base size increased ("increase side")
    const baseW = 11.5;
    const baseH = 14.0;

    for (var i = 0; i < totalBeads; i++) {
      final angle = angleForIndex(i.toDouble());
      final pos = ovalPoint(angle);
      final tangent = _ovalTangent(angle, rx, ry);

      var delta = (i - beadPosition).abs();
      if (delta > totalBeads / 2) delta = totalBeads - delta;
      final near = delta < 2.8;
      final t = near ? (1 - delta / 2.8).clamp(0.0, 1.0) : 0.0;
      final parity = i.isEven ? 1.14 : 0.92;
      final scale = (1.0 + t * 0.45) * parity;

      _drawBeadImage(
        canvas,
        pos,
        beadW: baseW * scale,
        beadH: baseH * scale,
        rotation: tangent,
        oddStyle: i.isOdd,
      );
    }

    final activeAngle = angleForIndex(beadPosition);
    final active = ovalPoint(activeAngle);
    final activeTangent = _ovalTangent(activeAngle, rx, ry);
    final pulseR = 1.0 + pulse * 0.16;
    final activeEven = beadPosition.round() % 2 == 0;

    canvas.drawCircle(
      active,
      18 * pulseR,
      Paint()
        ..color = AppColors.chandloRed.withValues(alpha: 0.22 + pulse * 0.18)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8),
    );
    _drawBeadImage(
      canvas,
      active,
      beadW: (activeEven ? 15.0 : 13.5) * pulseR,
      beadH: (activeEven ? 18.5 : 16.5) * pulseR,
      rotation: activeTangent,
      oddStyle: !activeEven,
      activeRing: true,
    );

    final meruPos = ovalPoint(meruAngle);
    _drawBeadImage(
      canvas,
      meruPos,
      beadW: 16.5,
      beadH: 20.0,
      rotation: 0,
      oddStyle: false,
    );
    _drawRedTassel(canvas, meruPos);
  }

  double _ovalTangent(double angle, double rx, double ry) {
    final dx = -rx * math.sin(angle);
    final dy = ry * math.cos(angle);
    return math.atan2(dy, dx);
  }

  void _drawBeadImage(
    Canvas canvas,
    Offset center, {
    required double beadW,
    required double beadH,
    required double rotation,
    required bool oddStyle,
    bool activeRing = false,
  }) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation + math.pi / 2);

    final w = oddStyle ? beadW * 0.96 : beadW;
    final h = oddStyle ? beadH * 1.04 : beadH;
    final dst = Rect.fromCenter(center: Offset.zero, width: w, height: h);

    final img = beadImage;
    if (img != null) {
      // Crop white margins — bead sits in center ~55% of frame
      final src = Rect.fromLTWH(
        img.width * 0.18,
        img.height * 0.14,
        img.width * 0.64,
        img.height * 0.72,
      );
      final paint = Paint()
        ..filterQuality = FilterQuality.medium
        ..isAntiAlias = true;
      if (oddStyle) {
        paint.colorFilter = const ColorFilter.matrix(<double>[
          1.05, 0, 0, 0, 8,
          0, 0.98, 0, 0, 4,
          0, 0, 0.92, 0, 0,
          0, 0, 0, 1, 0,
        ]);
      }
      // Soft circular clip so white corners from photo don't show
      canvas.save();
      canvas.clipPath(Path()..addOval(dst));
      canvas.drawImageRect(img, src, dst, paint);
      canvas.restore();
    } else {
      // Fallback while image loads
      canvas.drawOval(
        dst,
        Paint()..color = const Color(0xFF5D4037),
      );
    }

    if (activeRing) {
      canvas.drawOval(
        dst.inflate(2.0),
        Paint()
          ..color = AppColors.chandloRed.withValues(alpha: 0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }

    canvas.restore();
  }

  void _drawRedTassel(Canvas canvas, Offset meru) {
    final knot = Offset(meru.dx, meru.dy - 12);
    canvas.drawLine(
      Offset(meru.dx, meru.dy - 6),
      knot,
      Paint()
        ..color = AppColors.chandloRed
        ..strokeWidth = 2.6
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(knot, 3.4, Paint()..color = AppColors.chandloRed);

    final strand = Paint()
      ..color = AppColors.chandloRed
      ..strokeWidth = 1.7
      ..strokeCap = StrokeCap.round;
    for (var i = -4; i <= 4; i++) {
      final tip = Offset(knot.dx + i * 2.6, knot.dy - 18 - (i.abs() * 0.6));
      canvas.drawLine(knot, tip, strand);
      canvas.drawCircle(
        tip,
        1.5,
        Paint()..color = AppColors.chandloRed.withValues(alpha: 0.9),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MalaPainter oldDelegate) =>
      oldDelegate.beadPosition != beadPosition ||
      oldDelegate.pulse != pulse ||
      oldDelegate.totalBeads != totalBeads ||
      oldDelegate.beadImage != beadImage;
}
