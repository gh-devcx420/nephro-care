import 'package:cloud_firestore/cloud_firestore.dart';

class BPMonitor {
  final String id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final double? spo2;
  final Timestamp timestamp;

  BPMonitor({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    this.spo2,
    required this.timestamp,
  });

  factory BPMonitor.fromJson(Map<String, dynamic> json) {
    return BPMonitor(
      id: json['id'] as String,
      systolic: (json['systolic'] as num).toInt(),
      diastolic: (json['diastolic'] as num).toInt(),
      pulse: (json['pulse'] as num).toInt(),
      spo2: json['spo2'] != null ? (json['spo2'] as num).toDouble() : null,
      timestamp: json['timestamp'] as Timestamp,
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
