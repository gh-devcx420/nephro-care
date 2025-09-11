import 'package:intl/intl.dart';

enum Urine {
  quantity,
  time,
}

extension UrineExtension on Urine {
  String get fieldName {
    switch (this) {
      case Urine.quantity:
        return 'Urine Quantity';
      case Urine.time:
        return 'Urine Time';
    }
  }

  String get hintText {
    switch (this) {
      case Urine.quantity:
        return 'Urine Quantity';
      case Urine.time:
        return 'Urine Time';
    }
  }

  String get fieldKey {
    switch (this) {
      case Urine.quantity:
        return 'quantity_key';
      case Urine.time:
        return 'time_key';
    }
  }
}

enum UrineUnits {
  milliliters,
  litres,
}

extension UrineUnitsExtension on UrineUnits {
  String get siUnit {
    switch (this) {
      case UrineUnits.milliliters:
        return 'ml';
      case UrineUnits.litres:
        return 'L';
    }
  }

  NumberFormat get valueFormat {
    switch (this) {
      case UrineUnits.milliliters:
        return NumberFormat('#');
      case UrineUnits.litres:
        return NumberFormat('#.##');
    }
  }
}
