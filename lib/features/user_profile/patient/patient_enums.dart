import 'package:nephro_care/core/constants/nc_app_icons.dart';

///Patient enums
enum Patient {
  name,
  age,
  height,
  weight,
}

extension PatientExtension on Patient {
  String get displayName {
    switch (this) {
      case Patient.name:
        return 'Name';
      case Patient.age:
        return 'Age';
      case Patient.height:
        return 'Height';
      case Patient.weight:
        return 'Weight';
    }
  }
}

///Gender enums
enum Gender {
  male,
  female,
  other,
}

extension GenderExtension on Gender {
  String get displayName {
    switch (this) {
      case Gender.male:
        return 'Male';
      case Gender.female:
        return 'Female';
      case Gender.other:
        return 'Other';
    }
  }
}

///Blood Group Enums
enum BloodGroup {
  aPositive,
  aNegative,
  bPositive,
  bNegative,
  abPositive,
  abNegative,
  oPositive,
  oNegative
}

extension BloodGroupExtension on BloodGroup {
  String get getName {
    switch (this) {
      case BloodGroup.aPositive:
        return 'A+';
      case BloodGroup.aNegative:
        return 'A-';
      case BloodGroup.bPositive:
        return 'B+';
      case BloodGroup.bNegative:
        return 'B-';
      case BloodGroup.abPositive:
        return 'AB+';
      case BloodGroup.abNegative:
        return 'AB-';
      case BloodGroup.oPositive:
        return 'O+';
      case BloodGroup.oNegative:
        return 'O-';
    }
  }

  String get getNCIcon {
    switch (this) {
      case BloodGroup.aPositive:
        return NCIcons.bloodTypeAPlus;
      case BloodGroup.aNegative:
        return NCIcons.bloodTypeAMinus;
      case BloodGroup.bPositive:
        return NCIcons.bloodTypeBPlus;
      case BloodGroup.bNegative:
        return NCIcons.bloodTypeBMinus;
      case BloodGroup.abPositive:
        return NCIcons.bloodTypeABPlus;
      case BloodGroup.abNegative:
        return NCIcons.bloodTypeABMinus;
      case BloodGroup.oPositive:
        return NCIcons.bloodTypeOPlus;
      case BloodGroup.oNegative:
        return NCIcons.bloodTypeOMinus;
    }
  }
}

///Primary cause of CKD
enum CKDCause {
  diabeticNephropathy,
  hypertensiveNephropathy,
  glomerulonephritis,
  polycysticKidneyDisease,
  interstitialNephritis,
  obstructiveNephropathy,
  vascularDisease,
  congenital,
  unknown,
  other,
}

extension CKDCauseExtension on CKDCause {
  String get displayName {
    switch (this) {
      case CKDCause.diabeticNephropathy:
        return 'Diabetic Nephropathy';
      case CKDCause.hypertensiveNephropathy:
        return 'Hypertensive Nephropathy';
      case CKDCause.glomerulonephritis:
        return 'Glomerulonephritis';
      case CKDCause.polycysticKidneyDisease:
        return 'Polycystic Kidney Disease';
      case CKDCause.interstitialNephritis:
        return 'Interstitial Nephritis';
      case CKDCause.obstructiveNephropathy:
        return 'Obstructive Nephropathy';
      case CKDCause.vascularDisease:
        return 'Vascular Disease';
      case CKDCause.congenital:
        return 'Congenital Abnormality';
      case CKDCause.unknown:
        return 'Unknown';
      case CKDCause.other:
        return 'Other';
    }
  }
}

///Chronic Kidney Disease stages based on GFR
enum CKDStage {
  stage1, // GFR ≥90
  stage2, // GFR 60-89
  stage3A, // GFR 45-59
  stage3B, // GFR 30-44
  stage4, // GFR 15-29
  stage5, // GFR <15 (not on dialysis)
  stage5D, // GFR <15 (on dialysis)
  unknown,
}

extension CKDStageExtension on CKDStage {
  String get displayName {
    switch (this) {
      case CKDStage.stage1:
        return 'Stage 1';
      case CKDStage.stage2:
        return 'Stage 2';
      case CKDStage.stage3A:
        return 'Stage 3A';
      case CKDStage.stage3B:
        return 'Stage 3B';
      case CKDStage.stage4:
        return 'Stage 4';
      case CKDStage.stage5:
        return 'Stage 5';
      case CKDStage.stage5D:
        return 'Stage 5D';
      case CKDStage.unknown:
        return 'Unknown';
    }
  }

  String get description {
    switch (this) {
      case CKDStage.stage1:
        return 'Normal kidney function with kidney damage';
      case CKDStage.stage2:
        return 'Mild reduction in kidney function';
      case CKDStage.stage3A:
        return 'Mild to moderate reduction';
      case CKDStage.stage3B:
        return 'Moderate to severe reduction';
      case CKDStage.stage4:
        return 'Severe reduction in kidney function';
      case CKDStage.stage5:
        return 'Kidney failure (not on dialysis)';
      case CKDStage.stage5D:
        return 'Kidney failure (on dialysis)';
      case CKDStage.unknown:
        return 'Stage not determined';
    }
  }

