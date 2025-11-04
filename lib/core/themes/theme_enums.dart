import 'package:flutter/material.dart';

enum ThemeName {
  warmTeal,
  limeGreen,
  brightYellow,
  activePink,
  royalViolet,
  cozyBrown,
}

extension ThemeNameExtension on ThemeName {
  String get displayName {
    switch (this) {
      case ThemeName.warmTeal:
        return 'Warm Teal';
      case ThemeName.limeGreen:
        return 'Lime Green';
      case ThemeName.brightYellow:
        return 'Yellow';
      case ThemeName.activePink:
        return 'Pink';
      case ThemeName.royalViolet:
        return 'Violet';
      case ThemeName.cozyBrown:
        return 'Brown';
    }
  }

  String get description {
    switch (this) {
      case ThemeName.warmTeal:
        return 'Modern, calm, and inviting.';
      case ThemeName.limeGreen:
        return 'Fresh, vibrant, and energizing.';
      case ThemeName.brightYellow:
        return 'Bright, cheerful, and optimistic.';
      case ThemeName.activePink:
        return 'Playful, warm, and approachable.';
      case ThemeName.royalViolet:
        return 'Peaceful, mindful, and supportive.';
      case ThemeName.cozyBrown:
        return 'Earthy, stable, and grounded.';
    }
  }

  //Todo: Move these icons to nc_app_icons.dart
  IconData get iconData {
    switch (this) {
      case ThemeName.warmTeal:
        return Icons.spa;
      case ThemeName.limeGreen:
        return Icons.local_florist;
      case ThemeName.brightYellow:
        return Icons.wb_sunny;
      case ThemeName.activePink:
        return Icons.favorite;
      case ThemeName.royalViolet:
        return Icons.self_improvement;
      case ThemeName.cozyBrown:
        return Icons.terrain;
    }
  }

  String get useCase {
    switch (this) {
      case ThemeName.warmTeal:
        return 'Modern wellness apps, spa-like experience';
      case ThemeName.limeGreen:
        return 'Youthful energy, fitness apps';
      case ThemeName.brightYellow:
        return 'Motivational tools, positive interfaces';
      case ThemeName.activePink:
        return 'Social apps, community engagement';
      case ThemeName.royalViolet:
        return 'Stress reduction, mental health focus';
      case ThemeName.cozyBrown:
        return 'Natural themes, eco-friendly apps';
    }
  }
}
