enum Medication {
  name,
  dosage,
  frequency,
  time,
  startDate,
  endDate,
  reasonForUse,
  status,
  route,
  form,
  prescribedBy,
  pharmacy,
  instructions,
}

extension MedicationExtension on Medication {
  String get fieldName {
    switch (this) {
      case Medication.name:
        return 'Medication Name';
      case Medication.dosage:
        return 'Dosage';
      case Medication.frequency:
        return 'Frequency';
      case Medication.time:
        return 'Time';
      case Medication.startDate:
        return 'Start Date';
      case Medication.endDate:
        return 'End Date';
      case Medication.reasonForUse:
        return 'Reason for Use';
      case Medication.status:
        return 'Status';
      case Medication.route:
        return 'Route of Administration';
      case Medication.form:
        return 'Form';
      case Medication.prescribedBy:
        return 'Prescribed By';
      case Medication.pharmacy:
        return 'Pharmacy';
      case Medication.instructions:
        return 'Instructions';
    }
  }

  String get hintText {
    switch (this) {
      case Medication.name:
        return 'e.g., Aspirin';
      case Medication.dosage:
        return 'e.g., 100mg';
      case Medication.frequency:
        return 'How often';
      case Medication.time:
        return 'Time of day';
      case Medication.startDate:
        return 'When to start';
      case Medication.endDate:
        return 'When to end';
      case Medication.reasonForUse:
        return 'Why taking this medication';
      case Medication.status:
        return 'Current status';
      case Medication.route:
        return 'How to take';
      case Medication.form:
        return 'Tablet, liquid, etc.';
      case Medication.prescribedBy:
        return 'Doctor name';
      case Medication.pharmacy:
        return 'Pharmacy name';
      case Medication.instructions:
        return 'Special instructions';
    }
  }

  String get fieldKey {
    switch (this) {
      case Medication.name:
        return 'name_key';
      case Medication.dosage:
        return 'dosage_key';
      case Medication.frequency:
        return 'frequency_key';
      case Medication.time:
        return 'time_key';
      case Medication.startDate:
        return 'start_date_key';
      case Medication.endDate:
        return 'end_date_key';
      case Medication.reasonForUse:
        return 'reason_key';
      case Medication.status:
        return 'status_key';
      case Medication.route:
        return 'route_key';
      case Medication.form:
        return 'form_key';
      case Medication.prescribedBy:
        return 'prescribed_by_key';
      case Medication.pharmacy:
        return 'pharmacy_key';
      case Medication.instructions:
        return 'instructions_key';
    }
  }
}

enum MedicationStatus {
  active,
  completed,
  discontinued,
  onHold,
  archived,
}

extension MedicationStatusExtension on MedicationStatus {
  String get displayName {
    switch (this) {
      case MedicationStatus.active:
        return 'Active';
      case MedicationStatus.completed:
        return 'Completed';
      case MedicationStatus.discontinued:
        return 'Discontinued';
      case MedicationStatus.onHold:
        return 'On Hold';
      case MedicationStatus.archived:
        return 'Archived';
    }
  }

  bool get isActive {
    return this == MedicationStatus.active;
  }
}

enum MedicationFrequency {
  onceDaily,
  twiceDaily,
  threeTimesDaily,
  fourTimesDaily,
  everyOtherDay,
  everyThreeDays,
  weekly,
  biweekly,
  monthly,
  asNeeded,
  onceOnly,
  beforeMeals,
  afterMeals,
  withMeals,
  atBedtime,
  other,
}

extension MedicationFrequencyExtension on MedicationFrequency {
  String get displayName {
    switch (this) {
      case MedicationFrequency.onceDaily:
        return 'Once Daily (QD)';
      case MedicationFrequency.twiceDaily:
        return 'Twice Daily (BID)';
      case MedicationFrequency.threeTimesDaily:
        return 'Three Times Daily (TID)';
      case MedicationFrequency.fourTimesDaily:
        return 'Four Times Daily (QID)';
      case MedicationFrequency.everyOtherDay:
        return 'Every Other Day';
      case MedicationFrequency.everyThreeDays:
        return 'Every 3 Days';
      case MedicationFrequency.weekly:
        return 'Weekly';
      case MedicationFrequency.biweekly:
        return 'Biweekly (Every 2 Weeks)';
      case MedicationFrequency.monthly:
        return 'Monthly';
      case MedicationFrequency.asNeeded:
        return 'As Needed (PRN)';
      case MedicationFrequency.onceOnly:
        return 'Once Only';
      case MedicationFrequency.beforeMeals:
        return 'Before Meals (AC)';
      case MedicationFrequency.afterMeals:
        return 'After Meals (PC)';
      case MedicationFrequency.withMeals:
        return 'With Meals';
      case MedicationFrequency.atBedtime:
        return 'At Bedtime (HS)';
      case MedicationFrequency.other:
        return 'Other';
    }
  }

