import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../core/constants/mantra_constants.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/jap_widgets.dart';
import 'settings_page_scaffold.dart';

class DeitySettingsScreen extends StatelessWidget {
  const DeitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final selected = state.settings.selectedDeityId;
    final lang = state.settings.languageCode;

    return SettingsPageScaffold(
      title: l10n.selectDeity,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 12,
          childAspectRatio: 0.78,
        ),
        itemCount: MantraConstants.deities.length,
        itemBuilder: (_, i) {
          final d = MantraConstants.deities[i];
          final isSelected = selected == d.id;
          return GestureDetector(
            onTap: () => state.selectDeity(d.id),
            child: Column(
              children: [
                DeityImage(deityId: d.id, size: 72, selected: isSelected),
                const SizedBox(height: 8),
                Text(
                  d.nameFor(lang),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
