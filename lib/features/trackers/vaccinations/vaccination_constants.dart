class VaccinationConstants {
  // Firebase
  static const String vaccinationFirebaseCollectionName =
      'Vaccinations_Collection';
  static const String vaccinationHistoryCollectionName =
      'Vaccination_History_Collection';
  
  // Name constraints
  static const int vaccineNameMaxChars = 60;
  static const int manufacturerMaxChars = 50;
  static const int lotNumberMaxChars = 30;
  static const int batchNumberMaxChars = 30;
  static const int notesMaxChars = 500;

  // Standard intervals between doses (in days)
  static const int covid19StandardInterval = 21; // 3 weeks
  static const int hepatitisAInterval = 180; // 6 months
  static const int hepatitisBInterval = 30; // 1 month (3-dose series)
  static const int hpvInterval = 60; // 2 months
  static const int influenzaAnnualInterval = 365; // 1 year
  static const int tetanusBoosterInterval = 3650; // 10 years
  static const int shinglesInterval = 60; // 2-6 months

  // Due date calculation
  static const int overdueDaysThreshold = 7; // 1 week past due
  static const int upcomingDaysThreshold = 30; // Due within 30 days

  // Reaction monitoring
  static const int reactionMonitoringDays = 14; // 2 weeks
  static const int seriousReactionAlertHours = 48;
}
