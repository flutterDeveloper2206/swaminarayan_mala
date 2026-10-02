import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import '../../core/widgets/devotional_background.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final favMantras = state.mantras.where((m) => m.isFavorite).toList();
    final favStories = state.stories.where((s) => s.isFavorite).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: DevotionalBackground(
          dark: dark,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(l10n.myFavorites, style: AppTextStyles.heading(dark: dark)),
                    ],
                  ),
                ),
                TabBar(
                  labelColor: dark ? AppColors.gold : AppColors.primaryDeep,
                  tabs: [
                    Tab(text: l10n.mantras),
                    Tab(text: l10n.stories),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      favMantras.isEmpty
                          ? EmptyState(message: l10n.noFavoritesYet)
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: favMantras.length,
                              itemBuilder: (_, i) {
                                final m = favMantras[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: AppCard(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.jap,
                                      arguments: m.id,
                                    ),
                                    child: Text(m.text, style: AppTextStyles.title(dark: dark)),
                                  ),
                                );
                              },
                            ),
                      favStories.isEmpty
                          ? EmptyState(message: l10n.noFavoritesYet)
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: favStories.length,
                              itemBuilder: (_, i) {
                                final s = favStories[i];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: AppCard(
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      AppRoutes.storiesDetail,
                                      arguments: s.id,
                                    ),
                                    child: Text(
                                      s.title(state.isHindi),
                                      style: AppTextStyles.title(dark: dark),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
