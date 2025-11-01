import 'package:nephro_care/features/patient/patient_enums.dart';
import 'package:nephro_care/features/patient/patient_model.dart';

class PatientUtils {
  // ============ Age Calculation ============

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

  // ============ Disease Duration ============

  /// Get formatted duration since CKD diagnosis
  static String getDiseaseDuration(DateTime diagnosisDate) {
    final duration = DateTime.now().difference(diagnosisDate);
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;

    if (years > 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
    return '$months ${months == 1 ? 'month' : 'months'}';
  }

  /// Get formatted duration since dialysis started
  static String getDialysisDuration(DateTime dialysisStartDate) {
    final duration = DateTime.now().difference(dialysisStartDate);
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;

    if (years > 0) {
      return '$years ${years == 1 ? 'year' : 'years'}';
    }
    return '$months ${months == 1 ? 'month' : 'months'}';
  }

  /// Get formatted duration since transplant
  static String? getTransplantDuration(DateTime? transplantDate) {
    if (transplantDate == null) return null;

    final duration = DateTime.now().difference(transplantDate);
    final years = duration.inDays ~/ 365;
    final months = (duration.inDays % 365) ~/ 30;

    if (years > 0) {
      return '$years ${years == 1 ? 'year' : 'years'} post-transplant';
    }
    return '$months ${months == 1 ? 'month' : 'months'} post-transplant';
  }

  // ============ Validation ============

  /// Check if patient profile has all required fields
  static bool isProfileComplete(PatientModel patient) {
    return patient.fullName.isNotEmpty &&
        patient.phoneNumber.isNotEmpty &&
        patient.email.isNotEmpty &&
        (patient.primaryNephrologist?.isNotEmpty ?? false);
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  /// Validate phone number (basic)
  static bool isValidPhone(String phone) {
    final cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    return cleanPhone.length >= 10 && cleanPhone.length <= 15;
  }

  // ============ Formatting ============

  /// Format date to readable string
  static String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Get patient summary for display
  static String getPatientSummary(PatientModel patient) {
    final age = calculateAge(patient.dateOfBirth);
    return '${patient.fullName}, $age yrs, ${patient.gender.displayName}, CKD ${patient.ckdStage.displayName}';
  }
}
