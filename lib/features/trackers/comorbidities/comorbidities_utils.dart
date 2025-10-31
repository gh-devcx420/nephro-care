import 'package:nephro_care/features/trackers/comorbidities/comorbidities_constants.dart';
import 'package:nephro_care/features/trackers/comorbidities/comorbidities_enums.dart';
import 'package:nephro_care/features/trackers/comorbidities/comorbidities_model.dart';

class ComorbiditiesUtils {
  /// Validates notes length
  static bool isValidNotes(String? notes) {
    if (notes == null || notes.trim().isEmpty) return true;
    return notes.length <= ComorbiditiesConstants.notesMaxChars;
  }

  /// Validates condition name length
  static bool isValidCondition(String condition) {
    return condition.trim().isNotEmpty &&
        condition.length <= ComorbiditiesConstants.conditionMaxChars;
  }

  /// Groups comorbidities by their current status
  static Map<String, List<ComorbidityModel>> groupByStatus(
    List<ComorbidityModel> comorbidities,
  ) {
    final groups = <String, List<ComorbidityModel>>{};

    for (final comorbidity in comorbidities) {
      groups
          .putIfAbsent(comorbidity.status.displayName, () => [])
          .add(comorbidity);
    }

    return groups;
  }

  /// Sorts comorbidities by diagnosis date (most recent first)
  static List<ComorbidityModel> sortByMostRecent(
    List<ComorbidityModel> comorbidities,
  ) {
    final sorted = List<ComorbidityModel>.from(comorbidities);
    sorted.sort((a, b) => b.diagnosisDate.compareTo(a.diagnosisDate));
    return sorted;
  }
}
