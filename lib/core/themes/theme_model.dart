import 'package:flutter/material.dart';
import 'package:nephro_care/core/themes/theme_enums.dart';

class ThemeColorScheme {
  final ColorScheme light;
  final ColorScheme dark;

  const ThemeColorScheme({
    required this.light,
    required this.dark,
  });
}

class AppThemeItem {
  final String displayName;
  final ThemeColorScheme colorScheme;
  final IconData themeIcon;

  const AppThemeItem({
    required this.displayName,
    required this.colorScheme,
    required this.themeIcon,
  });
}

class ThemeInfo {
  final ThemeName name;
  final String displayName;
  final String description;
  final IconData icon;
  final String useCase;

  const ThemeInfo({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.useCase,
  });
}

class ThemePreview {
  final ThemeName name;
  final String displayName;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color primaryContainerColor;

  const ThemePreview({
    required this.name,
    required this.displayName,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.primaryContainerColor,
  });
}
