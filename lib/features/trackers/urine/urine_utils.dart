// urine_unit.dart

// Import your enum: import 'package:your_app/features/trackers/urine/urine_output_enums.dart';

import 'package:intl/intl.dart';
import 'package:nephro_care/features/shared/tracker_utils.dart';
import 'package:nephro_care/features/trackers/urine/urine_output_enums.dart';

/// UrineUnit handles formatting urine output measurements
/// Very similar to FluidUnit but uses UrineOutputField enum
class UrineUnit extends MeasurementUnit {
  // ===== IMPLEMENT ABSTRACT PROPERTIES =====

  @override
  String? get basicSIUnit => UrineOutputField.urineQuantityML.unit; // "ml"

  @override
  NumberFormat? get formatter =>
      UrineOutputField.urineQuantityML.numberFormat; // NumberFormat('#')

  // ===== IMPLEMENT ABSTRACT METHOD =====

  @override
  FormattedMeasurement format(dynamic input) {
    final double? numericValue = MeasurementUnit.parseValue(input);

    if (numericValue == null || numericValue < 0) {
      return FormattedMeasurement.invalid;
    }

    return _formatWithSmartUnit(numericValue);
  }

  // ===== URINE-SPECIFIC METHODS =====

  /// Smart formatting: automatically choose ml or L based on value
  FormattedMeasurement _formatWithSmartUnit(double mlValue) {
    // If >= 1000ml, show in liters for readability
    if (mlValue >= 1000) {
      return formatAsLiters(mlValue);
    }

    return formatAsMilliliters(mlValue);
  }

  /// Force format as milliliters: 350 -> "350 ml"
  FormattedMeasurement formatAsMilliliters(double mlValue) {
    return createFormattedMeasurement(
        mlValue,
        UrineOutputField.urineQuantityML.unit, // "ml"
        UrineOutputField.urineQuantityML.numberFormat // NumberFormat('#')
        );
  }

  /// Force format as liters: 1200 -> "1.20 L"
  FormattedMeasurement formatAsLiters(double mlValue) {
    final liters = convertMlToLiters(mlValue);

    return createFormattedMeasurement(
        liters,
        UrineOutputField.urineQuantityL.unit, // "L"
        UrineOutputField.urineQuantityL.numberFormat // NumberFormat('#.##')
        );
  }

  /// Format a value that's already in liters: 1.2 -> "1.20 L"
  FormattedMeasurement formatLiterValue(double literValue) {
    return createFormattedMeasurement(
        literValue,
        UrineOutputField.urineQuantityL.unit, // "L"
        UrineOutputField.urineQuantityL.numberFormat // NumberFormat('#.##')
        );
  }

  // ===== CONVERSION HELPERS =====

  /// Convert milliliters to liters: 1200ml -> 1.2L
  double convertMlToLiters(double ml) => ml / 1000;

  /// Convert liters to milliliters: 1.2L -> 1200ml
  double convertLitersToMl(double liters) => liters * 1000;

  /// Convert between urine measurement units
  double convertBetween({
    required double value,
    required UrineOutputField from,
    required UrineOutputField to,
  }) {
    // Skip non-quantity fields
    if (!from.isQuantity || !to.isQuantity) return value;

    // Same unit - no conversion
    if (from == to) return value;

    // ml to L
    if (from == UrineOutputField.urineQuantityML &&
        to == UrineOutputField.urineQuantityL) {
      return convertMlToLiters(value);
    }

    // L to ml
    if (from == UrineOutputField.urineQuantityL &&
        to == UrineOutputField.urineQuantityML) {
      return convertLitersToMl(value);
    }

    return value;
  }

  /// Format a value in a specific unit
  FormattedMeasurement formatAs(double value, UrineOutputField targetUnit) {
    switch (targetUnit) {
      case UrineOutputField.urineQuantityML:
        return formatAsMilliliters(value);
      case UrineOutputField.urineQuantityL:
        return formatAsLiters(value);
      default:
        return FormattedMeasurement.invalid; // Can't format non-quantity fields
    }
  }
}
