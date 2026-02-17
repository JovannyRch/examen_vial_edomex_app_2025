import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  // Primary palette (Duolingo-inspired) — same in both themes
  static const Color primary = Color(0xFF58CC02);
  static const Color primaryDark = Color(0xFF46A302);
  static const Color secondary = Color(0xFF1CB0F6);
  static const Color secondaryDark = Color(0xFF1899D6);

  // Accent colors — same in both themes
  static const Color orange = Color(0xFFFF9600);
  static const Color orangeDark = Color(0xFFE58600);
  static const Color red = Color(0xFFFF4B4B);
  static const Color redDark = Color(0xFFE53535);
  static const Color purple = Color(0xFFCE82FF);

  // Neutral colors — dynamic based on theme
  // These methods require BuildContext to properly react to theme changes
  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF1B1B2F)
          : const Color(0xFFF7F7F7);

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF262640)
          : const Color(0xFFFFFFFF);

  static Color cardBorder(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3A3A52)
          : const Color(0xFFE5E5E5);

  static Color progressTrack(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF3A3A52)
          : const Color(0xFFE5E5E5);

  static Color textPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFFEAEAEF)
          : const Color(0xFF3C3C3C);

  static Color textSecondary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF9E9EB3)
          : const Color(0xFF777777);

  static Color textLight(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? const Color(0xFF6B6B80)
          : const Color(0xFFAFAFAF);

  static const Color white = Color(0xFFFFFFFF);

  /// Darkens a color by reducing its lightness
  static Color darken(Color color, [double amount = 0.15]) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withLightness((hsl.lightness - amount).clamp(0.0, 1.0))
        .toColor();
  }
}

class AppTheme {
  static ThemeData get lightTheme => _buildTheme(Brightness.light);
  static ThemeData get darkTheme => _buildTheme(Brightness.dark);

  static ThemeData _buildTheme(Brightness brightness) {
    final bool isDark = brightness == Brightness.dark;

    // Define theme-specific colors
    final backgroundColor =
        isDark ? const Color(0xFF1B1B2F) : const Color(0xFFF7F7F7);
    final surfaceColor =
        isDark ? const Color(0xFF262640) : const Color(0xFFFFFFFF);
    final cardBorderColor =
        isDark ? const Color(0xFF3A3A52) : const Color(0xFFE5E5E5);
    final textPrimaryColor =
        isDark ? const Color(0xFFEAEAEF) : const Color(0xFF3C3C3C);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: (isDark
              ? const ColorScheme.dark(
                primary: AppColors.primary,
                secondary: AppColors.secondary,
              )
              : const ColorScheme.light(
                primary: AppColors.primary,
                secondary: AppColors.secondary,
              ))
          .copyWith(surface: surfaceColor),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textPrimaryColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: textPrimaryColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: cardBorderColor, width: 2),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
