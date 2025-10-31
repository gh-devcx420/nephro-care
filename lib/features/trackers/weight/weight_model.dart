import 'package:cloud_firestore/cloud_firestore.dart';

class WeightModel {
  final String id;
  final double weight;
  final Timestamp timestamp;
  final bool isPendingSync;

  WeightModel({
    required this.id,
    required this.weight,
    required this.timestamp,
    this.isPendingSync = false,
  });

  factory WeightModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return WeightModel(
      id: data['id'] as String,
      weight: (data['weight'] as num).toDouble(),
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: doc.metadata.hasPendingWrites,
    );
  }

  // Keep this for backward compatibility
  factory WeightModel.fromJson(Map<String, dynamic> json) {
    return WeightModel(
      id: json['id'] as String,
      weight: (json['weight'] as num).toDouble(),
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'weight': weight,
      'timestamp': timestamp,
    };
  }
}
