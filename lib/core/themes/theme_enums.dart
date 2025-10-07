import 'package:flutter/material.dart';

enum ThemeName {
  warmTeal,
  limeGreen,
  yellow,
  pink,
  violet,
  brown,
}

extension ThemeNameExtension on ThemeName {
  String get displayName {
    switch (this) {
      case ThemeName.warmTeal:
        return 'Warm Teal';
      case ThemeName.limeGreen:
        return 'Lime Green';
      case ThemeName.yellow:
        return 'Yellow';
      case ThemeName.pink:
        return 'Pink';
      case ThemeName.violet:
        return 'Violet';
      case ThemeName.brown:
        return 'Brown';
    }
  }

  String get description {
    switch (this) {
      case ThemeName.warmTeal:
        return 'Modern, calm, and inviting.';
      case ThemeName.limeGreen:
        return 'Fresh, vibrant, and energizing.';
      case ThemeName.yellow:
        return 'Bright, cheerful, and optimistic.';
      case ThemeName.pink:
        return 'Playful, warm, and approachable.';
      case ThemeName.violet:
        return 'Peaceful, mindful, and supportive.';
      case ThemeName.brown:
        return 'Earthy, stable, and grounded.';
    }
  }

  IconData get iconData {
    switch (this) {
      case ThemeName.warmTeal:
        return Icons.spa;
      case ThemeName.limeGreen:
        return Icons.local_florist;
      case ThemeName.yellow:
        return Icons.wb_sunny;
      case ThemeName.pink:
        return Icons.favorite;
      case ThemeName.violet:
        return Icons.self_improvement;
      case ThemeName.brown:
        return Icons.terrain;
    }
  }

  String get useCase {
    switch (this) {
      case ThemeName.warmTeal:
        return 'Modern wellness apps, spa-like experience';
      case ThemeName.limeGreen:
        return 'Youthful energy, fitness apps';
      case ThemeName.yellow:
        return 'Motivational tools, positive interfaces';
      case ThemeName.pink:
        return 'Social apps, community engagement';
      case ThemeName.violet:
        return 'Stress reduction, mental health focus';
      case ThemeName.brown:
        return 'Natural themes, eco-friendly apps';
    }
  }
}
