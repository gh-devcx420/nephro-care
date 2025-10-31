// Injections
enum InjectionRoute {
  intravenous, // IV - Directly into a vein
  intramuscular, // IM - Into a muscle
  subcutaneous, // SC - Into the fatty tissue
  intradermal, // ID - Into the skin layers
  epidural, // Into the space around the spinal cord
  intraosseous, // IO - Into the bone marrow (emergencies)
  intranasal, // NAS - Nasal spray
  intraperitoneal, // IP - Into the peritoneal cavity
  intrathecal, // IT - Into the spinal canal
  other,
  unknown,
}

extension InjectionRouteExtension on InjectionRoute {
  String get displayName {
    switch (this) {
      case InjectionRoute.intravenous:
        return 'Intravenous (IV)';
      case InjectionRoute.intramuscular:
        return 'Intramuscular (IM)';
      case InjectionRoute.subcutaneous:
        return 'Subcutaneous (SC)';
      case InjectionRoute.intradermal:
        return 'Intradermal (ID)';
      case InjectionRoute.epidural:
        return 'Epidural';
      case InjectionRoute.intraosseous:
        return 'Intraosseous (IO)';
      case InjectionRoute.intranasal:
        return 'Intranasal (NAS)';
      case InjectionRoute.intraperitoneal:
        return 'Intraperitoneal (IP)';
      case InjectionRoute.intrathecal:
        return 'Intrathecal (IT)';
      case InjectionRoute.other:
        return 'Other';
      case InjectionRoute.unknown:
        return 'Unknown';
    }
  }

  String get abbreviation {
    switch (this) {
      case InjectionRoute.intravenous:
        return 'IV';
      case InjectionRoute.intramuscular:
        return 'IM';
      case InjectionRoute.subcutaneous:
        return 'SC';
      case InjectionRoute.intradermal:
        return 'ID';
      case InjectionRoute.epidural:
        return 'Epidural';
      case InjectionRoute.intraosseous:
        return 'IO';
      case InjectionRoute.intranasal:
        return 'NAS';
      case InjectionRoute.intraperitoneal:
        return 'IP';
      case InjectionRoute.intrathecal:
        return 'IT';
      case InjectionRoute.other:
        return 'Other';
      case InjectionRoute.unknown:
        return 'Unknown';
    }
  }
}

enum InjectionSite {
  leftDeltoid,
  rightDeltoid,
  leftThigh,
  rightThigh,
  leftGluteal,
  rightGluteal,
  abdomen,
  leftForearm,
  rightForearm,
  leftUpperArm,
  rightUpperArm,
  avFistula, // For dialysis patients
  avGraft, // For dialysis patients
  centralLine, // For dialysis/IV access
  other,
  notApplicable,
}

extension InjectionSiteExtension on InjectionSite {
  String get displayName {
    switch (this) {
      case InjectionSite.leftDeltoid:
        return 'Left Deltoid (Shoulder)';
      case InjectionSite.rightDeltoid:
        return 'Right Deltoid (Shoulder)';
      case InjectionSite.leftThigh:
        return 'Left Thigh';
      case InjectionSite.rightThigh:
        return 'Right Thigh';
      case InjectionSite.leftGluteal:
        return 'Left Gluteal (Buttock)';
      case InjectionSite.rightGluteal:
        return 'Right Gluteal (Buttock)';
      case InjectionSite.abdomen:
        return 'Abdomen';
      case InjectionSite.leftForearm:
        return 'Left Forearm';
      case InjectionSite.rightForearm:
        return 'Right Forearm';
      case InjectionSite.leftUpperArm:
        return 'Left Upper Arm';
      case InjectionSite.rightUpperArm:
        return 'Right Upper Arm';
      case InjectionSite.avFistula:
        return 'AV Fistula';
      case InjectionSite.avGraft:
        return 'AV Graft';
      case InjectionSite.centralLine:
        return 'Central Line';
      case InjectionSite.other:
        return 'Other Site';
      case InjectionSite.notApplicable:
        return 'Not Applicable';
    }
  }
}

enum InjectionType {
  medication, // Drug administration
  dialysisRelated, // Post-HD EPO, iron, etc.
  vaccine, // Immunization
  allergyShot, // Immunotherapy
  diagnostic, // Contrast, skin tests
  therapeutic, // Joint injection, trigger point
  emergency, // Epinephrine, naloxone
  other,
}

extension InjectionTypeExtension on InjectionType {
  String get displayName {
    switch (this) {
      case InjectionType.medication:
        return 'Medication';
      case InjectionType.dialysisRelated:
        return 'Dialysis Related';
      case InjectionType.vaccine:
        return 'Vaccine';
      case InjectionType.allergyShot:
        return 'Allergy Shot';
      case InjectionType.diagnostic:
        return 'Diagnostic';
      case InjectionType.therapeutic:
        return 'Therapeutic Procedure';
      case InjectionType.emergency:
        return 'Emergency';
      case InjectionType.other:
        return 'Other';
    }
  }
}

enum InjectionReaction {
  none,
  mildPain,
  moderatePain,
  severePain,
  swelling,
  redness,
  bruising,
  itching,
  rash,
  bleeding,
  allergicReaction,
  other,
}

extension InjectionReactionExtension on InjectionReaction {
  String get displayName {
    switch (this) {
      case InjectionReaction.none:
        return 'No Reaction';
      case InjectionReaction.mildPain:
        return 'Mild Pain';
      case InjectionReaction.moderatePain:
        return 'Moderate Pain';
      case InjectionReaction.severePain:
        return 'Severe Pain';
      case InjectionReaction.swelling:
        return 'Swelling';
      case InjectionReaction.redness:
        return 'Redness';
      case InjectionReaction.bruising:
        return 'Bruising';
      case InjectionReaction.itching:
        return 'Itching';
      case InjectionReaction.rash:
        return 'Rash';
      case InjectionReaction.bleeding:
        return 'Bleeding';
      case InjectionReaction.allergicReaction:
        return 'Allergic Reaction';
      case InjectionReaction.other:
        return 'Other Reaction';
    }
  }

  bool get isSerious {
    return this == InjectionReaction.severePain ||
        this == InjectionReaction.allergicReaction;
  }
}
