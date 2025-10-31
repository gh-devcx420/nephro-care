import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/patient/patient_enums.dart';
import 'package:nephro_care/features/trackers/dialysis/dialysis_enums.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_enums.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';

/// Comprehensive patient profile model for CKD tracking app
class PatientModel {
  final String id;
  final String userId;

  // ── Basic Information ─────────────────────────────────────────────────────
  final String fullName;
  final DateTime dateOfBirth;
  final Gender gender; // Uses Gender enum from patient_enums.dart
  final double heightCm;
  final double weightKg;
  final BloodGroup? bloodGroup;

  // ── Contact & Emergency ───────────────────────────────────────────────────
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? emergencyContactName;
  final String? emergencyContactPhone;

  // ── CKD Core Data ─────────────────────────────────────────────────────────
  final CKDStage ckdStage;
  final CKDCause? ckdCause;
  final DateTime? ckdDiagnosisDate;
  final double? baselineCreatinine; // mg/dL
  final double? baselineEGFR; // mL/min/1.73m²

  // ── Dialysis Details ──────────────────────────────────────────────────────
  final DialysisType dialysisType;
  final DateTime? dialysisStartDate;
  final DialysisAccess? dialysisAccess;
  final int? dialysisFrequencyPerWeek;
  final double? dryWeightKg;

  // ── Transplant Status ─────────────────────────────────────────────────────
  final TransplantStatus transplantStatus;
  final DateTime? transplantDate;
  final String? transplantCenter;

  // ── Lifestyle & Restrictions ──────────────────────────────────────────────
  final List<DietRestriction> dietRestrictions;
  final FluidRestrictionLevel fluidRestrictionLevel;
  final double? dailyFluidLimitML;
  final ActivityLevel activityLevel;
  final SmokingStatus smokingStatus;
  final SmokingFrequency? smokingFrequency;
  final int? smokingPackYears;
  final AlcoholStatus alcoholStatus;
  final AlcoholConsumption? alcoholConsumption;

  // ── Healthcare Providers ──────────────────────────────────────────────────
  final String? primaryNephrologist;
  final String? primaryCarePhysician;
  final String? dialysisCenter;
  final String? preferredHospital;

  // ── Insurance & Admin ─────────────────────────────────────────────────────
  final String? insuranceProvider;
  final String? insurancePolicyNumber;
  final String? medicalRecordNumber;

  // ── Metadata ──────────────────────────────────────────────────────────────
  final String? notes;
  final bool isActive;
  final Timestamp createdAt;
  final Timestamp updatedAt;
  final bool isPendingSync;

  // ── Constructor ───────────────────────────────────────────────────────────
  PatientModel({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.heightCm,
    required this.weightKg,
    this.bloodGroup,
    this.phoneNumber,
    this.email,
    this.address,
    this.emergencyContactName,
    this.emergencyContactPhone,
    required this.ckdStage,
    this.ckdCause,
    this.ckdDiagnosisDate,
    this.baselineCreatinine,
    this.baselineEGFR,
    required this.dialysisType,
    this.dialysisStartDate,
    this.dialysisAccess,
    this.dialysisFrequencyPerWeek,
    this.dryWeightKg,
    required this.transplantStatus,
    this.transplantDate,
    this.transplantCenter,
    this.dietRestrictions = const [],
    required this.fluidRestrictionLevel,
    this.dailyFluidLimitML,
    required this.activityLevel,
    required this.smokingStatus,
    this.smokingFrequency,
    this.smokingPackYears,
    required this.alcoholStatus,
    this.alcoholConsumption,
    this.primaryNephrologist,
    this.primaryCarePhysician,
    this.dialysisCenter,
    this.preferredHospital,
    this.insuranceProvider,
    this.insurancePolicyNumber,
    this.medicalRecordNumber,
    this.notes,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.isPendingSync = false,
  });

