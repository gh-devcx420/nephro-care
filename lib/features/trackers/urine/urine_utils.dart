import 'package:nephro_care/features/trackers/generic/generic_models.dart';
import 'package:nephro_care/features/trackers/urine/urine_constants.dart';
import 'package:nephro_care/features/trackers/urine/urine_enums.dart';

class UrineUtils {
  static final _invalidUrineMeasure = Measurement.invalid<UrineUnits>();

  Measurement<UrineUnits> format(num value) {
    final processedValue = value.toDouble();

    if (processedValue < 0) return _invalidUrineMeasure;

    final baseMeasurement = Measurement<UrineUnits>(
      value: processedValue,
      formattedValue: UrineUnits.milliliters.valueFormat.format(processedValue),
      unit: UrineUnits.milliliters,
      unitString: UrineUnits.milliliters.siUnit,
      isValid: true,
    );

    return autoFormat(source: baseMeasurement);
  }

  /// Converts any measurement to the appropriate unit (auto-scaling)
  Measurement<UrineUnits> autoFormat(
      {required Measurement<UrineUnits> source}) {
    if (!_isValidSource(source)) return _invalidUrineMeasure;

    final sourceValue = source.value!;

    if (sourceValue >= UrineConstants.conversionThreshold) {
      return formatAsLitres(source);
    }

    final formattedValue =
        UrineUnits.milliliters.valueFormat.format(sourceValue);

    return Measurement<UrineUnits>(
      value: sourceValue,
      formattedValue: formattedValue,
      unit: UrineUnits.milliliters,
      unitString: UrineUnits.milliliters.siUnit,
      isValid: true,
    );
  }

  /// Converts any measurement to milliliters
  Measurement<UrineUnits> formatAsMilliliters(Measurement<UrineUnits> source) {
    if (!_isValidSource(source)) return _invalidUrineMeasure;

    final sourceUnit = source.unit as UrineUnits;
    final sourceValue = source.value!;

    double mlValue;
    if (sourceUnit == UrineUnits.litres) {
      mlValue = sourceValue * UrineConstants.conversionThreshold;
    } else {
      mlValue = sourceValue;
    }

    final formattedValue = UrineUnits.milliliters.valueFormat.format(mlValue);

    return Measurement<UrineUnits>(
      value: mlValue,
      formattedValue: formattedValue,
      unit: UrineUnits.milliliters,
      unitString: UrineUnits.milliliters.siUnit,
      isValid: true,
    );
  }

  /// Converts any measurement to liters
  Measurement<UrineUnits> formatAsLitres(Measurement<UrineUnits> source) {
    if (!_isValidSource(source)) return _invalidUrineMeasure;

    final sourceUnit = source.unit as UrineUnits;
    final sourceValue = source.value!;

    if (sourceUnit == UrineUnits.litres) return source;

    final litresValue = sourceValue / UrineConstants.conversionThreshold;

    final formattedValue = UrineUnits.litres.valueFormat.format(litresValue);

    return Measurement<UrineUnits>(
      value: litresValue,
      formattedValue: formattedValue,
      unit: UrineUnits.litres,
      unitString: UrineUnits.litres.siUnit,
      isValid: true,
    );
  }

  /// Converts between any two urine units
  Measurement<UrineUnits> formatBetween({
    required Measurement<UrineUnits> source,
    required UrineUnits target,
  }) {
    if (!_isValidSource(source) || source.unit == target) {
      return source.unit == target ? source : _invalidUrineMeasure;
    }

    return switch (target) {
      UrineUnits.milliliters => formatAsMilliliters(source),
      UrineUnits.litres => formatAsLitres(source),
    };
  }

  bool _isValidSource(Measurement<UrineUnits> source) {
    return source.isValid &&
        source.unit != null &&
        source.value != null &&
        source.unit is UrineUnits &&
        source.value! >= 0;
  }
}
