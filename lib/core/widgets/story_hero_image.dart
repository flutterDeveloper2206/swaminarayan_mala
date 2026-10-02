import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../data/models/story_model.dart';

/// Story illustration from bundled assets, with devotional fallback.
class StoryHeroImage extends StatelessWidget {
  const StoryHeroImage({
    super.key,
    required this.story,
    this.height = 160,
    this.borderRadius = 20,
  });

  final StoryModel story;
  final double height;
  final double borderRadius;

  String get _assetPath {
    if (story.thumbnail.isNotEmpty) return story.thumbnail;
    return 'assets/stories/${story.id}.png';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Image.asset(
          _assetPath,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _FallbackHero(category: story.category),
        ),
      ),
    );
  }
}

class _FallbackHero extends StatelessWidget {
  const _FallbackHero({required this.category});

  final String category;

  LinearGradient get _gradient {
    switch (category) {
      case 'swaminarayan':
        return const LinearGradient(
          colors: [Color(0xFF8B2E1F), Color(0xFFD8A84E)],
        );
      case 'gunatit':
        return const LinearGradient(
          colors: [Color(0xFF5A2417), Color(0xFFC96A24)],
        );
      case 'seva':
        return const LinearGradient(
          colors: [Color(0xFF5C7A4A), Color(0xFFD8A84E)],
        );
      case 'sadhana':
        return const LinearGradient(
          colors: [Color(0xFFC96A24), Color(0xFFF5E6C8)],
        );
      default:
        return AppColors.saffronGlow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: _gradient),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('॥', style: TextStyle(fontSize: 40, color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              category,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
