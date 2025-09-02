import 'package:cloud_firestore/cloud_firestore.dart';

class WeightModel {
  final String id;
  final double weight;
  final Timestamp timestamp;

  WeightModel({
    required this.id,
    required this.weight,
    required this.timestamp,
  });

  factory WeightModel.fromJson(Map<String, dynamic> json) {
    return WeightModel(
      id: json['id'] as String,
      weight: (json['weight'] as num).toDouble(),
      timestamp: json['timestamp'] as Timestamp,
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
