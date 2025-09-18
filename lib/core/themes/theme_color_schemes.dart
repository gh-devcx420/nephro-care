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
      case ThemeName.medicalBlue:
        return SeedColors.medicalBlue;
      case ThemeName.classicGreen:
        return SeedColors.classicGreen;
      case ThemeName.warmTeal:
        return SeedColors.warmTeal;
      case ThemeName.gentleViolet:
        return SeedColors.gentleViolet;
      case ThemeName.energeticOrange:
        return SeedColors.energeticOrange;
    }
  }

  static ThemeColorScheme get medicalBlue =>
      getThemeColors(ThemeName.medicalBlue);

  static ThemeColorScheme get classicGreen =>
      getThemeColors(ThemeName.classicGreen);

  static ThemeColorScheme get warmTeal => getThemeColors(ThemeName.warmTeal);

  static ThemeColorScheme get gentleViolet =>
      getThemeColors(ThemeName.gentleViolet);

  static ThemeColorScheme get energeticOrange =>
      getThemeColors(ThemeName.energeticOrange);
}

abstract class AppColors {
  static const Color successColor =
      Color(0xFF2E7D32); // Medical green for success
  static const Color warningColor = Color(0xFFFF8F00); // Amber for caution
  static const Color dangerColor = Color(0xFFD32F2F); // Red for danger/critical
  static const Color infoColor = Color(0xFF1976D2); // Blue for information
  static const Color neutralColor = Color(0xFF616161); // Gray for neutral
}
