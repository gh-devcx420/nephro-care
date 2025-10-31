import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';
import 'package:nephro_care/features/trackers/lab_results/lab_result_enums.dart';

class LabResultModel {
  final String id;
  final CKDLabTest testType;
  final double? value;
  final String? qualitativeResult;
  final LabResultStatus status;
  final String? unit;
  final double? referenceRangeLow;
  final double? referenceRangeHigh;
  final DateTime testDate;
  final String? orderedBy;
  final String? labName;
  final String? notes;
  final Timestamp timestamp;
  final bool isPendingSync;

  LabResultModel({
    required this.id,
    required this.testType,
    this.value,
    this.qualitativeResult,
    required this.status,
    this.unit,
    this.referenceRangeLow,
    this.referenceRangeHigh,
    required this.testDate,
    this.orderedBy,
    this.labName,
    this.notes,
    required this.timestamp,
    this.isPendingSync = false,
  });

  factory LabResultModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return LabResultModel(
      id: data['id'] as String,
      testType: CKDLabTest.values.parse(data['testType']),
      value: (data['value'] as num?)?.toDouble(),
      qualitativeResult: data['qualitativeResult'] as String?,
      status: LabResultStatus.values.parse(data['status']),
      unit: data['unit'] as String?,
      referenceRangeLow: (data['referenceRangeLow'] as num?)?.toDouble(),
      referenceRangeHigh: (data['referenceRangeHigh'] as num?)?.toDouble(),
      testDate: (data['testDate'] as Timestamp).toDate(),
      orderedBy: data['orderedBy'] as String?,
      labName: data['labName'] as String?,
      notes: data['notes'] as String?,
      timestamp: data['timestamp'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  factory LabResultModel.fromJson(Map<String, dynamic> json) {
    return LabResultModel(
      id: json['id'] as String,
      testType: CKDLabTest.values.parse(json['testType']),
      value: (json['value'] as num?)?.toDouble(),
      qualitativeResult: json['qualitativeResult'] as String?,
      status: LabResultStatus.values.parse(json['status']),
      unit: json['unit'] as String?,
      referenceRangeLow: (json['referenceRangeLow'] as num?)?.toDouble(),
      referenceRangeHigh: (json['referenceRangeHigh'] as num?)?.toDouble(),
      testDate: (json['testDate'] as Timestamp).toDate(),
      orderedBy: json['orderedBy'] as String?,
      labName: json['labName'] as String?,
      notes: json['notes'] as String?,
      timestamp: json['timestamp'] as Timestamp,
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testType': testType.name,
      'value': value,
      'qualitativeResult': qualitativeResult,
      'status': status.name,
      'unit': unit,
      'referenceRangeLow': referenceRangeLow,
      'referenceRangeHigh': referenceRangeHigh,
      'testDate': Timestamp.fromDate(testDate),
      'orderedBy': orderedBy,
      'labName': labName,
      'notes': notes,
      'timestamp': timestamp,
    };
  }

  LabResultModel copyWith({
    String? id,
    CKDLabTest? testType,
    double? value,
    String? qualitativeResult,
    LabResultStatus? status,
    String? unit,
    double? referenceRangeLow,
    double? referenceRangeHigh,
    DateTime? testDate,
    String? orderedBy,
    String? labName,
    String? notes,
    Timestamp? timestamp,
    bool? isPendingSync,
  }) {
    return LabResultModel(
      id: id ?? this.id,
      testType: testType ?? this.testType,
      value: value ?? this.value,
      qualitativeResult: qualitativeResult ?? this.qualitativeResult,
      status: status ?? this.status,
      unit: unit ?? this.unit,
      referenceRangeLow: referenceRangeLow ?? this.referenceRangeLow,
      referenceRangeHigh: referenceRangeHigh ?? this.referenceRangeHigh,
      testDate: testDate ?? this.testDate,
      orderedBy: orderedBy ?? this.orderedBy,
      labName: labName ?? this.labName,
      notes: notes ?? this.notes,
      timestamp: timestamp ?? this.timestamp,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  @override
  String toString() {
    return 'LabResultModel(id: $id, testType: ${testType.displayName}, value: $value, status: ${status.displayName})';
  }
}
