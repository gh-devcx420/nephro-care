import 'package:nephro_care/features/trackers/vaccinations/vaccination_constants.dart';
import 'package:nephro_care/features/trackers/vaccinations/vaccination_enums.dart';
import 'package:nephro_care/features/trackers/vaccinations/vaccination_model.dart';

class VaccinationUtils {
  /// Groups vaccinations by status
  static Map<VaccinationStatus, List<VaccinationModel>> groupByStatus(
    List<VaccinationModel> vaccinations,
  ) {
    final groups = <VaccinationStatus, List<VaccinationModel>>{};

    for (final vaccine in vaccinations) {
      groups.putIfAbsent(vaccine.status, () => []).add(vaccine);
    }

    return groups;
  }

  /// Groups vaccinations by vaccine type
  static Map<VaccineType, List<VaccinationModel>> groupByType(
    List<VaccinationModel> vaccinations,
  ) {
    final groups = <VaccineType, List<VaccinationModel>>{};

    for (final vaccine in vaccinations) {
      if (vaccine.vaccineType != null) {
        groups.putIfAbsent(vaccine.vaccineType!, () => []).add(vaccine);
      }
    }

    return groups;
  }

  /// Gets overdue vaccinations
  static List<VaccinationModel> getOverdueVaccinations(
    List<VaccinationModel> vaccinations, {
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();

    return vaccinations.where((vaccine) {
      if (vaccine.status != VaccinationStatus.overdue) return false;

      if (vaccine.nextDueDate != null) {
        final daysPastDue = now.difference(vaccine.nextDueDate!).inDays;
        return daysPastDue >= VaccinationConstants.overdueDaysThreshold;
      }

      return vaccine.status == VaccinationStatus.overdue;
    }).toList();
  }

  /// Gets upcoming vaccinations (due soon)
  static List<VaccinationModel> getUpcomingVaccinations(
    List<VaccinationModel> vaccinations, {
    DateTime? referenceDate,
    int daysThreshold = VaccinationConstants.upcomingDaysThreshold,
  }) {
    final now = referenceDate ?? DateTime.now();
    final cutoffDate = now.add(Duration(days: daysThreshold));

    return vaccinations.where((vaccine) {
      if (vaccine.nextDueDate == null) return false;

      return vaccine.nextDueDate!.isAfter(now) &&
          vaccine.nextDueDate!.isBefore(cutoffDate) &&
          (vaccine.status == VaccinationStatus.pending ||
              vaccine.status == VaccinationStatus.inProgress);
    }).toList();
  }

  /// Gets completed vaccinations
  static List<VaccinationModel> getCompletedVaccinations(
    List<VaccinationModel> vaccinations,
  ) {
    return vaccinations
        .where((vaccine) => vaccine.status == VaccinationStatus.completed)
        .toList();
  }

  /// Gets multi-dose series vaccinations in progress
  static List<VaccinationModel> getSeriesInProgress(
    List<VaccinationModel> vaccinations,
  ) {
    return vaccinations
        .where((vaccine) =>
            vaccine.isMultiDoseSeries &&
            !vaccine.isSeriesComplete &&
            vaccine.status == VaccinationStatus.inProgress)
        .toList();
  }

  /// Calculates next due date based on vaccine type and dose number
  static DateTime? calculateNextDueDate({
    required VaccinationModel vaccine,
    DateTime? lastDoseDate,
  }) {
    if (vaccine.vaccineType == null) return null;
    if (vaccine.isSeriesComplete) return null;

    final referenceDate = lastDoseDate ?? vaccine.administeredDate;
    if (referenceDate == null) return null;

    final intervalDays = _getIntervalForVaccineType(vaccine.vaccineType!);
    if (intervalDays == null) return null;

    return referenceDate.add(Duration(days: intervalDays));
  }

  /// Gets vaccinations with serious reactions
  static List<VaccinationModel> getVaccinationsWithSeriousReactions(
    List<VaccinationModel> vaccinations,
  ) {
    return vaccinations
        .where((vaccine) =>
            vaccine.reaction != null && vaccine.reaction!.isSerious)
        .toList();
  }

  /// Gets vaccination completion percentage
  static double getCompletionPercentage(
    List<VaccinationModel> vaccinations,
  ) {
    if (vaccinations.isEmpty) return 0.0;

    final completed = vaccinations
        .where((vaccine) => vaccine.status == VaccinationStatus.completed)
        .length;

    return (completed / vaccinations.length) * 100;
  }

  /// Checks if vaccination is due for booster
  static bool isDueForBooster(
    VaccinationModel vaccine, {
    DateTime? referenceDate,
  }) {
    if (vaccine.vaccineType == null) return false;
    if (vaccine.administeredDate == null) return false;

    final now = referenceDate ?? DateTime.now();
    final boosterInterval =
        _getBoosterIntervalForVaccineType(vaccine.vaccineType!);

    if (boosterInterval == null) return false;

    final boosterDueDate =
        vaccine.administeredDate!.add(Duration(days: boosterInterval));

    return now.isAfter(boosterDueDate);
  }

  /// Sorts vaccinations by next due date
  static List<VaccinationModel> sortByNextDueDate(
    List<VaccinationModel> vaccinations,
  ) {
    final sorted = List<VaccinationModel>.from(vaccinations);
    sorted.sort((a, b) {
      final aDue = a.nextDueDate;
      final bDue = b.nextDueDate;

      if (aDue == null && bDue == null) return 0;
      if (aDue == null) return 1;
      if (bDue == null) return -1;

      return aDue.compareTo(bDue);
    });
    return sorted;
  }

  /// Gets vaccination history for a specific vaccine type
  static List<VaccinationModel> getVaccineHistory(
    List<VaccinationModel> vaccinations,
    VaccineType vaccineType,
  ) {
    return vaccinations
        .where((vaccine) => vaccine.vaccineType == vaccineType)
        .toList();
  }

  /// Generates vaccination summary string
  static String generateVaccinationSummary(VaccinationModel vaccine) {
    final buffer = StringBuffer();
    buffer.write(vaccine.vaccineName);

    if (vaccine.isMultiDoseSeries) {
      buffer.write(' (${vaccine.doseProgressString})');
    }

    if (vaccine.manufacturer != null) {
      buffer.write(' - ${vaccine.manufacturer}');
    }

    if (vaccine.administeredDate != null) {
      buffer.write(
          ' on ${vaccine.administeredDate!.day}/${vaccine.administeredDate!.month}/${vaccine.administeredDate!.year}');
    }

    return buffer.toString();
  }

  /// Gets vaccines that need reaction monitoring
  static List<VaccinationModel> getNeedingMonitoring(
    List<VaccinationModel> vaccinations, {
    DateTime? referenceDate,
  }) {
    final now = referenceDate ?? DateTime.now();

    return vaccinations.where((vaccine) {
      if (vaccine.administeredDate == null) return false;

      final daysSince = now.difference(vaccine.administeredDate!).inDays;
      return daysSince <= VaccinationConstants.reactionMonitoringDays &&
          vaccine.status == VaccinationStatus.completed;
    }).toList();
  }

  /// Checks if vaccination record is complete
  static bool isRecordComplete(VaccinationModel vaccine) {
    return vaccine.vaccineName.isNotEmpty &&
        vaccine.administeredDate != null &&
        vaccine.route != null &&
        vaccine.site != null;
  }

  /// Gets immunization compliance rate
  static double getImmunizationComplianceRate(
    List<VaccinationModel> allVaccinations,
    List<VaccinationModel> requiredVaccinations,
  ) {
    if (requiredVaccinations.isEmpty) return 100.0;

    final completedRequired = requiredVaccinations
        .where((vaccine) => vaccine.status == VaccinationStatus.completed)
        .length;

    return (completedRequired / requiredVaccinations.length) * 100;
  }

  // Private helper methods

  static int? _getIntervalForVaccineType(VaccineType type) {
    return switch (type) {
      VaccineType.covid19 => VaccinationConstants.covid19StandardInterval,
      VaccineType.hepatitisA => VaccinationConstants.hepatitisAInterval,
      VaccineType.hepatitisB => VaccinationConstants.hepatitisBInterval,
      VaccineType.hpv => VaccinationConstants.hpvInterval,
      VaccineType.shingles => VaccinationConstants.shinglesInterval,
      _ => null,
    };
  }

  static int? _getBoosterIntervalForVaccineType(VaccineType type) {
    return switch (type) {
      VaccineType.tetanus => VaccinationConstants.tetanusBoosterInterval,
      VaccineType.influenza => VaccinationConstants.influenzaAnnualInterval,
      VaccineType.covid19 => 180, // 6 months for booster
      VaccineType.shingles => null, // No booster typically needed
      _ => null,
    };
  }
}
