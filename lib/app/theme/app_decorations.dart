import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppDecorations {
  AppDecorations._();

  static BoxDecoration card({bool dark = false}) => BoxDecoration(
        color: dark ? AppColors.darkSurface : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: dark ? AppColors.darkDivider : AppColors.cardBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: (dark ? Colors.black : AppColors.primaryDeep).withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration goldBorderCard({bool dark = false}) => BoxDecoration(
        color: dark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gold.withValues(alpha: 0.55), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowGold,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static BoxDecoration glass({bool dark = false}) => BoxDecoration(
        color: (dark ? AppColors.darkSurface : AppColors.surface).withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.25),
        ),
      );

  static BoxDecoration primaryButton() => BoxDecoration(
        gradient: AppColors.saffronGlow,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowSaffron,
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      );

  static BoxDecoration circularJapButton() => BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.saffronGlow,
        boxShadow: [
          BoxShadow(
            color: AppColors.glowSaffron,
            blurRadius: 24,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      );

  static BoxDecoration selectedDeity() => BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.gold, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppColors.glowGold,
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      );

  static BoxDecoration progressRingTrack({bool dark = false}) => BoxDecoration(
        shape: BoxShape.circle,
        color: dark ? AppColors.darkSurfaceElevated : AppColors.surfaceElevated,
      );
}
