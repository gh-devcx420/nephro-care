import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/dialysis/dialysis_enums.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';

class DialysisModel {
  final String id;
  final DialysisType dialysisType;
  final DialyserType dialyserType;
  final int dialyserReuseNumber;
  final DialysisAccess access;

  final DateTime sessionStartTime;
  final double sessionDuration;
  final DateTime sessionEndTime;

  final int? bloodPumpSpeed;
  final String? sessionRemarks;
  final Timestamp timestamp;
  final bool isPendingSync;

  final String? preDialysisBPRestingId;
  final String? preDialysisBPStandingId;
  final String? postDialysisBPRestingId;
  final String? postDialysisBPStandingId;

  // ToDo: Weight/Urine (implement later)
  // final String? preWeightId;
  // final String? postWeightId;
  // final String? ultraFiltrationTargetId;

  DialysisModel({
    required this.id,
    required this.dialysisType,
    required this.dialyserType,
    required this.dialyserReuseNumber,
    required this.access,
    required this.sessionStartTime,
    required this.sessionDuration,
    required this.sessionEndTime,
    this.bloodPumpSpeed,
    this.sessionRemarks,
    required this.timestamp,
    this.isPendingSync = false,
    // BP References
    this.preDialysisBPRestingId,
    this.preDialysisBPStandingId,
    this.postDialysisBPRestingId,
    this.postDialysisBPStandingId,
  });

