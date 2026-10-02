import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/celebration_blast.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/jap_widgets.dart';

class JapScreen extends StatefulWidget {
  const JapScreen({super.key, this.mantraId});

  final String? mantraId;

  @override
  State<JapScreen> createState() => _JapScreenState();
}

class _JapScreenState extends State<JapScreen> {
  bool _sessionStarted = false;
  String? _activeMantraId;
  bool _blast = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureSession());
  }

  Future<void> _ensureSession() async {
    final state = context.read<AppState>();
    _activeMantraId = widget.mantraId ?? state.settings.selectedMantraId;
    if (widget.mantraId != null) {
      await state.selectMantra(widget.mantraId!);
    }
    await state.startSession(mantraId: _activeMantraId);
    if (mounted) setState(() => _sessionStarted = true);
  }

  @override
  void dispose() {
    // End session when leaving — use root context carefully
    super.dispose();
  }

  Future<void> _onJap() async {
    final state = context.read<AppState>();
    if (!_sessionStarted) await _ensureSession();
    await state.japTap(mantraId: _activeMantraId);

    if (!mounted) return;
    if (state.malaJustCompleted) {
      setState(() => _blast = true);
      _showCalmSnack(AppLocalizations.of(context).malaCompleted);
      Future<void>.delayed(const Duration(milliseconds: 3600), () {
        if (mounted) setState(() => _blast = false);
      });
    }
    if (state.targetJustCompleted) {
      _showCalmSnack(AppLocalizations.of(context).targetCompleted);
    }
    if (state.streakMilestoneReached != null) {
      _showCalmSnack(
        AppLocalizations.of(context).streakMilestoneMessage(state.streakMilestoneReached!),
      );
    }
    state.clearCelebrations();
  }

  void _showCalmSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message 🙏'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDeep,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark || state.settings.nightMode;
    final focus = state.settings.focusMode;
    final mantra = state.selectedMantra;
    final today = state.today;

    return PopScope(
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) {
          await context.read<AppState>().endSession();
        }
      },
      child: Scaffold(
        body: DevotionalBackground(
          dark: dark,
          child: CelebrationBlast(
            play: _blast,
            child: SafeArea(
            child: focus
                ? _focusBody(l10n, state, dark, mantra?.text ?? '', today.totalCount)
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          children: [
                            if (Navigator.of(context).canPop())
                              IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                                onPressed: () async {
                                  await state.endSession();
                                  if (context.mounted) Navigator.of(context).pop();
                                },
                              )
                            else
                              const SizedBox(width: 48),
                            Expanded(
                              child: Text(
                                mantra?.name ?? l10n.jap,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.title(dark: dark),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                state.settings.focusMode
                                    ? Icons.fullscreen_exit
                                    : Icons.center_focus_strong_outlined,
                              ),
                              onPressed: () => state.setFocusMode(!state.settings.focusMode),
                              tooltip: l10n.focusMode,
                            ),
                            IconButton(
                              icon: Icon(
                                state.settings.nightMode
                                    ? Icons.wb_sunny_outlined
                                    : Icons.nights_stay_outlined,
                              ),
                              onPressed: () => state.setNightMode(!state.settings.nightMode),
                              tooltip: l10n.nightMode,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(flex: 1),
                      DeityImage(
                        deityId: mantra?.deityId ?? state.settings.selectedDeityId,
                        size: 130,
                        selected: true,
                      ),
                      const SizedBox(height: 16),
                      Text(mantra?.text ?? '', style: AppTextStyles.mantra(dark: dark)),
                      if (state.currentNamavaliLabel != null) ...[
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            state.currentNamavaliLabel!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.title(dark: dark).copyWith(
                              color: AppColors.maroon,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        l10n.targetProgress(today.totalCount, today.target),
                        style: AppTextStyles.caption(dark: dark),
                      ),
                      const SizedBox(height: 20),
                      ProgressRing(
                        progress: today.progressPercent,
                        size: 160,
                        child: AnimatedCounter(value: today.totalCount),
                      ),
                      const Spacer(flex: 1),
                      JapButton(
                        onTap: _onJap,
                        label: l10n.tapToJap,
                        hint: l10n.tapHint,
                        size: 150,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedCounter(
                            value: state.beadPosition,
                            enableSeparator: false,
                            style: AppTextStyles.caption(dark: dark),
                          ),
                          Text(
                            l10n.naamCount(0).replaceFirst('0', ''),
                            style: AppTextStyles.caption(dark: dark),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('${l10n.mala}: ', style: AppTextStyles.caption(dark: dark)),
                          AnimatedCounter(
                            value: today.malaCount,
                            enableSeparator: false,
                            style: AppTextStyles.caption(dark: dark),
                          ),
                        ],
                      ),
                      const Spacer(flex: 1),
                    ],
                  ),
          ),
          ),
        ),
      ),
    );
  }

  Widget _focusBody(
    AppLocalizations l10n,
    AppState state,
    bool dark,
    String mantraText,
    int count,
  ) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onJap,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () => state.setFocusMode(false),
              child: Text(l10n.exitFocusMode),
            ),
          ),
          const Spacer(),
          DeityImage(
            deityId: state.selectedMantra?.deityId ?? state.settings.selectedDeityId,
            size: 100,
          ),
          const SizedBox(height: 20),
          Text(mantraText, style: AppTextStyles.mantra(dark: dark)),
          if (state.currentNamavaliLabel != null) ...[
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Text(
                state.currentNamavaliLabel!,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(dark: dark).copyWith(fontSize: 14),
              ),
            ),
          ],
          const SizedBox(height: 24),
          AnimatedCounter(value: count),
          const Spacer(),
          Text(l10n.tapHint, style: AppTextStyles.caption(dark: dark)),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
