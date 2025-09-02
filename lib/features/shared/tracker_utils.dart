// formatted_measurement.dart

import 'package:intl/intl.dart';

/// This class holds the result of formatting a number with its unit
/// Think of it like a container that holds "70.5" + "kg" + "is this valid?"
class FormattedMeasurement {
  final String value; // The formatted number like "70.5" or "1500"
  final String? basicSIUnit; // The unit like "kg", "ml", or null if no unit
  final bool isValid; // Is this a valid measurement?

  const FormattedMeasurement({
    required this.value,
    this.basicSIUnit,
    this.isValid = true,
  });

  /// A special invalid measurement for errors
  static const invalid = FormattedMeasurement(
    value: 'N/A',
    basicSIUnit: null,
    isValid: false,
  );

  /// Convert to string for display: "70.5 kg" or just "N/A" if invalid
  @override
  String toString() {
    if (!isValid) return value; // Just show "N/A"

    if (basicSIUnit == null) return value; // Just the number if no unit

    return '$value $basicSIUnit'.trim(); // "70.5 kg"
  }

  /// Check if this measurement has a unit
  bool get hasUnit => basicSIUnit != null && isValid;

  /// Get just the numeric part
  String get numericValue => value;

  /// Get just the unit part (or empty string if null)
  String get unitValue => basicSIUnit ?? '';
}

// measurement_unit_abstract.dart
// Import our FormattedMeasurement class

/// This is like a blueprint that all measurement units must follow
/// Think of it as rules that every unit (FluidUnit, WeightUnit, etc.) must obey
abstract class MeasurementUnit {
  // ===== ABSTRACT PROPERTIES =====
  // Every child class MUST provide these

  /// What is the main unit? Like "ml" for fluids, "kg" for weight
  String? get basicSIUnit;

  /// How should numbers be formatted? Like NumberFormat('#') or NumberFormat('#.##')
  NumberFormat? get formatter;

  // ===== ABSTRACT METHODS =====
  // Every child class MUST implement these

  /// Take any input and format it properly
  /// For example: format(70.5) should return FormattedMeasurement("70.5", "kg", true)
  FormattedMeasurement format(dynamic input);

  // ===== HELPER METHODS =====
  // These are ready to use - no need to override

  /// Convert any input to a number (or null if impossible)
  static double? parseValue(dynamic input) {
    if (input == null) return null;
    if (input is double) return input;
    if (input is int) return input.toDouble();
    if (input is String) {
      // Remove everything except numbers and dots: "70.5kg" becomes "70.5"
      final cleaned = input.replaceAll(RegExp(r'[^0-9.]'), '').trim();
      return double.tryParse(cleaned);
    }
    return null;
  }

  /// Create a FormattedMeasurement safely
  /// This is a helper that child classes can use
  FormattedMeasurement createFormattedMeasurement(
      double value, String? unit, NumberFormat? format) {
    // Check if value makes sense
    if (value < 0) {
      return FormattedMeasurement.invalid;
    }

    // Format the number
    final formattedValue = format?.format(value) ?? value.toString();

    return FormattedMeasurement(
      value: formattedValue,
      basicSIUnit: unit,
      isValid: true,
    );
  }

  /// Check if this unit can format numbers
  bool get canFormatNumbers => formatter != null && basicSIUnit != null;
}
