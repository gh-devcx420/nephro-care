import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/comorbidities/comorbidities_enums.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';

class ComorbidityModel {
  final String id;
  final String condition;
  final Timestamp diagnosisDate;
  final ComorbidityStatus status;
  final String? notes;
  final Timestamp createdAt;
  final bool isPendingSync;

  ComorbidityModel({
    required this.id,
    required this.condition,
    required this.diagnosisDate,
    required this.status,
    this.notes,
    required this.createdAt,
    this.isPendingSync = false,
  });

  factory ComorbidityModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return ComorbidityModel(
      id: data['id'] as String,
      condition: data['condition'] as String,
      diagnosisDate: data['diagnosisDate'] as Timestamp,
      status: ComorbidityStatus.values.parse(data['status']),
      notes: data['notes'] as String?,
      createdAt: data['createdAt'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  factory ComorbidityModel.fromJson(Map<String, dynamic> json) {
    return ComorbidityModel(
      id: json['id'] as String,
      condition: json['condition'] as String,
      diagnosisDate: json['diagnosisDate'] as Timestamp,
      status: ComorbidityStatus.values.parse(json['status']),
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as Timestamp,
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'condition': condition,
      'diagnosisDate': diagnosisDate,
      'status': status.name,
      'notes': notes,
      'createdAt': createdAt,
    };
  }

  ComorbidityModel copyWith({
    String? id,
    String? condition,
    Timestamp? diagnosisDate,
    ComorbidityStatus? status,
    String? notes,
    Timestamp? createdAt,
    bool? isPendingSync,
  }) {
    return ComorbidityModel(
      id: id ?? this.id,
      condition: condition ?? this.condition,
      diagnosisDate: diagnosisDate ?? this.diagnosisDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  @override
  String toString() {
    return 'ComorbidityModel(condition: $condition, status: ${status.displayName}, date: ${diagnosisDate.toDate().toString().split(' ')[0]})';
  }
}
