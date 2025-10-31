class DialysisConstants {
  // Firebase collection names
  static const String dialysisFirebaseCollectionName = 'Dialysis_Collection';
  
  // Validation limits
  static const int notesMaxChars = 500;

  // Duration constraints (in hours)
  static const double durationMin = 0.0;
  static const double durationMax = 24.0;

  static const double minHemodialysisDuration = 3.0;
  static const double optimalHemodialysisDuration = 4.0;
  static const double maxHemodialysisDuration = 8.0;

  static const double minPeritonealDialysisDuration = 4.0;
  static const double optimalPeritonealDialysisDuration = 8.0;
  static const double maxPeritonealDialysisDuration = 24.0;

  // Weight change thresholds (in kg)
  static const double minimalWeightChange = 0.5;
  static const double normalWeightChangeMin = 1.0;
  static const double normalWeightChangeMax = 3.0;
  static const double highWeightChangeThreshold = 5.0;

  // Ultrafiltration rate thresholds (ml/hour)
  static const double optimalUFRate = 500.0;
  static const double acceptableUFRate = 1000.0;
  static const double highUFRate = 1500.0;

  // Helper method to get min duration for dialysis type
  static double getMinDuration(String dialysisType) {
    switch (dialysisType) {
      case 'hemodialysis':
        return minHemodialysisDuration;
      case 'peritonealDialysis':
        return minPeritonealDialysisDuration;
      default:
        return durationMin;
    }
  }

  // Helper method to get max duration for dialysis type
  static double getMaxDuration(String dialysisType) {
    switch (dialysisType) {
      case 'hemodialysis':
        return maxHemodialysisDuration;
      case 'peritonealDialysis':
        return maxPeritonealDialysisDuration;
      default:
        return durationMax;
    }
  }

  // Helper method to get optimal duration for dialysis type
  static double getOptimalDuration(String dialysisType) {
    switch (dialysisType) {
      case 'hemodialysis':
        return optimalHemodialysisDuration;
      case 'peritonealDialysis':
        return optimalPeritonealDialysisDuration;
      default:
        return durationMin;
    }
  }
}
