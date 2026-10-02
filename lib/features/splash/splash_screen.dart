import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/tilak_chandlo_mark.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _main;
  late final AnimationController _particles;
  late final Animation<double> _fadeBg;
  late final Animation<double> _fadeText;
  late final Animation<Offset> _slideText;

  @override
  void initState() {
    super.initState();
    _main = AnimationController(vsync: this, duration: const Duration(milliseconds: 2600));
    _particles = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();

    _fadeBg = CurvedAnimation(parent: _main, curve: const Interval(0, 0.25, curve: Curves.easeOut));
    _fadeText = CurvedAnimation(parent: _main, curve: const Interval(0.55, 0.9, curve: Curves.easeIn));
    _slideText = Tween(begin: const Offset(0, 0.12), end: Offset.zero).animate(
      CurvedAnimation(parent: _main, curve: const Interval(0.55, 0.95, curve: Curves.easeOutCubic)),
    );

    _main.forward();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;
    final state = context.read<AppState>();
    final route = state.settings.firstLaunchCompleted ? AppRoutes.home : AppRoutes.onboarding;
    Navigator.of(context).pushReplacementNamed(route);
  }

  @override
  void dispose() {
    _main.dispose();
    _particles.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: FadeTransition(
        opacity: _fadeBg,
        child: DevotionalBackground(
          showMandala: false,
          child: Stack(
            children: [
              AnimatedBuilder(
                animation: _particles,
                builder: (_, __) => CustomPaint(
                  size: MediaQuery.sizeOf(context),
                  painter: _SaffronDustPainter(_particles.value),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TilakChandloMark(
                      size: 148,
                      showGlow: true,
                      filled: false,
                      animate: true,
                      repeatPulse: true,
                    ),
                    const SizedBox(height: 32),
                    FadeTransition(
                      opacity: _fadeText,
                      child: SlideTransition(
                        position: _slideText,
                        child: Column(
                          children: [
                            Text(
                              l10n.appName,
                              style: AppTextStyles.display().copyWith(
                                color: AppColors.maroon,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 36),
                              child: Text(
                                l10n.appSlogan,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.slogan().copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'जय स्वामिनारायण',
                              style: AppTextStyles.title().copyWith(
                                color: AppColors.chandloRed,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SaffronDustPainter extends CustomPainter {
  _SaffronDustPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(7);
    for (var i = 0; i < 22; i++) {
      final x = rnd.nextDouble() * size.width;
      final baseY = rnd.nextDouble() * size.height;
      final y = (baseY - t * size.height * 0.25) % size.height;
      final saffron = i.isEven;
      canvas.drawCircle(
        Offset(x, y),
        1.2 + rnd.nextDouble() * 2.2,
        Paint()
          ..color = (saffron ? AppColors.saffron : AppColors.chandloRed)
              .withValues(alpha: 0.12 + rnd.nextDouble() * 0.18),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SaffronDustPainter oldDelegate) => oldDelegate.t != t;
}
