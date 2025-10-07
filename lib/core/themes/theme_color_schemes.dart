import 'package:flutter/material.dart';
import 'package:nephro_care/core/themes/theme_color_generator.dart';
import 'package:nephro_care/core/themes/theme_enums.dart';
import 'package:nephro_care/core/themes/theme_model.dart';
import 'package:nephro_care/core/themes/theme_seed_colors.dart';

abstract class AppColorScheme {
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

  static Color _getSeedColor(ThemeName themeName) {
    switch (themeName) {
      case ThemeName.warmTeal:
        return SeedColors.warmTeal;
      case ThemeName.limeGreen:
        return SeedColors.limeGreen;
      case ThemeName.yellow:
        return SeedColors.yellow;
      case ThemeName.pink:
        return SeedColors.pink;
      case ThemeName.violet:
        return SeedColors.violet;
      case ThemeName.brown:
        return SeedColors.brown;
    }
  }

  static ThemeColorScheme get warmTeal => getThemeColors(ThemeName.warmTeal);

  static ThemeColorScheme get limeGreen => getThemeColors(ThemeName.limeGreen);

  static ThemeColorScheme get yellow => getThemeColors(ThemeName.yellow);

  static ThemeColorScheme get pink => getThemeColors(ThemeName.pink);

  static ThemeColorScheme get violet => getThemeColors(ThemeName.violet);

  static ThemeColorScheme get brown => getThemeColors(ThemeName.brown);
}

abstract class AppColors {
  static const Color successColor =
      Color(0xFF2E7D32); // Medical green for success
  static const Color warningColor = Color(0xFFFF8F00); // Amber for caution
  static const Color dangerColor = Color(0xFFDB4437); // Red for danger/critical
  static const Color infoColor = Color(0xFF1976D2); // Blue for information
  static const Color neutralColor = Color(0xFF616161); // Gray for neutral
}
