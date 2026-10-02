import 'package:flutter/material.dart';
import 'package:swaminarayan_mala/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/providers/app_state.dart';
import '../../core/widgets/devotional_background.dart';
import '../../core/widgets/story_hero_image.dart';
import '../../data/models/story_model.dart';

class StoryDetailScreen extends StatelessWidget {
  const StoryDetailScreen({super.key, required this.storyId});

  final String storyId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AppState>();
    final dark = Theme.of(context).brightness == Brightness.dark;
    StoryModel? found;
    for (final s in state.stories) {
      if (s.id == storyId) {
        found = s;
        break;
      }
    }

    if (found == null) {
      return Scaffold(body: Center(child: Text(l10n.errorGeneric)));
    }
    final story = found;

    return Scaffold(
      body: DevotionalBackground(
        dark: dark,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                        story.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: AppColors.templeRed,
                      ),
                      onPressed: () => state.toggleStoryFavorite(story.id),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StoryHeroImage(story: story, height: 220),
                      const SizedBox(height: 20),
                      Text(
                        story.title(state.isHindi),
                        style: AppTextStyles.heading(dark: dark),
                      ),
                      const SizedBox(height: 8),
                      Text(story.category, style: AppTextStyles.caption(color: AppColors.gold)),
                      const SizedBox(height: 20),
                      Text(
                        story.content(state.isHindi),
                        style: AppTextStyles.body(dark: dark).copyWith(height: 1.7, fontSize: 17),
                      ),
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
