import 'package:intl/intl.dart';

enum BloodPressureField {
  systolic,
  diastolic,
  pulse,
  spo2,
  time,
}

extension BloodPressureFieldExtension on BloodPressureField {
  String get fieldName {
    switch (this) {
      case BloodPressureField.systolic:
        return 'Systolic';
      case BloodPressureField.diastolic:
        return 'Diastolic';
      case BloodPressureField.pulse:
        return 'Pulse';
      case BloodPressureField.spo2:
        return 'Spo2';
      case BloodPressureField.time:
        return 'Time';
    }
  }

  String get hintText {
    switch (this) {
      case BloodPressureField.systolic:
        return 'Systolic';
      case BloodPressureField.diastolic:
        return 'Diastolic';
      case BloodPressureField.pulse:
        return 'Pulse';
      case BloodPressureField.spo2:
        return 'Spo2';
      case BloodPressureField.time:
        return 'Measurement Time';
    }
  }

  String get fieldKey {
    switch (this) {
      case BloodPressureField.systolic:
        return 'systolic_key';
      case BloodPressureField.diastolic:
        return 'diastolic_key';
      case BloodPressureField.pulse:
        return 'pulse_key';
      case BloodPressureField.spo2:
        return 'spo2_key';
      case BloodPressureField.time:
        return 'time_key';
    }
  }

  String get siUnit {
    switch (this) {
      case BloodPressureField.systolic:
        return 'mmHg';
      case BloodPressureField.diastolic:
        return 'mmHg';
      case BloodPressureField.pulse:
        return 'bpm';
      case BloodPressureField.spo2:
        return '%';
      case BloodPressureField.time:
        return '';
    }
  }

  NumberFormat get valueFormat {
    switch (this) {
      case BloodPressureField.systolic:
        return NumberFormat('#');
      case BloodPressureField.diastolic:
        return NumberFormat('#');
      case BloodPressureField.pulse:
        return NumberFormat('#');
      case BloodPressureField.spo2:
        return NumberFormat('#');
      case BloodPressureField.time:
        return NumberFormat('#');
    }
  }
}
