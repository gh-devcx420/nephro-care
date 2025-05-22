import 'package:cloud_firestore/cloud_firestore.dart';

// This class represents a single fluid intake entry.
class FluidIntake {
  final String id;
  final String fluidName;
  final double quantity;
  final Timestamp timestamp;
  final bool toBeSynced; // New field to track offline entries

  FluidIntake({
    required this.id,
    required this.fluidName,
    required this.quantity,
    required this.timestamp,
    this.toBeSynced = false, // Default to false
  });

  // Converts a FluidIntake entry into a format Firestore can store.
  Map<String, dynamic> toJson() => {
        'id': id,
        'fluidName': fluidName,
        'quantity': quantity,
        'timestamp': timestamp,
        'toBeSynced': toBeSynced, // Include in JSON
      };

  // Creates a FluidIntake entry from Firestore data.
  static FluidIntake fromJson(Map<String, dynamic> json) => FluidIntake(
        id: json['id'],
        fluidName: json['fluidName'],
        quantity: (json['quantity'] as num).toDouble(),
        timestamp: json['timestamp'],
        toBeSynced: json['toBeSynced'] ?? false, // Handle missing field
      );
}
