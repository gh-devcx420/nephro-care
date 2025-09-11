import 'package:intl/intl.dart';

enum Weight {
  weightValue,
  time,
}

extension WeightExtensions on Weight {
  String get name {
    switch (this) {
      case Weight.weightValue:
        return 'Weight Value';
      case Weight.time:
        return 'Time';
    }
  }

  String get hintText {
    switch (this) {
      case Weight.weightValue:
        return 'Weight Value';
      case Weight.time:
        return 'Time';
    }
  }

  String get fieldKey {
    switch (this) {
      case Weight.weightValue:
        return 'weight_value_key';
      case Weight.time:
        return 'time_key';
    }
  }
}

enum WeightUnits {
  grams,
  kilograms,
  pounds,
}

extension WeightUnitsExtension on WeightUnits {
  String get siUnit {
    switch (this) {
      case WeightUnits.grams:
        return 'g';
      case WeightUnits.kilograms:
        return 'kg';
      case WeightUnits.pounds:
        return 'lbs';
    }
  }

  NumberFormat get valueFormat {
    switch (this) {
      case WeightUnits.grams:
        return NumberFormat('#');
      case WeightUnits.kilograms:
        return NumberFormat('#.##');
      case WeightUnits.pounds:
        return NumberFormat('#.##');
    }
  }
}
