import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/allergies/allergy_enums.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';

class AllergyModel {
  final String id;
  final String allergen;
  final AllergySeverity severity;
  final String? reaction;
  final DateTime? onsetDate;
  final String? diagnosedBy;
  final String? notes;
  final bool isActive;
  final Timestamp timestamp;
  final bool isPendingSync;

  AllergyModel({
    required this.id,
    required this.allergen,
    required this.severity,
    this.reaction,
    this.onsetDate,
    this.diagnosedBy,
    this.notes,
    this.isActive = true,
    required this.timestamp,
    this.isPendingSync = false,
  });

  factory AllergyModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return AllergyModel(
      id: data['id'] as String,
      allergen: data['allergen'] as String,
      severity: AllergySeverity.values.parse(data['severity']),
      reaction: data['reaction'] as String?,
      onsetDate: ModelUtils.timestampToDate(data['onsetDate']),
      diagnosedBy: data['diagnosedBy'] as String?,
      notes: data['notes'] as String?,
      isActive: data['isActive'] as bool? ?? true,
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  factory AllergyModel.fromJson(Map<String, dynamic> json) {
    return AllergyModel(
      id: json['id'] as String,
      allergen: json['allergen'] as String,
      severity: AllergySeverity.values.parse(json['severity']),
      reaction: json['reaction'] as String?,
      onsetDate: ModelUtils.timestampToDate(json['onsetDate']),
      diagnosedBy: json['diagnosedBy'] as String?,
      notes: json['notes'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'allergen': allergen,
      'severity': severity.name,
      'reaction': reaction,
      'onsetDate': ModelUtils.dateToTimestamp(onsetDate),
      'diagnosedBy': diagnosedBy,
      'notes': notes,
      'isActive': isActive,
      'timestamp': timestamp,
    };
  }

  AllergyModel copyWith({
    String? id,
    String? allergen,
    AllergySeverity? severity,
    String? reaction,
    DateTime? onsetDate,
    String? diagnosedBy,
    String? notes,
    bool? isActive,
    Timestamp? timestamp,
    bool? isPendingSync,
  }) {
    return AllergyModel(
      id: id ?? this.id,
      allergen: allergen ?? this.allergen,
      severity: severity ?? this.severity,
      reaction: reaction ?? this.reaction,
      onsetDate: onsetDate ?? this.onsetDate,
      diagnosedBy: diagnosedBy ?? this.diagnosedBy,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      timestamp: timestamp ?? this.timestamp,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  @override
  String toString() {
    return 'AllergyModel(id: $id, allergen: $allergen, severity: ${severity.name}, isActive: $isActive)';
  }
}
