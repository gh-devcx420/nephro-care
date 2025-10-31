import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';

class UrineModel {
  final String id;
  final String outputName;
  final double volume;
  final Timestamp timestamp;
  final bool isPendingSync;

  UrineModel({
    required this.id,
    required this.outputName,
    required this.volume,
    required this.timestamp,
    this.isPendingSync = false,
  });

  factory UrineModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return UrineModel(
      id: data['id'] as String,
      outputName: data['outputName'] as String,
      volume: (data['quantity'] as num).toDouble(),
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  factory UrineModel.fromJson(Map<String, dynamic> json) {
    return UrineModel(
      id: json['id'] as String,
      outputName: json['outputName'] as String,
      volume: (json['quantity'] as num).toDouble(),
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outputName': outputName,
      'quantity': volume,
      'timestamp': timestamp,
    };
  }
}
