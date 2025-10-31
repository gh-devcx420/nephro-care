import 'package:nephro_care/features/trackers/medications/medication_constants.dart';
import 'package:nephro_care/features/trackers/medications/medication_enums.dart';
import 'package:nephro_care/features/trackers/medications/medication_model.dart';

class MedicationUtils {
  /// Validates medication name
  static bool isValidName(String? name) {
    if (name == null || name.trim().isEmpty) return false;
    return name.length <= MedicationConstants.medicationNameMaxChars;
  }

  /// Validates dosage
  static bool isValidDosage(String? dosage) {
    if (dosage == null || dosage.trim().isEmpty) return false;
    return dosage.length <= MedicationConstants.dosageMaxChars;
  }

  /// Validates reason for use
  static bool isValidReason(String? reason) {
    if (reason == null || reason.trim().isEmpty) return true; // Optional field
    return reason.length <= MedicationConstants.reasonMaxChars;
  }

  /// Validates instructions
  static bool isValidInstructions(String? instructions) {
    if (instructions == null || instructions.trim().isEmpty)
      return true; // Optional field
    return instructions.length <= MedicationConstants.instructionsMaxChars;
  }

  /// Validates prescribed by
  static bool isValidPrescribedBy(String? prescribedBy) {
    if (prescribedBy == null || prescribedBy.trim().isEmpty)
      return true; // Optional field
    return prescribedBy.length <= MedicationConstants.prescribedByMaxChars;
  }

  /// Validates pharmacy
  static bool isValidPharmacy(String? pharmacy) {
    if (pharmacy == null || pharmacy.trim().isEmpty)
      return true; // Optional field
    return pharmacy.length <= MedicationConstants.pharmacyMaxChars;
  }

  /// Validates scheduled times
  static bool isValidScheduledTimes(List<DateTime>? times) {
    if (times == null || times.isEmpty) return false;
    return times.length <= MedicationConstants.maxScheduledTimesPerDay;
  }

  /// Validates date range
  static bool isValidDateRange(DateTime startDate, DateTime? endDate) {
    if (endDate == null) return true;
    return endDate.isAfter(startDate) || endDate.isAtSameMomentAs(startDate);
  }

  /// Checks if the medication needs a refill soon
  static bool needsRefillSoon(
    MedicationModel medication, {
    int threshold = MedicationConstants.refillThreshold,
  }) {
    return medication.refillsRemaining != null &&
        medication.refillsRemaining! <= threshold;
  }

  /// Gets the next scheduled dose after a reference time (default: now)
  static DateTime? getNextScheduledDose(
    MedicationModel medication, {
    DateTime? referenceTime,
  }) {
    final now = referenceTime ?? DateTime.now();
    try {
      return medication.scheduledTimes.firstWhere(
        (time) => time.isAfter(now),
      );
    } catch (e) {
      return null;
    }
  }

  /// Groups medications by time of day
  static Map<String, List<MedicationModel>> groupByTimeOfDay(
    List<MedicationModel> medications,
  ) {
    final groups = <String, List<MedicationModel>>{
      'Morning': [],
      'Afternoon': [],
      'Evening': [],
      'Night': [],
      'As Needed': [],
    };

    for (final med in medications) {
      if (med.frequency == MedicationFrequency.asNeeded) {
        groups['As Needed']!.add(med);
        continue;
      }

      for (final time in med.scheduledTimes) {
        final hour = time.hour;
        if (hour >= 5 && hour < 12) {
          if (!groups['Morning']!.contains(med)) {
            groups['Morning']!.add(med);
          }
        } else if (hour >= 12 && hour < 17) {
          if (!groups['Afternoon']!.contains(med)) {
            groups['Afternoon']!.add(med);
          }
        } else if (hour >= 17 && hour < 21) {
          if (!groups['Evening']!.contains(med)) {
            groups['Evening']!.add(med);
          }
        } else {
          if (!groups['Night']!.contains(med)) {
            groups['Night']!.add(med);
          }
        }
      }
    }

    groups.removeWhere((key, value) => value.isEmpty);
    return groups;
  }

  /// Gets medications due soon (within time window)
  static List<MedicationModel> getMedicationsDueSoon(
    List<MedicationModel> medications, {
    DateTime? referenceTime,
    int minutesWindow = MedicationConstants.doseTimeWindowBefore,
  }) {
    final now = referenceTime ?? DateTime.now();
    final windowEnd = now.add(Duration(minutes: minutesWindow));

    return medications.where((med) {
      if (med.status != MedicationStatus.active) return false;
      if (med.frequency == MedicationFrequency.asNeeded) return false;

      final nextDose = getNextScheduledDose(med, referenceTime: now);
      if (nextDose == null) return false;

      return nextDose.isAfter(now) && nextDose.isBefore(windowEnd);
    }).toList();
  }

