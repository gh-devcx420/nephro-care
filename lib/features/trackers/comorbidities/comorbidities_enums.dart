enum ComorbidityField {
  condition,
  diagnosisDate,
  status,
  notes,
}

extension ComorbidityFieldExtension on ComorbidityField {
  String get fieldName {
    switch (this) {
      case ComorbidityField.condition:
        return 'Condition Name';
      case ComorbidityField.diagnosisDate:
        return 'Diagnosis Date';
      case ComorbidityField.status:
        return 'Status';
      case ComorbidityField.notes:
        return 'Notes';
    }
  }

  String get hintText {
    switch (this) {
      case ComorbidityField.condition:
        return 'e.g., Diabetes, Hypertension';
      case ComorbidityField.diagnosisDate:
        return 'When was this diagnosed?';
      case ComorbidityField.status:
        return 'Current status (e.g., Active, Resolved)';
      case ComorbidityField.notes:
        return 'Any relevant details';
    }
  }

  String get fieldKey {
    switch (this) {
      case ComorbidityField.condition:
        return 'condition_key';
      case ComorbidityField.diagnosisDate:
        return 'diagnosis_date_key';
      case ComorbidityField.status:
        return 'status_key';
      case ComorbidityField.notes:
        return 'notes_key';
    }
  }
}

enum ComorbidityStatus {
  active,
  resolved,
  inRemission,
  chronic,
}

extension ComorbidityStatusExtension on ComorbidityStatus {
  String get displayName {
    switch (this) {
      case ComorbidityStatus.active:
        return 'Active';
      case ComorbidityStatus.resolved:
        return 'Resolved';
      case ComorbidityStatus.inRemission:
        return 'In Remission';
      case ComorbidityStatus.chronic:
        return 'Chronic/Stable';
    }
  }
}

enum ComorbidityCondition {
  // Cardiovascular Conditions
  hypertension,
  coronaryArteryDisease,
  congestiveHeartFailure,
  atrialFibrillation,
  peripheralArteryDisease,
  cerebrovascularAccident,

  // Endocrine & Metabolic Conditions
  diabetesMellitusType1,
  diabetesMellitusType2,
  obesity,
  dyslipidemia,
  goutHyperuricemia,
  secondaryHyperparathyroidism,

  // Hematologic & Infectious Conditions
  anemia,
  chronicInfectionHepatitisC,
  chronicInfectionHepatitisB,
  historyOfMalignancy,

  // Respiratory Conditions
  chronicObstructivePulmonaryDisease,
  sleepApnea,

  // Gastrointestinal Conditions
  chronicLiverDisease,
  gastroesophagealRefluxDisease,
  inflammatoryBowelDisease,

  // Neurological Conditions
  dementia,
  parkinsonsDisease,
  epilepsySeizureDisorder,

  // Musculoskeletal & Rheumatic Conditions
  osteoporosis,
  osteoarthritis,
  rheumatoidArthritis,
  systemicLupusErythematosus,
  chronicPainSyndrome,

  // Urology/Nephrology Specific
  kidneyStones,
  polycysticKidneyDisease,

  // Mental Health
  depression,
  anxietyDisorder,

  // Placeholder/Other
  other,
}

extension ComorbidityConditionExtension on ComorbidityCondition {
  String get displayName {
    switch (this) {
      // Cardiovascular
      case ComorbidityCondition.hypertension:
        return 'Hypertension (High BP)';
      case ComorbidityCondition.coronaryArteryDisease:
        return 'Coronary Artery Disease (CAD)';
      case ComorbidityCondition.congestiveHeartFailure:
        return 'Congestive Heart Failure (CHF)';
      case ComorbidityCondition.atrialFibrillation:
        return 'Atrial Fibrillation (Afib)';
      case ComorbidityCondition.peripheralArteryDisease:
        return 'Peripheral Artery Disease (PAD)';
      case ComorbidityCondition.cerebrovascularAccident:
        return 'Stroke (CVA)';

      // Endocrine & Metabolic
      case ComorbidityCondition.diabetesMellitusType1:
        return 'Diabetes Mellitus Type 1';
      case ComorbidityCondition.diabetesMellitusType2:
        return 'Diabetes Mellitus Type 2';
      case ComorbidityCondition.obesity:
        return 'Obesity';
      case ComorbidityCondition.dyslipidemia:
        return 'Dyslipidemia (High Cholesterol)';
      case ComorbidityCondition.goutHyperuricemia:
        return 'Gout / Hyperuricemia';
      case ComorbidityCondition.secondaryHyperparathyroidism:
        return 'Secondary Hyperparathyroidism (SHPT)';

      // Hematologic & Infectious
      case ComorbidityCondition.anemia:
        return 'Anemia';
      case ComorbidityCondition.chronicInfectionHepatitisC:
        return 'Chronic Hepatitis C Infection';
      case ComorbidityCondition.chronicInfectionHepatitisB:
        return 'Chronic Hepatitis B Infection';
      case ComorbidityCondition.historyOfMalignancy:
        return 'History of Malignancy (Cancer)';

      // Respiratory Conditions
      case ComorbidityCondition.chronicObstructivePulmonaryDisease:
        return 'Chronic Obstructive Pulmonary Disease (COPD)';
      case ComorbidityCondition.sleepApnea:
        return 'Sleep Apnea';

      // Gastrointestinal Conditions
      case ComorbidityCondition.chronicLiverDisease:
        return 'Chronic Liver Disease';
      case ComorbidityCondition.gastroesophagealRefluxDisease:
        return 'GERD (Reflux)';
      case ComorbidityCondition.inflammatoryBowelDisease:
        return 'Inflammatory Bowel Disease (IBD)';

      // Neurological Conditions
      case ComorbidityCondition.dementia:
        return 'Dementia / Cognitive Impairment';
      case ComorbidityCondition.parkinsonsDisease:
        return 'Parkinson\'s Disease';
      case ComorbidityCondition.epilepsySeizureDisorder:
        return 'Epilepsy / Seizure Disorder';

      // Musculoskeletal & Rheumatic Conditions
      case ComorbidityCondition.osteoporosis:
        return 'Osteoporosis';
      case ComorbidityCondition.osteoarthritis:
        return 'Osteoarthritis';
      case ComorbidityCondition.rheumatoidArthritis:
        return 'Rheumatoid Arthritis (RA)';
      case ComorbidityCondition.systemicLupusErythematosus:
        return 'Systemic Lupus Erythematosus (SLE)';
      case ComorbidityCondition.chronicPainSyndrome:
        return 'Chronic Pain Syndrome';

      // Urology/Nephrology Specific
      case ComorbidityCondition.kidneyStones:
        return 'History of Kidney Stones';
      case ComorbidityCondition.polycysticKidneyDisease:
        return 'Polycystic Kidney Disease (PKD)';

      // Mental Health
      case ComorbidityCondition.depression:
        return 'Depression';
      case ComorbidityCondition.anxietyDisorder:
        return 'Anxiety Disorder';

      case ComorbidityCondition.other:
        return 'Other';
    }
  }
}
