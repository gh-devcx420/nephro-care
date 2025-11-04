import 'package:flutter/material.dart';
import 'package:nephro_care/core/themes/theme_color_generator.dart';
import 'package:nephro_care/core/themes/theme_enums.dart';
import 'package:nephro_care/core/themes/theme_model.dart';
import 'package:nephro_care/core/themes/theme_seed_colors.dart';

abstract class AppColorScheme {
  /// Returns a [ThemeColorScheme] for the given [themeName].
  static ThemeColorScheme getThemeColors(ThemeName themeName) {
    final seedColor = _getSeedColor(themeName);

    return ThemeColorScheme(
      light: ColorGenerator.generateColorScheme(
        seedColor: seedColor,
        brightness: Brightness.light,
      ),
      dark: ColorGenerator.generateColorScheme(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
    );
  }

  /// Returns the seed color for the given [themeName].
  static Color _getSeedColor(ThemeName themeName) {
    switch (themeName) {
      case ThemeName.warmTeal:
        return SeedColors.warmTeal;
      case ThemeName.limeGreen:
        return SeedColors.limeGreen;
      case ThemeName.brightYellow:
        return SeedColors.brightYellow;
      case ThemeName.activePink:
        return SeedColors.activePink;
      case ThemeName.royalViolet:
        return SeedColors.royalViolet;
      case ThemeName.cozyBrown:
        return SeedColors.cozyBrown;
    }
  }

  /// Returns a [ThemeColorScheme] for warmTeal seed color.
  static ThemeColorScheme get warmTeal => getThemeColors(ThemeName.warmTeal);

  /// Returns a [ThemeColorScheme] for limeGreen seed color.
  static ThemeColorScheme get limeGreen => getThemeColors(ThemeName.limeGreen);

  /// Returns a [ThemeColorScheme] for brightYellow seed color.
  static ThemeColorScheme get brightYellow =>
      getThemeColors(ThemeName.brightYellow);

  /// Returns a [ThemeColorScheme] for activePink seed color.
  static ThemeColorScheme get activePink =>
      getThemeColors(ThemeName.activePink);

  /// Returns a [ThemeColorScheme] for royalViolet seed color.
  static ThemeColorScheme get royalViolet =>
      getThemeColors(ThemeName.royalViolet);

  /// Returns a [ThemeColorScheme] for cozyBrown seed color.
  static ThemeColorScheme get cozyBrown => getThemeColors(ThemeName.cozyBrown);
}

/// Abstract class for app colors.
abstract class AppColors {
  static const Color successColor =
      Color(0xFF2E7D32); // Medical green for success
  static const Color warningColor = Color(0xFFFF8F00); // Amber for caution
  static const Color dangerColor = Color(0xFFDB4437); // Red for danger/critical
  static const Color infoColor = Color(0xFF1976D2); // Blue for information
  static const Color neutralColor = Color(0xFF616161); // Gray for neutral
}
