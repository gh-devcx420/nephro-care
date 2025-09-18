import 'package:intl/intl.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_constants.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';
import 'package:nephro_care/features/trackers/generic/tracker_utils.dart';

class BloodPressureUtils implements TrackerUtils<BloodPressureField> {
  static final _invalidBPMeasure = Measurement.invalid<BloodPressureField>();

  bool _isValidSource(Measurement<BloodPressureField> source) {
    return source.isValid &&
        source.unit != null &&
        source.value != null &&
        source.unit is BloodPressureField &&
        source.value! >= 0;
  }

  bool _isValidFieldValue(BloodPressureField field, double value) {
    return value >= BloodPressureConstants.getMinValue(field) &&
        value <= BloodPressureConstants.getMaxValue(field);
  }

  @override
  BloodPressureField get baseUnit => BloodPressureField.systolic;

  @override
  NumberFormat get baseUnitFormat => BloodPressureField.systolic.valueFormat;

  @override
  Measurement<BloodPressureField> format(num value) {
    throw UnimplementedError(
      'Use formatField() instead. BP measurements require specifying both value and field type.',
    );
  }

  /// Validates if systolic > diastolic
  bool isValidBPReading({
    required Measurement<BloodPressureField> systolic,
    required Measurement<BloodPressureField> diastolic,
  }) {
    if (!_isValidSource(systolic) ||
        !_isValidSource(diastolic) ||
        systolic.unit != BloodPressureField.systolic ||
        diastolic.unit != BloodPressureField.diastolic) {
      return false;
    }

    return systolic.value! > diastolic.value!;
  }

  /// Formats a measurement for a specific blood pressure field
  Measurement<BloodPressureField> formatField({
    required BloodPressureField field,
    required num value,
  }) {
    final processedValue = value.toDouble();

    if (processedValue < 0 || !_isValidFieldValue(field, processedValue)) {
      return _invalidBPMeasure;
    }

    final formattedValue = field.valueFormat.format(processedValue);

    return Measurement<BloodPressureField>(
      value: processedValue,
      formattedValue: formattedValue,
      unit: field,
      unitString: field.siUnit,
      isValid: true,
    );
  }

  Measurement<BloodPressureField> formatSystolic(num value) {
    return formatField(field: BloodPressureField.systolic, value: value);
  }

  Measurement<BloodPressureField> formatDiastolic(num value) {
    return formatField(field: BloodPressureField.diastolic, value: value);
  }

  Measurement<BloodPressureField> formatPulse(num value) {
    return formatField(field: BloodPressureField.pulse, value: value);
  }

  Measurement<BloodPressureField> formatSpO2(num value) {
    return formatField(field: BloodPressureField.spo2, value: value);
  }

  Measurement<BloodPressureField> formatBPReading({
    required Measurement<BloodPressureField> systolic,
    required Measurement<BloodPressureField> diastolic,
  }) {
    if (!isValidBPReading(systolic: systolic, diastolic: diastolic)) {
      return const Measurement<BloodPressureField>(
        value: null,
        formattedValue: null,
        unit: null,
        unitString: null,
        isValid: false,
        displayValue: 'Invalid Reading',
      );
    }

    final customDisplayValue =
        '${systolic.value!.round()}/${diastolic.value!.round()}';

    return Measurement<BloodPressureField>(
      value: systolic.value,
      formattedValue: customDisplayValue,
      unit: BloodPressureField.systolic,
      unitString: BloodPressureField.systolic.siUnit,
      isValid: true,
      displayValue: customDisplayValue,
    );
  }

  String getBPCategory({
    required Measurement<BloodPressureField> systolic,
    required Measurement<BloodPressureField> diastolic,
  }) {
    if (!isValidBPReading(systolic: systolic, diastolic: diastolic)) {
      return 'Invalid';
    }

    final sys = systolic.value!;
    final dia = diastolic.value!;

    if (sys >= BloodPressureConstants.crisisSystolicMin ||
        dia >= BloodPressureConstants.crisisDiastolicMin) {
      return 'Hypertensive Crisis';
    } else if (sys >= BloodPressureConstants.stage2SystolicMin ||
        dia >= BloodPressureConstants.stage2DiastolicMin) {
      return 'High Blood Pressure : Stage 2';
    } else if ((sys >= BloodPressureConstants.stage1SystolicMin &&
            sys <= BloodPressureConstants.stage1SystolicMax) ||
        (dia >= BloodPressureConstants.stage1DiastolicMin &&
            dia <= BloodPressureConstants.stage1DiastolicMax)) {
      return 'High Blood Pressure : Stage 1';
    } else if (sys >= BloodPressureConstants.elevatedSystolicMin &&
        sys <= BloodPressureConstants.elevatedSystolicMax &&
        dia <= BloodPressureConstants.elevatedDiastolicMax) {
      return 'Elevated';
    } else {
      return 'Normal';
    }
  }

  String getPulseCategory(Measurement<BloodPressureField> pulse) {
    if (!_isValidSource(pulse) || pulse.unit != BloodPressureField.pulse) {
      return 'Invalid';
    }

    final pulseValue = pulse.value!;

    if (pulseValue <= BloodPressureConstants.bradycardiaMax) {
      return 'Bradycardia (Low)';
    } else if (pulseValue >= BloodPressureConstants.normalPulseMin &&
        pulseValue <= BloodPressureConstants.normalPulseMax) {
      return 'Normal';
    } else {
      return 'Tachycardia (High)';
    }
  }

  String getSpO2Category(Measurement<BloodPressureField> spo2) {
    if (!_isValidSource(spo2) || spo2.unit != BloodPressureField.spo2) {
      return 'Invalid';
    }

    final spo2Value = spo2.value!;

    if (spo2Value >= BloodPressureConstants.normalSpo2Min) {
      return 'Normal';
    } else if (spo2Value >= BloodPressureConstants.mildHypoxemiaMin) {
      return 'Mild Hypoxemia';
    } else if (spo2Value >= BloodPressureConstants.moderateHypoxemiaMin) {
      return 'Moderate Hypoxemia';
    } else {
      return 'Severe Hypoxemia';
    }
  }
}
