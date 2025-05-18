import 'package:flutter/material.dart';

Future<dynamic> showNCAlertDialogue({
  required context,
  required titleText,
  required Widget content,
  required Widget action1,
  required Widget action2,
}) {
  return showDialog(
    context: context,
    builder: (context) {
      final isDark = Theme.of(context).brightness == Brightness.dark;
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: isDark
            ? Theme.of(context).colorScheme.surfaceDim
            : Theme.of(context).colorScheme.surface,
        title: Text(titleText),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 16, 8),
        content: content,
        contentTextStyle: Theme.of(context).textTheme.bodyMedium,
        contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
        actions: [action1, action2],
        actionsPadding: const EdgeInsets.fromLTRB(24, 8, 16, 16),
      );
    },
  );
}
