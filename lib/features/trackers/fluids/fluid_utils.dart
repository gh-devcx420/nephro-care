import 'package:intl/intl.dart';
import 'package:nephro_care/features/shared/tracker_utils.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_intake_enums.dart';

/// FluidUnit handles formatting fluid measurements
/// Knows about ml and liters, can convert between them
class FluidUnit extends MeasurementUnit {
  // ===== IMPLEMENT ABSTRACT PROPERTIES =====

  @override
  String? get basicSIUnit => FluidIntakeField.fluidQuantityMl.unit; // "ml"

  @override
  NumberFormat? get formatter =>
      FluidIntakeField.fluidQuantityMl.numberFormat; // NumberFormat('#')

  // ===== IMPLEMENT ABSTRACT METHOD =====

  @override
  FormattedMeasurement format(dynamic input) {
    // Step 1: Try to convert input to a number
    final double? numericValue = MeasurementUnit.parseValue(input);

    // Step 2: Check if conversion failed
    if (numericValue == null || numericValue < 0) {
      return FormattedMeasurement.invalid;
    }

    // Step 3: Smart formatting - choose best unit
    return _formatWithSmartUnit(numericValue);
  }

  // ===== FLUID-SPECIFIC METHODS =====

  /// Smart formatting: automatically choose ml or L based on value
  FormattedMeasurement _formatWithSmartUnit(double mlValue) {
    // If >= 1000ml, show in liters for readability
    if (mlValue >= 1000) {
      return formatAsLiters(mlValue);
    }

    // Otherwise show in ml
    return formatAsMilliliters(mlValue);
  }

  /// Force format as milliliters: 1500 -> "1500 ml"
  FormattedMeasurement formatAsMilliliters(double mlValue) {
    return createFormattedMeasurement(
        mlValue,
        FluidIntakeField.fluidQuantityMl.unit, // "ml"
        FluidIntakeField.fluidQuantityMl.numberFormat // NumberFormat('#')
        );
  }

  /// Force format as liters: 1500 -> "1.50 L"
  FormattedMeasurement formatAsLiters(double mlValue) {
    final liters = convertMlToLiters(mlValue); // 1500 -> 1.5

    return createFormattedMeasurement(
        liters,
        FluidIntakeField.fluidQuantityL.unit, // "L"
        FluidIntakeField.fluidQuantityL.numberFormat // NumberFormat('#.##')
        );
  }

  /// Format a value that's already in liters: 1.5 -> "1.50 L"
  FormattedMeasurement formatLiterValue(double literValue) {
    return createFormattedMeasurement(
        literValue,
        FluidIntakeField.fluidQuantityL.unit, // "L"
        FluidIntakeField.fluidQuantityL.numberFormat // NumberFormat('#.##')
        );
  }

  // ===== CONVERSION HELPERS =====

  /// Convert milliliters to liters: 1500ml -> 1.5L
  double convertMlToLiters(double ml) => ml / 1000;

  /// Convert liters to milliliters: 1.5L -> 1500ml
  double convertLitersToMl(double liters) => liters * 1000;

  /// Convert any fluid value between units
  double convertBetween({
    required double value,
    required FluidIntakeField from,
    required FluidIntakeField to,
  }) {
    // Skip non-quantity fields
    if (!from.isQuantity || !to.isQuantity) return value;

    // Same unit - no conversion
    if (from == to) return value;

    // ml to L
    if (from == FluidIntakeField.fluidQuantityMl &&
        to == FluidIntakeField.fluidQuantityL) {
      return convertMlToLiters(value);
    }

    // L to ml
    if (from == FluidIntakeField.fluidQuantityL &&
        to == FluidIntakeField.fluidQuantityMl) {
      return convertLitersToMl(value);
    }

    return value;
  }

  /// Format a value in a specific unit
  FormattedMeasurement formatAs(double value, FluidIntakeField targetUnit) {
    switch (targetUnit) {
      case FluidIntakeField.fluidQuantityMl:
        return formatAsMilliliters(value);
      case FluidIntakeField.fluidQuantityL:
        return formatAsLiters(value);
      default:
        return FormattedMeasurement.invalid; // Can't format non-quantity fields
    }
  }
}
