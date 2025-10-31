import 'package:cloud_firestore/cloud_firestore.dart';

class FluidsModel {
  final String id;
  final String fluidName;
  final double quantity;
  final Timestamp timestamp;
  final bool isPendingSync;

  FluidsModel({
    required this.id,
    required this.fluidName,
    required this.quantity,
    required this.timestamp,
    this.isPendingSync = false,
  });

  factory FluidsModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return FluidsModel(
      id: data['id'] as String,
      fluidName: data['fluidName'] as String,
      quantity: (data['quantity'] as num).toDouble(),
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync:
          doc.metadata.hasPendingWrites, // 👈 Gets sync status from Firestore
    );
  }

  // Keep this for backward compatibility
  factory FluidsModel.fromJson(Map<String, dynamic> json) {
    return FluidsModel(
      id: json['id'] as String,
      fluidName: json['fluidName'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fluidName': fluidName,
      'quantity': quantity,
      'timestamp': timestamp,
      // ❌ DON'T save isPendingSync - it comes from metadata now
    };
  }
}
