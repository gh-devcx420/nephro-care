import 'package:nephro_care/features/trackers/generic/tracker_models.dart';
import 'package:nephro_care/features/trackers/weight/weight_constants.dart';
import 'package:nephro_care/features/trackers/weight/weight_enums.dart';

class WeightUtils {
  static final _invalidWeightMeasure = Measurement.invalid<WeightUnits>();

  bool _isValidSource(Measurement<WeightUnits> source) {
    return source.isValid &&
        source.unit != null &&
        source.value != null &&
        source.unit is WeightUnits &&
        source.value! >= 0;
  }

  Measurement<WeightUnits> format(num value) {
    final processedValue = value.toDouble();

    if (processedValue < 0) return _invalidWeightMeasure;

    final formattedValue =
        WeightUnits.kilograms.valueFormat.format(processedValue);

    return Measurement<WeightUnits>(
      value: processedValue,
      formattedValue: formattedValue,
      unit: WeightUnits.kilograms,
      unitString: WeightUnits.kilograms.siUnit,
      isValid: true,
    );
  }

  Measurement<WeightUnits> formatAsGrams(Measurement<WeightUnits> source) {
    if (!_isValidSource(source)) return _invalidWeightMeasure;

    final sourceValue = source.value!;
    final sourceUnit = source.unit as WeightUnits;

    double gramsValue;
    if (sourceUnit == WeightUnits.grams) {
      gramsValue = sourceValue;
    } else if (sourceUnit == WeightUnits.kilograms) {
      gramsValue = sourceValue * WeightConstants.gramsPerKilogram;
    } else {
      gramsValue = sourceValue * WeightConstants.gramsPerPound;
    }

    final formattedValue = WeightUnits.grams.valueFormat.format(gramsValue);
    return Measurement<WeightUnits>(
      value: gramsValue,
      formattedValue: formattedValue,
      unit: WeightUnits.grams,
      unitString: WeightUnits.grams.siUnit,
      isValid: true,
    );
  }

  Measurement<WeightUnits> formatAsKilograms(Measurement<WeightUnits> source) {
    if (!_isValidSource(source)) return _invalidWeightMeasure;

    final sourceValue = source.value!;
    final sourceUnit = source.unit as WeightUnits;

    if (sourceUnit == WeightUnits.kilograms) return source;

    double kilogramsValue;
    if (sourceUnit == WeightUnits.grams) {
      kilogramsValue = sourceValue / WeightConstants.gramsPerKilogram;
    } else {
      kilogramsValue = sourceValue * WeightConstants.kilogramsPerPound;
    }

    final formattedValue =
        WeightUnits.kilograms.valueFormat.format(kilogramsValue);

    return Measurement<WeightUnits>(
      value: kilogramsValue,
      formattedValue: formattedValue,
      unit: WeightUnits.kilograms,
      unitString: WeightUnits.kilograms.siUnit,
      isValid: true,
    );
  }

  Measurement<WeightUnits> formatAsPounds(Measurement<WeightUnits> source) {
    if (!_isValidSource(source)) return _invalidWeightMeasure;

    final sourceValue = source.value!;
    final sourceUnit = source.unit as WeightUnits;

    if (sourceUnit == WeightUnits.pounds) return source;

    double poundsValue;
    if (sourceUnit == WeightUnits.kilograms) {
      poundsValue = sourceValue * WeightConstants.poundsPerKilogram;
    } else {
      poundsValue = sourceValue / WeightConstants.gramsPerPound;
    }

    final formattedValue = WeightUnits.pounds.valueFormat.format(poundsValue);

    return Measurement<WeightUnits>(
      value: poundsValue,
      formattedValue: formattedValue,
      unit: WeightUnits.pounds,
      unitString: WeightUnits.pounds.siUnit,
      isValid: true,
    );
  }

  Measurement<WeightUnits> formatBetween({
    required Measurement<WeightUnits> source,
    required WeightUnits target,
  }) {
    if (!_isValidSource(source) || source.unit == target) {
      return source.unit == target ? source : _invalidWeightMeasure;
    }

    return switch (target) {
      WeightUnits.grams => formatAsGrams(source),
      WeightUnits.kilograms => formatAsKilograms(source),
      WeightUnits.pounds => formatAsPounds(source),
    };
  }
}
