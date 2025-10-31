import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nephro_care/features/trackers/generic/generic_utils.dart';
import 'package:nephro_care/features/trackers/medical_records/medical_records_enums.dart';

class MedicalRecordModel {
  final String id;
  final String title;
  final RecordCategory category;
  final Timestamp date;
  final String? attachmentUrl;
  final String? notes;
  final Timestamp uploadedAt;
  final bool isPendingSync;

  MedicalRecordModel({
    required this.id,
    required this.title,
    required this.category,
    required this.date,
    this.attachmentUrl,
    this.notes,
    required this.uploadedAt,
    this.isPendingSync = false,
  });

  factory MedicalRecordModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data()!;
    return MedicalRecordModel(
      id: data['id'] as String,
      title: data['title'] as String,
      category: RecordCategory.values.parse(data['category']),
      date: data['date'] as Timestamp,
      attachmentUrl: data['attachmentUrl'] as String?,
      notes: data['notes'] as String?,
      uploadedAt: data['uploadedAt'] as Timestamp,
      isPendingSync: ModelUtils.getPendingSyncStatus(doc),
    );
  }

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] as String,
      title: json['title'] as String,
      category: RecordCategory.values.parse(json['category']),
      date: json['date'] as Timestamp,
      attachmentUrl: json['attachmentUrl'] as String?,
      notes: json['notes'] as String?,
      uploadedAt: json['uploadedAt'] as Timestamp,
      isPendingSync: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'date': date,
      'attachmentUrl': attachmentUrl,
      'notes': notes,
      'uploadedAt': uploadedAt,
    };
  }

  MedicalRecordModel copyWith({
    String? id,
    String? title,
    RecordCategory? category,
    Timestamp? date,
    String? attachmentUrl,
    String? notes,
    Timestamp? uploadedAt,
    bool? isPendingSync,
  }) {
    return MedicalRecordModel(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
      notes: notes ?? this.notes,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      isPendingSync: isPendingSync ?? this.isPendingSync,
    );
  }

  @override
  String toString() {
    return 'MedicalRecordModel(title: $title, category: ${category.displayName}, date: ${date.toDate().toString().split(' ')[0]})';
  }
}
