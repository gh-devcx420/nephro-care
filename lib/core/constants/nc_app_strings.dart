class AppStrings {
  AppStrings._();

  // Dialog Titles
  static const String editEntryTitle = 'Edit Entry';
  static const String deleteEntryTitle = 'Delete Entry';
  static const String deleteAllEntriesTitle = 'Delete All Entries';
  static const String logDetails = 'Log Details';
  static const String settings = 'Settings';

  // Dialog Actions
  static const String editConfirm = 'Edit';
  static const String deleteConfirm = 'Delete';
  static const String deleteAllConfirm = 'Delete All';
  static const String ok = 'Ok';

  // Dialog Content Templates
  static const String editEntryPrompt = 'Do you want to edit this ';
  static const String deleteEntryPrompt =
      'Are you sure you want to delete this ';
  static const String deleteAllEntriesPrompt =
      'Are you sure you want to delete all ';
  static const String entrySuffix = ' entry?';
  static const String entriesForDateSuffix = ' entries for this date?';

  // SnackBar Messages - Success
  static const String entryDeletedSuccess = 'Entry deleted successfully';
  static const String allEntriesDeletedPrefix = 'All';
  static const String allEntriesDeletedSuffix = 'entries deleted successfully';

  // SnackBar Messages - Error
  static const String userNotAuthenticated =
      'User not authenticated. Please log in.';
  static const String editTodayOnly = 'Can only edit entries from today';
  static const String failedToDeleteEntry = 'Failed to delete entry: ';
  static const String failedToDeleteEntries = 'Failed to delete entries: ';

  // Empty State Messages
  static const String noEntriesPrefix = 'No entries for ';
  static const String addEntryPrompt = 'Add a ';
  static const String toTrackNow = ' to track now.';

  // Helper methods for formatted strings
  static String editEntryContent(String entryType) =>
      '$editEntryPrompt$entryType$entrySuffix';

  static String deleteEntryContent(String entryType) =>
      '$deleteEntryPrompt$entryType$entrySuffix';

  static String deleteAllEntriesContent(String entryType) =>
      '$deleteAllEntriesPrompt$entryType$entriesForDateSuffix';

  static String allEntriesDeleted(String entryType) =>
      '$allEntriesDeletedPrefix $entryType $allEntriesDeletedSuffix';

  static String noEntriesMessage(String date) => '$noEntriesPrefix$date';

  static String addEntryMessage(String entryType) =>
      '$addEntryPrompt$entryType$toTrackNow';
}

// ============================================================================
// USAGE EXAMPLES
// ============================================================================

/*
// Before (Old way):
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/constants/strings.dart';
import 'package:nephro_care/core/constants/provider_constants.dart';

final radius = kBorderRadius;
final title = Strings.editEntryTitle;
final cache = kCacheDurationInMinutes;

// After (New way):
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/constants/nc_app_strings.dart';
import 'package:nephro_care/core/constants/nc_app_constants.dart';

final radius = UIConstants.borderRadius;
final title = AppStrings.editEntryTitle;
final cache = AppConstants.cacheDurationMinutes;

// Helper methods for dynamic strings:
final message = AppStrings.editEntryContent('blood pressure');
// Output: "Do you want to edit this blood pressure entry?"

final emptyMsg = AppStrings.noEntriesMessage('today');
// Output: "No entries for today"
*/
