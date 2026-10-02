import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import '../../core/widgets/devotional_background.dart';

/// Settings hub — opens each category on its own screen.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dark = Theme.of(context).brightness == Brightness.dark;
    context.watch<AppState>();

    return Scaffold(
      body: DevotionalBackground(
        dark: dark,
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(l10n.settings, style: AppTextStyles.heading(dark: dark)),
                ],
              ),
              const SizedBox(height: 8),
              _tile(
                context,
                icon: Icons.self_improvement_outlined,
                title: l10n.japSettings,
                route: AppRoutes.settingsJap,
              ),
              _tile(
                context,
                icon: Icons.music_note_outlined,
                title: l10n.musicSection,
                route: AppRoutes.settingsMusic,
              ),
              _tile(
                context,
                icon: Icons.spa_outlined,
                title: l10n.selectDeity,
                route: AppRoutes.settingsDeity,
              ),
              _tile(
                context,
                icon: Icons.notifications_outlined,
                title: l10n.dailyReminder,
                route: AppRoutes.settingsReminder,
              ),
              _tile(
                context,
                icon: Icons.palette_outlined,
                title: l10n.appearance,
                route: AppRoutes.settingsAppearance,
              ),
              _tile(
                context,
                icon: Icons.translate_outlined,
                title: l10n.language,
                route: AppRoutes.settingsLanguage,
              ),
              _tile(
                context,
                icon: Icons.storage_outlined,
                title: l10n.dataSection,
                route: AppRoutes.settingsData,
              ),
              const SizedBox(height: 20),
              Text(
                l10n.privacyMessage,
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(dark: dark),
              ),
              const SizedBox(height: 12),
              Text(
                'Swaminarayan Maala is an independent devotion app inspired by publicly known teachings of the Akshar-Purushottam tradition. It is not affiliated with, endorsed by, or an official product of BAPS Swaminarayan Sanstha. Research inspiration: baps.org',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption(dark: dark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String route,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        onTap: () => Navigator.pushNamed(context, route),
        child: ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
