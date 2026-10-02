import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/providers/app_state.dart';
import '../../core/services/reminder_service.dart';
import '../../core/widgets/app_widgets.dart';
import 'settings_page_scaffold.dart';

class ReminderSettingsScreen extends StatelessWidget {
  const ReminderSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final s = state.settings;

    return SettingsPageScaffold(
      title: l10n.dailyReminder,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          AppCard(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.enableReminder),
                  value: s.reminder.enabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: (v) async {
                    if (v) {
                      final ok = await ReminderService.instance.requestPermission();
                      if (!ok && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.notificationPermissionDenied)),
                        );
                        return;
                      }
                    }
                    await state.updateSettings(
                      s.copyWith(reminder: s.reminder.copyWith(enabled: v)),
                    );
                  },
                ),
                ListTile(
                  title: Text(l10n.reminderTime),
                  subtitle: Text(
                    '${s.reminder.hour.toString().padLeft(2, '0')}:${s.reminder.minute.toString().padLeft(2, '0')}',
                  ),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay(
                        hour: s.reminder.hour,
                        minute: s.reminder.minute,
                      ),
                    );
                    if (picked != null) {
                      await state.updateSettings(
                        s.copyWith(
                          reminder: s.reminder.copyWith(
                            hour: picked.hour,
                            minute: picked.minute,
                          ),
                        ),
                      );
                    }
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.morning),
                  value: s.reminder.morningEnabled,
                  onChanged: (v) => state.updateSettings(
                    s.copyWith(reminder: s.reminder.copyWith(morningEnabled: v)),
                  ),
                ),
                SwitchListTile(
                  title: Text(l10n.afternoon),
                  value: s.reminder.afternoonEnabled,
                  onChanged: (v) => state.updateSettings(
                    s.copyWith(reminder: s.reminder.copyWith(afternoonEnabled: v)),
                  ),
                ),
                SwitchListTile(
                  title: Text(l10n.evening),
                  value: s.reminder.eveningEnabled,
                  onChanged: (v) => state.updateSettings(
                    s.copyWith(reminder: s.reminder.copyWith(eveningEnabled: v)),
                  ),
                ),
                const Divider(),
                ListTile(title: Text(l10n.reminderMode)),
                RadioListTile<String>(
                  title: Text(l10n.normalJap),
                  value: 'normal',
                  groupValue: s.reminderMode,
                  onChanged: (v) => state.updateSettings(s.copyWith(reminderMode: v)),
                ),
                RadioListTile<String>(
                  title: Text(l10n.kidsJap),
                  value: 'kids',
                  groupValue: s.reminderMode,
                  onChanged: (v) => state.updateSettings(s.copyWith(reminderMode: v)),
                ),
                RadioListTile<String>(
                  title: Text(l10n.reminderModeAsk),
                  value: 'ask',
                  groupValue: s.reminderMode,
                  onChanged: (v) => state.updateSettings(s.copyWith(reminderMode: v)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