  // ── Firestore → Model ─────────────────────────────────────────────────────
  factory PatientModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return PatientModel(
      id: data['id'] as String,
      userId: data['userId'] as String,
      fullName: data['fullName'] as String,
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
      gender: Gender.values.parse(data['gender']),
      heightCm: (data['heightCm'] as num).toDouble(),
      weightKg: (data['weightKg'] as num).toDouble(),
      bloodGroup: BloodGroup.values.parseOrNull(data['bloodGroup']),
      phoneNumber: data['phoneNumber'] as String?,
      email: data['email'] as String?,
      address: data['address'] as String?,
      emergencyContactName: data['emergencyContactName'] as String?,
      emergencyContactPhone: data['emergencyContactPhone'] as String?,
      ckdStage: CKDStage.values.parse(data['ckdStage']),
      ckdCause: CKDCause.values.parseOrNull(data['ckdCause']),
      ckdDiagnosisDate: ModelUtils.timestampToDate(data['ckdDiagnosisDate']),
      baselineCreatinine: (data['baselineCreatinine'] as num?)?.toDouble(),
      baselineEGFR: (data['baselineEGFR'] as num?)?.toDouble(),
      dialysisType: DialysisType.values.parse(data['dialysisType']),
      dialysisStartDate: ModelUtils.timestampToDate(data['dialysisStartDate']),
      dialysisAccess: DialysisAccess.values.parseOrNull(data['dialysisAccess']),
      dialysisFrequencyPerWeek: data['dialysisFrequencyPerWeek'] as int?,
      dryWeightKg: (data['dryWeightKg'] as num?)?.toDouble(),
      transplantStatus: TransplantStatus.values.parse(data['transplantStatus']),
      transplantDate: ModelUtils.timestampToDate(data['transplantDate']),
      transplantCenter: data['transplantCenter'] as String?,
      dietRestrictions: (data['dietRestrictions'] as List<dynamic>?)
              ?.map((e) => DietRestriction.values.parse(e as String))
              .toList() ??
          [],
      fluidRestrictionLevel:
          FluidRestrictionLevel.values.parse(data['fluidRestrictionLevel']),
      dailyFluidLimitML: (data['dailyFluidLimitML'] as num?)?.toDouble(),
      activityLevel: ActivityLevel.values.parse(data['activityLevel']),
      smokingStatus: SmokingStatus.values.parse(data['smokingStatus']),
      smokingFrequency:
          SmokingFrequency.values.parseOrNull(data['smokingFrequency']),
      smokingPackYears: data['smokingPackYears'] as int?,
      alcoholStatus: AlcoholStatus.values.parse(data['alcoholStatus']),
      alcoholConsumption:
          AlcoholConsumption.values.parseOrNull(data['alcoholConsumption']),
      primaryNephrologist: data['primaryNephrologist'] as String?,
      primaryCarePhysician: data['primaryCarePhysician'] as String?,
      dialysisCenter: data['dialysisCenter'] as String?,
      preferredHospital: data['preferredHospital'] as String?,
      insuranceProvider: data['insuranceProvider'] as String?,
      insurancePolicyNumber: data['insurancePolicyNumber'] as String?,
      medicalRecordNumber: data['medicalRecordNumber'] as String?,
      notes: data['notes'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: data['createdAt'] as Timestamp,
      updatedAt: data['updatedAt'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  // ── Model → JSON ──────────────────────────────────────────────────────────
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'fullName': fullName,
        'dateOfBirth': Timestamp.fromDate(dateOfBirth),
        'gender': gender.name,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'bloodGroup': bloodGroup?.name,
        'phoneNumber': phoneNumber,
        'email': email,
        'address': address,
        'emergencyContactName': emergencyContactName,
        'emergencyContactPhone': emergencyContactPhone,
        'ckdStage': ckdStage.name,
        'ckdCause': ckdCause?.name,
        'ckdDiagnosisDate': ModelUtils.dateToTimestamp(ckdDiagnosisDate),
        'baselineCreatinine': baselineCreatinine,
        'baselineEGFR': baselineEGFR,
        'dialysisType': dialysisType.name,
        'dialysisStartDate': ModelUtils.dateToTimestamp(dialysisStartDate),
        'dialysisAccess': dialysisAccess?.name,
        'dialysisFrequencyPerWeek': dialysisFrequencyPerWeek,
        'dryWeightKg': dryWeightKg,
        'transplantStatus': transplantStatus.name,
        'transplantDate': ModelUtils.dateToTimestamp(transplantDate),
        'transplantCenter': transplantCenter,
        'dietRestrictions': dietRestrictions.map((e) => e.name).toList(),
        'fluidRestrictionLevel': fluidRestrictionLevel.name,
        'dailyFluidLimitML': dailyFluidLimitML,
        'activityLevel': activityLevel.name,
        'smokingStatus': smokingStatus.name,
        'smokingFrequency': smokingFrequency?.name,
        'smokingPackYears': smokingPackYears,
        'alcoholStatus': alcoholStatus.name,
        'alcoholConsumption': alcoholConsumption?.name,
        'primaryNephrologist': primaryNephrologist,
        'primaryCarePhysician': primaryCarePhysician,
        'dialysisCenter': dialysisCenter,
        'preferredHospital': preferredHospital,
        'insuranceProvider': insuranceProvider,
        'insurancePolicyNumber': insurancePolicyNumber,
        'medicalRecordNumber': medicalRecordNumber,
        'notes': notes,
        'isActive': isActive,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  // ── CopyWith ──────────────────────────────────────────────────────────────
  PatientModel copyWith({
    String? id,
    String? userId,
    String? fullName,
    DateTime? dateOfBirth,
    Gender? gender,
    double? heightCm,
    double? weightKg,
    BloodGroup? bloodGroup,
    String? phoneNumber,
    String? email,
    String? address,
    String? emergencyContactName,
    String? emergencyContactPhone,
    CKDStage? ckdStage,
    CKDCause? ckdCause,
    DateTime? ckdDiagnosisDate,
    double? baselineCreatinine,
    double? baselineEGFR,
    DialysisType? dialysisType,
    DateTime? dialysisStartDate,
    DialysisAccess? dialysisAccess,
    int? dialysisFrequencyPerWeek,
    double? dryWeightKg,
    TransplantStatus? transplantStatus,
    DateTime? transplantDate,
    String? transplantCenter,
    List<DietRestriction>? dietRestrictions,
    FluidRestrictionLevel? fluidRestrictionLevel,
    double? dailyFluidLimitML,
    ActivityLevel? activityLevel,
    SmokingStatus? smokingStatus,
    SmokingFrequency? smokingFrequency,
    int? smokingPackYears,
    AlcoholStatus? alcoholStatus,
    AlcoholConsumption? alcoholConsumption,
    String? primaryNephrologist,
    String? primaryCarePhysician,
    String? dialysisCenter,
    String? preferredHospital,
    String? insuranceProvider,
    String? insurancePolicyNumber,
    String? medicalRecordNumber,
    String? notes,
    bool? isActive,
    Timestamp? createdAt,
    Timestamp? updatedAt,
    bool? isPendingSync,
  }) {
    return PatientModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      address: address ?? this.address,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactPhone:
          emergencyContactPhone ?? this.emergencyContactPhone,
      ckdStage: ckdStage ?? this.ckdStage,
      ckdCause: ckdCause ?? this.ckdCause,
      ckdDiagnosisDate: ckdDiagnosisDate ?? this.ckdDiagnosisDate,
      baselineCreatinine: baselineCreatinine ?? this.baselineCreatinine,
      baselineEGFR: baselineEGFR ?? this.baselineEGFR,
      dialysisType: dialysisType ?? this.dialysisType,
      dialysisStartDate: dialysisStartDate ?? this.dialysisStartDate,
      dialysisAccess: dialysisAccess ?? this.dialysisAccess,
      dialysisFrequencyPerWeek:
          dialysisFrequencyPerWeek ?? this.dialysisFrequencyPerWeek,
      dryWeightKg: dryWeightKg ?? this.dryWeightKg,
      transplantStatus: transplantStatus ?? this.transplantStatus,
      transplantDate: transplantDate ?? this.transplantDate,
      transplantCenter: transplantCenter ?? this.transplantCenter,
      dietRestrictions: dietRestrictions ?? this.dietRestrictions,
      fluidRestrictionLevel:
          fluidRestrictionLevel ?? this.fluidRestrictionLevel,
      dailyFluidLimitML: dailyFluidLimitML ?? this.dailyFluidLimitML,
      activityLevel: activityLevel ?? this.activityLevel,
      smokingStatus: smokingStatus ?? this.smokingStatus,
      smokingFrequency: smokingFrequency ?? this.smokingFrequency,
      smokingPackYears: smokingPackYears ?? this.smokingPackYears,
      alcoholStatus: alcoholStatus ?? this.alcoholStatus,
      alcoholConsumption: alcoholConsumption ?? this.alcoholConsumption,
      primaryNephrologist: primaryNephrologist ?? this.primaryNephrologist,
      primaryCarePhysician: primaryCarePhysician ?? this.primaryCarePhysician,
      dialysisCenter: dialysisCenter ?? this.dialysisCenter,
      preferredHospital: preferredHospital ?? this.preferredHospital,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insurancePolicyNumber:
          insurancePolicyNumber ?? this.insurancePolicyNumber,
      medicalRecordNumber: medicalRecordNumber ?? this.medicalRecordNumber,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  @override
  String toString() {
    return 'Patient(id: $id, $fullName, ${gender.displayName}, CKD ${ckdStage.displayName}, ${dialysisType.displayName})';
  }
}
