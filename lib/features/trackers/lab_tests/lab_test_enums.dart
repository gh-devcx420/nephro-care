//Todo: Create separate folders for CBC , RFT & others while keeping generics separate

enum LabTestType {
  rft,
  cbc,
}

extension LabTestTypeExtension on LabTestType {
  String get labTestTypeAsString {
    switch (this) {
      case LabTestType.rft:
        return "renal_function_test";
      case LabTestType.cbc:
        return "CBC";
    }
  }

  String get labTestFullName {
    switch (this) {
      case LabTestType.rft:
        return "Renal Function Test";
      case LabTestType.cbc:
        return "Complete Blood Count";
    }
  }
}

/// Status of a Lab Result (covers both quantitative and qualitative outcomes)
enum LabResultStatus {
  // ===== Quantitative Status =====
  normal,
  borderline,
  abnormalLow,
  abnormalHigh,
  critical,
  pending,

  // ===== Qualitative / Semi-Quantitative =====
  notApplicable, // For non-numeric results
  positive,
  negative,
  trace,
  onePlus,
  twoPlus,
  threePlus,
  fourPlus,
  reactive,
  nonReactive,
  detected,
  notDetected,
  present,
  absent,
  abnormal,
  indeterminate,
}

extension LabResultStatusExtension on LabResultStatus {
  /// Human-readable label for UI
  String get displayName {
    switch (this) {
      // Quantitative
      case LabResultStatus.normal:
        return 'Normal';
      case LabResultStatus.borderline:
        return 'Borderline';
      case LabResultStatus.abnormalLow:
        return 'Low';
      case LabResultStatus.abnormalHigh:
        return 'High';
      case LabResultStatus.critical:
        return 'Critical';
      case LabResultStatus.pending:
        return 'Pending';

      // Qualitative / Semi-Quantitative
      case LabResultStatus.notApplicable:
        return 'N/A';
      case LabResultStatus.positive:
        return 'Positive';
      case LabResultStatus.negative:
        return 'Negative';
      case LabResultStatus.trace:
        return 'Trace';
      case LabResultStatus.onePlus:
        return '+1';
      case LabResultStatus.twoPlus:
        return '+2';
      case LabResultStatus.threePlus:
        return '+3';
      case LabResultStatus.fourPlus:
        return '+4';
      case LabResultStatus.reactive:
        return 'Reactive';
      case LabResultStatus.nonReactive:
        return 'Non-reactive';
      case LabResultStatus.detected:
        return 'Detected';
      case LabResultStatus.notDetected:
        return 'Not Detected';
      case LabResultStatus.present:
        return 'Present';
      case LabResultStatus.absent:
        return 'Absent';
      case LabResultStatus.abnormal:
        return 'Abnormal';
      case LabResultStatus.indeterminate:
        return 'Indeterminate';
    }
  }

  /// Helper to check if this status represents a quantitative test result
  bool get resultStatus {
    switch (this) {
      case LabResultStatus.normal:
      case LabResultStatus.borderline:
      case LabResultStatus.abnormalLow:
      case LabResultStatus.abnormalHigh:
      case LabResultStatus.critical:
      case LabResultStatus.pending:
        return true;
      default:
        return false;
    }
  }

  /// Helper to check if this status represents a qualitative or descriptive result
  bool get isQualitative => !resultStatus;
}

/// Specific Lab Tests Relevant to CKD Patients
/// Tests are organized in clinical groupings for easier management
/// Todo: Move these to separate folders for each clinical grouping
enum CKDLabTest {
  // ========== KIDNEY FUNCTION ==========
  creatinine,
  eGFR,
  bloodUreaNitrogen,

  // ========== ELECTROLYTES ==========
  potassium,
  sodium,
  chloride,
  bicarbonate,

  // ========== BONE & MINERAL METABOLISM (CKD-MBD) ==========
  calcium,
  phosphate,
  parathyroidHormone, // PTH
  alkalinePhosphatase, // ALP

  // ========== ANEMIA MARKERS ==========
  hemoglobin,
  hematocrit,
  redBloodCellCount,
  ferritin,
  transferrinSaturation,

  // ========== PROTEINURIA / URINALYSIS ==========
  urineAlbuminToCreatinineRatio, // UACR
  urineProteinToCreatinineRatio, // UPCR
  urineDipstickProtein,
  microscopicExam,

  // ========== GLUCOSE & METABOLIC ==========
  glucose,
  hba1c,
  uricAcid,

  // ========== CARDIOVASCULAR RISK (LIPIDS) ==========
  totalCholesterol,
  hdlCholesterol,
  ldlCholesterol,
  triglycerides,

  // ========== LIVER FUNCTION ==========
  alt, // Alanine Aminotransferase
  ast, // Aspartate Aminotransferase
  bilirubin,

  // ========== COAGULATION ==========
  prothrombinTime, // PT
  inr, // International Normalized Ratio
  partialThromboplastinTime, // PTT
}

