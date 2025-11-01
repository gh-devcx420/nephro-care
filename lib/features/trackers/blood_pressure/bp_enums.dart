import 'package:intl/intl.dart';

enum BloodPressureField {
  systolic,
  diastolic,
  pulse,
  spo2,
  time,
}

extension BloodPressureFieldExtension on BloodPressureField {
  String get fieldName {
    switch (this) {
      case BloodPressureField.systolic:
        return 'Systolic';
      case BloodPressureField.diastolic:
        return 'Diastolic';
      case BloodPressureField.pulse:
        return 'Pulse';
      case BloodPressureField.spo2:
        return 'Spo2';
      case BloodPressureField.time:
        return 'Time';
    }
  }

  String get hintText {
    switch (this) {
      case BloodPressureField.systolic:
        return 'Systolic';
      case BloodPressureField.diastolic:
        return 'Diastolic';
      case BloodPressureField.pulse:
        return 'Pulse';
      case BloodPressureField.spo2:
        return 'Spo2';
      case BloodPressureField.time:
        return 'Measurement Time';
    }
  }

  String get fieldKey {
    switch (this) {
      case BloodPressureField.systolic:
        return 'systolic_key';
      case BloodPressureField.diastolic:
        return 'diastolic_key';
      case BloodPressureField.pulse:
        return 'pulse_key';
      case BloodPressureField.spo2:
        return 'spo2_key';
      case BloodPressureField.time:
        return 'time_key';
    }
  }

  String get siUnit {
    switch (this) {
      case BloodPressureField.systolic:
        return 'mmHg';
      case BloodPressureField.diastolic:
        return 'mmHg';
      case BloodPressureField.pulse:
        return 'bpm';
      case BloodPressureField.spo2:
        return '%';
      case BloodPressureField.time:
        return '';
    }
  }

  NumberFormat get valueFormat {
    switch (this) {
      case BloodPressureField.systolic:
        return NumberFormat('#');
      case BloodPressureField.diastolic:
        return NumberFormat('#');
      case BloodPressureField.pulse:
        return NumberFormat('#');
      case BloodPressureField.spo2:
        return NumberFormat('#');
      case BloodPressureField.time:
        return NumberFormat('#');
    }
  }
}

enum BPReadingType {
  normal,
  preDialysisResting,
  preDialysisStanding,
  postDialysisResting,
  postDialysisStanding,
}

extension BPReadingTypeExtension on BPReadingType {
  String get displayName {
    switch (this) {
      case BPReadingType.normal:
        return 'Normal Reading';
      case BPReadingType.preDialysisResting:
        return 'Pre-Dialysis (Resting)';
      case BPReadingType.preDialysisStanding:
        return 'Pre-Dialysis (Standing)';
      case BPReadingType.postDialysisResting:
        return 'Post-Dialysis (Resting)';
      case BPReadingType.postDialysisStanding:
        return 'Post-Dialysis (Standing)';
    }
  }

  String get shortName {
    switch (this) {
      case BPReadingType.normal:
        return 'Normal';
      case BPReadingType.preDialysisResting:
        return 'Pre-HD Rest';
      case BPReadingType.preDialysisStanding:
        return 'Pre-HD Stand';
      case BPReadingType.postDialysisResting:
        return 'Post-HD Rest';
      case BPReadingType.postDialysisStanding:
        return 'Post-HD Stand';
    }
  }

  /// Icon to represent this reading type in UI
  String get iconEmoji {
    switch (this) {
      case BPReadingType.normal:
        return '🫀';
      case BPReadingType.preDialysisResting:
        return '🏥⬇️';
      case BPReadingType.preDialysisStanding:
        return '🏥🧍';
      case BPReadingType.postDialysisResting:
        return '🏥⬆️';
      case BPReadingType.postDialysisStanding:
        return '🏥🧍⬆️';
    }
  }

  /// Check if this is a dialysis-related reading
  bool get isFromDialysis {
    return this != BPReadingType.normal;
  }

  /// Check if this is a pre-dialysis reading
  bool get isPreDialysis {
    return this == BPReadingType.preDialysisResting ||
        this == BPReadingType.preDialysisStanding;
  }

  /// Check if this is a post-dialysis reading
  bool get isPostDialysis {
    return this == BPReadingType.postDialysisResting ||
        this == BPReadingType.postDialysisStanding;
  }

  /// Check if this is a resting reading
  bool get isResting {
    return this == BPReadingType.normal ||
        this == BPReadingType.preDialysisResting ||
        this == BPReadingType.postDialysisResting;
  }

  /// Check if this is a standing reading
  bool get isStanding {
    return this == BPReadingType.preDialysisStanding ||
        this == BPReadingType.postDialysisStanding;
  }
}
