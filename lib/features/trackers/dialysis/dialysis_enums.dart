import 'package:intl/intl.dart';

enum DialysisSession {
  type,
  access,
  duration,
  preWeight,
  postWeight,
  preDialysisBPResting,
  preDialysisBPStanding,
  postDialysisBPResting,
  postDialysisBPStanding,
  ultrafiltration,
  notes,
  time,
}

extension DialysisSessionExtension on DialysisSession {
  String get fieldName {
    switch (this) {
      case DialysisSession.type:
        return 'Dialysis Type';
      case DialysisSession.access:
        return 'Access Type';
      case DialysisSession.duration:
        return 'Duration';
      case DialysisSession.preWeight:
        return 'Pre-Dialysis Weight';
      case DialysisSession.postWeight:
        return 'Post-Dialysis Weight';
      case DialysisSession.preDialysisBPResting:
        return 'Pre-Dialysis BP (Resting)';
      case DialysisSession.preDialysisBPStanding:
        return 'Pre-Dialysis BP (Standing)';
      case DialysisSession.postDialysisBPResting:
        return 'Post-Dialysis BP (Resting)';
      case DialysisSession.postDialysisBPStanding:
        return 'Post-Dialysis BP (Standing)';
      case DialysisSession.ultrafiltration:
        return 'Ultrafiltration';
      case DialysisSession.notes:
        return 'Notes';
      case DialysisSession.time:
        return 'Time';
    }
  }

  String get hintText {
    switch (this) {
      case DialysisSession.type:
        return 'Select dialysis type';
      case DialysisSession.access:
        return 'Select access type';
      case DialysisSession.duration:
        return 'Duration (hours)';
      case DialysisSession.preWeight:
        return 'Weight before dialysis';
      case DialysisSession.postWeight:
        return 'Weight after dialysis';
      case DialysisSession.preDialysisBPResting:
        return 'BP before dialysis (resting)';
      case DialysisSession.preDialysisBPStanding:
        return 'BP before dialysis (standing)';
      case DialysisSession.postDialysisBPResting:
        return 'BP after dialysis (resting)';
      case DialysisSession.postDialysisBPStanding:
        return 'BP after dialysis (standing)';
      case DialysisSession.ultrafiltration:
        return 'Fluid removed';
      case DialysisSession.notes:
        return 'Any additional notes';
      case DialysisSession.time:
        return 'Time';
    }
  }

  String get fieldKey {
    switch (this) {
      case DialysisSession.type:
        return 'type_key';
      case DialysisSession.access:
        return 'access_key';
      case DialysisSession.duration:
        return 'duration_key';
      case DialysisSession.preWeight:
        return 'pre_weight_key';
      case DialysisSession.postWeight:
        return 'post_weight_key';
      case DialysisSession.preDialysisBPResting:
        return 'pre_bp_resting_key';
      case DialysisSession.preDialysisBPStanding:
        return 'pre_bp_standing_key';
      case DialysisSession.postDialysisBPResting:
        return 'post_bp_resting_key';
      case DialysisSession.postDialysisBPStanding:
        return 'post_bp_standing_key';
      case DialysisSession.ultrafiltration:
        return 'ultrafiltration_key';
      case DialysisSession.notes:
        return 'notes_key';
      case DialysisSession.time:
        return 'time_key';
    }
  }
}

enum DialysisType {
  hemodialysis,
  peritonealDialysis,
  none,
}

extension DialysisTypeExtension on DialysisType {
  String get displayName {
    switch (this) {
      case DialysisType.hemodialysis:
        return 'Hemodialysis';
      case DialysisType.peritonealDialysis:
        return 'Peritoneal Dialysis';
      case DialysisType.none:
        return 'Not on Dialysis';
    }
  }

  String get abbreviation {
    switch (this) {
      case DialysisType.hemodialysis:
        return 'HD';
      case DialysisType.peritonealDialysis:
        return 'PD';
      case DialysisType.none:
        return 'N/A';
    }
  }
}

