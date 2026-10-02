import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import '../../core/widgets/devotional_background.dart';
import '../../data/models/jap_session_model.dart';
import '../../data/models/mantra_model.dart';
import 'kids_jap_game_screen.dart';

class KidsJapEntryScreen extends StatefulWidget {
  const KidsJapEntryScreen({super.key});

  @override
  State<KidsJapEntryScreen> createState() => _KidsJapEntryScreenState();
}

class _KidsJapEntryScreenState extends State<KidsJapEntryScreen> {
  String? _mantraId;
  int _target = AppConstants.defaultKidsTarget;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AppState>();
      setState(() => _mantraId = state.settings.selectedMantraId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final mantras = state.mantras;
    final active = state.activeSession;
    final canContinue = active != null &&
        active.isKids &&
        active.endedAt == null &&
        active.count > 0 &&
        active.count < active.target;

    return Scaffold(
      body: DevotionalBackground(
        dark: dark,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Expanded(
                    child: Text(l10n.kidsJap, style: AppTextStyles.heading(dark: dark)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              AppCard(
                goldBorder: true,
                child: Column(
                  children: [
                    const Text('🎮', style: TextStyle(fontSize: 48)),
                    const SizedBox(height: 8),
                    Text(
                      l10n.kidsJapSubtitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.title(dark: dark),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.kidsJapIntro,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.caption(dark: dark),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: const [
                        Text('🌸', style: TextStyle(fontSize: 28)),
                        Text('⭐', style: TextStyle(fontSize: 28)),
                        Text('🪔', style: TextStyle(fontSize: 28)),
                        Text('🦚', style: TextStyle(fontSize: 28)),
                        Text('🪷', style: TextStyle(fontSize: 28)),
                      ],
                    ),
                  ],
                ),
              ),
              if (canContinue) ...[
                const SizedBox(height: 16),
                AppCard(
                  onTap: () => _openGame(
                    context,
                    mantraId: active.mantraId,
                    target: active.target,
                    continueSession: true,
                  ),
                  child: ListTile(
                    leading: const Text('🙏', style: TextStyle(fontSize: 28)),
                    title: Text(l10n.continueJap),
                    subtitle: Text(
                      '${_mantraName(mantras, active.mantraId)} · ${active.count} / ${active.target}',
                    ),
                    trailing: const Icon(Icons.play_arrow_rounded, color: AppColors.primary),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(l10n.selectMantra, style: AppTextStyles.title(dark: dark)),
              const SizedBox(height: 8),
              ...mantras.map((m) {
                final selected = m.id == _mantraId;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: AppCard(
                    goldBorder: selected,
                    onTap: () => setState(() => _mantraId = m.id),
                    child: ListTile(
                      leading: Text(
                        selected ? '✨' : '🕉️',
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(m.text, style: AppTextStyles.mantra(dark: dark).copyWith(fontSize: 18)),
                      subtitle: Text(m.name),
                      trailing: selected
                          ? const Icon(Icons.check_circle, color: AppColors.primary)
                          : null,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Text(l10n.chooseTarget, style: AppTextStyles.title(dark: dark)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final t in AppConstants.kidsTargets)
                    ChoiceChip(
                      label: Text('$t'),
                      selected: _target == t,
                      selectedColor: AppColors.goldSoft,
                      onSelected: (_) => setState(() => _target = t),
                    ),
                  ActionChip(
                    label: Text(l10n.customTarget),
                    onPressed: () => _customTarget(context),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                label: l10n.startKidsJap,
                onPressed: _mantraId == null
                    ? null
                    : () => _openGame(
                          context,
                          mantraId: _mantraId!,
                          target: _target,
                          continueSession: false,
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _mantraName(List<MantraModel> mantras, String id) {
    try {
      return mantras.firstWhere((m) => m.id == id).text;
    } catch (_) {
      return id;
    }
  }

  Future<void> _customTarget(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: '$_target');
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customTarget),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
        ],
      ),
    );
    if (ok == true) {
      final v = int.tryParse(controller.text) ?? AppConstants.defaultKidsTarget;
      setState(() => _target = v.clamp(1, 100000));
    }
  }

  Future<void> _openGame(
    BuildContext context, {
    required String mantraId,
    required int target,
    required bool continueSession,
  }) async {
    final state = context.read<AppState>();
    if (!continueSession) {
      await state.selectMantra(mantraId);
      await state.startSession(
        mantraId: mantraId,
        mode: JapMode.kids,
        target: target,
      );
    }
    if (!context.mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => KidsJapGameScreen(
          mantraId: mantraId,
          target: target,
        ),
      ),
    );
  }
}

/// Lightweight tab wrapper that opens entry as the tab body.
class KidsJapTabScreen extends StatelessWidget {
  const KidsJapTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    final state = context.watch<AppState>();

    return DevotionalBackground(
      dark: dark,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.kidsJap, style: AppTextStyles.heading(dark: dark)),
              const SizedBox(height: 20),
              Expanded(
                child: AppCard(
                  goldBorder: true,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.kidsJap),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Transform.rotate(
                        angle: math.sin(DateTime.now().millisecond / 200) * 0.02,
                        child: const Text('🎮', style: TextStyle(fontSize: 64)),
                      ),
                      const SizedBox(height: 16),
                      Text(l10n.kidsJap, style: AppTextStyles.title(dark: dark)),
                      const SizedBox(height: 8),
                      Text(
                        l10n.kidsJapCardSubtitle,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption(dark: dark),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        label: l10n.startKidsJap,
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.kidsJap),
                      ),
                      if (state.activeSession?.isKids == true &&
                          (state.activeSession!.count) > 0) ...[
                        const SizedBox(height: 12),
                        Text(
                          '${l10n.continueJap}: ${state.activeSession!.count}/${state.activeSession!.target}',
                          style: AppTextStyles.caption(color: AppColors.primary),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
