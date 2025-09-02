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

class TrackersColorScheme {
  final Color primary;
  final Color onPrimary;
  final Color secondary;
  final Color onSecondary;
  final Color tertiary;
  final Color background;

  const TrackersColorScheme({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.tertiary,
    required this.background,
  });
}
