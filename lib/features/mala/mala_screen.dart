import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/celebration_blast.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/jap_widgets.dart';

class MalaScreen extends StatefulWidget {
  const MalaScreen({super.key});

  @override
  State<MalaScreen> createState() => _MalaScreenState();
}

class _MalaScreenState extends State<MalaScreen> {
  bool _blast = false;

  Future<void> _onJapTap(AppState state, AppLocalizations l10n) async {
    await state.startSession();
    await state.japTap();
    if (!mounted) return;
    if (state.malaJustCompleted) {
      setState(() => _blast = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.malaCompleted} 🙏')),
      );
      state.clearCelebrations();
      Future<void>.delayed(const Duration(milliseconds: 3600), () {
        if (mounted) setState(() => _blast = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bead = state.beadPosition;
    final remaining = AppConstants.malaBeads - bead;

    return DevotionalBackground(
      dark: dark,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Column(
                children: [
                  Text(l10n.mala, style: AppTextStyles.heading(dark: dark)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedCounter(
                        value: remaining == AppConstants.malaBeads ? 0 : remaining,
                        enableSeparator: false,
                        style: AppTextStyles.caption(dark: dark),
                      ),
                      Text(
                        l10n.remainingCount(0).replaceFirst('0', ''),
                        style: AppTextStyles.caption(dark: dark),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxW = constraints.maxWidth;
                  final maxH = constraints.maxHeight;
                  final baseW = math.min(maxW * 1.0, maxH / 1.18 * 1.0);
                  final malaW = baseW.clamp(0.0, maxW);
                  final japSize = (malaW * 0.34).clamp(96.0, 128.0);

                  return CelebrationBlast(
                    play: _blast,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        MalaWidget(
                          beadPosition: bead,
                          size: malaW,
                          flipHorizontal: state.today.malaCount.isOdd,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (state.currentNamavaliLabel != null) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: malaW * 0.12),
                                child: Text(
                                  state.currentNamavaliLabel!,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.title(dark: dark).copyWith(fontSize: 14),
                                ),
                              ),
                              const SizedBox(height: 6),
                            ],
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                AnimatedCounter(
                                  value: bead,
                                  enableSeparator: false,
                                  style: AppTextStyles.counter(dark: dark).copyWith(
                                    fontSize: (malaW * 0.11).clamp(28.0, 40.0),
                                  ),
                                ),
                                Text(
                                  ' / ${AppConstants.malaBeads}',
                                  style: AppTextStyles.counter(dark: dark).copyWith(
                                    fontSize: (malaW * 0.11).clamp(28.0, 40.0),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${l10n.todaysMala}: ',
                                  style: AppTextStyles.title(dark: dark).copyWith(
                                    fontSize: (malaW * 0.048).clamp(14.0, 18.0),
                                  ),
                                ),
                                AnimatedCounter(
                                  value: state.today.malaCount,
                                  enableSeparator: false,
                                  style: AppTextStyles.title(dark: dark).copyWith(
                                    fontSize: (malaW * 0.048).clamp(14.0, 18.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: malaW * 0.04),
                            JapButton(
                              size: japSize,
                              onTap: () => _onJapTap(state, l10n),
                              label: l10n.tapToJap,
                              hint: l10n.tapHint,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
