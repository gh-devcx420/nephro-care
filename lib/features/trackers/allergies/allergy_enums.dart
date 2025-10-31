enum AllergySeverity {
  mild,
  moderate,
  severe,
  anaphylaxis,
}

extension AllergySeverityExtension on AllergySeverity {
  String get displayName {
    switch (this) {
      case AllergySeverity.mild:
        return 'Mild';
      case AllergySeverity.moderate:
        return 'Moderate';
      case AllergySeverity.severe:
        return 'Severe';
      case AllergySeverity.anaphylaxis:
        return 'Anaphylaxis';
    }
  }

  int get severity {
    switch (this) {
      case AllergySeverity.mild:
        return 1;
      case AllergySeverity.moderate:
        return 2;
      case AllergySeverity.severe:
        return 3;
      case AllergySeverity.anaphylaxis:
        return 4;
    }
  }
}
