import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/strings_constants.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/utils/date_time_utils.dart';
import 'package:nephro_care/utils/ui_utils.dart';

/// Utility class for shared logic across log screens.
class TrackerScreenUtils {
  /// Shows a modal bottom sheet for adding a new entry.
  static Future<void> showAddModalSheet<T>({
    required BuildContext context,
    required Widget inputWidget,
    required Color backgroundColor,
  }) async {
    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      builder: (_) => inputWidget,
    );

    if (result != null && context.mounted) {
      showSnackBar(context, result.message, result.backgroundColor);
    }
  }

  /// Shows a confirmation dialog for editing an entry.
  static Future<bool> showEditConfirmationDialog({
    required BuildContext context,
    required String metricName,
    required Color confirmColor,
  }) async {
    return UIUtils.showConfirmationDialog(
      context: context,
      title: Strings.editEntryTitle,
      content:
          '${Strings.editEntryContentPrefix}$metricName${Strings.entrySuffix}',
      confirmText: Strings.editConfirmText,
      confirmColor: confirmColor,
    );
  }

  /// Shows a modal bottom sheet for editing an entry.
  static Future<void> showEditModalSheet<T>({
    required BuildContext context,
    required WidgetRef ref,
    required T item,
    required Widget inputWidget,
    required Color backgroundColor,
    required String metricName,
  }) async {
    final selectedDate = ref.read(selectedDateProvider);
    final entryDate =
        (item as dynamic).timestamp.toDate();

    if (!DateTimeUtils.isSameDay(entryDate, selectedDate)) {
      if (context.mounted) {
        showSnackBar(context, Strings.editTodayOnly,
            Theme.of(context).colorScheme.error);
      }
      return;
    }

    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: backgroundColor,
      builder: (_) => inputWidget,
    );

    if (result != null && context.mounted) {
      showSnackBar(context, result.message, result.backgroundColor);
    }
  }

  /// Shows a confirmation dialog for deleting a single entry.
  static Future<bool> showDeleteConfirmationDialog({
    required BuildContext context,
    required String metricName,
  }) async {
    return UIUtils.showConfirmationDialog(
      context: context,
      title: Strings.deleteEntryTitle,
      content:
          '${Strings.deleteEntryContentPrefix}$metricName${Strings.entrySuffix}',
      confirmText: Strings.deleteConfirmText,
    );
  }

  /// Deletes a single entry from Firebase.
  static Future<void> deleteItem({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required String itemId,
    required String collectionName,
    required Color successColor,
    required Color errorColor,
  }) async {
    try {
      final user = ref.read(authProvider);
      if (user == null) {
        if (context.mounted) {
          showSnackBar(context, Strings.userNotAuthenticated, errorColor);
        }
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection(collectionName)
          .doc(itemId)
          .delete();
      if (context.mounted) {
        showSnackBar(context, Strings.entryDeletedSuccessfully, successColor);
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            context, '${Strings.failedToDeleteEntryPrefix}$e', errorColor);
      }
    }
  }

  /// Shows a confirmation dialog for deleting all entries.
  static Future<bool> showDeleteAllConfirmationDialog({
    required BuildContext context,
    required String metricName,
  }) async {
    return UIUtils.showConfirmationDialog(
      context: context,
      title: Strings.deleteAllEntriesTitle,
      content:
          '${Strings.deleteAllEntriesContentPrefix}$metricName${Strings.entriesForDateSuffix}',
      confirmText: Strings.deleteAllConfirmText,
    );
  }

  /// Deletes all entries using a batch operation.
  static Future<void> deleteAllItems<T>({
    required BuildContext context,
    required WidgetRef ref,
    required String userId,
    required List<T> items,
    required String collectionName,
    required Color successColor,
    required Color errorColor,
    required String metricName,
  }) async {
    try {
      final user = ref.read(authProvider);
      if (user == null) {
        if (context.mounted) {
          showSnackBar(context, Strings.userNotAuthenticated, errorColor);
        }
        return;
      }

      final batch = FirebaseFirestore.instance.batch();
      for (var item in items) {
        final itemId = (item as dynamic).id;
        batch.delete(
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(collectionName)
              .doc(itemId),
        );
      }
      await batch.commit();

      if (context.mounted) {
        showSnackBar(
          context,
          '${Strings.allEntriesDeletedSuccessfullyPrefix}$metricName${Strings.allEntriesDeletedSuccessfullySuffix}',
          successColor,
        );
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBar(
            context, '${Strings.failedToDeleteEntriesPrefix}$e', errorColor);
      }
    }
  }

  /// Shows a snackbar with the given message and background color.
  static void showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor,
  ) {
    UIUtils.showSnackBar(context, message, backgroundColor);
  }
}
