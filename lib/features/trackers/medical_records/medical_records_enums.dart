enum MedicalRecordField {
  title,
  category,
  date,
  attachmentUrl,
  notes,
}

extension MedicalRecordFieldExtension on MedicalRecordField {
  String get fieldName {
    switch (this) {
      case MedicalRecordField.title:
        return 'Record Title';
      case MedicalRecordField.category:
        return 'Category';
      case MedicalRecordField.date:
        return 'Date of Record';
      case MedicalRecordField.attachmentUrl:
        return 'Attachment';
      case MedicalRecordField.notes:
        return 'Summary/Notes';
    }
  }

  String get hintText {
    switch (this) {
      case MedicalRecordField.title:
        return 'e.g., Latest Labs, Chest X-ray';
      case MedicalRecordField.category:
        return 'Select record type';
      case MedicalRecordField.date:
        return 'Date the test/record was created';
      case MedicalRecordField.attachmentUrl:
        return 'Secure URL to the file';
      case MedicalRecordField.notes:
        return 'Key findings or summary';
    }
  }

  String get fieldKey {
    switch (this) {
      case MedicalRecordField.title:
        return 'title_key';
      case MedicalRecordField.category:
        return 'category_key';
      case MedicalRecordField.date:
        return 'date_key';
      case MedicalRecordField.attachmentUrl:
        return 'attachment_url_key';
      case MedicalRecordField.notes:
        return 'notes_key';
    }
  }
}

enum RecordCategory {
  // DIAGNOSTICS & RESULTS
  labResults,
  imagingReport, // General Radiology/Imaging
  ecgEegEmg, // Cardiac/Neuro Testing
  pathologyReport, // Tissue or fluid analysis
  geneticTestResult,
  microbiologyReport, // Cultures

  // VISIT & CONSULTATION NOTES
  clinicNote, // General visit/progress note
  consultationReport, // Specialist referral note
  hospitalAdmissionNote,
  dischargeSummary,
  emergencyRoomNote,
  transferSummary,

  // PROCEDURES & SURGERY
  operativeReport,
  anesthesiaRecord,
  procedureNote, // e.g., endoscopy, minor procedure
  immunizationRecord, // Vaccination Record
  physiotherapyNote,

  // PLANS & SUMMARIES
  medicationList,
  carePlan,
  dietaryConsultation,
  specialistCarePlan,
  rehabilitationPlan,

  // ADMINISTRATIVE & LEGAL
  insuranceDocument,
  financialRecord,
  consentForm,
  advanceDirective, // Living Will, DNR
  patientQuestionnaire,

  // OTHER
  otherClinicalDocument,
  otherAdministrative,
  other, // Catch-all for anything missed
}

extension RecordCategoryExtension on RecordCategory {
  String get displayName {
    switch (this) {
      // DIAGNOSTICS & RESULTS
      case RecordCategory.labResults:
        return 'Lab Results (Blood, Urine)';
      case RecordCategory.imagingReport:
        return 'Imaging / Radiology Report';
      case RecordCategory.ecgEegEmg:
        return 'ECG, EEG, or EMG';
      case RecordCategory.pathologyReport:
        return 'Pathology / Biopsy Report';
      case RecordCategory.geneticTestResult:
        return 'Genetic Test Result';
      case RecordCategory.microbiologyReport:
        return 'Microbiology / Culture Report';

      // VISIT & CONSULTATION NOTES
      case RecordCategory.clinicNote:
        return 'Clinic / Progress Note';
      case RecordCategory.consultationReport:
        return 'Specialist Consultation Report';
      case RecordCategory.hospitalAdmissionNote:
        return 'Hospital Admission Note';
      case RecordCategory.dischargeSummary:
        return 'Hospital Discharge Summary';
      case RecordCategory.emergencyRoomNote:
        return 'Emergency Room Note';
      case RecordCategory.transferSummary:
        return 'Transfer Summary';

      // PROCEDURES & SURGERY
      case RecordCategory.operativeReport:
        return 'Operative / Surgical Report';
      case RecordCategory.anesthesiaRecord:
        return 'Anesthesia Record';
      case RecordCategory.procedureNote:
        return 'Procedure Note (Minor Surgery, Scope)';
      case RecordCategory.immunizationRecord:
        return 'Vaccination Record';
      case RecordCategory.physiotherapyNote:
        return 'Physical Therapy Note';

      // PLANS & SUMMARIES
      case RecordCategory.medicationList:
        return 'Medication List / Summary';
      case RecordCategory.carePlan:
        return 'General Care Plan';
      case RecordCategory.dietaryConsultation:
        return 'Dietary / Nutrition Consultation';
      case RecordCategory.specialistCarePlan:
        return 'Specialist Care Plan';
      case RecordCategory.rehabilitationPlan:
        return 'Rehabilitation Plan';

      // ADMINISTRATIVE & LEGAL
      case RecordCategory.insuranceDocument:
        return 'Insurance / Coverage Document';
      case RecordCategory.financialRecord:
        return 'Medical Billing / Financial Record';
      case RecordCategory.consentForm:
        return 'Surgical / Treatment Consent Form';
      case RecordCategory.advanceDirective:
        return 'Advance Directive / Living Will';
      case RecordCategory.patientQuestionnaire:
        return 'Patient Questionnaire / Intake Form';

      // OTHER
      case RecordCategory.otherClinicalDocument:
        return 'Other Clinical Document';
      case RecordCategory.otherAdministrative:
        return 'Other Administrative Document';
      case RecordCategory.other:
        return 'Other (Specify in Title)';
    }
  }
}
