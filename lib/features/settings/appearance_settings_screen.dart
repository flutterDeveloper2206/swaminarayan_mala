import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import 'settings_page_scaffold.dart';

class AppearanceSettingsScreen extends StatelessWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final s = state.settings;

    return SettingsPageScaffold(
      title: l10n.appearance,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          AppCard(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: Text(l10n.themeLight),
                  value: 'light',
                  groupValue: s.themeMode,
                  onChanged: (v) => state.setThemeMode(v!),
                ),
                RadioListTile<String>(
                  title: Text(l10n.themeDark),
                  value: 'dark',
                  groupValue: s.themeMode,
                  onChanged: (v) => state.setThemeMode(v!),
                ),
                RadioListTile<String>(
                  title: Text(l10n.themeSystem),
                  value: 'system',
                  groupValue: s.themeMode,
                  onChanged: (v) => state.setThemeMode(v!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
