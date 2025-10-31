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

enum FluidRestrictionLevel {
  //USe constants for lower and upper limits
  none,
  mild, // 2-3L/day
  moderate, // 1-2L/day
  severe, // <1L/day
}

extension FluidRestrictionLevelExtension on FluidRestrictionLevel {
  String get displayName {
    switch (this) {
      case FluidRestrictionLevel.none:
        return 'No restriction';
      case FluidRestrictionLevel.mild:
        return 'Mild (2-3L/day)';
      case FluidRestrictionLevel.moderate:
        return 'Moderate (1-2L/day)';
      case FluidRestrictionLevel.severe:
        return 'Severe (<1L/day)';
    }
  }

  String get dailyLimit {
    switch (this) {
      case FluidRestrictionLevel.none:
        return 'No limit';
      case FluidRestrictionLevel.mild:
        return '2-3 liters';
      case FluidRestrictionLevel.moderate:
        return '1-2 liters';
      case FluidRestrictionLevel.severe:
        return '<1 liter';
    }
  }
}