enum DialysisAccess {
  // Arteriovenous Fistula
  avFistulaLeftArm,
  avFistulaRightArm,
  avFistulaOther,

  // Arteriovenous Graft
  avGraftLeftArm,
  avGraftRightArm,
  avGraftOther,

  // Central Venous Catheters
  cvcRightInternalJugular,
  cvcLeftInternalJugular,
  cvcRightSubclavian,
  cvcLeftSubclavian,
  cvcRightFemoral,
  cvcLeftFemoral,
  cvcOther,

  // Peritoneal Dialysis
  peritonealCatheter,

  // None / Unknown
  none,
  unknown,
}

extension DialysisAccessExtension on DialysisAccess {
  String get displayName {
    switch (this) {
      case DialysisAccess.avFistulaLeftArm:
        return 'AV Fistula (Left Arm)';
      case DialysisAccess.avFistulaRightArm:
        return 'AV Fistula (Right Arm)';
      case DialysisAccess.avFistulaOther:
        return 'AV Fistula (Other Site)';

      case DialysisAccess.avGraftLeftArm:
        return 'AV Graft (Left Arm)';
      case DialysisAccess.avGraftRightArm:
        return 'AV Graft (Right Arm)';
      case DialysisAccess.avGraftOther:
        return 'AV Graft (Other Site)';

      case DialysisAccess.cvcRightInternalJugular:
        return 'Central Catheter (Right IJ)';
      case DialysisAccess.cvcLeftInternalJugular:
        return 'Central Catheter (Left IJ)';
      case DialysisAccess.cvcRightSubclavian:
        return 'Central Catheter (Right Subclavian)';
      case DialysisAccess.cvcLeftSubclavian:
        return 'Central Catheter (Left Subclavian)';
      case DialysisAccess.cvcRightFemoral:
        return 'Central Catheter (Right Femoral)';
      case DialysisAccess.cvcLeftFemoral:
        return 'Central Catheter (Left Femoral)';
      case DialysisAccess.cvcOther:
        return 'Central Catheter (Other Site)';

      case DialysisAccess.peritonealCatheter:
        return 'Peritoneal Dialysis Catheter';

      case DialysisAccess.none:
        return 'No Access';
      case DialysisAccess.unknown:
        return 'Unknown';
    }
  }

  String get location {
    switch (this) {
      case DialysisAccess.avFistulaLeftArm:
      case DialysisAccess.avFistulaRightArm:
      case DialysisAccess.avFistulaOther:
      case DialysisAccess.avGraftLeftArm:
      case DialysisAccess.avGraftRightArm:
      case DialysisAccess.avGraftOther:
        return 'Upper extremity (usually arm)';

      case DialysisAccess.cvcRightInternalJugular:
      case DialysisAccess.cvcLeftInternalJugular:
        return 'Neck (Internal Jugular vein)';

      case DialysisAccess.cvcRightSubclavian:
      case DialysisAccess.cvcLeftSubclavian:
        return 'Chest (Subclavian vein)';

      case DialysisAccess.cvcRightFemoral:
      case DialysisAccess.cvcLeftFemoral:
        return 'Groin (Femoral vein)';

      case DialysisAccess.cvcOther:
        return 'Other central venous site';

      case DialysisAccess.peritonealCatheter:
        return 'Abdomen';

      case DialysisAccess.none:
      case DialysisAccess.unknown:
        return 'N/A';
    }
  }
}

enum DialysisDuration {
  hours,
}

extension DialysisDurationExtension on DialysisDuration {
  String get name {
    switch (this) {
      case DialysisDuration.hours:
        return 'Hours';
    }
  }

  String get siUnit {
    switch (this) {
      case DialysisDuration.hours:
        return 'hrs';
    }
  }

  NumberFormat get valueFormat {
    switch (this) {
      case DialysisDuration.hours:
        return NumberFormat('#.#');
    }
  }
}
