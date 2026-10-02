import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Platform fonts support Devanagari on Android/iOS.

  static TextStyle display({Color? color, bool dark = false}) => TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        height: 1.2,
        letterSpacing: 0.5,
        color: color ?? (dark ? AppColors.darkTextPrimary : AppColors.textPrimary),
      );

  static TextStyle heading({Color? color, bool dark = false}) => TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.3,
        color: color ?? (dark ? AppColors.darkTextPrimary : AppColors.textPrimary),
      );

  static TextStyle title({Color? color, bool dark = false}) => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: color ?? (dark ? AppColors.darkTextPrimary : AppColors.textPrimary),
      );

  static TextStyle body({Color? color, bool dark = false}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: color ?? (dark ? AppColors.darkTextSecondary : AppColors.textSecondary),
      );

  static TextStyle caption({Color? color, bool dark = false}) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: color ?? (dark ? AppColors.darkTextMuted : AppColors.textMuted),
      );

  static TextStyle counter({Color? color, bool dark = false}) => TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 1.1,
        letterSpacing: 1.5,
        fontFeatures: const [FontFeature.tabularFigures()],
        color: color ?? (dark ? AppColors.goldSoft : AppColors.primaryDeep),
      );

  static TextStyle mantra({Color? color, bool dark = false}) => TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.4,
        letterSpacing: 1.2,
        color: color ?? (dark ? AppColors.gold : AppColors.primaryDeep),
      );

  static TextStyle slogan({Color? color, bool dark = false}) => TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        fontStyle: FontStyle.italic,
        color: color ?? (dark ? AppColors.goldSoft : AppColors.primary),
      );

  static TextStyle button({Color? color}) => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: 0.3,
        color: color ?? Colors.white,
      );
}
