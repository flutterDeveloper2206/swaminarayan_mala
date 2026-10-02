import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/constants/app_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import 'settings_page_scaffold.dart';

class JapSettingsScreen extends StatelessWidget {
  const JapSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final s = state.settings;

    return SettingsPageScaffold(
      title: l10n.japSettings,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          AppCard(
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.dailyTarget),
                  subtitle: Text('${s.dailyTarget}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickTarget(context, state),
                ),
                SwitchListTile(
                  title: Text(l10n.sound),
                  value: s.soundEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => state.updateSettings(s.copyWith(soundEnabled: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.haptic),
                  value: s.hapticEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => state.updateSettings(s.copyWith(hapticEnabled: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.volumeButtonJap),
                  value: s.volumeButtonEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) =>
                      state.updateSettings(s.copyWith(volumeButtonEnabled: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.autoStartLastMantra),
                  value: s.autoStartLastMantra,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) =>
                      state.updateSettings(s.copyWith(autoStartLastMantra: v)),
                ),
                SwitchListTile(
                  title: Text(l10n.nightMode),
                  value: s.nightMode,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => state.setNightMode(v),
                ),
                SwitchListTile(
                  title: Text(l10n.focusMode),
                  value: s.focusMode,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) => state.setFocusMode(v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickTarget(BuildContext context, AppState state) async {
    final l10n = AppLocalizations.of(context);
    final custom = TextEditingController();
    final result = await showModalBottomSheet<int>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final t in AppConstants.presetTargets)
                ListTile(
                  title: Text('$t'),
                  onTap: () => Navigator.pop(ctx, t),
                ),
              ListTile(
                title: Text(l10n.customTarget),
                onTap: () async {
                  final ok = await showDialog<bool>(
                    context: ctx,
                    builder: (_) => AlertDialog(
                      title: Text(l10n.customTarget),
                      content: TextField(
                        controller: custom,
                        keyboardType: TextInputType.number,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.save),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    final v = int.tryParse(custom.text) ?? 108;
                    if (ctx.mounted) Navigator.pop(ctx, v);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
    if (result != null) {
      await state.updateSettings(state.settings.copyWith(dailyTarget: result));
    }
  }
}