  String get gfrRange {
    switch (this) {
      case CKDStage.stage1:
        return '≥90';
      case CKDStage.stage2:
        return '60-89';
      case CKDStage.stage3A:
        return '45-59';
      case CKDStage.stage3B:
        return '30-44';
      case CKDStage.stage4:
        return '15-29';
      case CKDStage.stage5:
      case CKDStage.stage5D:
        return '<15';
      case CKDStage.unknown:
        return 'N/A';
    }
  }

  int get severity {
    switch (this) {
      case CKDStage.stage1:
        return 1;
      case CKDStage.stage2:
        return 2;
      case CKDStage.stage3A:
        return 3;
      case CKDStage.stage3B:
        return 4;
      case CKDStage.stage4:
        return 5;
      case CKDStage.stage5:
      case CKDStage.stage5D:
        return 6;
      case CKDStage.unknown:
        return 0;
    }
  }
}

///Kidney transplant status
enum TransplantStatus {
  notListed,
  underEvaluation,
  listed,
  transplanted,
  notCandidate,
  declined,
}

extension TransplantStatusExtension on TransplantStatus {
  String get displayName {
    switch (this) {
      case TransplantStatus.notListed:
        return 'Not Listed';
      case TransplantStatus.underEvaluation:
        return 'Under Evaluation';
      case TransplantStatus.listed:
        return 'Listed for Transplant';
      case TransplantStatus.transplanted:
        return 'Transplanted';
      case TransplantStatus.notCandidate:
        return 'Not a Candidate';
      case TransplantStatus.declined:
        return 'Declined Transplant';
    }
  }
}

///Dietary restrictions for CKD patients
enum DietRestriction {
  lowSodium,
  lowPotassium,
  lowPhosphorus,
  lowProtein,
  diabetic,
  lowFat,
  renalDiet,
  none,
}

extension DietRestrictionExtension on DietRestriction {
  String get displayName {
    switch (this) {
      case DietRestriction.lowSodium:
        return 'Low Sodium';
      case DietRestriction.lowPotassium:
        return 'Low Potassium';
      case DietRestriction.lowPhosphorus:
        return 'Low Phosphorus';
      case DietRestriction.lowProtein:
        return 'Low Protein';
      case DietRestriction.diabetic:
        return 'Diabetic Diet';
      case DietRestriction.lowFat:
        return 'Low Fat';
      case DietRestriction.renalDiet:
        return 'Renal Diet';
      case DietRestriction.none:
        return 'No restrictions';
    }
  }
}

///Physical activity level
enum ActivityLevel {
  sedentary,
  light,
  moderate,
  active,
  veryActive,
}

extension ActivityLevelExtension on ActivityLevel {
  String get displayName {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Sedentary';
      case ActivityLevel.light:
        return 'Light';
      case ActivityLevel.moderate:
        return 'Moderate';
      case ActivityLevel.active:
        return 'Active';
      case ActivityLevel.veryActive:
        return 'Very Active';
    }
  }

  String get description {
    switch (this) {
      case ActivityLevel.sedentary:
        return 'Little to no exercise';
      case ActivityLevel.light:
        return 'Light exercise 1-3 days/week';
      case ActivityLevel.moderate:
        return 'Moderate exercise 3-5 days/week';
      case ActivityLevel.active:
        return 'Active exercise 6-7 days/week';
      case ActivityLevel.veryActive:
        return 'Very active, physical job or athlete';
    }
  }
}

///Smoking status
enum SmokingStatus {
  never,
  former,
  current,
}

extension SmokingStatusExtension on SmokingStatus {
  String get displayName {
    switch (this) {
      case SmokingStatus.never:
        return 'Never smoked';
      case SmokingStatus.former:
        return 'Former smoker';
      case SmokingStatus.current:
        return 'Current smoker';
    }
  }
}

///Smoking Frequency
enum SmokingFrequency {
  never,
  occasional,
  moderate,
  heavy,
}

extension SmokingFrequencyExtension on SmokingFrequency {
  String get displayName {
    switch (this) {
      case SmokingFrequency.never:
        return 'Never';
      case SmokingFrequency.occasional:
        return 'Occasional';
      case SmokingFrequency.moderate:
        return 'Moderate';
      case SmokingFrequency.heavy:
        return 'Heavy';
    }
  }
}

///Smoking status
enum AlcoholStatus {
  never,
  former,
  current,
}

extension AlcoholStatusExtension on AlcoholStatus {
  String get displayName {
    switch (this) {
      case AlcoholStatus.never:
        return 'Never drank';
      case AlcoholStatus.former:
        return 'Former drinker';
      case AlcoholStatus.current:
        return 'Current drinker';
    }
  }
}

///Alcohol consumption frequency
enum AlcoholConsumption {
  none,
  occasional, // <1 drink/week
  moderate, // 1-7 drinks/week
  heavy, // >7 drinks/week
}

extension AlcoholConsumptionExtension on AlcoholConsumption {
  String get displayName {
    switch (this) {
      case AlcoholConsumption.none:
        return 'None';
      case AlcoholConsumption.occasional:
        return 'Occasional';
      case AlcoholConsumption.moderate:
        return 'Moderate';
      case AlcoholConsumption.heavy:
        return 'Heavy';
    }
  }
}
