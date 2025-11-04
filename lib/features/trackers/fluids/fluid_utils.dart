import 'package:nephro_care/features/trackers/fluids/fluid_constants.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_enums.dart';
import 'package:nephro_care/features/trackers/generic/generic_models.dart';

class FluidUtils {
  static final _invalidFluidMeasure = Measurement.invalid<FluidUnits>();

  Measurement<FluidUnits> format(num value) {
    final processedValue = value.toDouble();

    if (processedValue < 0) return _invalidFluidMeasure;

    final baseMeasurement = Measurement<FluidUnits>(
      value: processedValue,
      formattedValue: FluidUnits.milliliters.valueFormat.format(processedValue),
      unit: FluidUnits.milliliters,
      unitString: FluidUnits.milliliters.siUnit,
      isValid: true,
    );

    return autoFormat(source: baseMeasurement);
  }

  Measurement<FluidUnits> autoFormat(
      {required Measurement<FluidUnits> source}) {
    if (!_isValidSource(source)) return _invalidFluidMeasure;

    final sourceValue = source.value!;

    if (sourceValue >= FluidConstants.conversionThreshold) {
      return formatAsLitres(source);
    }

    final formattedValue =
        FluidUnits.milliliters.valueFormat.format(sourceValue);

    return Measurement<FluidUnits>(
      value: sourceValue,
      formattedValue: formattedValue,
      unit: FluidUnits.milliliters,
      unitString: FluidUnits.milliliters.siUnit,
      isValid: true,
    );
  }

  Measurement<FluidUnits> formatAsMilliliters(Measurement<FluidUnits> source) {
    if (!_isValidSource(source)) return _invalidFluidMeasure;

    final sourceValue = source.value!;
    final sourceUnit = source.unit as FluidUnits;

    double mlValue;
    if (sourceUnit == FluidUnits.litres) {
      mlValue = sourceValue * FluidConstants.conversionThreshold;
    } else {
      mlValue = sourceValue;
    }

    final formattedValue = FluidUnits.milliliters.valueFormat.format(mlValue);

    return Measurement<FluidUnits>(
      value: mlValue,
      formattedValue: formattedValue,
      unit: FluidUnits.milliliters,
      unitString: FluidUnits.milliliters.siUnit,
      isValid: true,
    );
  }

  Measurement<FluidUnits> formatAsLitres(Measurement<FluidUnits> source) {
    if (!_isValidSource(source)) return _invalidFluidMeasure;

    final sourceValue = source.value!;
    final sourceUnit = source.unit as FluidUnits;

    if (sourceUnit == FluidUnits.litres) return source;

    final litresValue = sourceValue / FluidConstants.conversionThreshold;

    final formattedValue = FluidUnits.litres.valueFormat.format(litresValue);
    return Measurement<FluidUnits>(
      value: litresValue,
      formattedValue: formattedValue,
      unit: FluidUnits.litres,
      unitString: FluidUnits.litres.siUnit,
      isValid: true,
    );
  }

  Measurement<FluidUnits> formatBetween({
    required Measurement<FluidUnits> source,
    required FluidUnits target,
  }) {
    if (!_isValidSource(source) || source.unit == target) {
      return source.unit == target ? source : _invalidFluidMeasure;
    }

    return switch (target) {
      FluidUnits.milliliters => formatAsMilliliters(source),
      FluidUnits.litres => formatAsLitres(source),
    };
  }

  bool _isValidSource(Measurement<FluidUnits> source) {
    return source.isValid &&
        source.unit != null &&
        source.value != null &&
        source.unit is FluidUnits &&
        source.value! >= 0;
  }
}
