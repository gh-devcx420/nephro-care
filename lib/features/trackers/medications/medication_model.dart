import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';
import 'package:nephro_care/features/trackers/medications/medication_enums.dart';

class MedicationModel {
  final String id;
  final String name;
  final String dosage;
  final MedicationFrequency frequency;
  final MedicationRoute route;
  final MedicationForm? form;
  final List<DateTime> scheduledTimes;
  final DateTime startDate;
  final DateTime? endDate;
  final String? reasonForUse;
  final String? prescribedBy;
  final String? pharmacy;
  final int? refillsRemaining;
  final DateTime? lastRefillDate;
  final String? instructions;
  final MedicationStatus status;
  final bool isPendingSync;

  MedicationModel({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.route,
    this.form,
    required this.scheduledTimes,
    required this.startDate,
    this.endDate,
    this.reasonForUse,
    this.prescribedBy,
    this.pharmacy,
    this.refillsRemaining,
    this.lastRefillDate,
    this.instructions,
    required this.status,
    this.isPendingSync = false,
  });

  factory MedicationModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MedicationModel(
      id: data['id'] as String,
      name: data['name'] as String,
      dosage: data['dosage'] as String,
      frequency: MedicationFrequency.values.parse(data['frequency']),
      route: MedicationRoute.values.parse(data['route']),
      form: MedicationForm.values.parseOrNull(data['form']),
      scheduledTimes:
          ModelUtils.timestampListToDateList(data['scheduledTimes']),
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: ModelUtils.timestampToDate(data['endDate']),
      reasonForUse: data['reasonForUse'] as String?,
      prescribedBy: data['prescribedBy'] as String?,
      pharmacy: data['pharmacy'] as String?,
      refillsRemaining: data['refillsRemaining'] as int?,
      lastRefillDate: ModelUtils.timestampToDate(data['lastRefillDate']),
      instructions: data['instructions'] as String?,
      status: MedicationStatus.values.parse(data['status']),
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  factory MedicationModel.fromJson(Map<String, dynamic> json) {
    return MedicationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      dosage: json['dosage'] as String,
      frequency: MedicationFrequency.values.parse(json['frequency']),
      route: MedicationRoute.values.parse(json['route']),
      form: MedicationForm.values.parseOrNull(json['form']),
      scheduledTimes:
          ModelUtils.timestampListToDateList(json['scheduledTimes']),
      startDate: (json['startDate'] as Timestamp).toDate(),
      endDate: ModelUtils.timestampToDate(json['endDate']),
      reasonForUse: json['reasonForUse'] as String?,
      prescribedBy: json['prescribedBy'] as String?,
      pharmacy: json['pharmacy'] as String?,
      refillsRemaining: json['refillsRemaining'] as int?,
      lastRefillDate: ModelUtils.timestampToDate(json['lastRefillDate']),
      instructions: json['instructions'] as String?,
      status: MedicationStatus.values.parse(json['status']),
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'frequency': frequency.name,
      'route': route.name,
      'form': form?.name,
      'scheduledTimes': ModelUtils.dateListToTimestampList(scheduledTimes),
      'startDate': Timestamp.fromDate(startDate),
      'endDate': ModelUtils.dateToTimestamp(endDate),
      'reasonForUse': reasonForUse,
      'prescribedBy': prescribedBy,
      'pharmacy': pharmacy,
      'refillsRemaining': refillsRemaining,
      'lastRefillDate': ModelUtils.dateToTimestamp(lastRefillDate),
      'instructions': instructions,
      'status': status.name,
    };
  }

  MedicationModel copyWith({
    String? id,
    String? name,
    String? dosage,
    MedicationFrequency? frequency,
    MedicationRoute? route,
    MedicationForm? form,
    List<DateTime>? scheduledTimes,
    DateTime? startDate,
    DateTime? endDate,
    String? reasonForUse,
    String? prescribedBy,
    String? pharmacy,
    int? refillsRemaining,
    DateTime? lastRefillDate,
    String? instructions,
    MedicationStatus? status,
    bool? isPendingSync,
  }) {
    return MedicationModel(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      frequency: frequency ?? this.frequency,
      route: route ?? this.route,
      form: form ?? this.form,
      scheduledTimes: scheduledTimes ?? this.scheduledTimes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reasonForUse: reasonForUse ?? this.reasonForUse,
      prescribedBy: prescribedBy ?? this.prescribedBy,
      pharmacy: pharmacy ?? this.pharmacy,
      refillsRemaining: refillsRemaining ?? this.refillsRemaining,
      lastRefillDate: lastRefillDate ?? this.lastRefillDate,
      instructions: instructions ?? this.instructions,
      status: status ?? this.status,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  @override
  String toString() {
    return 'MedicationModel(id: $id, name: $name, dosage: $dosage, route: ${route.abbreviation}, status: ${status.displayName})';
  }
}
