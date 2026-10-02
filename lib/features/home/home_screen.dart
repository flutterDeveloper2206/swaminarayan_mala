import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/mantra_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/services/audio_service.dart';
import '../../core/widgets/app_widgets.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/jap_widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncMusic());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Keep ambient playing while app is open; stop only on background if desired.
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final mode = context.read<AppState>().settings.ambientPlaybackMode;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      // loop keeps playing in background; once/continue stop when leaving foreground
      if (mode != AppConstants.ambientModeLoop) {
        AudioService.instance.stopAmbient();
      }
    } else if (state == AppLifecycleState.resumed) {
      _syncMusic(forceRestart: mode != AppConstants.ambientModeLoop);
    }
  }

  Future<void> _syncMusic({bool forceRestart = false}) async {
    if (!mounted) return;
    final s = context.read<AppState>().settings;
    await AudioService.instance.startAmbient(
      enabled: s.backgroundMusicEnabled,
      volume: s.backgroundMusicVolume,
      customPath: s.ambientMusicPath,
      mode: s.ambientPlaybackMode,
      forceRestart: forceRestart,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final deity = MantraConstants.deityById(state.settings.selectedDeityId);
    final greeting =
        deity?.greetingFor(state.settings.languageCode) ?? 'Jai Swaminarayan';
    final mantra = state.selectedMantra;
    final today = state.today;
    final streak = state.currentStreak;

    return DevotionalBackground(
      dark: dark,
      child: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('$greeting 🙏',
                                style: AppTextStyles.heading(dark: dark)),
                            const SizedBox(height: 4),
                            Text(l10n.appSlogan,
                                style: AppTextStyles.slogan(dark: dark)),
                          ],
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.backgroundMusic,
                        onPressed: () async {
                          final next = !state.settings.backgroundMusicEnabled;
                          await state.updateSettings(
                            state.settings
                                .copyWith(backgroundMusicEnabled: next),
                          );
                          await _syncMusic();
                        },
                        icon: Icon(
                          state.settings.backgroundMusicEnabled
                              ? Icons.music_note_rounded
                              : Icons.music_off_rounded,
                          color: state.settings.backgroundMusicEnabled
                              ? AppColors.primary
                              : (dark
                                  ? AppColors.darkTextMuted
                                  : AppColors.textMuted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    goldBorder: true,
                    child: Column(
                      children: [
                        DeityImage(
                          deityId:
                              mantra?.deityId ?? state.settings.selectedDeityId,
                          size: 110,
                          selected: true,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          mantra?.text ?? 'श्री राम',
                          style: AppTextStyles.mantra(dark: dark),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.todayJap,
                          style: AppTextStyles.caption(dark: dark),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.dailyQuote,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.caption(dark: dark),
                        ),
                        const SizedBox(height: 20),
                        ProgressRing(
                          progress: today.progressPercent,
                          size: 150,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedCounter(value: today.totalCount),
                              Text(
                                l10n.targetProgress(
                                    today.totalCount, today.target),
                                style: AppTextStyles.caption(dark: dark),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        AppButton(
                          label: today.totalCount > 0
                              ? l10n.continueJap
                              : l10n.startJap,
                          onPressed: () =>
                              Navigator.of(context).pushNamed(AppRoutes.jap),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    onTap: () =>
                        Navigator.of(context).pushNamed(AppRoutes.kidsJap),
                    child: Row(
                      children: [
                        const Text('🎮', style: TextStyle(fontSize: 36)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(l10n.kidsJap,
                                  style: AppTextStyles.title(dark: dark)),
                              Text(
                                l10n.kidsJapCardSubtitle,
                                style: AppTextStyles.caption(dark: dark),
                              ),
                            ],
                          ),
                        ),
                        AppButton(
                          label: l10n.startKidsJap,
                          expand: false,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(AppRoutes.kidsJap),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.todaysProgress,
                            style: AppTextStyles.title(dark: dark)),
                        const SizedBox(height: 4),
                        Text(
                          mantra?.name ?? '',
                          style: AppTextStyles.caption(dark: dark),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: today.progressPercent,
                            minHeight: 8,
                            backgroundColor: AppColors.cardBorder,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            _stat(l10n.todaysMala, today.malaCount, dark),
                            _stat(
                                l10n.todaysSessions, today.sessionCount, dark),
                            _stat(l10n.currentStreak, streak, dark),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  SectionHeader(
                    title: l10n.quickMantras,
                    action: TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(AppRoutes.mantras),
                      child: Text(l10n.all),
                    ),
                  ),
                  SizedBox(
                    height: 168,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: state.mantras.take(8).length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final m = state.mantras[i];
                        final todayCount = state.todayCountForMantra(m.id);
                        final selected =
                            m.id == state.settings.selectedMantraId;
                        return SizedBox(
                          width: 150,
                          child: AppCard(
                            goldBorder: selected,
                            onTap: () async {
                              await state.selectMantra(m.id);
                              if (!context.mounted) return;
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.jap, arguments: m.id);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DeityImage(
                                    deityId: m.deityId,
                                    size: 40,
                                    selected: selected),
                                const SizedBox(height: 8),
                                Text(
                                  m.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.title(dark: dark)
                                      .copyWith(fontSize: 15),
                                ),
                                Text(
                                  m.transliteration,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.caption(dark: dark),
                                ),
                                const Spacer(),
                                Text(
                                  l10n.todayJap,
                                  style: AppTextStyles.caption(dark: dark)
                                      .copyWith(fontSize: 11),
                                ),
                                AnimatedCounter(
                                  value: todayCount,
                                  style: AppTextStyles.caption(
                                      color: AppColors.primary),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  AppButton(
                    label: l10n.sadhanaAnalytics,
                    secondary: true,
                    onPressed: () =>
                        Navigator.of(context).pushNamed(AppRoutes.progress),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String label, int value, bool dark) {
    return Expanded(
      child: Column(
        children: [
          AnimatedCounter(value: value, style: AppTextStyles.title(dark: dark)),
          Text(label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(dark: dark)),
        ],
      ),
    );
  }
}
