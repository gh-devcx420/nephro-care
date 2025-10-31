import 'package:nephro_care/features/trackers/injections/injection_enums.dart';

enum VaccinationStatus {
  completed,
  pending,
  overdue,
  inProgress, // For multi-dose series
  notRequired,
  contraindicated,
  declined,
}

extension VaccinationStatusExtension on VaccinationStatus {
  String get displayName {
    switch (this) {
      case VaccinationStatus.completed:
        return 'Completed';
      case VaccinationStatus.pending:
        return 'Pending';
      case VaccinationStatus.overdue:
        return 'Overdue';
      case VaccinationStatus.inProgress:
        return 'In Progress';
      case VaccinationStatus.notRequired:
        return 'Not Required';
      case VaccinationStatus.contraindicated:
        return 'Contraindicated';
      case VaccinationStatus.declined:
        return 'Declined';
    }
  }

  bool get isActive {
    return this == VaccinationStatus.pending ||
        this == VaccinationStatus.overdue ||
        this == VaccinationStatus.inProgress;
  }
}

enum VaccineType {
  covid19,
  influenza,
  hepatitisA,
  hepatitisB,
  pneumococcal,
  tetanus,
  diphtheria,
  pertussis, // Whooping cough
  measles,
  mumps,
  rubella,
  varicella, // Chickenpox
  shingles, // Herpes zoster
  hpv, // Human papillomavirus
  meningococcal,
  polio,
  rabies,
  typhoid,
  yellowFever,
  tuberculosis, // BCG
  rotavirus,
  hib, // Haemophilus influenzae type b
  other,
}

extension VaccineTypeExtension on VaccineType {
  String get displayName {
    switch (this) {
      case VaccineType.covid19:
        return 'COVID-19';
      case VaccineType.influenza:
        return 'Influenza (Flu)';
      case VaccineType.hepatitisA:
        return 'Hepatitis A';
      case VaccineType.hepatitisB:
        return 'Hepatitis B';
      case VaccineType.pneumococcal:
        return 'Pneumococcal';
      case VaccineType.tetanus:
        return 'Tetanus';
      case VaccineType.diphtheria:
        return 'Diphtheria';
      case VaccineType.pertussis:
        return 'Pertussis (Whooping Cough)';
      case VaccineType.measles:
        return 'Measles';
      case VaccineType.mumps:
        return 'Mumps';
      case VaccineType.rubella:
        return 'Rubella';
      case VaccineType.varicella:
        return 'Varicella (Chickenpox)';
      case VaccineType.shingles:
        return 'Shingles (Herpes Zoster)';
      case VaccineType.hpv:
        return 'HPV';
      case VaccineType.meningococcal:
        return 'Meningococcal';
      case VaccineType.polio:
        return 'Polio';
      case VaccineType.rabies:
        return 'Rabies';
      case VaccineType.typhoid:
        return 'Typhoid';
      case VaccineType.yellowFever:
        return 'Yellow Fever';
      case VaccineType.tuberculosis:
        return 'Tuberculosis (BCG)';
      case VaccineType.rotavirus:
        return 'Rotavirus';
      case VaccineType.hib:
        return 'HIB';
      case VaccineType.other:
        return 'Other';
    }
  }

  /// Common routes for this vaccine type
  List<InjectionRoute> get typicalRoutes {
    switch (this) {
      case VaccineType.covid19:
      case VaccineType.influenza:
      case VaccineType.hepatitisA:
      case VaccineType.hepatitisB:
      case VaccineType.tetanus:
      case VaccineType.diphtheria:
      case VaccineType.pertussis:
      case VaccineType.hpv:
      case VaccineType.meningococcal:
      case VaccineType.rabies:
        return [InjectionRoute.intramuscular];

      case VaccineType.measles:
      case VaccineType.mumps:
      case VaccineType.rubella:
      case VaccineType.varicella:
      case VaccineType.shingles:
        return [InjectionRoute.subcutaneous];

      case VaccineType.tuberculosis:
        return [InjectionRoute.intradermal];

      case VaccineType.influenza: // Some flu vaccines can be nasal
        return [InjectionRoute.intramuscular, InjectionRoute.intranasal];

      case VaccineType.rotavirus:
        return [
          InjectionRoute.intranasal
        ]; // Oral, but using intranasal as closest

      default:
        return [InjectionRoute.intramuscular, InjectionRoute.subcutaneous];
    }
  }

  /// Whether this vaccine typically requires multiple doses
  bool get isMultiDose {
    switch (this) {
      case VaccineType.covid19:
      case VaccineType.hepatitisA:
      case VaccineType.hepatitisB:
      case VaccineType.hpv:
      case VaccineType.rotavirus:
      case VaccineType.pneumococcal:
        return true;
      default:
        return false;
    }
  }
}

enum VaccineReaction {
  none,
  soreness,
  swelling,
  redness,
  fever,
  fatigue,
  headache,
  muscleAches,
  chills,
  nausea,
  lymphNodeSwelling,
  allergicReaction,
  severeReaction,
  other,
}

extension VaccineReactionExtension on VaccineReaction {
  String get displayName {
    switch (this) {
      case VaccineReaction.none:
        return 'No Reaction';
      case VaccineReaction.soreness:
        return 'Soreness at Site';
      case VaccineReaction.swelling:
        return 'Swelling';
      case VaccineReaction.redness:
        return 'Redness';
      case VaccineReaction.fever:
        return 'Fever';
      case VaccineReaction.fatigue:
        return 'Fatigue';
      case VaccineReaction.headache:
        return 'Headache';
      case VaccineReaction.muscleAches:
        return 'Muscle Aches';
      case VaccineReaction.chills:
        return 'Chills';
      case VaccineReaction.nausea:
        return 'Nausea';
      case VaccineReaction.lymphNodeSwelling:
        return 'Lymph Node Swelling';
      case VaccineReaction.allergicReaction:
        return 'Allergic Reaction';
      case VaccineReaction.severeReaction:
        return 'Severe Reaction';
      case VaccineReaction.other:
        return 'Other Reaction';
    }
  }

  bool get isSerious {
    return this == VaccineReaction.allergicReaction ||
        this == VaccineReaction.severeReaction;
  }

  bool get isCommon {
    return this == VaccineReaction.soreness ||
        this == VaccineReaction.fatigue ||
        this == VaccineReaction.headache ||
        this == VaccineReaction.fever;
  }
}
