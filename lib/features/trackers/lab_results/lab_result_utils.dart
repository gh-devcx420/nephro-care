import 'package:nephro_care/features/trackers/lab_results/lab_result_enums.dart';
import 'package:nephro_care/features/trackers/lab_results/lab_result_model.dart';

class LabResultUtils {
  /// Check if the result is within normal range
  static bool isWithinNormalRange(LabResultModel result) {
    if (result.value == null ||
        result.referenceRangeLow == null ||
        result.referenceRangeHigh == null) {
      return false;
    }
    return result.value! >= result.referenceRangeLow! &&
        result.value! <= result.referenceRangeHigh!;
  }

  /// Get a formatted string representation of the value
  static String getFormattedValue(LabResultModel result) {
    if (result.value != null) {
      return '${result.value!.toStringAsFixed(2)} ${result.unit ?? result.testType.unit}';
    } else if (result.qualitativeResult != null) {
      return result.qualitativeResult!;
    } else {
      return 'N/A';
    }
  }

  /// Get the clinical section/grouping for this test
  static String getSectionHeader(LabResultModel result) {
    return result.testType.sectionHeaderTitle;
  }

  /// Format the lab result as a summary string
  static String formatSummary(LabResultModel result) {
    return 'LabResultModel(id: ${result.id}, testType: ${result.testType.displayName}, value: ${getFormattedValue(result)}, status: ${result.status.displayName})';
  }
}
