// urine_output_enums.dart

import 'package:intl/intl.dart';
import 'package:nephro_care/features/shared/tracker_utils.dart';
import 'package:nephro_care/features/trackers/urine/urine_utils.dart';

enum UrineOutputField {
  urineQuantityML, // Urine output in milliliters
  urineQuantityL, // Urine output in liters
  color, // Color of urine
  time, // Time of measurement
}

extension UrineOutputFieldExtension on UrineOutputField {
  String? get unit {
    switch (this) {
      case UrineOutputField.urineQuantityML:
        return 'ml';
      case UrineOutputField.urineQuantityL:
        return 'L';
      case UrineOutputField.color:
        return null; // Color has no unit
      case UrineOutputField.time:
        return null; // Time has no unit
    }
  }

  NumberFormat? get numberFormat {
    switch (this) {
      case UrineOutputField.urineQuantityML:
        return NumberFormat('#'); // Show as: 350 ml
      case UrineOutputField.urineQuantityL:
        return NumberFormat('#.##'); // Show as: 1.20 L
      case UrineOutputField.color:
        return null; // Color is not a number field
      case UrineOutputField.time:
        return null; // Time is not a number field
    }
  }

  String get displayName {
    switch (this) {
      case UrineOutputField.urineQuantityML:
        return 'Urine Output (ml)';
      case UrineOutputField.urineQuantityL:
        return 'Urine Output (L)';
      case UrineOutputField.color:
        return 'Urine Color';
      case UrineOutputField.time:
        return 'Time';
    }
  }

  bool get isQuantity {
    return this == UrineOutputField.urineQuantityML ||
        this == UrineOutputField.urineQuantityL;
  }

  /// Format a value using UrineUnit with smart unit selection
  /// This allows you to call: UrineOutputField.urineQuantityML.format(1200).number
  /// Smart formatting automatically chooses ml or L based on value size
  FormattedMeasurement format(dynamic input) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid; // Can't format non-quantity fields
    }

    final urineUnit = UrineUnit();
    return urineUnit.format(input);
  }

  /// Format as specific unit (ml or L) without smart conversion
  /// This allows you to call: UrineOutputField.urineQuantityML.formatAs(1200, UrineOutputField.urineQuantityL)
  FormattedMeasurement formatAs(double value, UrineOutputField targetUnit) {
    if (!isQuantity || !targetUnit.isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final urineUnit = UrineUnit();
    return urineUnit.formatAs(value, targetUnit);
  }

  /// Force format as milliliters
  /// This allows you to call: UrineOutputField.urineQuantityML.formatAsMilliliters(350)
  FormattedMeasurement formatAsMilliliters(double mlValue) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final urineUnit = UrineUnit();
    return urineUnit.formatAsMilliliters(mlValue);
  }

  /// Force format as liters
  /// This allows you to call: UrineOutputField.urineQuantityML.formatAsLiters(1200)
  FormattedMeasurement formatAsLiters(double mlValue) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final urineUnit = UrineUnit();
    return urineUnit.formatAsLiters(mlValue);
  }

  /// Format a value that's already in liters
  /// This allows you to call: UrineOutputField.urineQuantityL.formatLiterValue(1.2)
  FormattedMeasurement formatLiterValue(double literValue) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final urineUnit = UrineUnit();
    return urineUnit.formatLiterValue(literValue);
  }

  /// Convert between urine measurement units
  /// This allows you to call: UrineOutputField.urineQuantityML.convertTo(1200, UrineOutputField.urineQuantityL)
  double convertTo(double value, UrineOutputField targetUnit) {
    if (!isQuantity || !targetUnit.isQuantity) {
      return value; // Return unchanged if not quantity fields
    }

    final urineUnit = UrineUnit();
    return urineUnit.convertBetween(
      value: value,
      from: this,
      to: targetUnit,
    );
  }

  /// Convert milliliters to liters
  /// This allows you to call: UrineOutputField.urineQuantityML.convertMlToLiters(1200)
  double convertMlToLiters(double ml) {
    final urineUnit = UrineUnit();
    return urineUnit.convertMlToLiters(ml);
  }

  /// Convert liters to milliliters
  /// This allows you to call: UrineOutputField.urineQuantityL.convertLitersToMl(1.2)
  double convertLitersToMl(double liters) {
    final urineUnit = UrineUnit();
    return urineUnit.convertLitersToMl(liters);
  }
}