extension CKDLabTestExtension on CKDLabTest {
  String get displayName {
    switch (this) {
      // Kidney Function
      case CKDLabTest.creatinine:
        return 'Creatinine';
      case CKDLabTest.eGFR:
        return 'eGFR';
      case CKDLabTest.bloodUreaNitrogen:
        return 'BUN';

      // Electrolytes
      case CKDLabTest.potassium:
        return 'Potassium (K⁺)';
      case CKDLabTest.sodium:
        return 'Sodium (Na⁺)';
      case CKDLabTest.chloride:
        return 'Chloride (Cl⁻)';
      case CKDLabTest.bicarbonate:
        return 'Bicarbonate (HCO₃⁻)';

      // Bone and Mineral Metabolism
      case CKDLabTest.calcium:
        return 'Calcium';
      case CKDLabTest.phosphate:
        return 'Phosphate (P)';
      case CKDLabTest.parathyroidHormone:
        return 'PTH';
      case CKDLabTest.alkalinePhosphatase:
        return 'ALP';

      // Anemia Markers
      case CKDLabTest.hemoglobin:
        return 'Hemoglobin';
      case CKDLabTest.hematocrit:
        return 'Hematocrit';
      case CKDLabTest.redBloodCellCount:
        return 'RBC Count';
      case CKDLabTest.ferritin:
        return 'Ferritin';
      case CKDLabTest.transferrinSaturation:
        return 'TSAT';

      // Proteinuria / Urinalysis
      case CKDLabTest.urineAlbuminToCreatinineRatio:
        return 'UACR';
      case CKDLabTest.urineProteinToCreatinineRatio:
        return 'UPCR';
      case CKDLabTest.urineDipstickProtein:
        return 'Urine Protein (Dipstick)';
      case CKDLabTest.microscopicExam:
        return 'Urine Microscopic Exam';

      // Glucose & Metabolic
      case CKDLabTest.glucose:
        return 'Glucose (Fasting)';
      case CKDLabTest.hba1c:
        return 'HbA1c';
      case CKDLabTest.uricAcid:
        return 'Uric Acid';

      // Cardiovascular Risk (Lipids)
      case CKDLabTest.totalCholesterol:
        return 'Total Cholesterol';
      case CKDLabTest.hdlCholesterol:
        return 'HDL-C';
      case CKDLabTest.ldlCholesterol:
        return 'LDL-C';
      case CKDLabTest.triglycerides:
        return 'Triglycerides';

      // Liver Function
      case CKDLabTest.alt:
        return 'ALT';
      case CKDLabTest.ast:
        return 'AST';
      case CKDLabTest.bilirubin:
        return 'Bilirubin (Total)';

      // Coagulation
      case CKDLabTest.prothrombinTime:
        return 'Prothrombin Time (PT)';
      case CKDLabTest.inr:
        return 'INR';
      case CKDLabTest.partialThromboplastinTime:
        return 'PTT';
    }
  }

  /// Get the typical unit of measurement for each test
  String get unit {
    switch (this) {
      // Kidney Function
      case CKDLabTest.creatinine:
        return 'mg/dL';
      case CKDLabTest.eGFR:
        return 'mL/min/1.73m²';
      case CKDLabTest.bloodUreaNitrogen:
        return 'mg/dL';

      // Electrolytes
      case CKDLabTest.potassium:
      case CKDLabTest.sodium:
      case CKDLabTest.chloride:
      case CKDLabTest.bicarbonate:
        return 'mEq/L';

      // Bone and Mineral Metabolism
      case CKDLabTest.calcium:
        return 'mg/dL';
      case CKDLabTest.phosphate:
        return 'mg/dL';
      case CKDLabTest.parathyroidHormone:
        return 'pg/mL';
      case CKDLabTest.alkalinePhosphatase:
        return 'U/L';

      // Anemia Markers
      case CKDLabTest.hemoglobin:
        return 'g/dL';
      case CKDLabTest.hematocrit:
        return '%';
      case CKDLabTest.redBloodCellCount:
        return 'million/μL';
      case CKDLabTest.ferritin:
        return 'ng/mL';
      case CKDLabTest.transferrinSaturation:
        return '%';

      // Proteinuria / Urinalysis
      case CKDLabTest.urineAlbuminToCreatinineRatio:
      case CKDLabTest.urineProteinToCreatinineRatio:
        return 'mg/g';
      case CKDLabTest.urineDipstickProtein:
        return 'qualitative';
      case CKDLabTest.microscopicExam:
        return 'descriptive';

      // Glucose & Metabolic
      case CKDLabTest.glucose:
        return 'mg/dL';
      case CKDLabTest.hba1c:
        return '%';
      case CKDLabTest.uricAcid:
        return 'mg/dL';

      // Cardiovascular Risk (Lipids)
      case CKDLabTest.totalCholesterol:
      case CKDLabTest.hdlCholesterol:
      case CKDLabTest.ldlCholesterol:
      case CKDLabTest.triglycerides:
        return 'mg/dL';

      // Liver Function
      case CKDLabTest.alt:
      case CKDLabTest.ast:
        return 'U/L';
      case CKDLabTest.bilirubin:
        return 'mg/dL';

      // Coagulation
      case CKDLabTest.prothrombinTime:
      case CKDLabTest.partialThromboplastinTime:
        return 'seconds';
      case CKDLabTest.inr:
        return 'ratio';
    }
  }

  /// Helper to get section header for UI grouping
  /// Returns the clinical grouping name for organizing tests in the UI
  String get sectionHeaderTitle {
    if (this.index <= CKDLabTest.bloodUreaNitrogen.index) {
      return 'Kidney Function';
    } else if (this.index <= CKDLabTest.bicarbonate.index) {
      return 'Electrolytes';
    } else if (this.index <= CKDLabTest.alkalinePhosphatase.index) {
      return 'Bone & Mineral Metabolism';
    } else if (this.index <= CKDLabTest.transferrinSaturation.index) {
      return 'Anemia Markers';
    } else if (this.index <= CKDLabTest.microscopicExam.index) {
      return 'Proteinuria / Urinalysis';
    } else if (this.index <= CKDLabTest.uricAcid.index) {
      return 'Glucose & Metabolic';
    } else if (this.index <= CKDLabTest.triglycerides.index) {
      return 'Cardiovascular Risk';
    } else if (this.index <= CKDLabTest.bilirubin.index) {
      return 'Liver Function';
    } else {
      return 'Coagulation';
    }
  }
}
