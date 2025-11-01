import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';

class BPTrackerModel {
  final String id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final double? spo2;
  final Timestamp timestamp;
  final bool isPendingSync;
  final BPReadingType readingType;
  final String? dialysisSessionId;

  BPTrackerModel({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    this.spo2,
    required this.timestamp,
    this.isPendingSync = false,
    this.readingType = BPReadingType.normal,
    this.dialysisSessionId,
  });

  bool get isFromDialysis => readingType.isFromDialysis;

  factory BPTrackerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;

    // Parse reading type from string, default to normal
    BPReadingType readingType = BPReadingType.normal;
    if (data['readingType'] != null) {
      try {
        readingType =
            BPReadingType.values.byName(data['readingType'] as String);
      } catch (e) {
        // If parsing fails, default to normal
        readingType = BPReadingType.normal;
      }
    }

    return BPTrackerModel(
      id: data['id'] as String,
      systolic: (data['systolic'] as num).toInt(),
      diastolic: (data['diastolic'] as num).toInt(),
      pulse: (data['pulse'] as num).toInt(),
      spo2: (data['spo2'] as num?)?.toDouble(),
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
      readingType: readingType,
      dialysisSessionId: data['dialysisSessionId'] as String?,
    );
  }

  factory BPTrackerModel.fromJson(Map<String, dynamic> json) {
    // Parse reading type from string, default to normal
    BPReadingType readingType = BPReadingType.normal;
    if (json['readingType'] != null) {
      try {
        readingType =
            BPReadingType.values.byName(json['readingType'] as String);
      } catch (e) {
        readingType = BPReadingType.normal;
      }
    }

    return BPTrackerModel(
      id: json['id'] as String,
      systolic: (json['systolic'] as num).toInt(),
      diastolic: (json['diastolic'] as num).toInt(),
      pulse: (json['pulse'] as num).toInt(),
      spo2: (json['spo2'] as num?)?.toDouble(),
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
      readingType: readingType,
      dialysisSessionId: json['dialysisSessionId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'spo2': spo2,
      'timestamp': timestamp,
      'readingType': readingType.name, // Store as string
      'dialysisSessionId': dialysisSessionId,
    };
  }

  // ✨ Helper: Create a copy with different reading type and session ID
  BPTrackerModel copyWith({
    String? id,
    int? systolic,
    int? diastolic,
    int? pulse,
    double? spo2,
    Timestamp? timestamp,
    bool? isPendingSync,
    BPReadingType? readingType,
    String? dialysisSessionId,
  }) {
    return BPTrackerModel(
      id: id ?? this.id,
      systolic: systolic ?? this.systolic,
      diastolic: diastolic ?? this.diastolic,
      pulse: pulse ?? this.pulse,
      spo2: spo2 ?? this.spo2,
      timestamp: timestamp ?? this.timestamp,
      isPendingSync: isPendingSync ?? this.isPendingSync,
      readingType: readingType ?? this.readingType,
      dialysisSessionId: dialysisSessionId ?? this.dialysisSessionId,
    );
  }

  @override
  String toString() {
    return 'BPTrackerModel(id: $id, BP: $systolic/$diastolic, type: ${readingType.displayName}, dialysisSession: $dialysisSessionId)';
  }
}
