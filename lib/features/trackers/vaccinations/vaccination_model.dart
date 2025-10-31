import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';
import 'package:nephro_care/features/trackers/injections/injection_enums.dart';
import 'package:nephro_care/features/trackers/vaccinations/vaccination_enums.dart';

class VaccinationModel {
  final String id;
  final String vaccineName;
  final VaccineType? vaccineType;
  final VaccinationStatus status;
  final DateTime? administeredDate;
  final DateTime? nextDueDate;
  final String? administeredBy;
  final String? location;
  final String? manufacturer;
  final String? lotNumber;
  final String? batchNumber;
  final InjectionRoute? route;
  final InjectionSite? site;
  final int? doseNumber;
  final int? totalDoses;
  final VaccineReaction? reaction;
  final String? reactionNotes;
  final String? notes;
  final Timestamp timestamp;
  final bool isPendingSync;

  VaccinationModel({
    required this.id,
    required this.vaccineName,
    this.vaccineType,
    required this.status,
    this.administeredDate,
    this.nextDueDate,
    this.administeredBy,
    this.location,
    this.manufacturer,
    this.lotNumber,
    this.batchNumber,
    this.route,
    this.site,
    this.doseNumber,
    this.totalDoses,
    this.reaction,
    this.reactionNotes,
    this.notes,
    required this.timestamp,
    this.isPendingSync = false,
  });

  factory VaccinationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return VaccinationModel(
      id: data['id'] as String,
      vaccineName: data['vaccineName'] as String,
      vaccineType: VaccineType.values.parseOrNull(data['vaccineType']),
      status: VaccinationStatus.values.parse(data['status']),
      administeredDate: ModelUtils.timestampToDate(data['administeredDate']),
      nextDueDate: ModelUtils.timestampToDate(data['nextDueDate']),
      administeredBy: data['administeredBy'] as String?,
      location: data['location'] as String?,
      manufacturer: data['manufacturer'] as String?,
      lotNumber: data['lotNumber'] as String?,
      batchNumber: data['batchNumber'] as String?,
      route: InjectionRoute.values.parseOrNull(data['route']),
      site: InjectionSite.values.parseOrNull(data['site']),
      doseNumber: data['doseNumber'] as int?,
      totalDoses: data['totalDoses'] as int?,
      reaction: VaccineReaction.values.parseOrNull(data['reaction']),
      reactionNotes: data['reactionNotes'] as String?,
      notes: data['notes'] as String?,
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  factory VaccinationModel.fromJson(Map<String, dynamic> json) {
    return VaccinationModel(
      id: json['id'] as String,
      vaccineName: json['vaccineName'] as String,
      vaccineType: VaccineType.values.parseOrNull(json['vaccineType']),
      status: VaccinationStatus.values.parse(json['status']),
      administeredDate: ModelUtils.timestampToDate(json['administeredDate']),
      nextDueDate: ModelUtils.timestampToDate(json['nextDueDate']),
      administeredBy: json['administeredBy'] as String?,
      location: json['location'] as String?,
      manufacturer: json['manufacturer'] as String?,
      lotNumber: json['lotNumber'] as String?,
      batchNumber: json['batchNumber'] as String?,
      route: InjectionRoute.values.parseOrNull(json['route']),
      site: InjectionSite.values.parseOrNull(json['site']),
      doseNumber: json['doseNumber'] as int?,
      totalDoses: json['totalDoses'] as int?,
      reaction: VaccineReaction.values.parseOrNull(json['reaction']),
      reactionNotes: json['reactionNotes'] as String?,
      notes: json['notes'] as String?,
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vaccineName': vaccineName,
      'vaccineType': vaccineType?.name,
      'status': status.name,
      'administeredDate': ModelUtils.dateToTimestamp(administeredDate),
      'nextDueDate': ModelUtils.dateToTimestamp(nextDueDate),
      'administeredBy': administeredBy,
      'location': location,
      'manufacturer': manufacturer,
      'lotNumber': lotNumber,
      'batchNumber': batchNumber,
      'route': route?.name,
      'site': site?.name,
      'doseNumber': doseNumber,
      'totalDoses': totalDoses,
      'reaction': reaction?.name,
      'reactionNotes': reactionNotes,
      'notes': notes,
      'timestamp': timestamp,
    };
  }

  VaccinationModel copyWith({
    String? id,
    String? vaccineName,
    VaccineType? vaccineType,
    VaccinationStatus? status,
    DateTime? administeredDate,
    DateTime? nextDueDate,
    String? administeredBy,
    String? location,
    String? manufacturer,
    String? lotNumber,
    String? batchNumber,
    InjectionRoute? route,
    InjectionSite? site,
    int? doseNumber,
    int? totalDoses,
    VaccineReaction? reaction,
    String? reactionNotes,
    String? notes,
    Timestamp? timestamp,
    bool? isPendingSync,
  }) {
    return VaccinationModel(
      id: id ?? this.id,
      vaccineName: vaccineName ?? this.vaccineName,
      vaccineType: vaccineType ?? this.vaccineType,
      status: status ?? this.status,
      administeredDate: administeredDate ?? this.administeredDate,
      nextDueDate: nextDueDate ?? this.nextDueDate,
      administeredBy: administeredBy ?? this.administeredBy,
      location: location ?? this.location,
      manufacturer: manufacturer ?? this.manufacturer,
      lotNumber: lotNumber ?? this.lotNumber,
      batchNumber: batchNumber ?? this.batchNumber,
      route: route ?? this.route,
      site: site ?? this.site,
      doseNumber: doseNumber ?? this.doseNumber,
      totalDoses: totalDoses ?? this.totalDoses,
      reaction: reaction ?? this.reaction,
      reactionNotes: reactionNotes ?? this.reactionNotes,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  bool get isMultiDoseSeries => totalDoses != null && totalDoses! > 1;

  bool get isSeriesComplete =>
      isMultiDoseSeries && doseNumber != null && doseNumber! >= totalDoses!;

  String get doseProgressString {
    if (doseNumber != null && totalDoses != null) {
      return '$doseNumber/$totalDoses';
    }
    return '';
  }

  @override
  String toString() {
    final doseInfo =
        doseProgressString.isNotEmpty ? ' ($doseProgressString)' : '';
    return 'VaccinationModel(id: $id, vaccine: $vaccineName$doseInfo, status: ${status.displayName})';
  }
}
