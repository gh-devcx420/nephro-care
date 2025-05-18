import 'package:cloud_firestore/cloud_firestore.dart';

class UrineOutput {
  final String id;
  final String outputName;
  final double quantity;
  final Timestamp timestamp;

  UrineOutput({
    required this.id,
    required this.outputName,
    required this.quantity,
    required this.timestamp,
  });

  factory UrineOutput.fromJson(Map<String, dynamic> json) {
    return UrineOutput(
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
