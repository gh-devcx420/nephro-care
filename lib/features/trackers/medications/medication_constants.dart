class MedicationConstants {
  // Firebase
  static const String medicationFirebaseCollectionName =
      'Medications_Collection';
  
  // Validation limits
  static const int medicationNameMaxChars = 50;
  static const int dosageMaxChars = 30;
  static const int reasonMaxChars = 200;
  static const int instructionsMaxChars = 300;
  static const int prescribedByMaxChars = 50;
  static const int pharmacyMaxChars = 50;

  // Refill thresholds
  static const int refillThreshold = 6;
  static const int criticalRefillThreshold = 2;

  // Dose timing windows (in minutes)
  static const int doseTimeWindowBefore = 30;
  static const int doseTimeWindowAfter = 30;
  static const int missedDoseThreshold = 60;

  // Scheduled times limits
  static const int maxScheduledTimesPerDay = 12;
}
