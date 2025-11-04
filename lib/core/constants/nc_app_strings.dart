class AppStrings {
  AppStrings._();

  // Dialog Titles.
  static const String editEntryTitle = 'Edit Entry';
  static const String deleteEntryTitle = 'Delete Entry';
  static const String deleteAllEntriesTitle = 'Delete All Entries';
  static const String logDetails = 'Log Details';
  static const String settings = 'Settings';

  // Dialog Actions.
  static const String editConfirm = 'Edit';
  static const String deleteConfirm = 'Delete';
  static const String deleteAllConfirm = 'Delete All';
  static const String ok = 'Ok';

  // Dialog Content Templates.
  static const String editEntryPrompt = 'Do you want to edit this ';
  static const String deleteEntryPrompt =
      'Are you sure you want to delete this ';
  static const String deleteAllEntriesPrompt =
      'Are you sure you want to delete all ';
  static const String entrySuffix = ' entry?';
  static const String entriesForDateSuffix = ' entries for this date?';

  // SnackBar Messages - Success.
  static const String entryDeletedSuccess = 'Entry deleted successfully';
  static const String allEntriesDeletedPrefix = 'All';
  static const String allEntriesDeletedSuffix = 'entries deleted successfully';

  // SnackBar Messages - Error.
  static const String userNotAuthenticated =
      'User not authenticated. Please log in.';
  static const String editTodayOnly = 'Can only edit entries from today';
  static const String failedToDeleteEntry = 'Failed to delete entry: ';
  static const String failedToDeleteEntries = 'Failed to delete entries: ';

  // Empty State Messages.
  static const String noEntriesPrefix = 'No entries for ';
  static const String addEntryPrompt = 'Add a ';
  static const String toTrackNow = ' to track now.';

  /// Helper method to format edit entry content.
  static String editEntryContent(String entryType) =>
      '$editEntryPrompt$entryType$entrySuffix';

  /// Helper method to format delete entry content.
  static String deleteEntryContent(String entryType) =>
      '$deleteEntryPrompt$entryType$entrySuffix';

  /// Helper method to format delete all entries content.
  static String deleteAllEntriesContent(String entryType) =>
      '$deleteAllEntriesPrompt$entryType$entriesForDateSuffix';

  /// Helper method to show snackbar message for all entries deleted.
  static String allEntriesDeleted(String entryType) =>
      '$allEntriesDeletedPrefix $entryType $allEntriesDeletedSuffix';

  /// Helper method to format no entries message.
  static String noEntriesMessage(String date) => '$noEntriesPrefix$date';

  /// Helper method to format add entry message.
  static String addEntryMessage(String entryType) =>
      '$addEntryPrompt$entryType$toTrackNow';
}
