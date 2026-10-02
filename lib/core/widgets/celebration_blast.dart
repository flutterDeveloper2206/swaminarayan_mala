import 'dart:math' as math;

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Flower petals + full flowers blast for mala completion.
class CelebrationBlast extends StatefulWidget {
  const CelebrationBlast({
    super.key,
    required this.play,
    this.child,
  });

  /// When true, fires a blast (edge-triggered by parent).
  final bool play;
  final Widget? child;

  @override
  State<CelebrationBlast> createState() => _CelebrationBlastState();
}

class _CelebrationBlastState extends State<CelebrationBlast> {
  late final ConfettiController _petals;
  late final ConfettiController _flowers;
  bool _wasPlaying = false;
  int _shapeTick = 0;

  static const _flowerColors = [
    AppColors.chandloRed,
    Color(0xFFFF6B8A), // rose
    Color(0xFFFFC1CC), // soft pink
    AppColors.tilakYellow,
    AppColors.gold,
    Color(0xFFFFE082), // pale marigold
    Color(0xFFFFF5F6), // cream
    AppColors.saffronSoft,
  ];

  @override
  void initState() {
    super.initState();
    _petals = ConfettiController(duration: const Duration(milliseconds: 2800));
    _flowers = ConfettiController(duration: const Duration(milliseconds: 2800));
  }

  @override
  void didUpdateWidget(covariant CelebrationBlast oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !_wasPlaying) {
      _fire();
    }
    _wasPlaying = widget.play;
  }

  Future<void> _fire() async {
    // Wait for mala flip (~1000ms) then blast petals + flowers
    await Future<void>.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    _petals.play();
    _flowers.play();
  }

  @override
  void dispose() {
    _petals.dispose();
    _flowers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (widget.child != null) widget.child!,
        IgnorePointer(
          child: ConfettiWidget(
            confettiController: _petals,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.06,
            numberOfParticles: 42,
            maxBlastForce: 30,
            minBlastForce: 12,
            gravity: 0.16,
            shouldLoop: false,
            colors: _flowerColors,
            createParticlePath: _petalPath,
          ),
        ),
        IgnorePointer(
          child: ConfettiWidget(
            confettiController: _flowers,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 22,
            maxBlastForce: 24,
            minBlastForce: 8,
            gravity: 0.14,
            shouldLoop: false,
            colors: _flowerColors,
            createParticlePath: _flowerPath,
          ),
        ),
      ],
    );
  }

  /// Single soft flower petal.
  Path _petalPath(Size size) {
    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.5, h);
    path.quadraticBezierTo(w * 1.15, h * 0.55, w * 0.5, 0);
    path.quadraticBezierTo(w * -0.15, h * 0.55, w * 0.5, h);
    path.close();
    return path;
  }

  /// Full flower: center + 5 or 6 petals.
  Path _flowerPath(Size size) {
    _shapeTick++;
    final petalCount = 5 + (_shapeTick % 2);
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final outer = math.min(w, h) * 0.48;
    final path = Path();

    for (var i = 0; i < petalCount; i++) {
      final angle = -math.pi / 2 + (2 * math.pi * i / petalCount);
      final tip = Offset(cx + outer * math.cos(angle), cy + outer * math.sin(angle));
      final leftAngle = angle - math.pi / petalCount * 0.85;
      final rightAngle = angle + math.pi / petalCount * 0.85;
      final left = Offset(
        cx + outer * 0.42 * math.cos(leftAngle),
        cy + outer * 0.42 * math.sin(leftAngle),
      );
      final right = Offset(
        cx + outer * 0.42 * math.cos(rightAngle),
        cy + outer * 0.42 * math.sin(rightAngle),
      );

      path.moveTo(cx, cy);
      path.quadraticBezierTo(left.dx, left.dy, tip.dx, tip.dy);
      path.quadraticBezierTo(right.dx, right.dy, cx, cy);
      path.close();
    }

    path.addOval(Rect.fromCircle(center: Offset(cx, cy), radius: outer * 0.22));
    return path;
  }
}