  factory DialysisModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return DialysisModel(
      id: data['id'] as String,
      dialysisType: DialysisType.values.parse(data['dialysisType']),
      dialyserType: DialyserType.values.parse(data['dialyserType']),
      dialyserReuseNumber: (data['dialyserReuseNumber'] as num?)?.toInt() ?? 0,
      access: DialysisAccess.values.parse(data['access']),
      sessionStartTime: (data['sessionStartTime'] as Timestamp).toDate(),
      sessionDuration: (data['sessionDuration'] as num).toDouble(),
      sessionEndTime: (data['sessionEndTime'] as Timestamp).toDate(),
      bloodPumpSpeed: data['bloodPumpSpeed'] as int?,
      sessionRemarks: data['sessionRemarks'] as String?,
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
      // Load BP reference IDs
      preDialysisBPRestingId: data['preDialysisBPRestingId'] as String?,
      preDialysisBPStandingId: data['preDialysisBPStandingId'] as String?,
      postDialysisBPRestingId: data['postDialysisBPRestingId'] as String?,
      postDialysisBPStandingId: data['postDialysisBPStandingId'] as String?,
    );
  }

  factory DialysisModel.fromJson(Map<String, dynamic> json) {
    return DialysisModel(
      id: json['id'] as String,
      dialysisType: DialysisType.values.parse(json['dialysisType']),
      dialyserType: DialyserType.values.parse(json['dialyserType']),
      dialyserReuseNumber: (json['dialyserReuseNumber'] as num?)?.toInt() ?? 0,
      access: DialysisAccess.values.parse(json['access']),
      sessionStartTime: DateTime.parse(json['sessionStartTime'] as String),
      sessionDuration: (json['sessionDuration'] as num).toDouble(),
      sessionEndTime: DateTime.parse(json['sessionEndTime'] as String),
      bloodPumpSpeed: json['bloodPumpSpeed'] as int?,
      sessionRemarks: json['sessionRemarks'] as String?,
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
      // Load BP reference IDs
      preDialysisBPRestingId: json['preDialysisBPRestingId'] as String?,
      preDialysisBPStandingId: json['preDialysisBPStandingId'] as String?,
      postDialysisBPRestingId: json['postDialysisBPRestingId'] as String?,
      postDialysisBPStandingId: json['postDialysisBPStandingId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dialysisType': dialysisType.name,
      'dialyserType': dialyserType.name,
      'dialyserReuseNumber': dialyserReuseNumber,
      'access': access.name,
      'sessionStartTime': Timestamp.fromDate(sessionStartTime),
      'sessionDuration': sessionDuration,
      'sessionEndTime': Timestamp.fromDate(sessionEndTime),
      'bloodPumpSpeed': bloodPumpSpeed,
      'sessionRemarks': sessionRemarks,
      'timestamp': timestamp,
      // Save BP reference IDs
      'preDialysisBPRestingId': preDialysisBPRestingId,
      'preDialysisBPStandingId': preDialysisBPStandingId,
      'postDialysisBPRestingId': postDialysisBPRestingId,
      'postDialysisBPStandingId': postDialysisBPStandingId,
    };
  }

  DialysisModel copyWith({
    String? id,
    DialysisType? dialysisType,
    DialyserType? dialyserType,
    int? dialyserReuseNumber,
    DialysisAccess? access,
    DateTime? sessionStartTime,
    double? sessionDuration,
    DateTime? sessionEndTime,
    int? bloodPumpSpeed,
    String? sessionRemarks,
    Timestamp? timestamp,
    bool? isPendingSync,
    String? preDialysisBPRestingId,
    String? preDialysisBPStandingId,
    String? postDialysisBPRestingId,
    String? postDialysisBPStandingId,
  }) {
    return DialysisModel(
      id: id ?? this.id,
      dialysisType: dialysisType ?? this.dialysisType,
      dialyserType: dialyserType ?? this.dialyserType,
      dialyserReuseNumber: dialyserReuseNumber ?? this.dialyserReuseNumber,
      access: access ?? this.access,
      sessionStartTime: sessionStartTime ?? this.sessionStartTime,
      sessionDuration: sessionDuration ?? this.sessionDuration,
      sessionEndTime: sessionEndTime ?? this.sessionEndTime,
      bloodPumpSpeed: bloodPumpSpeed ?? this.bloodPumpSpeed,
      sessionRemarks: sessionRemarks ?? this.sessionRemarks,
      timestamp: timestamp ?? this.timestamp,
      isPendingSync: isPendingSync ?? this.isPendingSync,
      preDialysisBPRestingId:
          preDialysisBPRestingId ?? this.preDialysisBPRestingId,
      preDialysisBPStandingId:
          preDialysisBPStandingId ?? this.preDialysisBPStandingId,
      postDialysisBPRestingId:
          postDialysisBPRestingId ?? this.postDialysisBPRestingId,
      postDialysisBPStandingId:
          postDialysisBPStandingId ?? this.postDialysisBPStandingId,
    );
  }

  @override
  String toString() {
    return 'DialysisModel('
        'id: $id, '
        'type: ${dialysisType.displayName}, '
        'dialyser: ${dialyserType.displayName} (Reuse #$dialyserReuseNumber), '
        'access: ${access.displayName}, '
        'duration: $sessionDuration hrs, '
        'start: $sessionStartTime, '
        'end: $sessionEndTime'
        ')';
  }
}

// DialysisCenterModel remains unchanged
class DialysisCenterModel {
  final String id;
  final String name;
  final GeoPoint? location;
  final String phoneNumber;

  DialysisCenterModel({
    required this.id,
    required this.name,
    this.location,
    required this.phoneNumber,
  });

  factory DialysisCenterModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return DialysisCenterModel(
      id: data['id'] as String,
      name: data['name'] as String,
      location: data['location'] as GeoPoint?,
      phoneNumber: data['phoneNumber'] as String,
    );
  }

  factory DialysisCenterModel.fromJson(Map<String, dynamic> json) {
    return DialysisCenterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      location: json['location'] as GeoPoint?,
      phoneNumber: json['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'phoneNumber': phoneNumber,
    };
  }

  DialysisCenterModel copyWith({
    String? id,
    String? name,
    GeoPoint? location,
    String? phoneNumber,
  }) {
    return DialysisCenterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  String toString() {
    return 'DialysisCenterModel(id: $id, name: $name, phone: $phoneNumber)';
  }
}
