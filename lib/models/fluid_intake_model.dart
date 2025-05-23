import 'package:cloud_firestore/cloud_firestore.dart';

class FluidIntake {
  final String id;
  final String fluidName;
  final double quantity;
  final Timestamp timestamp;

  FluidIntake({
    required this.id,
    required this.fluidName,
    required this.quantity,
    required this.timestamp,
  });

  factory FluidIntake.fromJson(Map<String, dynamic> json) {
    return FluidIntake(
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
