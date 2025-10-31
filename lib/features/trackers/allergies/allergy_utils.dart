import 'package:nephro_care/features/trackers/allergies/allergy_enums.dart';
import 'package:nephro_care/features/trackers/allergies/allergy_model.dart';

class AllergyUtils {
  /// Check if an allergy is critical (severe or anaphylaxis)
  static bool isCritical(AllergyModel allergy) {
    return allergy.severity == AllergySeverity.severe ||
        allergy.severity == AllergySeverity.anaphylaxis;
  }

  /// Get a formatted display string for the allergy
  static String getDisplaySummary(AllergyModel allergy) {
    final buffer = StringBuffer(allergy.allergen);
    if (allergy.reaction != null && allergy.reaction!.isNotEmpty) {
      buffer.write(' - ${allergy.reaction}');
    }
    buffer.write(' (${allergy.severity.displayName})');
    return buffer.toString();
  }

  /// Get a short summary (just allergen and severity)
  static String getShortSummary(AllergyModel allergy) {
    return '${allergy.allergen} (${allergy.severity.displayName})';
  }

  /// Filter active allergies from a list
  static List<AllergyModel> getActiveAllergies(List<AllergyModel> allergies) {
    return allergies.where((allergy) => allergy.isActive).toList();
  }

  /// Filter critical allergies from a list
  static List<AllergyModel> getCriticalAllergies(List<AllergyModel> allergies) {
    return allergies.where((allergy) => isCritical(allergy)).toList();
  }

  /// Sort allergies by severity (most severe first)
  static List<AllergyModel> sortBySeverity(List<AllergyModel> allergies) {
    final sorted = List<AllergyModel>.from(allergies);
    sorted.sort((a, b) => b.severity.severity.compareTo(a.severity.severity));
    return sorted;
  }

  /// Sort allergies by date (most recent first)
  static List<AllergyModel> sortByDate(List<AllergyModel> allergies) {
    final sorted = List<AllergyModel>.from(allergies);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  /// Format onset date for display
  static String? formatOnsetDate(AllergyModel allergy) {
    if (allergy.onsetDate == null) return null;
    final date = allergy.onsetDate!;
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Get days since onset
  static int? getDaysSinceOnset(AllergyModel allergy) {
    if (allergy.onsetDate == null) return null;
    return DateTime.now().difference(allergy.onsetDate!).inDays;
  }

  /// Check if allergy information is complete
  static bool isComplete(AllergyModel allergy) {
    return allergy.allergen.isNotEmpty &&
        allergy.reaction != null &&
        allergy.reaction!.isNotEmpty;
  }

  /// Validate allergy data
  static bool isValid(AllergyModel allergy) {
    if (allergy.allergen.trim().isEmpty) return false;
    if (allergy.onsetDate != null &&
        allergy.onsetDate!.isAfter(DateTime.now())) {
      return false;
    }
    return true;
  }
}
