import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';

class BloodPressureConstants {
  // Systolic pressure ranges (mmHg)
  static const double systolicMin = 70.0;
  static const double systolicMax = 250.0;

  // Diastolic pressure ranges (mmHg)
  static const double diastolicMin = 40.0;
  static const double diastolicMax = 150.0;

  // Pulse/Heart rate ranges (bpm)
  static const double pulseMin = 30.0;
  static const double pulseMax = 200.0;

  // SpO2 ranges (%)
  static const double spo2Min = 70.0;
  static const double spo2Max = 100.0;

  // BP Category thresholds
  static const double normalSystolicMax = 119.0;
  static const double normalDiastolicMax = 79.0;

  static const double elevatedSystolicMin = 120.0;
  static const double elevatedSystolicMax = 129.0;
  static const double elevatedDiastolicMax = 79.0;

  static const double stage1SystolicMin = 130.0;
  static const double stage1DiastolicMin = 80.0;

  static const double stage1SystolicMax = 139.0;
  static const double stage1DiastolicMax = 89.0;

  static const double stage2SystolicMin = 140.0;
  static const double stage2DiastolicMin = 90.0;

  static const double crisisSystolicMin = 180.0;
  static const double crisisDiastolicMin = 120.0;

  // Pulse categories
  static const double bradycardiaMax = 59.0;
  static const double normalPulseMin = 60.0;
  static const double normalPulseMax = 100.0;
  static const double tachycardiaMin = 101.0;

  // SpO2 categories
  static const double normalSpo2Min = 95.0;
  static const double mildHypoxemiaMin = 90.0;
  static const double moderateHypoxemiaMin = 85.0;

  // Firebase collection name
  static const String bpFirebaseCollectionName = 'BloodPressure_Collection';

  // Time constraints
  static const double timeMin = 0.0;
  static const double timeMax = double.maxFinite;

  static double getMinValue(BloodPressureField field) {
    switch (field) {
      case BloodPressureField.systolic:
        return systolicMin;
      case BloodPressureField.diastolic:
        return diastolicMin;
      case BloodPressureField.pulse:
        return pulseMin;
      case BloodPressureField.spo2:
        return spo2Min;
      case BloodPressureField.time:
        return timeMin;
    }
  }

  // Helper method to get max value for a field
  static double getMaxValue(BloodPressureField field) {
    switch (field) {
      case BloodPressureField.systolic:
        return systolicMax;
      case BloodPressureField.diastolic:
        return diastolicMax;
      case BloodPressureField.pulse:
        return pulseMax;
      case BloodPressureField.spo2:
        return spo2Max;
      case BloodPressureField.time:
        return timeMax;
    }
  }
}
