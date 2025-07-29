import 'package:flutter/material.dart';

Future<dynamic> showNCAlertDialog({
  required context,
  required titleText,
  required Widget content,
  required Widget action1,
  required Widget action2,
  Color? titleColor,
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
        titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
            color: titleColor ?? Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w800),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
        content: content,
        contentTextStyle: Theme.of(context).textTheme.bodyMedium,
        contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        actions: [action1, action2],
        actionsPadding: const EdgeInsets.fromLTRB(16, 4, 12, 12),
      );
    },
  );
}
