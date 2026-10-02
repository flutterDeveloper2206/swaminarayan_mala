import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/mantra_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/jap_widgets.dart';
import '../../core/widgets/app_widgets.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/profile_avatar.dart';
import '../../data/local/local_database.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final deity = MantraConstants.deityById(state.settings.selectedDeityId);
    final db = LocalDatabase.instance;
    final lifetime = db.getSetting<int>(AppConstants.keyLifetimeCount, defaultValue: 0);
    final displayName = state.settings.userName.trim().isNotEmpty
        ? state.settings.userName.trim()
        : (deity?.nameFor(state.settings.languageCode) ?? '');

    return DevotionalBackground(
      dark: dark,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(l10n.profile, style: AppTextStyles.heading(dark: dark)),
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  const ProfileAvatar(size: 100, editable: true),
                  const SizedBox(height: 12),
                  Text(displayName, style: AppTextStyles.title(dark: dark)),
                  Text(l10n.appSlogan, style: AppTextStyles.slogan(dark: dark)),
                  TextButton(
                    onPressed: () => _editName(context, state),
                    child: Text(l10n.editProfile),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              goldBorder: true,
              child: Column(
                children: [
                  _rowInt(l10n.totalJap, lifetime, dark),
                  _rowInt(l10n.currentStreak, state.currentStreak, dark),
                  _rowInt(l10n.longestStreak, state.longestStreak, dark),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.progress),
              child: ListTile(
                leading: const Icon(Icons.insights_outlined),
                title: Text(l10n.sadhanaAnalytics),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
              child: ListTile(
                leading: const Icon(Icons.favorite_outline),
                title: Text(l10n.favorites),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.stories),
              child: ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(l10n.stories),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.mantras),
              child: ListTile(
                leading: const Icon(Icons.auto_awesome),
                title: Text(l10n.mantraLibrary),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.kidsJap),
              child: ListTile(
                leading: const Icon(Icons.sports_esports_outlined),
                title: Text(l10n.kidsJap),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
              child: ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: Text(l10n.settings),
                trailing: const Icon(Icons.chevron_right),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              l10n.privacyMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption(dark: dark),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _editName(BuildContext context, AppState state) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: state.settings.userName);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.yourName),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(hintText: l10n.yourName),
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
      await state.setUserName(controller.text);
    }
  }

  Widget _rowInt(String label, int value, bool dark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppTextStyles.body(dark: dark))),
          AnimatedCounter(value: value, style: AppTextStyles.title(dark: dark)),
        ],
      ),
    );
  }
}
