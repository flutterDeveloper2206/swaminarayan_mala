import 'package:flutter/material.dart';

/// SwamiNaam — cherry-red temple palette (tilak + kumkum chandlo).
class AppColors {
  AppColors._();

  // Brand — cherry red (no orange)
  static const Color saffron = Color(0xFFD2042D); // kept name; cherry primary
  static const Color saffronDeep = Color(0xFF9B0A1E);
  static const Color saffronSoft = Color(0xFFE57373);
  static const Color primary = Color(0xFFD2042D);
  static const Color primaryDeep = Color(0xFF7A0616);
  static const Color gold = Color(0xFFC9A227);
  static const Color goldSoft = Color(0xFFE8D48B);
  static const Color maroon = Color(0xFF6B0F1A);
  static const Color templeRed = Color(0xFFB71C1C);
  static const Color spiritualGreen = Color(0xFF2E7D32);
  static const Color chandloRed = Color(0xFFE30613);
  /// Tilak U arms — yellow (chandlo stays red).
  static const Color tilakYellow = Color(0xFFFFD600);
  static const Color tilakOrange = tilakYellow; // alias used by painters
  static const Color tilakCream = Color(0xFFFFF5F6);

  // Light surfaces — soft rose cream (no amber/orange tint)
  static const Color background = Color(0xFFFFF8F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFFF0F1);
  static const Color cardBorder = Color(0xFFF5C6CB);
  static const Color textPrimary = Color(0xFF3A1A1E);
  static const Color textSecondary = Color(0xFF6D3A42);
  static const Color textMuted = Color(0xFFA07880);
  static const Color divider = Color(0xFFF5C6CB);

  // Dark / night
  static const Color darkBackground = Color(0xFF14080A);
  static const Color darkSurface = Color(0xFF1F0E12);
  static const Color darkSurfaceElevated = Color(0xFF2A1418);
  static const Color darkTextPrimary = Color(0xFFFFF0F1);
  static const Color darkTextSecondary = Color(0xFFF5A3AD);
  static const Color darkTextMuted = Color(0xFFBCAAA4);
  static const Color darkDivider = Color(0xFF4A2A30);

  // Semantic
  static const Color success = Color(0xFF43A047);
  static const Color warning = Color(0xFFD2042D);
  static const Color error = Color(0xFFB71C1C);
  static const Color streak = Color(0xFFC41E3A);

  // Glow / ambient
  static const Color glowGold = Color(0x55C9A227);
  static const Color glowSaffron = Color(0x55FFD600);
  static const Color glowChandlo = Color(0x44E30613);
  static const Color diyaFlame = Color(0xFFE53935);
  static const Color lotusPink = Color(0xFFEF9A9A);

  /// Tilak-brand gradient: yellow → cherry red
  static const LinearGradient tilakGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFEB3B),
      Color(0xFFFFD600),
      Color(0xFFE30613),
    ],
  );

  static const LinearGradient templeGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF5F6),
      Color(0xFFFFF8F8),
      Color(0xFFFCE4E6),
    ],
  );

  static const LinearGradient templeGradientDark = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF2A1014),
      Color(0xFF14080A),
      Color(0xFF0A0406),
    ],
  );

  static const LinearGradient saffronGlow = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE57373),
      Color(0xFFD2042D),
      Color(0xFF9B0A1E),
    ],
  );

  static const LinearGradient goldShimmer = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF5E6A8),
      Color(0xFFC9A227),
      Color(0xFFD2042D),
    ],
  );

  static const LinearGradient chandloGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF5252),
      Color(0xFFE30613),
      Color(0xFFB71C1C),
    ],
  );
}
