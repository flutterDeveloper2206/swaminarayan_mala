import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/jap_widgets.dart';
import '../../data/models/jap_session_model.dart';
import '../../data/models/mantra_model.dart';
import 'kids_jap_theme.dart';
import 'kids_parchment.dart';

class KidsJapGameScreen extends StatefulWidget {
  const KidsJapGameScreen({
    super.key,
    required this.mantraId,
    required this.target,
  });

  final String mantraId;
  final int target;

  @override
  State<KidsJapGameScreen> createState() => _KidsJapGameScreenState();
}

class _FallingObj {
  _FallingObj({
    required this.id,
    required this.label,
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.rotation,
    required this.spin,
  });

  final String id;
  final String label;
  double x;
  double y;
  final double speed;
  final double size;
  double rotation;
  final double spin;
  bool popping = false;
}

class _FloatLabel {
  _FloatLabel({required this.x, required this.y, required this.born});
  double x;
  double y;
  final DateTime born;
}

class _KidsJapGameScreenState extends State<KidsJapGameScreen>
    with TickerProviderStateMixin {
  late final AnimationController _loop;
  late final AnimationController _bob;
  late final KidsJapThemeConfig _theme;
  final _rng = math.Random();
  final List<_FallingObj> _objects = [];
  final List<_FloatLabel> _floats = [];
  int _sessionCount = 0;
  int _target = 108;
  bool _paused = false;
  bool _completed = false;
  bool _busy = false;
  String? _cheer;
  DateTime? _cheerUntil;
  int _tapsSinceCheer = 0;
  late DateTime _lastTick;

  @override
  void initState() {
    super.initState();
    final state = context.read<AppState>();
    MantraModel? mantra;
    try {
      mantra = state.mantras.firstWhere((m) => m.id == widget.mantraId);
    } catch (_) {}
    _theme = KidsJapThemeConfig.forMantra(widget.mantraId, deityId: mantra?.deityId);
    final active = state.activeSession;
    _target = widget.target;
    if (active != null && active.isKids && active.mantraId == widget.mantraId) {
      _sessionCount = active.count;
      _target = active.target > 0 ? active.target : widget.target;
    }
    _lastTick = DateTime.now();
    _loop = AnimationController(vsync: this, duration: const Duration(seconds: 1))
      ..addListener(_onTick)
      ..repeat();
    _bob = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    for (var i = 0; i < 8; i++) {
      _spawn(initial: true);
    }
  }

  @override
  void dispose() {
    _loop.dispose();
    _bob.dispose();
    super.dispose();
  }

  void _onTick() {
    if (_paused || _completed || !mounted) return;
    final now = DateTime.now();
    final dt = now.difference(_lastTick).inMilliseconds / 1000.0;
    _lastTick = now;
    if (dt <= 0 || dt > 0.1) return;

    setState(() {
      for (final o in _objects) {
        if (o.popping) continue;
        o.y += o.speed * dt;
        o.rotation += o.spin * dt;
        o.x += math.sin(o.y * 6 + o.spin) * 0.0008;
      }
      _objects.removeWhere((o) => o.y > 1.12 && !o.popping);
      while (_objects.where((o) => !o.popping).length < 8 && !_completed) {
        _spawn();
      }
      _floats.removeWhere((f) => now.difference(f.born).inMilliseconds > 750);
      for (final f in _floats) {
        f.y -= 0.4 * dt;
      }
      if (_cheerUntil != null && now.isAfter(_cheerUntil!)) {
        _cheer = null;
        _cheerUntil = null;
      }
    });
  }

  void _spawn({bool initial = false}) {
    final label = _theme.fallingObjects[_rng.nextInt(_theme.fallingObjects.length)];
    _objects.add(
      _FallingObj(
        id: '${DateTime.now().microsecondsSinceEpoch}_${_rng.nextInt(9999)}',
        label: label,
        x: 0.1 + _rng.nextDouble() * 0.8,
        y: initial ? _rng.nextDouble() * 0.5 : -0.15 - _rng.nextDouble() * 0.2,
        speed: 0.07 + _rng.nextDouble() * 0.06,
        size: 48 + _rng.nextDouble() * 20,
        rotation: _rng.nextDouble() * 0.5,
        spin: (_rng.nextBool() ? 1 : -1) * (0.15 + _rng.nextDouble() * 0.4),
      ),
    );
  }

  Future<void> _onTapObj(_FallingObj obj) async {
    if (_paused || _completed || _busy || obj.popping) return;
    setState(() => obj.popping = true);
    _busy = true;

    final state = context.read<AppState>();
    await state.japTap(mantraId: widget.mantraId);
    state.clearCelebrations();

    if (!mounted) return;
    setState(() {
      _sessionCount += 1;
      _floats.add(_FloatLabel(x: obj.x, y: obj.y, born: DateTime.now()));
      _objects.removeWhere((o) => o.id == obj.id);
      _tapsSinceCheer++;
      if (_tapsSinceCheer >= 8 + _rng.nextInt(5)) {
        _tapsSinceCheer = 0;
        final l10n = AppLocalizations.of(context);
        _cheer = _rng.nextBool() ? l10n.kidsWonderful : l10n.kidsShabash;
        _cheerUntil = DateTime.now().add(const Duration(seconds: 2));
      }
      if (_sessionCount >= _target) {
        _completed = true;
        _paused = true;
      }
    });
    _busy = false;
  }

  Future<void> _exitSave() async {
    await context.read<AppState>().endSession();
    if (mounted) Navigator.pop(context);
  }

  void _showPause() {
    setState(() => _paused = true);
    final l10n = AppLocalizations.of(context);
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: KidsWinScroll(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.pauseJap,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF5A3418),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.kidsPauseMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF6B4E32), fontSize: 15),
              ),
              const SizedBox(height: 18),
              KidsGoldButton(
                label: l10n.resumeJap,
                onPressed: () {
                  Navigator.pop(ctx);
                  setState(() {
                    _paused = false;
                    _lastTick = DateTime.now();
                  });
                },
              ),
              const SizedBox(height: 10),
              KidsGoldButton(
                label: l10n.restartJap,
                onPressed: () async {
                  Navigator.pop(ctx);
                  await context.read<AppState>().endSession();
                  if (!mounted) return;
                  await context.read<AppState>().startSession(
                        mantraId: widget.mantraId,
                        mode: JapMode.kids,
                        target: _target,
                      );
                  setState(() {
                    _sessionCount = 0;
                    _completed = false;
                    _paused = false;
                    _objects.clear();
                    for (var i = 0; i < 8; i++) {
                      _spawn(initial: true);
                    }
                    _lastTick = DateTime.now();
                  });
                },
              ),
              const SizedBox(height: 10),
              KidsGoldButton(
                label: l10n.exitJap,
                onPressed: () async {
                  Navigator.pop(ctx);
                  await _exitSave();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _playAgain() async {
    await context.read<AppState>().endSession();
    if (!mounted) return;
    await context.read<AppState>().startSession(
          mantraId: widget.mantraId,
          mode: JapMode.kids,
          target: _target,
        );
    if (!mounted) return;
    setState(() {
      _sessionCount = 0;
      _completed = false;
      _paused = false;
      _objects.clear();
      for (var i = 0; i < 8; i++) {
        _spawn(initial: true);
      }
      _lastTick = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final night = state.settings.nightMode;
    MantraModel? mantra;
    try {
      mantra = state.mantras.firstWhere((m) => m.id == widget.mantraId);
    } catch (_) {}

    final mantraLine = mantra?.text ?? 'श्री राम';
    final displayMantra = mantraLine.contains('/')
        ? mantraLine
        : (mantraLine.length > 10 ? '$mantraLine / $mantraLine' : mantraLine);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (!_completed) await context.read<AppState>().endSession();
        if (context.mounted) Navigator.pop(context);
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background garden
            ColorFiltered(
              colorFilter: night
                  ? const ColorFilter.mode(Color(0x66000000), BlendMode.darken)
                  : const ColorFilter.mode(Colors.transparent, BlendMode.dst),
              child: Image.asset(
                AssetConstants.kidsBg,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: _theme.skyColors + _theme.groundColors,
                    ),
                  ),
                ),
              ),
            ),
            // Soft vignette
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.05),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.12),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Stack(
                children: [
                  // Top bar
                  Positioned(
                    top: 8,
                    left: 12,
                    right: 12,
                    child: Row(
                      children: [
                        KidsRoundIconButton(
                          icon: Icons.arrow_back_rounded,
                          onTap: () async {
                            if (!_completed) {
                              await context.read<AppState>().endSession();
                            }
                            if (context.mounted) Navigator.pop(context);
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: KidsParchmentBox(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Text(
                              displayMantra,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF5A3418),
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        KidsRoundIconButton(
                          icon: state.settings.soundEnabled
                              ? Icons.music_note_rounded
                              : Icons.music_off_rounded,
                          onTap: () {
                            state.updateSettings(
                              state.settings.copyWith(
                                soundEnabled: !state.settings.soundEnabled,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Falling playfield
                  Positioned.fill(
                    top: 72,
                    bottom: 150,
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final size = Size(constraints.maxWidth, constraints.maxHeight);
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            for (final o in _objects)
                              Positioned(
                                left: o.x * size.width - o.size / 2,
                                top: o.y * size.height - o.size / 2,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () => _onTapObj(o),
                                  child: AnimatedScale(
                                    scale: o.popping ? 1.4 : 1,
                                    duration: const Duration(milliseconds: 220),
                                    child: Transform.rotate(
                                      angle: o.rotation,
                                      child: _FallingBadge(label: o.label, size: o.size),
                                    ),
                                  ),
                                ),
                              ),
                            for (final f in _floats)
                              Positioned(
                                left: f.x * size.width - 28,
                                top: f.y * size.height,
                                child: Text(
                                  l10n.plusOneJap,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 20,
                                    color: const Color(0xFF8B4513),
                                    shadows: [
                                      Shadow(
                                        color: Colors.white.withValues(alpha: 0.95),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            if (_cheer != null)
                              Align(
                                alignment: const Alignment(0, -0.15),
                                child: KidsParchmentBox(
                                  child: Text(
                                    _cheer!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      color: Color(0xFF5A3418),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),

                  // Character
                  Positioned(
                    bottom: 138,
                    left: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: _bob,
                      builder: (_, child) {
                        return Transform.translate(
                          offset: Offset(0, -6 * _bob.value),
                          child: child,
                        );
                      },
                      child: Center(
                        child: Image.asset(
                          AssetConstants.kidsCatch,
                          height: 150,
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Text(
                            _theme.characterEmoji,
                            style: const TextStyle(fontSize: 72),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Counter + pause
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 18,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Spacer(),
                        KidsParchmentBox(
                          width: 170,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          borderRadius: 22,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('🌸', style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 6),
                                  AnimatedCounter(
                                    value: _sessionCount,
                                    enableSeparator: false,
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF5A3418),
                                      height: 1.05,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                l10n.japCountLabel,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF7A5632),
                                ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: (_sessionCount / _target).clamp(0.0, 1.0),
                                  minHeight: 8,
                                  backgroundColor: const Color(0xFFE8D5B0),
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedCounter(
                                    value: _sessionCount,
                                    enableSeparator: false,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF8B6A42),
                                    ),
                                  ),
                                  const Text(
                                    ' / ',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF8B6A42),
                                    ),
                                  ),
                                  Text(
                                    '$_target',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF8B6A42),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        KidsRoundIconButton(
                          icon: Icons.pause_rounded,
                          onTap: _showPause,
                          size: 52,
                        ),
                      ],
                    ),
                  ),

                  if (_completed) _winOverlay(context, l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _winOverlay(BuildContext context, AppLocalizations l10n) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withValues(alpha: 0.5),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: KidsWinScroll(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.kidsJapCompletedTitle,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF5A3418),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n.kidsJapCompletedBody(_target),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.35,
                      color: Color(0xFF6B4E32),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    l10n.kidsKeepGoingLittle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF8B5A2B),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Image.asset(
                    AssetConstants.kidsWin,
                    height: 150,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Text('🙏🌸', style: TextStyle(fontSize: 48)),
                  ),
                  const SizedBox(height: 16),
                  KidsGoldButton(
                    label: l10n.kidsPlayAgain,
                    onPressed: _playAgain,
                  ),
                  const SizedBox(height: 10),
                  KidsGoldButton(
                    label: l10n.kidsGoToJap,
                    onPressed: () async {
                      await context.read<AppState>().endSession();
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      Navigator.of(context).pushNamed(
                        AppRoutes.jap,
                        arguments: widget.mantraId,
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  KidsGoldButton(
                    label: l10n.home,
                    onPressed: () async {
                      await context.read<AppState>().endSession();
                      if (!context.mounted) return;
                      Navigator.popUntil(
                        context,
                        (route) =>
                            route.settings.name == AppRoutes.home || route.isFirst,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FallingBadge extends StatelessWidget {
  const _FallingBadge({required this.label, required this.size});

  final String label;
  final double size;

  bool get _isWoodTile {
    // Text mantras / Om look like wooden tiles in the mockup.
    return label.contains('ॐ') ||
        label.contains('राम') ||
        label.contains('राधे') ||
        label.contains('कृष्ण') ||
        label.contains('♪');
  }

  @override
  Widget build(BuildContext context) {
    final wood = _isWoodTile;
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: wood ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: wood ? BorderRadius.circular(10) : null,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: wood
              ? const [Color(0xFFF5E0B8), Color(0xFFD4A574)]
              : [
                  Colors.white.withValues(alpha: 0.55),
                  Colors.white.withValues(alpha: 0.25),
                ],
        ),
        border: Border.all(
          color: wood ? const Color(0xFF8B5A2B) : Colors.white.withValues(alpha: 0.7),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.45),
            blurRadius: 14,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: wood ? size * 0.34 : size * 0.55,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF5A3418),
        ),
      ),
    );
  }
}
