class InjectionConstants {
  // Firebase
  static const String injectionFirebaseCollectionName = 'Injections_Collection';
  static const String injectionHistoryCollectionName =
      'Injection_History_Collection';
  
  // Name constraints
  static const int drugNameMaxChars = 50;
  static const int dosageMaxChars = 20;
  static const int lotNumberMaxChars = 30;
  static const int batchNumberMaxChars = 30;
  static const int notesMaxChars = 500;

  // Site rotation recommendations (in days)
  static const int minDaysBetweenSameSite = 2;
  static const int recommendedSiteRotationDays = 7;

  // Reaction monitoring
  static const int reactionMonitoringHours = 72; // 3 days
  static const int seriousReactionAlertHours = 24;

  // Dialysis-specific
  static const int postDialysisInjectionWindowMinutes = 30;
  static const int maxInjectionsPerDialysisSession = 5;
}
