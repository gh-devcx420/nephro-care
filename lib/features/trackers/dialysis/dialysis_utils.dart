import 'package:nephro_care/features/trackers/dialysis/dialysis_constants.dart';
import 'package:nephro_care/features/trackers/dialysis/dialysis_enums.dart';
import 'package:nephro_care/features/trackers/dialysis/dialysis_model.dart';

class DialysisUtils {
  /// Validates notes length
  static bool isValidNotes(String? notes) {
    if (notes == null || notes.trim().isEmpty) return true; // Optional field
    return notes.length <= DialysisConstants.notesMaxChars;
  }

  /// Validates if duration is within acceptable range for dialysis type
  static bool isValidDuration({
    required DialysisType type,
    required double duration,
  }) {
    if (duration < DialysisConstants.durationMin ||
        duration > DialysisConstants.durationMax) {
      return false;
    }

    final minDuration = DialysisConstants.getMinDuration(type.name);
    final maxDuration = DialysisConstants.getMaxDuration(type.name);

    return duration >= minDuration && duration <= maxDuration;
  }

  /// Gets duration status based on dialysis type and duration
  static String getDurationStatus({
    required DialysisType type,
    required double duration,
  }) {
    if (!isValidDuration(type: type, duration: duration)) {
      return 'Invalid Duration';
    }

    final optimal = DialysisConstants.getOptimalDuration(type.name);
    final min = DialysisConstants.getMinDuration(type.name);

    if (duration < min) {
      return 'Below Minimum';
    } else if (duration < optimal) {
      return 'Below Optimal';
    } else if (duration == optimal) {
      return 'Optimal';
    } else {
      return 'Extended';
    }
  }

  // Todo: Implement weight & UF related calculation
  // /// Calculates weight change (kg) between pre and post dialysis
  // static double? calculateWeightChange(DialysisModel model) {
  //   if (model.preWeight == null || model.postWeight == null) {
  //     return null;
  //   }
  //   return model.preWeight!.weight - model.postWeight!.weight;
  // }
  //
  // /// Gets weight change category
  // static String getWeightChangeCategory(DialysisModel model) {
  //   final change = calculateWeightChange(model);
  //   if (change == null) {
  //     return 'N/A';
  //   }
  //
  //   final absChange = change.abs();
  //   if (absChange < DialysisConstants.minimalWeightChange) {
  //     return 'Minimal';
  //   } else if (absChange >= DialysisConstants.normalWeightChangeMin &&
  //       absChange <= DialysisConstants.normalWeightChangeMax) {
  //     return 'Normal';
  //   } else if (absChange > DialysisConstants.normalWeightChangeMax &&
  //       absChange < DialysisConstants.highWeightChangeThreshold) {
  //     return 'High';
  //   } else {
  //     return 'Excessive';
  //   }
  // }
  //
  // /// Calculates ultrafiltration rate (ml/hour)
  // static double? calculateUFRate(DialysisModel model) {
  //   if (model.ultraFiltrationTarget == null || model.sessionDuration <= 0) {
  //     return null;
  //   }
  //   return model.ultraFiltrationTarget!.volume / model.sessionDuration;
  // }
  //
  // /// Gets ultrafiltration rate category
  // static String getUFRateCategory(DialysisModel model) {
  //   final rate = calculateUFRate(model);
  //   if (rate == null) {
  //     return 'N/A';
  //   }
  //
  //   if (rate <= DialysisConstants.optimalUFRate) {
  //     return 'Optimal';
  //   } else if (rate <= DialysisConstants.acceptableUFRate) {
  //     return 'Acceptable';
  //   } else if (rate <= DialysisConstants.highUFRate) {
  //     return 'High';
  //   } else {
  //     return 'Excessive';
  //   }
  // }
  //
  // /// Validates if dialysis session is complete with all required fields
  // static bool isCompleteSession(DialysisModel model) {
  //   return model.preWeight != null &&
  //       model.postWeight != null &&
  //       model.preDialysisBPResting != null &&
  //       model.postDialysisBPResting != null &&
  //       isValidDuration(
  //           type: model.dialysisType, duration: model.sessionDuration);
  // }
  //
  // /// Gets session completeness percentage
  // static int getSessionCompleteness(DialysisModel model) {
  //   int completedFields = 0;
  //   const totalFields = 9; // Total trackable fields
  //
  //   if (model.preWeight != null) completedFields++;
  //   if (model.postWeight != null) completedFields++;
  //   if (model.preDialysisBPResting != null) completedFields++;
  //   if (model.preDialysisBPStanding != null) completedFields++;
  //   if (model.postDialysisBPResting != null) completedFields++;
  //   if (model.postDialysisBPStanding != null) completedFields++;
  //   if (model.ultraFiltrationTarget != null) completedFields++;
  //   if (isValidDuration(
  //       type: model.dialysisType, duration: model.sessionDuration)) {
  //     completedFields++;
  //   }
  //   if (model.sessionRemarks != null && model.sessionRemarks!.isNotEmpty)
  //     completedFields++;
  //
  //   return ((completedFields / totalFields) * 100).round();
  // }
  //  Gets average weight change across sessions
  // static double? getAverageWeightChange(List<DialysisModel> sessions) {
  //   final validSessions = sessions
  //       .where((s) => s.preWeight != null && s.postWeight != null)
  //       .toList();
  //
  //   if (validSessions.isEmpty) return null;
  //
  //   final totalChange = validSessions.fold<double>(
  //       0, (sum, s) => sum + (calculateWeightChange(s) ?? 0));
  //   return totalChange / validSessions.length;
  // }
  //
  // /// Checks if session duration is optimal
  // static bool isOptimalDuration(DialysisModel model) {
  //   final optimal =
  //   DialysisConstants.getOptimalDuration(model.dialysisType.name);
  //   return model.sessionDuration >= optimal;
  // }
  //
  // /// Generates a summary string for a dialysis session
  // static String generateSessionSummary(DialysisModel model) {
  //   final buffer = StringBuffer();
  //   buffer.write(
  //       '${model.dialysisType.displayName} - ${model.sessionDuration} hrs');
  //
  //   final weightChange = calculateWeightChange(model);
  //   if (weightChange != null) {
  //     buffer.write(' | Weight change: ${weightChange.toStringAsFixed(1)} kg');
  //   }
  //
  //   final ufRate = calculateUFRate(model);
  //   if (ufRate != null) {
  //     buffer.write(' | UF rate: ${ufRate.toStringAsFixed(0)} ml/hr');
  //   }
  //
  //   return buffer.toString();
  // }

