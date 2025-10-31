import 'package:nephro_care/features/trackers/injections/injection_constants.dart';
import 'package:nephro_care/features/trackers/injections/injection_enums.dart';
import 'package:nephro_care/features/trackers/injections/injection_model.dart';

class InjectionUtils {
  /// Groups injections by type
  static Map<InjectionType, List<InjectionModel>> groupByType(
    List<InjectionModel> injections,
  ) {
    final groups = <InjectionType, List<InjectionModel>>{};

    for (final injection in injections) {
      groups.putIfAbsent(injection.type, () => []).add(injection);
    }

    return groups;
  }

  /// Gets injections for a specific dialysis session
  static List<InjectionModel> getDialysisInjections(
    List<InjectionModel> injections,
    String dialysisSessionId,
  ) {
    return injections
        .where((inj) => inj.linkedDialysisSessionId == dialysisSessionId)
        .toList();
  }

  /// Gets recent injections within specified days
  static List<InjectionModel> getRecentInjections(
    List<InjectionModel> injections, {
    int days = 30,
    DateTime? referenceDate,
  }) {
    final reference = referenceDate ?? DateTime.now();
    final cutoffDate = reference.subtract(Duration(days: days));

    return injections
        .where((inj) => inj.administeredDate.isAfter(cutoffDate))
        .toList();
  }

  /// Groups injections by site
  static Map<InjectionSite, List<InjectionModel>> groupBySite(
    List<InjectionModel> injections,
  ) {
    final groups = <InjectionSite, List<InjectionModel>>{};

    for (final injection in injections) {
      groups.putIfAbsent(injection.site, () => []).add(injection);
    }

    return groups;
  }

  /// Suggests next injection site based on rotation
  static InjectionSite? suggestNextSite(
    List<InjectionModel> recentInjections,
    InjectionRoute route,
  ) {
    if (recentInjections.isEmpty) {
      return _getDefaultSiteForRoute(route);
    }

    // Sort by most recent first
    final sorted = List<InjectionModel>.from(recentInjections);
    sorted.sort((a, b) => b.administeredDate.compareTo(a.administeredDate));

    final lastInjection = sorted.first;
    final lastSite = lastInjection.site;

    // Get available sites for this route
    final availableSites = _getAvailableSitesForRoute(route);

    // Find a site not recently used
    for (final site in availableSites) {
      if (site != lastSite) {
        // Check if this site was used recently
        final daysSinceUsed = _daysSinceLastUsedSite(sorted, site);
        if (daysSinceUsed == null ||
            daysSinceUsed >= InjectionConstants.minDaysBetweenSameSite) {
          return site;
        }
      }
    }

    return availableSites.first; // Fallback
  }

  /// Gets injections with serious reactions
  static List<InjectionModel> getInjectionsWithSeriousReactions(
    List<InjectionModel> injections,
  ) {
    return injections
        .where((inj) =>
            inj.reaction != null &&
            (inj.reaction!.isSerious ||
                inj.reaction == InjectionReaction.allergicReaction))
        .toList();
  }

  /// Checks if site rotation is recommended
  static bool needsSiteRotation(
    List<InjectionModel> recentInjections,
    InjectionSite currentSite,
  ) {
    if (recentInjections.isEmpty) return false;

    final daysSinceUsed = _daysSinceLastUsedSite(recentInjections, currentSite);
    if (daysSinceUsed == null) return false;

    return daysSinceUsed < InjectionConstants.minDaysBetweenSameSite;
  }

  /// Gets injection count by drug name
  static Map<String, int> countByDrug(List<InjectionModel> injections) {
    final counts = <String, int>{};

    for (final injection in injections) {
      counts[injection.drugName] = (counts[injection.drugName] ?? 0) + 1;
    }

    return counts;
  }

  /// Sorts injections by date (most recent first)
  static List<InjectionModel> sortByDateDescending(
    List<InjectionModel> injections,
  ) {
    final sorted = List<InjectionModel>.from(injections);
    sorted.sort((a, b) => b.administeredDate.compareTo(a.administeredDate));
    return sorted;
  }

  /// Gets injections that need reaction monitoring
  static List<InjectionModel> getNeedingMonitoring(
    List<InjectionModel> injections, {
    DateTime? referenceTime,
  }) {
    final now = referenceTime ?? DateTime.now();

    return injections.where((inj) {
      final hoursSince = now.difference(inj.administeredDate).inHours;
      return hoursSince <= InjectionConstants.reactionMonitoringHours &&
          (inj.reaction == null || inj.reaction == InjectionReaction.none);
    }).toList();
  }

  /// Generates injection history summary
  static String generateInjectionSummary(InjectionModel injection) {
    final buffer = StringBuffer();
    buffer.write('${injection.drugName} ${injection.dosage}');
    buffer.write(' via ${injection.route.abbreviation}');
    buffer.write(' at ${injection.site.displayName}');

    if (injection.reaction != null &&
        injection.reaction != InjectionReaction.none) {
      buffer.write(' - ${injection.reaction!.displayName}');
    }

    return buffer.toString();
  }

  /// Calculates average injections per time period
  static double calculateAverageInjectionsPerPeriod(
    List<InjectionModel> injections, {
    required int days,
  }) {
    if (injections.isEmpty || days <= 0) return 0.0;

    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: days));
    final recentInjections =
        injections.where((inj) => inj.administeredDate.isAfter(cutoff)).length;

    return recentInjections / days;
  }

  // Private helper methods

  static int? _daysSinceLastUsedSite(
    List<InjectionModel> injections,
    InjectionSite site,
  ) {
    final siteInjections = injections.where((inj) => inj.site == site).toList();

    if (siteInjections.isEmpty) return null;

    siteInjections
        .sort((a, b) => b.administeredDate.compareTo(a.administeredDate));
    final lastUsed = siteInjections.first.administeredDate;

    return DateTime.now().difference(lastUsed).inDays;
  }

  static InjectionSite _getDefaultSiteForRoute(InjectionRoute route) {
    return switch (route) {
      InjectionRoute.intramuscular => InjectionSite.leftDeltoid,
      InjectionRoute.subcutaneous => InjectionSite.abdomen,
      InjectionRoute.intravenous => InjectionSite.leftForearm,
      InjectionRoute.intradermal => InjectionSite.leftForearm,
      _ => InjectionSite.other,
    };
  }

  static List<InjectionSite> _getAvailableSitesForRoute(InjectionRoute route) {
    return switch (route) {
      InjectionRoute.intramuscular => [
          InjectionSite.leftDeltoid,
          InjectionSite.rightDeltoid,
          InjectionSite.leftThigh,
          InjectionSite.rightThigh,
          InjectionSite.leftGluteal,
          InjectionSite.rightGluteal,
        ],
      InjectionRoute.subcutaneous => [
          InjectionSite.abdomen,
          InjectionSite.leftThigh,
          InjectionSite.rightThigh,
          InjectionSite.leftUpperArm,
          InjectionSite.rightUpperArm,
        ],
      InjectionRoute.intravenous => [
          InjectionSite.leftForearm,
          InjectionSite.rightForearm,
          InjectionSite.avFistula,
          InjectionSite.avGraft,
          InjectionSite.centralLine,
        ],
      InjectionRoute.intradermal => [
          InjectionSite.leftForearm,
          InjectionSite.rightForearm,
        ],
      _ => [InjectionSite.other],
    };
  }
}
