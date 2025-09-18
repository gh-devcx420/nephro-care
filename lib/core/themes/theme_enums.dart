enum ThemeName {
  medicalBlue,
  classicGreen,
  warmTeal,
  gentleViolet,
  energeticOrange,
}

extension ThemeNameExtension on ThemeName {
  String get displayName {
    switch (this) {
      case ThemeName.medicalBlue:
        return 'Medical Blue';
      case ThemeName.classicGreen:
        return 'Classic Green';
      case ThemeName.warmTeal:
        return 'Warm Teal';
      case ThemeName.gentleViolet:
        return 'Gentle Violet';
      case ThemeName.energeticOrange:
        return 'Energetic Orange';
    }
  }

  String get description {
    switch (this) {
      case ThemeName.medicalBlue:
        return 'Professional blue theme for clinical environments and trust';
      case ThemeName.classicGreen:
        return 'Traditional medical green for familiarity and calm';
      case ThemeName.warmTeal:
        return 'Modern teal for sophisticated, contemporary feel';
      case ThemeName.gentleViolet:
        return 'Calming violet to reduce stress and promote wellness';
      case ThemeName.energeticOrange:
        return 'Motivating orange for energy and positive health habits';
    }
  }

  String get iconIdentifier {
    switch (this) {
      case ThemeName.medicalBlue:
        return 'medical_services'; // Medical cross icon
      case ThemeName.classicGreen:
        return 'eco'; // Leaf icon for natural feel
      case ThemeName.warmTeal:
        return 'spa'; // Spa icon for wellness
      case ThemeName.gentleViolet:
        return 'self_care'; // Self-care icon
      case ThemeName.energeticOrange:
        return 'energy_savings_leaf'; // Energy icon
    }
  }

  bool get isProfessional {
    switch (this) {
      case ThemeName.medicalBlue:
      case ThemeName.classicGreen:
        return true; // Healthcare professional environments
      case ThemeName.warmTeal:
      case ThemeName.gentleViolet:
      case ThemeName.energeticOrange:
        return false; // Personal/patient use
    }
  }

  String get useCase {
    switch (this) {
      case ThemeName.medicalBlue:
        return 'Healthcare professionals, clinical settings';
      case ThemeName.classicGreen:
        return 'Traditional medical environments, familiarity';
      case ThemeName.warmTeal:
        return 'Modern wellness apps, spa-like experience';
      case ThemeName.gentleViolet:
        return 'Stress reduction, mental health focus';
      case ThemeName.energeticOrange:
        return 'Motivation, fitness tracking, goal achievement';
    }
  }
}
