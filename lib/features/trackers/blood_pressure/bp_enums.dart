// bp_enums.dart

import 'package:intl/intl.dart';
import 'package:nephro_care/features/shared/tracker_utils.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_utils.dart';

enum BloodPressureField {
  systolic, // Systolic blood pressure
  diastolic, // Diastolic blood pressure
  pulse, // Pulse rate
  spo2, // Oxygen saturation
  time, // Time of measurement
}

extension BloodPressureFieldExtension on BloodPressureField {
  String? get unit {
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
        return null; // Time has no unit
    }
  }

  NumberFormat? get numberFormat {
    switch (this) {
      case BloodPressureField.systolic:
        return NumberFormat('#'); // Show as: 120 mmHg
      case BloodPressureField.diastolic:
        return NumberFormat('#'); // Show as: 80 mmHg
      case BloodPressureField.pulse:
        return NumberFormat('#'); // Show as: 72 bpm
      case BloodPressureField.spo2:
        return NumberFormat('#.#'); // Show as: 98.5%
      case BloodPressureField.time:
        return null; // Time is not a number field
    }
  }

  String get displayName {
    switch (this) {
      case BloodPressureField.systolic:
        return 'Systolic (mmHg)';
      case BloodPressureField.diastolic:
        return 'Diastolic (mmHg)';
      case BloodPressureField.pulse:
        return 'Pulse (bpm)';
      case BloodPressureField.spo2:
        return 'SpO2 (%)';
      case BloodPressureField.time:
        return 'Time';
    }
  }

  bool get isQuantity {
    return this == BloodPressureField.systolic ||
        this == BloodPressureField.diastolic ||
        this == BloodPressureField.pulse ||
        this == BloodPressureField.spo2;
  }

  FormattedMeasurement format(dynamic input) {
    // Create the appropriate BloodPressureUnit for this field
    final bloodPressureUnit = BloodPressureUnit(this);

    // Use the BloodPressureUnit to format the input
    return bloodPressureUnit.format(input);
  }

  /// Format with validation feedback - useful for user input
  /// This allows you to call: BloodPressureField.pulse.formatWithFeedback(userInput)
  FormattedMeasurement formatWithFeedback(dynamic input) {
    // Create the appropriate BloodPressureUnit for this field
    final bloodPressureUnit = BloodPressureUnit(this);

    // Use the BloodPressureUnit to format with feedback
    return bloodPressureUnit.formatWithFeedback(input);
  }

  /// Get health status for a value
  /// This allows you to call: BloodPressureField.systolic.getHealthStatus(120)
  String getHealthStatus(double value) {
    final bloodPressureUnit = BloodPressureUnit(this);
    return bloodPressureUnit.getHealthStatus(value);
  }

  /// Check if value indicates high blood pressure
  /// This allows you to call: BloodPressureField.systolic.isHighBloodPressure(140)
  bool isHighBloodPressure(double value) {
    final bloodPressureUnit = BloodPressureUnit(this);
    return bloodPressureUnit.isHighBloodPressure(value);
  }

  /// Check if value indicates low blood pressure
  /// This allows you to call: BloodPressureField.systolic.isLowBloodPressure(90)
  bool isLowBloodPressure(double value) {
    final bloodPressureUnit = BloodPressureUnit(this);
    return bloodPressureUnit.isLowBloodPressure(value);
  }
}
