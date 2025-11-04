import 'package:cloud_firestore/cloud_firestore.dart';

/// Utility class for common model operations
/// Reduces boilerplate across all Firestore models
class ModelUtils {
  // Private constructor to prevent instantiation
  ModelUtils._();

  /// Extracts isPendingSync status from Firestore document metadata
  ///
  /// Used in: All models' fromFirestore() factory constructors
  ///
  /// Example:
  /// ```dart
  /// isPendingSync: ModelUtils.getPendingSyncStatus(doc),
  /// ```
  static bool getPendingSyncStatus(DocumentSnapshot doc) {
    return doc.metadata.hasPendingWrites;
  }

  /// Converts Firestore Timestamp to nullable DateTime
  /// Handles null values and type checking gracefully
  ///
  /// Used in: fromFirestore() and fromJson() for optional date fields
  ///
  /// Example:
  /// ```dart
  /// onsetDate: ModelUtils.timestampToDate(data['onsetDate']),
  /// ```
  static DateTime? timestampToDate(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is Timestamp) return timestamp.toDate();
    if (timestamp is DateTime) return timestamp;
    return null;
  }

  /// Converts DateTime to Firestore Timestamp (nullable)
  ///
  /// Used in: toJson() for optional date fields
  ///
  /// Example:
  /// ```dart
  /// 'onsetDate': ModelUtils.dateToTimestamp(onsetDate),
  /// ```
  static Timestamp? dateToTimestamp(DateTime? date) {
    return date != null ? Timestamp.fromDate(date) : null;
  }

  /// Converts List<DateTime> to List<Timestamp>
  ///
  /// Used in: toJson() for lists of dates (e.g., scheduledTimes)
  ///
  /// Example:
  /// ```dart
  /// 'scheduledTimes': ModelUtils.dateListToTimestampList(scheduledTimes),
  /// ```
  static List<Timestamp> dateListToTimestampList(List<DateTime> dates) {
    return dates.map((d) => Timestamp.fromDate(d)).toList();
  }

  /// Converts List<Timestamp> to List<DateTime>
  /// Handles null and type checking
  ///
  /// Used in: fromFirestore() for lists of dates
  ///
  /// Example:
  /// ```dart
  /// scheduledTimes: ModelUtils.timestampListToDateList(data['scheduledTimes']),
  /// ```
  static List<DateTime> timestampListToDateList(dynamic timestamps) {
    if (timestamps == null) return [];
    if (timestamps is! List) return [];
    return (timestamps).map((t) => (t as Timestamp).toDate()).toList();
  }
}

/// Extension for cleaner enum parsing across all models
extension EnumParsing<T extends Enum> on List<T> {
  /// Parses required enum field
  /// Throws ArgumentError if value is null or invalid
  T parse(dynamic value) {
    if (value == null) {
      throw ArgumentError('Required enum field is null');
    }
    return byName(value as String);
  }

  /// Parses optional enum field
  /// Returns null if value is null or invalid
  T? parseOrNull(dynamic value) {
    if (value == null) return null;
    try {
      return byName(value as String);
    } catch (e) {
      return null;
    }
  }
}
