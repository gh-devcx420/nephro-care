import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';

class BPTrackerModel {
  final String id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final double? spo2;
  final Timestamp timestamp;
  final bool isPendingSync;

  BPTrackerModel({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    this.spo2,
    required this.timestamp,
    this.isPendingSync = false,
  });

  factory BPTrackerModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return BPTrackerModel(
      id: data['id'] as String,
      systolic: (data['systolic'] as num).toInt(),
      diastolic: (data['diastolic'] as num).toInt(),
      pulse: (data['pulse'] as num).toInt(),
      spo2: (data['spo2'] as num?)?.toDouble(),
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  factory BPTrackerModel.fromJson(Map<String, dynamic> json) {
    return BPTrackerModel(
      id: json['id'] as String,
      systolic: (json['systolic'] as num).toInt(),
      diastolic: (json['diastolic'] as num).toInt(),
      pulse: (json['pulse'] as num).toInt(),
      spo2: (json['spo2'] as num?)?.toDouble(),
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
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
    };
  }
}
