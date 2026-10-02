import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Kids Jap theme — Swaminarayan kid-safe visuals only.
class KidsJapThemeConfig {
  const KidsJapThemeConfig({
    required this.mantraId,
    required this.fallingObjects,
    required this.characterEmoji,
    required this.primaryColor,
    required this.secondaryColor,
    required this.skyColors,
    required this.groundColors,
    required this.decorEmojis,
  });

  final String mantraId;
  final List<String> fallingObjects;
  final String characterEmoji;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Color> skyColors;
  final List<Color> groundColors;
  final List<String> decorEmojis;

  static KidsJapThemeConfig forMantra(String mantraId, {String? deityId}) {
    // Single Swaminarayan kids theme (optional soft variants by focus).
    final key = deityId ?? 'swaminarayan';
    switch (key) {
      case 'gunatitanand':
      case 'yogiji':
        return KidsJapThemeConfig(
          mantraId: mantraId,
          fallingObjects: const ['🪷', '🌸', '⭐', '🪔', 'जय', 'ૐ', '🦚'],
          characterEmoji: '🪷',
          primaryColor: const Color(0xFF2E7D4F),
          secondaryColor: AppColors.gold,
          skyColors: const [Color(0xFFFCE4E6), Color(0xFFE8F5E9)],
          groundColors: const [Color(0xFFA5D6A7), Color(0xFF66BB6A)],
          decorEmojis: const ['🛕', '🪷', '☁️', '🦚'],
        );
      case 'pramukh_swami':
      case 'mahant_swami':
        return KidsJapThemeConfig(
          mantraId: mantraId,
          fallingObjects: const ['🪷', '🪔', '⭐', '॥', 'जय', '🌸', '🦚'],
          characterEmoji: '🪔',
          primaryColor: AppColors.maroon,
          secondaryColor: AppColors.gold,
          skyColors: const [Color(0xFFFCE4E6), Color(0xFFFFF5F6)],
          groundColors: const [Color(0xFFBCAAA4), Color(0xFF8D6E63)],
          decorEmojis: const ['🛕', '🪔', '☁️', '🪷'],
        );
      default:
        return KidsJapThemeConfig(
          mantraId: mantraId,
          fallingObjects: const ['🪷', '🪔', '⭐', '🦚', 'जय', '॥', '🌸'],
          characterEmoji: '॥',
          primaryColor: AppColors.primary,
          secondaryColor: AppColors.chandloRed,
          skyColors: const [Color(0xFFFFF0F1), Color(0xFFFCE4E6)],
          groundColors: const [Color(0xFFE57373), Color(0xFFD2042D)],
          decorEmojis: const ['🛕', '🪷', '☁️', '🪔'],
        );
    }
  }
}
