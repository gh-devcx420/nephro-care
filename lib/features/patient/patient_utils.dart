import 'package:nephro_care/features/patient/patient_constants.dart';
import 'package:nephro_care/features/patient/patient_enums.dart';
import 'package:nephro_care/features/patient/patient_model.dart';
import 'package:nephro_care/features/trackers/dialysis/dialysis_enums.dart';

class PatientInfoUtils {
  // ============ Age Calculations ============

  /// Calculate age from date of birth
  static int calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;
    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }
    return age;
  }

  /// Get age category (pediatric, adult, geriatric)
  static String getAgeCategory(DateTime dateOfBirth) {
    final age = calculateAge(dateOfBirth);
    if (age < 18) return 'Pediatric';
    if (age < 65) return 'Adult';
    return 'Geriatric';
  }

  // ============ BMI Calculations ============

  /// Calculate BMI (Body Mass Index) from height in cm and weight in kg
  static double calculateBMI({
    required double heightCm,
    required double weightKg,
  }) {
    final heightInMeters = heightCm / 100;
    return weightKg / (heightInMeters * heightInMeters);
  }

  /// Get BMI category
  static String getBMICategory(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    if (bmi < 35) return 'Obese Class I';
    if (bmi < 40) return 'Obese Class II';
    return 'Obese Class III';
  }

  /// Get BMI status with health implications
  static String getBMIStatus(double bmi) {
    if (bmi < 18.5) return 'Below Normal - May increase health risks';
    if (bmi < 25) return 'Normal - Healthy weight range';
    if (bmi < 30) return 'Above Normal - Consider weight management';
    return 'High - Increased health risks';
  }

  // ============ CKD Stage Information ============

  /// Get CKD stage description with GFR range
  static String getCKDStageDescription(int stage) {
    switch (stage) {
      case 1:
        return 'Stage 1 (GFR ≥90) - Kidney damage with normal function';
      case 2:
        return 'Stage 2 (GFR 60-89) - Mild decrease in kidney function';
      case 3:
        return 'Stage 3 (GFR 30-59) - Moderate decrease in kidney function';
      case 4:
        return 'Stage 4 (GFR 15-29) - Severe decrease in kidney function';
      case 5:
        return 'Stage 5 (GFR <15) - Kidney failure';
      default:
        return 'Unknown Stage';
    }
  }

  /// Get short CKD stage description
  static String getCKDStageShort(int stage) {
    switch (stage) {
      case 1:
        return 'Stage 1 (GFR ≥90)';
      case 2:
        return 'Stage 2 (GFR 60-89)';
      case 3:
        return 'Stage 3 (GFR 30-59)';
      case 4:
        return 'Stage 4 (GFR 15-29)';
      case 5:
        return 'Stage 5 (GFR <15)';
      default:
        return 'Unknown';
    }
  }

  /// Check if CKD stage is advanced (4 or 5)
  static bool isAdvancedCKD(int stage) {
    return stage >= 4;
  }

  // ============ Disease Duration Calculations ============

  /// Get years since CKD diagnosis
  static int? calculateYearsSinceDiagnosis(DateTime? diagnosisDate) {
    if (diagnosisDate == null) return null;
    return DateTime.now().difference(diagnosisDate).inDays ~/ 365;
  }

  /// Get months since CKD diagnosis
  static int? calculateMonthsSinceDiagnosis(DateTime? diagnosisDate) {
    if (diagnosisDate == null) return null;
    return DateTime.now().difference(diagnosisDate).inDays ~/ 30;
  }

  /// Get formatted disease duration string
  static String getFormattedDiseaseDuration(DateTime? diagnosisDate) {
    if (diagnosisDate == null) return 'Unknown';

    final years = calculateYearsSinceDiagnosis(diagnosisDate);
    if (years == null) return 'Unknown';

    if (years == 0) {
      final months = calculateMonthsSinceDiagnosis(diagnosisDate);
      return '$months ${months == 1 ? 'month' : 'months'}';
    }

    return '$years ${years == 1 ? 'year' : 'years'}';
  }

  // ============ Dialysis Information ============

  /// Get years on dialysis
  static int? calculateYearsOnDialysis(DateTime? dialysisStartDate) {
    if (dialysisStartDate == null) return null;
    return DateTime.now().difference(dialysisStartDate).inDays ~/ 365;
  }

  /// Get months on dialysis
  static int? calculateMonthsOnDialysis(DateTime? dialysisStartDate) {
    if (dialysisStartDate == null) return null;
    return DateTime.now().difference(dialysisStartDate).inDays ~/ 30;
  }

  /// Get formatted dialysis duration string
  static String getFormattedDialysisDuration(DateTime? dialysisStartDate) {
    if (dialysisStartDate == null) return 'Not on dialysis';

    final years = calculateYearsOnDialysis(dialysisStartDate);
    if (years == null) return 'Not on dialysis';

    if (years == 0) {
      final months = calculateMonthsOnDialysis(dialysisStartDate);
      return '$months ${months == 1 ? 'month' : 'months'}';
    }

    return '$years ${years == 1 ? 'year' : 'years'}';
  }

  // ============ Transplant Information ============

  /// Get years since transplant
  static int? calculateYearsSinceTransplant(DateTime? transplantDate) {
    if (transplantDate == null) return null;
    return DateTime.now().difference(transplantDate).inDays ~/ 365;
  }

  /// Get months since transplant
  static int? calculateMonthsSinceTransplant(DateTime? transplantDate) {
    if (transplantDate == null) return null;
    return DateTime.now().difference(transplantDate).inDays ~/ 30;
  }

  /// Get formatted transplant duration string
  static String getFormattedTransplantDuration(DateTime? transplantDate) {
    if (transplantDate == null) return 'No transplant';

    final years = calculateYearsSinceTransplant(transplantDate);
    if (years == null) return 'No transplant';

    if (years == 0) {
      final months = calculateMonthsSinceTransplant(transplantDate);
      return '$months ${months == 1 ? 'month' : 'months'} post-transplant';
    }

    return '$years ${years == 1 ? 'year' : 'years'} post-transplant';
  }

  // ============ Lifestyle & Risk Factors ============

  /// Get formatted diet restrictions as string
  static String getFormattedDietRestrictions(
      List<DietRestriction> restrictions) {
    if (restrictions.isEmpty) return 'No restrictions';
    return restrictions.map((e) => e.displayName).join(', ');
  }

  /// Get smoking risk level
  static String getSmokingRiskLevel({
    required SmokingStatus status,
    SmokingFrequency? frequency,
  }) {
    if (status == SmokingStatus.never) return 'No Risk';
    if (status == SmokingStatus.former) return 'Former Risk';

    // Current smoker
    if (frequency == null) return 'High Risk';

    switch (frequency) {
      case SmokingFrequency.occasional:
        return 'Moderate Risk';
      case SmokingFrequency.moderate:
        return 'High Risk';
      case SmokingFrequency.heavy:
        return 'Very High Risk';
      default:
        return 'Unknown Risk';
    }
  }

  /// Get alcohol risk level
  static String getAlcoholRiskLevel({
    required AlcoholStatus status,
    AlcoholConsumption? consumption,
  }) {
    if (status == AlcoholStatus.never) return 'No Risk';
    if (status == AlcoholStatus.former) return 'Former Risk';

    // Current drinker
    if (consumption == null) return 'Unknown Risk';

    switch (consumption) {
      case AlcoholConsumption.none:
        return 'No Risk';
      case AlcoholConsumption.occasional:
        return 'Low Risk';
      case AlcoholConsumption.moderate:
        return 'Moderate Risk';
      case AlcoholConsumption.heavy:
        return 'High Risk';
    }
  }

  // ============ Validation Methods ============

  /// Validate patient name
  static bool isValidName(String name) {
    return name.trim().isNotEmpty &&
        name.length <= PatientInfoConstants.nameMaxChars;
  }

  /// Validate height (in cm)
  static bool isValidHeight(double height) {
    return height >= PatientInfoConstants.minHeightCms &&
        height <= PatientInfoConstants.maxHeightCms;
  }

  /// Validate weight (in kg)
  static bool isValidWeight(double weight) {
    return weight >= PatientInfoConstants.minWeightKg &&
        weight <= PatientInfoConstants.maxWeightKg;
  }

  /// Validate CKD stage
  static bool isValidCKDStage(int stage) {
    return stage >= 1 && stage <= 5;
  }

  /// Validate phone number (basic check)
  static bool isValidPhoneNumber(String? phone) {
    if (phone == null || phone.trim().isEmpty) return true; // Optional field
    return phone.length >= 10 && phone.length <= 15;
  }

  /// Validate email (basic check)
  static bool isValidEmail(String? email) {
    if (email == null || email.trim().isEmpty) return true; // Optional field
    return email.contains('@') && email.contains('.');
  }

  /// Validate notes
  static bool isValidNotes(String? notes) {
    if (notes == null || notes.trim().isEmpty) return true; // Optional field
    return notes.length <= PatientInfoConstants.nameMaxChars;
  }

  /// Check if patient profile is complete
  static bool isProfileComplete(PatientModel patient) {
    return patient.fullName.isNotEmpty &&
        patient.phoneNumber != null &&
        patient.phoneNumber!.isNotEmpty &&
        patient.ckdCause != null &&
        patient.ckdDiagnosisDate != null &&
        patient.primaryNephrologist != null &&
        patient.primaryNephrologist!.isNotEmpty;
  }

  // ============ Patient Summary ============

  /// Generate patient summary string
  static String generatePatientSummary(PatientModel patient) {
    final buffer = StringBuffer();
    buffer.write(
        '${patient.fullName}, ${calculateAge(patient.dateOfBirth)} yrs, ');
    buffer.write('${patient.gender}, ');
    buffer.write('CKD Stage ${patient.ckdStage}');

    if (patient.dialysisType != DialysisType.none) {
      buffer.write(', On ${patient.dialysisType.displayName}');
    }

    if (patient.transplantStatus == TransplantStatus.transplanted) {
      buffer.write(', Transplanted');
    }

    return buffer.toString();
  }

  /// Generate detailed patient info string
  static String generateDetailedPatientInfo(PatientModel patient) {
    final buffer = StringBuffer();
    buffer.writeln('Patient: ${patient.fullName}');
    buffer.writeln('Age: ${calculateAge(patient.dateOfBirth)} years');
    buffer.writeln('Sex: ${patient.gender}');
    buffer.writeln(
        'BMI: ${calculateBMI(heightCm: patient.heightCm, weightKg: patient.weightKg).toStringAsFixed(1)}');
    buffer.writeln('CKD: ${getCKDStageShort(patient.ckdStage.severity)}');

    if (patient.ckdCause != null) {
      buffer.writeln('Cause: ${patient.ckdCause!.displayName}');
    }

    if (patient.dialysisType != DialysisType.none) {
      buffer.writeln('Dialysis: ${patient.dialysisType.displayName}');
      if (patient.dialysisStartDate != null) {
        buffer.writeln(
            'Duration: ${getFormattedDialysisDuration(patient.dialysisStartDate)}');
      }
    }

    return buffer.toString();
  }

  // ============ Risk Assessment ============

  /// Calculate overall patient risk score (0-100)
  static int calculateRiskScore(PatientModel patient) {
    int score = 0;

    // CKD stage contributes 0-40 points
    score += (patient.ckdStage.severity * 8);

    // Age contributes 0-20 points
    final age = calculateAge(patient.dateOfBirth);
    if (age > 65) {
      score += 20;
    } else if (age > 50) {
      score += 10;
    }

    // BMI contributes 0-15 points
    final bmi =
        calculateBMI(heightCm: patient.heightCm, weightKg: patient.weightKg);
    if (bmi >= 35 || bmi < 18.5) {
      score += 15;
    } else if (bmi >= 30 || bmi < 20) {
      score += 8;
    }

    // Smoking contributes 0-15 points
    if (patient.smokingStatus == SmokingStatus.current) {
      if (patient.smokingFrequency == SmokingFrequency.heavy) {
        score += 15;
      } else if (patient.smokingFrequency == SmokingFrequency.moderate) {
        score += 10;
      } else {
        score += 5;
      }
    }

    // Dialysis contributes 0-10 points
    if (patient.dialysisType != DialysisType.none) score += 10;

    return score.clamp(0, 100);
  }

  /// Get risk category based on risk score
  static String getRiskCategory(int riskScore) {
    if (riskScore < 20) return 'Low Risk';
    if (riskScore < 40) return 'Moderate Risk';
    if (riskScore < 60) return 'High Risk';
    if (riskScore < 80) return 'Very High Risk';
    return 'Critical Risk';
  }

  // ============ Formatting Helpers ============

  /// Format date for display
  static String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Format blood group for display
  static String formatBloodGroup(String? bloodGroup) {
    if (bloodGroup == null || bloodGroup.isEmpty) return 'Unknown';
    return bloodGroup;
  }

  /// Format contact info for display
  static String formatContactInfo(PatientModel patient) {
    final buffer = StringBuffer();

    if (patient.phoneNumber != null && patient.phoneNumber!.isNotEmpty) {
      buffer.writeln('Phone: ${patient.phoneNumber}');
    }

    if (patient.email != null && patient.email!.isNotEmpty) {
      buffer.writeln('Email: ${patient.email}');
    }

    if (patient.address != null && patient.address!.isNotEmpty) {
      buffer.writeln('Address: ${patient.address}');
    }

    return buffer.toString().trim();
  }

  /// Format emergency contact for display
  static String formatEmergencyContact(PatientModel patient) {
    if (patient.emergencyContactName == null ||
        patient.emergencyContactPhone == null) {
      return 'No emergency contact';
    }

    return '${patient.emergencyContactName} - ${patient.emergencyContactPhone}';
  }
}
