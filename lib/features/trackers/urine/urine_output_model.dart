import 'package:cloud_firestore/cloud_firestore.dart';

class UrineOutputModel {
  final String id;
  final String outputName;
  final double quantity;
  final Timestamp timestamp;

  UrineOutputModel({
    required this.id,
    required this.outputName,
    required this.quantity,
    required this.timestamp,
  });

  factory UrineOutputModel.fromJson(Map<String, dynamic> json) {
    return UrineOutputModel(
      id: json['id'] as String,
      outputName: json['outputName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      timestamp: json['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'outputName': outputName,
      'quantity': quantity,
      'timestamp': timestamp,
    };
  }
}
