import 'package:nephro_care/features/trackers/lab_tests/lab_test_enums.dart';

class LabResultConstants {
  // Collection name in Firebase
  static const String labResultFirebaseCollectionName =
      'Lab_Results_Collection';

  // UI/Display limits
  static const int labNameMaxChars = 100;
  static const int notesMaxChars = 500;
  static const int orderedByMaxChars = 100;

  // Value formatting
  static const int valueDecimalPlaces = 2;

  // Date constraints
  static const int maxFutureDaysAllowed =
      0; // Lab results can't be in the future
  static const int maxPastYearsAllowed =
      10; // How far back lab results can be recorded

  // Reference range defaults (can be overridden per test)
  static const double defaultReferenceRangeLow = 0.0;
  static const double defaultReferenceRangeHigh = 100.0;

  // Status thresholds for automatic categorization
  static const double criticalLowPercentage = 0.5; // 50% below reference low
  static const double criticalHighPercentage = 1.5; // 150% above reference high
  static const double borderlineRangePercentage =
      0.1; // 10% within range boundaries

  // Batch operations
  static const int maxBatchUploadSize = 50; // Max lab results to upload at once

  // Cache/Storage
  static const int recentResultsCacheSize =
      100; // Number of recent results to cache
  static const Duration cacheDuration = Duration(hours: 24);

  // ========== REFERENCE RANGES BY TEST TYPE ==========
  // Format: {low, high} for each test

  static const Map<CKDLabTest, ({double low, double high})> referenceRanges = {
    // ===== KIDNEY FUNCTION =====
    // Note: Use creatinineM or creatinineF for gender-specific ranges
    CKDLabTest.eGFR: (low: 90.0, high: 120.0),
    // mL/min/1.73m² (>60 is acceptable)
    CKDLabTest.bloodUreaNitrogen: (low: 7.0, high: 20.0),
    // mg/dL

    // ===== ELECTROLYTES =====
    CKDLabTest.potassium: (low: 3.5, high: 5.0),
    // mEq/L
    CKDLabTest.sodium: (low: 136.0, high: 145.0),
    // mEq/L
    CKDLabTest.chloride: (low: 96.0, high: 106.0),
    // mEq/L
    CKDLabTest.bicarbonate: (low: 22.0, high: 29.0),
    // mEq/L

    // ===== BONE & MINERAL METABOLISM =====
    CKDLabTest.calcium: (low: 8.5, high: 10.5),
    // mg/dL
    CKDLabTest.phosphate: (low: 2.5, high: 4.5),
    // mg/dL
    CKDLabTest.parathyroidHormone: (low: 10.0, high: 65.0),
    // pg/mL
    CKDLabTest.alkalinePhosphatase: (low: 30.0, high: 120.0),
    // U/L

    // ===== ANEMIA MARKERS =====
    // Note: Use hemoglobinM/F, hematocritM/F, redBloodCellCountM/F for gender-specific ranges
    CKDLabTest.ferritin: (low: 30.0, high: 300.0),
    // ng/mL
    CKDLabTest.transferrinSaturation: (low: 20.0, high: 50.0),
    // %

    // ===== PROTEINURIA / URINALYSIS =====
    CKDLabTest.urineAlbuminToCreatinineRatio: (low: 0.0, high: 30.0),
    // mg/g (<30 is normal)
    CKDLabTest.urineProteinToCreatinineRatio: (low: 0.0, high: 200.0),
    // mg/g

    // ===== GLUCOSE & METABOLIC =====
    CKDLabTest.glucose: (low: 70.0, high: 100.0),
    // mg/dL (fasting)
    CKDLabTest.hba1c: (low: 4.0, high: 5.6),
    // % (<5.7 is normal)
    CKDLabTest.uricAcid: (low: 3.5, high: 7.2),
    // mg/dL

    // ===== CARDIOVASCULAR RISK (LIPIDS) =====
    CKDLabTest.totalCholesterol: (low: 125.0, high: 200.0),
    // mg/dL
    CKDLabTest.hdlCholesterol: (low: 40.0, high: 60.0),
    // mg/dL (higher is better)
    CKDLabTest.ldlCholesterol: (low: 0.0, high: 100.0),
    // mg/dL (lower is better)
    CKDLabTest.triglycerides: (low: 0.0, high: 150.0),
    // mg/dL

    // ===== LIVER FUNCTION =====
    CKDLabTest.alt: (low: 7.0, high: 56.0),
    // U/L
    CKDLabTest.ast: (low: 10.0, high: 40.0),
    // U/L
    CKDLabTest.bilirubin: (low: 0.1, high: 1.2),
    // mg/dL

    // ===== COAGULATION =====
    CKDLabTest.prothrombinTime: (low: 11.0, high: 13.5),
    // seconds
    CKDLabTest.inr: (low: 0.8, high: 1.1),
    // ratio
    CKDLabTest.partialThromboplastinTime: (low: 25.0, high: 35.0),
    // seconds
  };

