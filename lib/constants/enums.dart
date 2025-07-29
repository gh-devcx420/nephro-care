enum BPMonitorFieldEnum {
  systolic,
  diastolic,
  pulse,
  spo2,
  time,
}

enum FluidIntakeFieldEnum {
  fluidName,
  quantity,
  time,
}

enum UrineOutputFieldEnum {
  quantity,
  time,
}

enum SIUnitEnum {
  bloodPressureSIUnit,
  pulseSIUnit,
  fluidsSIUnitML,
  fluidsSIUnitLitres,
  percentSIUnit,
}

enum MeasurementType { fluid, bp, pulse, spo2, weight }

const Map<BPMonitorFieldEnum, String> bpMonitorEnumMap = {
  BPMonitorFieldEnum.systolic: 'systolic',
  BPMonitorFieldEnum.diastolic: 'diastolic',
  BPMonitorFieldEnum.pulse: 'pulse',
  BPMonitorFieldEnum.spo2: 'spo2',
  BPMonitorFieldEnum.time: 'time',
};

const Map<FluidIntakeFieldEnum, String> fluidIntakeEnumMap = {
  FluidIntakeFieldEnum.fluidName: 'fluidName',
  FluidIntakeFieldEnum.quantity: 'quantity',
  FluidIntakeFieldEnum.time: 'time',
};

const Map<UrineOutputFieldEnum, String> urineOutputEnumMap = {
  UrineOutputFieldEnum.quantity: 'quantity',
  UrineOutputFieldEnum.time: 'time',
};

const Map<SIUnitEnum, String> siUnitEnumMap = {
  SIUnitEnum.bloodPressureSIUnit: 'mmHg',
  SIUnitEnum.pulseSIUnit: 'bpm',
  SIUnitEnum.fluidsSIUnitML: 'ml',
  SIUnitEnum.fluidsSIUnitLitres: 'Litres',
  SIUnitEnum.percentSIUnit: '%',
};
