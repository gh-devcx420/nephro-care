import 'package:nephro_care/features/trackers/medical_records/medical_record_constants.dart';
import 'package:nephro_care/features/trackers/medical_records/medical_records_enums.dart';
import 'package:nephro_care/features/trackers/medical_records/medical_records_model.dart';

class MedicalRecordsUtils {
  /// Validates notes length
  static bool isValidNotes(String? notes) {
    if (notes == null || notes.trim().isEmpty) return true; // Optional field
    return notes.length <= MedicalRecordsConstants.notesMaxChars;
  }

  /// Validates title length
  static bool isValidTitle(String title) {
    return title.trim().isNotEmpty &&
        title.length <= MedicalRecordsConstants.titleMaxChars;
  }

  /// Validates attachment URL length (URL validity check would be more complex)
  static bool isValidAttachmentUrl(String? url) {
    if (url == null || url.trim().isEmpty) return true; // Optional field
    return url.length <= MedicalRecordsConstants.attachmentUrlMaxChars;
  }

  /// Groups medical records by category
  static Map<RecordCategory, List<MedicalRecordModel>> groupByCategory(
    List<MedicalRecordModel> records,
  ) {
    final groups = <RecordCategory, List<MedicalRecordModel>>{};

    for (final record in records) {
      groups.putIfAbsent(record.category, () => []).add(record);
    }

    return groups;
  }

  /// Sorts records by record date (most recent first)
  static List<MedicalRecordModel> sortByMostRecentDate(
    List<MedicalRecordModel> records,
  ) {
    final sorted = List<MedicalRecordModel>.from(records);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted;
  }
}
