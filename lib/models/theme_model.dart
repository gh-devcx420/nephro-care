import 'package:flutter/material.dart';

class ThemeColorScheme {
  final ColorScheme light;
  final ColorScheme dark;

  const ThemeColorScheme({
    required this.light,
    required this.dark,
  });
}

class AppThemeItem {
  final String identifier;
  final ThemeColorScheme colorScheme;
  final String themeIcon;

  const AppThemeItem({
    required this.identifier,
    required this.colorScheme,
    required this.themeIcon,
  });
}
