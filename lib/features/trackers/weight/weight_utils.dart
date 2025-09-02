// weight_unit.dart

// Import your enum: import 'package:your_app/features/trackers/weight/weight_enums.dart';

import 'package:intl/intl.dart';
import 'package:nephro_care/features/shared/tracker_utils.dart';
import 'package:nephro_care/features/trackers/weight/weight_enums.dart';

/// WeightUnit handles formatting weight measurements
/// Simple - only deals with kg (no unit conversion needed yet)
class WeightUnit extends MeasurementUnit {
  // ===== IMPLEMENT ABSTRACT PROPERTIES =====

  @override
  String? get basicSIUnit => WeightField.weightValue.unit; // "kg"

  @override
  NumberFormat? get formatter =>
      WeightField.weightValue.numberFormat; // NumberFormat('#.#')

  // ===== IMPLEMENT ABSTRACT METHOD =====

  @override
  FormattedMeasurement format(dynamic input) {
    final double? numericValue = MeasurementUnit.parseValue(input);

    if (numericValue == null || numericValue < 0) {
      return FormattedMeasurement.invalid;
    }

    // Weight is simple - always show in kg
    return formatAsKilograms(numericValue);
  }

  // ===== WEIGHT-SPECIFIC METHODS =====

  /// Format as kilograms: 70.567 -> "70.6 kg"
  FormattedMeasurement formatAsKilograms(double kgValue) {
    return createFormattedMeasurement(
        kgValue,
        WeightField.weightValue.unit, // "kg"
        WeightField.weightValue.numberFormat // NumberFormat('#.#')
        );
  }

  // ===== FUTURE CONVERSION HELPERS =====
  // These are ready for when you add pounds/grams to your enum

  /// Convert kilograms to pounds: 70kg -> 154.3 lbs
  double convertKgToPounds(double kg) => kg * 2.20462;

  /// Convert pounds to kilograms: 154.3 lbs -> 70kg
  double convertPoundsToKg(double pounds) => pounds / 2.20462;

  /// Convert kilograms to grams: 70kg -> 70000g
  double convertKgToGrams(double kg) => kg * 1000;

  /// Convert grams to kilograms: 70000g -> 70kg
  double convertGramsToKg(double grams) => grams / 1000;

  /// Format weight in different units (ready for future use)
  FormattedMeasurement formatAsUnit(double kgValue, String targetUnit) {
    switch (targetUnit.toLowerCase()) {
      case 'kg':
      case 'kilograms':
        return formatAsKilograms(kgValue);

      case 'lbs':
      case 'pounds':
        final pounds = convertKgToPounds(kgValue);
        // For now, using kg formatter - update when you add pounds to enum
        return FormattedMeasurement(
          value: NumberFormat('#.#').format(pounds),
          basicSIUnit: 'lbs',
          isValid: true,
        );

      case 'g':
      case 'grams':
        final grams = convertKgToGrams(kgValue);
        return FormattedMeasurement(
          value: NumberFormat('#').format(grams),
          basicSIUnit: 'g',
          isValid: true,
        );

      default:
        return formatAsKilograms(kgValue); // Default to kg
    }
  }

  /// Validate weight range (basic health checks)
  bool isValidWeight(double kgValue) {
    // Basic sanity checks - adjust as needed
    return kgValue > 0 && kgValue <= 1000; // 0kg to 1000kg seems reasonable
  }

  /// Format with validation
  FormattedMeasurement formatWithValidation(dynamic input) {
    final double? numericValue = MeasurementUnit.parseValue(input);

    if (numericValue == null) {
      return FormattedMeasurement.invalid;
    }

    if (!isValidWeight(numericValue)) {
      return FormattedMeasurement(
        value: 'Invalid',
        basicSIUnit: basicSIUnit,
        isValid: false,
      );
    }

    return formatAsKilograms(numericValue);
  }
}
