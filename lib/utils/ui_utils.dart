import 'package:flutter/material.dart';
import 'package:nephro_care/widgets/nc_alert_dialogue.dart';

class UIUtils {

  static void showSnackBar(
    BuildContext context,
    String message,
    Color backgroundColor, {
    int durationSeconds = 3,
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
            duration: Duration(seconds: durationSeconds),
          ),
        );
    }
  }

  // Utility Function to show a confirmation dialog with
  // customizable title, content, and confirm button.
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirm',
    Color? confirmColor,
  }) async {
    final theme = Theme.of(context);
    final result = await showNCAlertDialog(
      context: context,
      titleText: title,
      content: Text(content),
      action1: TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Cancel'),
      ),
      action2: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: ElevatedButton.styleFrom(
          backgroundColor: confirmColor ?? theme.colorScheme.error,
        ),
        child: Text(
          confirmText,
          style: TextStyle(color: theme.colorScheme.surfaceBright),
        ),
      ),
    );
    return result ?? false;
  }
}
