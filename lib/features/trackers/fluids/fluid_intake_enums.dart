// fluid_intake_enums.dart

import 'package:intl/intl.dart';
import 'package:nephro_care/features/shared/tracker_utils.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_utils.dart';

enum FluidIntakeField {
  fluidQuantityMl, // Fluid quantity in milliliters
  fluidQuantityL, // Fluid quantity in liters
  fluidType, // Type of fluid (water, juice, etc.)
  time, // Time of intake
}

extension FluidIntakeFieldExtension on FluidIntakeField {
  String? get unit {
    switch (this) {
      case FluidIntakeField.fluidQuantityMl:
        return 'ml';
      case FluidIntakeField.fluidQuantityL:
        return 'L';
      case FluidIntakeField.fluidType:
        return null; // Fluid type has no unit
      case FluidIntakeField.time:
        return null; // Time has no unit
    }
  }

  NumberFormat? get numberFormat {
    switch (this) {
      case FluidIntakeField.fluidQuantityMl:
        return NumberFormat('#'); // Show as: 250 ml
      case FluidIntakeField.fluidQuantityL:
        return NumberFormat('#.##'); // Show as: 1.25 L
      case FluidIntakeField.fluidType:
        return null; // Fluid type is not a number field
      case FluidIntakeField.time:
        return null; // Time is not a number field
    }
  }

  String get displayName {
    switch (this) {
      case FluidIntakeField.fluidQuantityMl:
        return 'Fluid Quantity (ml)';
      case FluidIntakeField.fluidQuantityL:
        return 'Fluid Quantity (L)';
      case FluidIntakeField.fluidType:
        return 'Fluid Type';
      case FluidIntakeField.time:
        return 'Time';
    }
  }

  bool get isQuantity {
    return this == FluidIntakeField.fluidQuantityMl ||
        this == FluidIntakeField.fluidQuantityL;
  }

  /// Format a value using FluidUnit with smart unit selection
  /// This allows you to call: FluidIntakeField.fluidQuantityMl.format(1500).number
  /// Smart formatting automatically chooses ml or L based on value size
  FormattedMeasurement format(dynamic input) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid; // Can't format non-quantity fields
    }

    final fluidUnit = FluidUnit();
    return fluidUnit.format(input);
  }

  /// Format as specific unit (ml or L) without smart conversion
  /// This allows you to call: FluidIntakeField.fluidQuantityMl.formatAs(1500, FluidIntakeField.fluidQuantityL)
  FormattedMeasurement formatAs(double value, FluidIntakeField targetUnit) {
    if (!isQuantity || !targetUnit.isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final fluidUnit = FluidUnit();
    return fluidUnit.formatAs(value, targetUnit);
  }

  /// Force format as milliliters
  /// This allows you to call: FluidIntakeField.fluidQuantityMl.formatAsMilliliters(1500)
  FormattedMeasurement formatAsMilliliters(double mlValue) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final fluidUnit = FluidUnit();
    return fluidUnit.formatAsMilliliters(mlValue);
  }

  /// Force format as liters
  /// This allows you to call: FluidIntakeField.fluidQuantityMl.formatAsLiters(1500)
  FormattedMeasurement formatAsLiters(double mlValue) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final fluidUnit = FluidUnit();
    return fluidUnit.formatAsLiters(mlValue);
  }

  /// Format a value that's already in liters
  /// This allows you to call: FluidIntakeField.fluidQuantityL.formatLiterValue(1.5)
  FormattedMeasurement formatLiterValue(double literValue) {
    if (!isQuantity) {
      return FormattedMeasurement.invalid;
    }

    final fluidUnit = FluidUnit();
    return fluidUnit.formatLiterValue(literValue);
  }

  /// Convert between fluid units
  /// This allows you to call: FluidIntakeField.fluidQuantityMl.convertTo(1500, FluidIntakeField.fluidQuantityL)
  double convertTo(double value, FluidIntakeField targetUnit) {
    if (!isQuantity || !targetUnit.isQuantity) {
      return value; // Return unchanged if not quantity fields
    }

    final fluidUnit = FluidUnit();
    return fluidUnit.convertBetween(
      value: value,
      from: this,
      to: targetUnit,
    );
  }

  /// Convert milliliters to liters
  /// This allows you to call: FluidIntakeField.fluidQuantityMl.convertMlToLiters(1500)
  double convertMlToLiters(double ml) {
    final fluidUnit = FluidUnit();
    return fluidUnit.convertMlToLiters(ml);
  }

  /// Convert liters to milliliters
  /// This allows you to call: FluidIntakeField.fluidQuantityL.convertLitersToMl(1.5)
  double convertLitersToMl(double liters) {
    final fluidUnit = FluidUnit();
    return fluidUnit.convertLitersToMl(liters);
  }
}
