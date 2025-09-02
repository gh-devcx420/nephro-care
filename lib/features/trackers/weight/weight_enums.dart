// weight_enums.dart

import 'package:intl/intl.dart';
import 'package:nephro_care/features/shared/tracker_utils.dart';
import 'package:nephro_care/features/trackers/weight/weight_utils.dart';

enum WeightField {
  weightValue, // Weight value in kilograms
  measurementDate, // Date of measurement
  time, // Time of measurement
  notes, // Optional notes
}

extension WeightFieldExtension on WeightField {
  String? get unit {
    switch (this) {
      case WeightField.weightValue:
        return 'kg';
      case WeightField.measurementDate:
        return null; // Date has no unit
      case WeightField.time:
        return null; // Time has no unit
      case WeightField.notes:
        return null; // Notes have no unit
    }
  }

  NumberFormat? get numberFormat {
    switch (this) {
      case WeightField.weightValue:
        return NumberFormat('#.#'); // Show as: 70.5 kg
      case WeightField.measurementDate:
        return null; // Date is not a number field
      case WeightField.time:
        return null; // Time is not a number field
      case WeightField.notes:
        return null; // Notes are not a number field
    }
  }

  String get displayName {
    switch (this) {
      case WeightField.weightValue:
        return 'Weight (kg)';
      case WeightField.measurementDate:
        return 'Measurement Date';
      case WeightField.time:
        return 'Time';
      case WeightField.notes:
        return 'Notes';
    }
  }

  bool get isQuantity {
    return this == WeightField.weightValue;
  }

  /// Format a value using WeightUnit
  /// This allows you to call: WeightField.weightValue.format(70.567).number
  FormattedMeasurement format(dynamic input) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid; // Can't format non-quantity fields
    }

    final weightUnit = WeightUnit();
    return weightUnit.format(input);
  }

  /// Format as kilograms with validation
  /// This allows you to call: WeightField.weightValue.formatWithValidation(70.567)
  FormattedMeasurement formatWithValidation(dynamic input) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final weightUnit = WeightUnit();
    return weightUnit.formatWithValidation(input);
  }

  /// Force format as kilograms
  /// This allows you to call: WeightField.weightValue.formatAsKilograms(70.567)
  FormattedMeasurement formatAsKilograms(double kgValue) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final weightUnit = WeightUnit();
    return weightUnit.formatAsKilograms(kgValue);
  }

  /// Format weight in different units (ready for future use)
  /// This allows you to call: WeightField.weightValue.formatAsUnit(70.5, 'lbs')
  FormattedMeasurement formatAsUnit(double kgValue, String targetUnit) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final weightUnit = WeightUnit();
    return weightUnit.formatAsUnit(kgValue, targetUnit);
  }

  /// Convert kilograms to pounds
  /// This allows you to call: WeightField.weightValue.convertKgToPounds(70)
  double convertKgToPounds(double kg) {
    final weightUnit = WeightUnit();
    return weightUnit.convertKgToPounds(kg);
  }

  /// Convert pounds to kilograms
  /// This allows you to call: WeightField.weightValue.convertPoundsToKg(154.3)
  double convertPoundsToKg(double pounds) {
    final weightUnit = WeightUnit();
    return weightUnit.convertPoundsToKg(pounds);
  }

  /// Convert kilograms to grams
  /// This allows you to call: WeightField.weightValue.convertKgToGrams(70)
  double convertKgToGrams(double kg) {
    final weightUnit = WeightUnit();
    return weightUnit.convertKgToGrams(kg);
  }

  /// Convert grams to kilograms
  /// This allows you to call: WeightField.weightValue.convertGramsToKg(70000)
  double convertGramsToKg(double grams) {
    final weightUnit = WeightUnit();
    return weightUnit.convertGramsToKg(grams);
  }

  /// Validate weight range
  /// This allows you to call: WeightField.weightValue.isValidWeight(70.5)
  bool isValidWeight(double kgValue) {
    final weightUnit = WeightUnit();
    return weightUnit.isValidWeight(kgValue);
  }
}
