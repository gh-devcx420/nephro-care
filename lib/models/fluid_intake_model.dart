import 'package:cloud_firestore/cloud_firestore.dart';

// This class represents a single water intake entry (like one line in your journal)
class FluidIntake {
  final String id; // A unique ID for this entry (e.g., "123456789")
  final String fluidName; // The name of the fluid (e.g., "Water")
  final double quantity; // The amount in milliliters (e.g., 300.0)
  final Timestamp
      timestamp; // The date and time of the entry (e.g., May 4, 2025, 9:07 PM)

  // Constructor: This is how we create a new WaterIntake entry
  FluidIntake({
    required this.id, // We must provide an ID
    required this.fluidName, // We must provide a fluid name
    required this.quantity, // We must provide a quantity
    required this.timestamp, // We must provide a timestamp
  });

  // Converts a WaterIntake entry into a format Firestore can store (a map, like a dictionary)
  Map<String, dynamic> toJson() => {
        'id': id, // Store the ID in the map
        'fluidName': fluidName, // Store the fluid name
        'quantity': quantity, // Store the quantity
        'timestamp': timestamp, // Store the timestamp
      };

  // Creates a WaterIntake entry from Firestore data (a map)
  static FluidIntake fromJson(Map<String, dynamic> json) => FluidIntake(
        id: json['id'],
        // Get the ID from the map
        fluidName: json['fluidName'],
        // Get the fluid name
        quantity: (json['quantity'] as num).toDouble(),
        // Get the quantity and convert to double
        timestamp: json['timestamp'], // Get the timestamp
      );
}