  // ===== GENDER-SPECIFIC REFERENCE RANGES =====
  // Male-specific ranges
  static const Map<CKDLabTest, ({double low, double high})> referenceRangesM = {
    CKDLabTest.creatinine: (low: 0.7, high: 1.3), // mg/dL (Male)
    CKDLabTest.hemoglobin: (low: 13.5, high: 17.5), // g/dL (Male)
    CKDLabTest.hematocrit: (low: 38.8, high: 50.0), // % (Male)
    CKDLabTest.redBloodCellCount: (low: 4.7, high: 6.1), // million/μL (Male)
  };

  // Female-specific ranges
  static const Map<CKDLabTest, ({double low, double high})> referenceRangesF = {
    CKDLabTest.creatinine: (low: 0.6, high: 1.1), // mg/dL (Female)
    CKDLabTest.hemoglobin: (low: 12.0, high: 15.5), // g/dL (Female)
    CKDLabTest.hematocrit: (low: 34.9, high: 44.5), // % (Female)
    CKDLabTest.redBloodCellCount: (low: 4.2, high: 5.4), // million/μL (Female)
  };

  // ===== CRITICAL VALUE THRESHOLDS =====
  // Values that require immediate medical attention
  static const Map<CKDLabTest, ({double? criticalLow, double? criticalHigh})>
      criticalThresholds = {
    // Kidney Function
    CKDLabTest.creatinine: (criticalLow: null, criticalHigh: 3.0),
    CKDLabTest.eGFR: (criticalLow: 15.0, criticalHigh: null),
    CKDLabTest.bloodUreaNitrogen: (criticalLow: null, criticalHigh: 50.0),

    // Electrolytes - Critical for cardiac function
    CKDLabTest.potassium: (criticalLow: 2.5, criticalHigh: 6.0),
    CKDLabTest.sodium: (criticalLow: 120.0, criticalHigh: 160.0),
    CKDLabTest.chloride: (criticalLow: 80.0, criticalHigh: 115.0),
    CKDLabTest.bicarbonate: (criticalLow: 10.0, criticalHigh: 40.0),

    // Bone & Mineral
    CKDLabTest.calcium: (criticalLow: 6.5, criticalHigh: 13.0),
    CKDLabTest.phosphate: (criticalLow: 1.0, criticalHigh: 8.0),

    // Anemia
    CKDLabTest.hemoglobin: (criticalLow: 7.0, criticalHigh: null),

    // Glucose
    CKDLabTest.glucose: (criticalLow: 40.0, criticalHigh: 400.0),

    // Coagulation
    CKDLabTest.inr: (criticalLow: null, criticalHigh: 5.0),
  };

  // ===== GENDER-SPECIFIC CRITICAL THRESHOLDS =====
  static const Map<CKDLabTest, ({double? criticalLow, double? criticalHigh})>
      criticalThresholdsM = {
    CKDLabTest.creatinine: (criticalLow: null, criticalHigh: 3.5), // Male
    CKDLabTest.hemoglobin: (criticalLow: 7.0, criticalHigh: null), // Male
  };

  static const Map<CKDLabTest, ({double? criticalLow, double? criticalHigh})>
      criticalThresholdsF = {
    CKDLabTest.creatinine: (criticalLow: null, criticalHigh: 2.5), // Female
    CKDLabTest.hemoglobin: (criticalLow: 6.5, criticalHigh: null), // Female
  };

  // ===== TARGET RANGES FOR CKD PATIENTS =====
  // May differ from general population reference ranges
  static const Map<CKDLabTest, ({double low, double high})> ckdTargetRanges = {
    CKDLabTest.eGFR: (low: 60.0, high: 120.0),
    // Stage 1-2 CKD
    CKDLabTest.potassium: (low: 3.5, high: 5.0),
    // Tight control needed
    CKDLabTest.phosphate: (low: 2.5, high: 4.5),
    // CKD-MBD management
    CKDLabTest.calcium: (low: 8.4, high: 9.5),
    // CKD-MBD management
    CKDLabTest.parathyroidHormone: (low: 150.0, high: 300.0),
    // Stage 3-4 CKD
    CKDLabTest.hemoglobin: (low: 11.0, high: 13.0),
    // CKD anemia target
    CKDLabTest.transferrinSaturation: (low: 20.0, high: 50.0),
    // Iron management
    CKDLabTest.urineAlbuminToCreatinineRatio: (low: 0.0, high: 30.0),
    // Albuminuria control
    CKDLabTest.hba1c: (low: 6.5, high: 7.0),
    // Diabetic nephropathy patients
  };
}
