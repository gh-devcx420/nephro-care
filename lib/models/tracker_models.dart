import 'package:cloud_firestore/cloud_firestore.dart';

class Cache<T> {
  final List<T> items;
  final DateTime lastFetched;

  Cache({
    required this.items,
    required this.lastFetched,
  });
}

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

class Weight {
  final String id;
  final double weight;
  final Timestamp timestamp;

  Weight({
    required this.id,
    required this.weight,
    required this.timestamp,
  });

  factory Weight.fromJson(Map<String, dynamic> json) {
    return Weight(
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

class BPMonitor {
  final String id;
  final int systolic;
  final int diastolic;
  final int pulse;
  final double? spo2;
  final Timestamp timestamp;

  BPMonitor({
    required this.id,
    required this.systolic,
    required this.diastolic,
    required this.pulse,
    this.spo2,
    required this.timestamp,
  });

  factory BPMonitor.fromJson(Map<String, dynamic> json) {
    return BPMonitor(
      id: json['id'] as String,
      systolic: (json['systolic'] as num).toInt(),
      diastolic: (json['diastolic'] as num).toInt(),
      pulse: (json['pulse'] as num).toInt(),
      spo2: json['spo2'] != null ? (json['spo2'] as num).toDouble() : null,
      timestamp: json['timestamp'] as Timestamp,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'systolic': systolic,
      'diastolic': diastolic,
      'pulse': pulse,
      'spo2': spo2,
      'timestamp': timestamp,
    };
  }
}
