import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../core/constants/asset_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import 'settings_page_scaffold.dart';

class LanguageSettingsScreen extends StatelessWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final selected = state.settings.languageCode;

    final options = [
      (code: 'en', label: l10n.english),
      (code: 'hi', label: l10n.hindi),
      (code: 'gu', label: l10n.gujarati),
    ];

    return SettingsPageScaffold(
      title: l10n.language,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          AppCard(
            child: Column(
              children: [
                for (final opt in options)
                  RadioListTile<String>(
                    value: opt.code,
                    groupValue: selected,
                    onChanged: (v) => state.setLanguage(v!),
                    title: Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            AssetConstants.languageBadge(opt.code),
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 36,
                              height: 36,
                              color: AppColors.primary.withValues(alpha: 0.2),
                              alignment: Alignment.center,
                              child: Text(
                                opt.code.toUpperCase(),
                                style: const TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(opt.label),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