  /// Gets overdue medications
  static List<MedicationModel> getOverdueMedications(
    List<MedicationModel> medications, {
    DateTime? referenceTime,
  }) {
    final now = referenceTime ?? DateTime.now();

    return medications.where((med) {
      if (med.status != MedicationStatus.active) return false;
      if (med.frequency == MedicationFrequency.asNeeded) return false;

      final nextDose = getNextScheduledDose(med, referenceTime: now);
      if (nextDose == null) return false;

      final overdueThreshold = nextDose.add(
        const Duration(minutes: MedicationConstants.missedDoseThreshold),
      );

      return now.isAfter(overdueThreshold);
    }).toList();
  }

  /// Gets medications needing refill
  static List<MedicationModel> getMedicationsNeedingRefill(
    List<MedicationModel> medications, {
    int threshold = MedicationConstants.refillThreshold,
  }) {
    return medications
        .where((med) =>
            med.status == MedicationStatus.active &&
            needsRefillSoon(med, threshold: threshold))
        .toList();
  }

  /// Gets medications with critical refill status
  static List<MedicationModel> getCriticalRefillMedications(
    List<MedicationModel> medications,
  ) {
    return getMedicationsNeedingRefill(
      medications,
      threshold: MedicationConstants.criticalRefillThreshold,
    );
  }

  /// Calculates next refill date based on dosage and frequency
  static DateTime? calculateNextRefillDate({
    required MedicationModel medication,
    required int daysSupply,
  }) {
    if (medication.lastRefillDate == null) return null;

    return medication.lastRefillDate!.add(Duration(days: daysSupply));
  }

  /// Groups medications by status
  static Map<MedicationStatus, List<MedicationModel>> groupByStatus(
    List<MedicationModel> medications,
  ) {
    final groups = <MedicationStatus, List<MedicationModel>>{};

    for (final med in medications) {
      groups.putIfAbsent(med.status, () => []).add(med);
    }

    return groups;
  }

  /// Gets active medications only
  static List<MedicationModel> getActiveMedications(
    List<MedicationModel> medications,
  ) {
    return medications
        .where((med) => med.status == MedicationStatus.active)
        .toList();
  }

  /// Sorts medications by next scheduled dose
  static List<MedicationModel> sortByNextDose(
    List<MedicationModel> medications,
  ) {
    final sorted = List<MedicationModel>.from(medications);
    sorted.sort((a, b) {
      final aNext = getNextScheduledDose(a);
      final bNext = getNextScheduledDose(b);

      if (aNext == null && bNext == null) return 0;
      if (aNext == null) return 1;
      if (bNext == null) return -1;

      return aNext.compareTo(bNext);
    });
    return sorted;
  }

  /// Checks if medication is due now (within time window)
  static bool isDueNow(
    MedicationModel medication, {
    DateTime? referenceTime,
  }) {
    if (medication.status != MedicationStatus.active) return false;
    if (medication.frequency == MedicationFrequency.asNeeded) return false;

    final now = referenceTime ?? DateTime.now();
    final nextDose = getNextScheduledDose(medication, referenceTime: now);
    if (nextDose == null) return false;

    final windowStart = nextDose.subtract(
      const Duration(minutes: MedicationConstants.doseTimeWindowBefore),
    );
    final windowEnd = nextDose.add(
      const Duration(minutes: MedicationConstants.doseTimeWindowAfter),
    );

    return now.isAfter(windowStart) && now.isBefore(windowEnd);
  }

  /// Gets medication count by route
  static Map<MedicationRoute, int> countByRoute(
    List<MedicationModel> medications,
  ) {
    final counts = <MedicationRoute, int>{};

    for (final med in medications) {
      counts[med.route] = (counts[med.route] ?? 0) + 1;
    }

    return counts;
  }

  /// Generates a summary string for a medication
  static String generateMedicationSummary(MedicationModel medication) {
    final buffer = StringBuffer();
    buffer.write('${medication.name} ${medication.dosage}');

    if (medication.form != null) {
      buffer.write(' (${medication.form!.displayName})');
    }

    buffer.write(' - ${medication.frequency.displayName}');
    buffer.write(' via ${medication.route.displayName}');

    return buffer.toString();
  }

  /// Gets total daily doses for a medication
  static int getTotalDailyDoses(MedicationModel medication) {
    return switch (medication.frequency) {
      MedicationFrequency.onceDaily => 1,
      MedicationFrequency.twiceDaily => 2,
      MedicationFrequency.threeTimesDaily => 3,
      MedicationFrequency.fourTimesDaily => 4,
      MedicationFrequency.everyOtherDay => 0, // Not daily
      MedicationFrequency.weekly => 0,
      MedicationFrequency.biweekly => 0,
      MedicationFrequency.monthly => 0,
      _ => medication.scheduledTimes.length,
    };
  }
}