  /// Groups dialysis sessions by type
  static Map<DialysisType, List<DialysisModel>> groupByType(
    List<DialysisModel> sessions,
  ) {
    final groups = <DialysisType, List<DialysisModel>>{};

    for (final session in sessions) {
      groups.putIfAbsent(session.dialysisType, () => []).add(session);
    }

    return groups;
  }

  /// Gets average session duration for a type
  static double? getAverageSessionDuration(
    List<DialysisModel> sessions,
    DialysisType type,
  ) {
    final typeSessions = sessions.where((s) => s.dialysisType == type).toList();
    if (typeSessions.isEmpty) return null;

    final totalDuration =
        typeSessions.fold<double>(0, (sum, s) => sum + s.sessionDuration);
    return totalDuration / typeSessions.length;
  }

  /// Sorts sessions by timestamp (most recent first)
  static List<DialysisModel> sortByMostRecent(List<DialysisModel> sessions) {
    final sorted = List<DialysisModel>.from(sessions);
    sorted.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return sorted;
  }

  /// Gets sessions within a date range
  static List<DialysisModel> getSessionsInDateRange(
    List<DialysisModel> sessions, {
    required DateTime startDate,
    required DateTime endDate,
  }) {
    return sessions.where((session) {
      final sessionDate = session.timestamp.toDate();
      return sessionDate.isAfter(startDate) &&
          sessionDate.isBefore(
            endDate.add(
              const Duration(days: 1),
            ),
          );
    }).toList();
  }

  /// Calculates total dialysis time in a period
  static double getTotalDialysisTime(List<DialysisModel> sessions) {
    return sessions.fold<double>(
        0, (sum, session) => sum + session.sessionDuration);
  }
}
