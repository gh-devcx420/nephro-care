// blood_pressure_unit.dart

// Import your enum: import 'package:your_app/features/trackers/blood_pressure/bp_enums.dart';

import 'package:intl/intl.dart';
import 'package:nephro_care/features/shared/tracker_utils.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';

/// BloodPressureUnit handles formatting blood pressure measurements
/// Different from others - needs to know which specific field it's formatting
class BloodPressureUnit extends MeasurementUnit {
  final BloodPressureField
      field; // Which BP field (systolic, diastolic, pulse, spo2)

  /// Constructor requires you to specify which field
  BloodPressureUnit(this.field);

  // ===== IMPLEMENT ABSTRACT PROPERTIES =====

  @override
  String? get basicSIUnit => field.unit;

  @override
  NumberFormat? get formatter => field.numberFormat;

  // ===== IMPLEMENT ABSTRACT METHOD =====

  @override
  FormattedMeasurement format(dynamic input) {
    final double? numericValue = MeasurementUnit.parseValue(input);

    if (numericValue == null) {
      return FormattedMeasurement.invalid;
    }

    // Validate the value for this specific field
    if (!_isValidValueForField(numericValue)) {
      return FormattedMeasurement(
        value: 'Invalid',
        basicSIUnit: basicSIUnit,
        isValid: false,
      );
    }

    return createFormattedMeasurement(numericValue, basicSIUnit, formatter);
  }

  // ===== BLOOD PRESSURE-SPECIFIC METHODS =====

  /// Check if value is reasonable for this field
  bool _isValidValueForField(double value) {
    switch (field) {
      case BloodPressureField.systolic:
        return value >= 50 && value <= 300; // 50-300 mmHg

      case BloodPressureField.diastolic:
        return value >= 30 && value <= 200; // 30-200 mmHg

      case BloodPressureField.pulse:
        return value >= 20 && value <= 300; // 20-300 bpm

      case BloodPressureField.spo2:
        return value >= 70 && value <= 100; // 70-100%

      case BloodPressureField.time:
        return true; // Time fields don't have numeric validation
    }
  }

  /// Get field-specific display name
  String get fieldDisplayName => field.displayName;

  /// Format with field-specific validation messages
  FormattedMeasurement formatWithFeedback(dynamic input) {
    final double? numericValue = MeasurementUnit.parseValue(input);

    if (numericValue == null) {
      return const FormattedMeasurement(
        value: 'Enter a number',
        basicSIUnit: null,
        isValid: false,
      );
    }

    if (!_isValidValueForField(numericValue)) {
      final range = _getValidRangeText();
      return FormattedMeasurement(
        value: 'Out of range ($range)',
        basicSIUnit: basicSIUnit,
        isValid: false,
      );
    }

    return createFormattedMeasurement(numericValue, basicSIUnit, formatter);
  }

  /// Get human-readable valid range for this field
  String _getValidRangeText() {
    switch (field) {
      case BloodPressureField.systolic:
        return '50-300 mmHg';
      case BloodPressureField.diastolic:
        return '30-200 mmHg';
      case BloodPressureField.pulse:
        return '20-300 bpm';
      case BloodPressureField.spo2:
        return '70-100%';
      case BloodPressureField.time:
        return 'Any time';
    }
  }

  /// Check if the reading suggests hypertension (high blood pressure)
  bool isHighBloodPressure(double value) {
    switch (field) {
      case BloodPressureField.systolic:
        return value >= 140; // High systolic
      case BloodPressureField.diastolic:
        return value >= 90; // High diastolic
      default:
        return false; // Only applies to BP values
    }
  }

  /// Check if the reading suggests hypotension (low blood pressure)
  bool isLowBloodPressure(double value) {
    switch (field) {
      case BloodPressureField.systolic:
        return value <= 90; // Low systolic
      case BloodPressureField.diastolic:
        return value <= 60; // Low diastolic
      default:
        return false;
    }
  }

  /// Get health status for the reading
  String getHealthStatus(double value) {
    if (!_isValidValueForField(value)) return 'Invalid';

    switch (field) {
      case BloodPressureField.systolic:
        if (value <= 90) return 'Low';
        if (value <= 120) return 'Normal';
        if (value <= 129) return 'Elevated';
        if (value <= 139) return 'Stage 1 High';
        return 'Stage 2 High';

      case BloodPressureField.diastolic:
        if (value <= 60) return 'Low';
        if (value <= 80) return 'Normal';
        if (value <= 89) return 'Stage 1 High';
        return 'Stage 2 High';

      case BloodPressureField.pulse:
        if (value < 60) return 'Low';
        if (value <= 100) return 'Normal';
        return 'High';

      case BloodPressureField.spo2:
        if (value >= 95) return 'Normal';
        if (value >= 90) return 'Low Normal';
        return 'Low';

      case BloodPressureField.time:
        return 'N/A';
    }
  }
}

// ===== FACTORY METHODS FOR EASY CREATION =====

class BloodPressureUnits {
  static BloodPressureUnit systolic() =>
      BloodPressureUnit(BloodPressureField.systolic);

  static BloodPressureUnit diastolic() =>
      BloodPressureUnit(BloodPressureField.diastolic);

  static BloodPressureUnit pulse() =>
      BloodPressureUnit(BloodPressureField.pulse);

  static BloodPressureUnit spo2() => BloodPressureUnit(BloodPressureField.spo2);
}
