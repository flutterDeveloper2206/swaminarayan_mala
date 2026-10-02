import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/routes.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/app_widgets.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/story_hero_image.dart';

class StoriesScreen extends StatelessWidget {
  const StoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    final stories = state.stories;

    return DevotionalBackground(
      dark: dark,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Text(l10n.stories, style: AppTextStyles.heading(dark: dark)),
            ),
            Expanded(
              child: stories.isEmpty
                  ? EmptyState(message: l10n.noStoriesYet)
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: stories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (_, i) {
                        final s = stories[i];
                        return AppCard(
                          padding: const EdgeInsets.all(12),
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.storiesDetail,
                            arguments: s.id,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: SizedBox(
                                  width: 88,
                                  height: 88,
                                  child: StoryHeroImage(
                                    story: s,
                                    height: 88,
                                    borderRadius: 0,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      s.title(state.isHindi),
                                      style: AppTextStyles.title(dark: dark),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      s.description(state.isHindi),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.caption(dark: dark),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      s.category,
                                      style: AppTextStyles.caption(color: AppColors.primary),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right, color: AppColors.gold),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