  String get abbreviation {
    switch (this) {
      case MedicationFrequency.onceDaily:
        return 'QD';
      case MedicationFrequency.twiceDaily:
        return 'BID';
      case MedicationFrequency.threeTimesDaily:
        return 'TID';
      case MedicationFrequency.fourTimesDaily:
        return 'QID';
      case MedicationFrequency.asNeeded:
        return 'PRN';
      case MedicationFrequency.beforeMeals:
        return 'AC';
      case MedicationFrequency.afterMeals:
        return 'PC';
      case MedicationFrequency.atBedtime:
        return 'HS';
      default:
        return '';
    }
  }
}

enum MedicationRoute {
  oral,
  sublingual,
  buccal,
  topical,
  transdermal,
  inhaled,
  nasal,
  ophthalmic,
  otic,
  rectal,
  vaginal,
  other,
}

extension MedicationRouteExtension on MedicationRoute {
  String get displayName {
    switch (this) {
      case MedicationRoute.oral:
        return 'Oral (By Mouth)';
      case MedicationRoute.sublingual:
        return 'Sublingual (Under Tongue)';
      case MedicationRoute.buccal:
        return 'Buccal (Cheek)';
      case MedicationRoute.topical:
        return 'Topical (Skin)';
      case MedicationRoute.transdermal:
        return 'Transdermal (Patch)';
      case MedicationRoute.inhaled:
        return 'Inhaled';
      case MedicationRoute.nasal:
        return 'Nasal';
      case MedicationRoute.ophthalmic:
        return 'Ophthalmic (Eye)';
      case MedicationRoute.otic:
        return 'Otic (Ear)';
      case MedicationRoute.rectal:
        return 'Rectal';
      case MedicationRoute.vaginal:
        return 'Vaginal';
      case MedicationRoute.other:
        return 'Other';
    }
  }

  String get abbreviation {
    switch (this) {
      case MedicationRoute.oral:
        return 'PO';
      case MedicationRoute.sublingual:
        return 'SL';
      case MedicationRoute.topical:
        return 'TOP';
      case MedicationRoute.inhaled:
        return 'INH';
      case MedicationRoute.rectal:
        return 'PR';
      default:
        return '';
    }
  }
}

enum MedicationForm {
  tablet,
  capsule,
  liquid,
  syrup,
  suspension,
  solution,
  drops,
  cream,
  ointment,
  gel,
  lotion,
  patch,
  inhaler,
  nebulizer,
  suppository,
  powder,
  granules,
  other,
}

extension MedicationFormExtension on MedicationForm {
  String get displayName {
    switch (this) {
      case MedicationForm.tablet:
        return 'Tablet';
      case MedicationForm.capsule:
        return 'Capsule';
      case MedicationForm.liquid:
        return 'Liquid';
      case MedicationForm.syrup:
        return 'Syrup';
      case MedicationForm.suspension:
        return 'Suspension';
      case MedicationForm.solution:
        return 'Solution';
      case MedicationForm.drops:
        return 'Drops';
      case MedicationForm.cream:
        return 'Cream';
      case MedicationForm.ointment:
        return 'Ointment';
      case MedicationForm.gel:
        return 'Gel';
      case MedicationForm.lotion:
        return 'Lotion';
      case MedicationForm.patch:
        return 'Patch';
      case MedicationForm.inhaler:
        return 'Inhaler';
      case MedicationForm.nebulizer:
        return 'Nebulizer Solution';
      case MedicationForm.suppository:
        return 'Suppository';
      case MedicationForm.powder:
        return 'Powder';
      case MedicationForm.granules:
        return 'Granules';
      case MedicationForm.other:
        return 'Other';
    }
  }
}
