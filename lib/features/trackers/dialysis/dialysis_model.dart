import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_model.dart';
import 'package:nephro_care/features/trackers/dialysis/dialysis_enums.dart';
import 'package:nephro_care/features/trackers/urine/urine_model.dart';
import 'package:nephro_care/features/trackers/weight/weight_model.dart';

class DialysisModel {
  final String id;
  final DialysisType type;
  final DialysisAccess access;
  final double duration; // in hours
  final WeightModel? preWeight;
  final WeightModel? postWeight;
  final BPTrackerModel? preDialysisBPResting;
  final BPTrackerModel? preDialysisBPStanding;
  final BPTrackerModel? postDialysisBPResting;
  final BPTrackerModel? postDialysisBPStanding;
  final UrineModel? ultrafiltration;
  final String? notes;
  final Timestamp timestamp;
  final bool isPendingSync;

  DialysisModel({
    required this.id,
    required this.type,
    required this.access,
    required this.duration,
    this.preWeight,
    this.postWeight,
    this.preDialysisBPResting,
    this.preDialysisBPStanding,
    this.postDialysisBPResting,
    this.postDialysisBPStanding,
    this.ultrafiltration,
    this.notes,
    required this.timestamp,
    this.isPendingSync = false,
  });

  /// Creates DialysisModel from Firestore document with metadata
  factory DialysisModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return DialysisModel(
      id: data['id'] as String,
      type: DialysisType.values.byName(data['type'] as String),
      access: DialysisAccess.values.byName(data['access'] as String),
      duration: (data['duration'] as num).toDouble(),
      preWeight: data['preWeight'] != null
          ? WeightModel.fromJson(data['preWeight'] as Map<String, dynamic>)
          : null,
      postWeight: data['postWeight'] != null
          ? WeightModel.fromJson(data['postWeight'] as Map<String, dynamic>)
          : null,
      preDialysisBPResting: data['preDialysisBPResting'] != null
          ? BPTrackerModel.fromJson(
              data['preDialysisBPResting'] as Map<String, dynamic>)
          : null,
      preDialysisBPStanding: data['preDialysisBPStanding'] != null
          ? BPTrackerModel.fromJson(
              data['preDialysisBPStanding'] as Map<String, dynamic>)
          : null,
      postDialysisBPResting: data['postDialysisBPResting'] != null
          ? BPTrackerModel.fromJson(
              data['postDialysisBPResting'] as Map<String, dynamic>)
          : null,
      postDialysisBPStanding: data['postDialysisBPStanding'] != null
          ? BPTrackerModel.fromJson(
              data['postDialysisBPStanding'] as Map<String, dynamic>)
          : null,
      ultrafiltration: data['ultrafiltration'] != null
          ? UrineModel.fromJson(data['ultrafiltration'] as Map<String, dynamic>)
          : null,
      notes: data['notes'] as String?,
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: doc.metadata.hasPendingWrites,
    );
  }

  /// Creates DialysisModel from JSON map (backward compatibility)
  factory DialysisModel.fromJson(Map<String, dynamic> json) {
    return DialysisModel(
      id: json['id'] as String,
      type: DialysisType.values.byName(json['type'] as String),
      access: DialysisAccess.values.byName(json['access'] as String),
      duration: (json['duration'] as num).toDouble(),
      preWeight: json['preWeight'] != null
          ? WeightModel.fromJson(json['preWeight'] as Map<String, dynamic>)
          : null,
      postWeight: json['postWeight'] != null
          ? WeightModel.fromJson(json['postWeight'] as Map<String, dynamic>)
          : null,
      preDialysisBPResting: json['preDialysisBPResting'] != null
          ? BPTrackerModel.fromJson(
              json['preDialysisBPResting'] as Map<String, dynamic>)
          : null,
      preDialysisBPStanding: json['preDialysisBPStanding'] != null
          ? BPTrackerModel.fromJson(
              json['preDialysisBPStanding'] as Map<String, dynamic>)
          : null,
      postDialysisBPResting: json['postDialysisBPResting'] != null
          ? BPTrackerModel.fromJson(
              json['postDialysisBPResting'] as Map<String, dynamic>)
          : null,
      postDialysisBPStanding: json['postDialysisBPStanding'] != null
          ? BPTrackerModel.fromJson(
              json['postDialysisBPStanding'] as Map<String, dynamic>)
          : null,
      ultrafiltration: json['ultrafiltration'] != null
          ? UrineModel.fromJson(json['ultrafiltration'] as Map<String, dynamic>)
          : null,
      notes: json['notes'] as String?,
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
    );
  }

  /// Converts DialysisModel to JSON map for Firestore storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'access': access.name,
      'duration': duration,
      'preWeight': preWeight?.toJson(),
      'postWeight': postWeight?.toJson(),
      'preDialysisBPResting': preDialysisBPResting?.toJson(),
      'preDialysisBPStanding': preDialysisBPStanding?.toJson(),
      'postDialysisBPResting': postDialysisBPResting?.toJson(),
      'postDialysisBPStanding': postDialysisBPStanding?.toJson(),
      'ultrafiltration': ultrafiltration?.toJson(),
      'notes': notes,
      'timestamp': timestamp,
      // Don't save isPendingSync - it comes from metadata
    };
  }

  /// Creates a copy of this model with updated fields
  DialysisModel copyWith({
    String? id,
    DialysisType? type,
    DialysisAccess? access,
    double? duration,
    WeightModel? preWeight,
    WeightModel? postWeight,
    BPTrackerModel? preDialysisBPResting,
    BPTrackerModel? preDialysisBPStanding,
    BPTrackerModel? postDialysisBPResting,
    BPTrackerModel? postDialysisBPStanding,
    UrineModel? ultrafiltration,
    String? notes,
    Timestamp? timestamp,
    bool? isPendingSync,
  }) {
    return DialysisModel(
      id: id ?? this.id,
      type: type ?? this.type,
      access: access ?? this.access,
      duration: duration ?? this.duration,
      preWeight: preWeight ?? this.preWeight,
      postWeight: postWeight ?? this.postWeight,
      preDialysisBPResting: preDialysisBPResting ?? this.preDialysisBPResting,
      preDialysisBPStanding:
          preDialysisBPStanding ?? this.preDialysisBPStanding,
      postDialysisBPResting:
          postDialysisBPResting ?? this.postDialysisBPResting,
      postDialysisBPStanding:
          postDialysisBPStanding ?? this.postDialysisBPStanding,
      ultrafiltration: ultrafiltration ?? this.ultrafiltration,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  @override
  String toString() {
    return 'DialysisModel(id: $id, type: ${type.displayName}, access: ${access.displayName}, duration: $duration hrs)';
  }
}
