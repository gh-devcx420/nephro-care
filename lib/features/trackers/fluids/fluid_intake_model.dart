import 'package:cloud_firestore/cloud_firestore.dart';

class FluidIntakeModel {
  final String id;
  final String fluidName;
  final double quantity;
  final Timestamp timestamp;

  FluidIntakeModel({
    required this.id,
    required this.fluidName,
    required this.quantity,
    required this.timestamp,
  });

  factory FluidIntakeModel.fromJson(Map<String, dynamic> json) {
    return FluidIntakeModel(
      id: json['id'] as String,
      fluidName: json['fluidName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      timestamp: json['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fluidName': fluidName,
      'quantity': quantity,
      'timestamp': timestamp,
    };
  }
}
