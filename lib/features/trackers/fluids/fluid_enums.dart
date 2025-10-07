import 'package:intl/intl.dart';

enum Fluids {
  name,
  quantity,
  time,
}

extension FluidsExtension on Fluids {
  String get fieldName {
    switch (this) {
      case Fluids.name:
        return 'Fluid Name';
      case Fluids.quantity:
        return 'Fluid Quantity';
      case Fluids.time:
        return 'Time';
    }
  }

  String get hintText {
    switch (this) {
      case Fluids.name:
        return 'Fluid Name';
      case Fluids.quantity:
        return 'Quantity';
      case Fluids.time:
        return 'Time';
    }
  }

  String get fieldKey {
    switch (this) {
      case Fluids.name:
        return 'name_key';
      case Fluids.quantity:
        return 'quantity_key';
      case Fluids.time:
        return 'time_key';
    }
  }
}

enum FluidUnits {
  milliliters,
  litres,
}

extension FluidUnitsExtension on FluidUnits {
  String get siUnit {
    switch (this) {
      case FluidUnits.milliliters:
        return 'ml';
      case FluidUnits.litres:
        return 'L';
    }
  }

  NumberFormat get valueFormat {
    switch (this) {
      case FluidUnits.milliliters:
        return NumberFormat('#');
      case FluidUnits.litres:
        return NumberFormat('#.##');
    }
  }
}
