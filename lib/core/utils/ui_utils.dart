import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/core/widgets/nc_alert_dialogue.dart';

class UIUtils {
  static Future<bool> showNCConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    Color? titleColor,
    String confirmText = 'Confirm',
    Color? cancelColor,
    Color? confirmColor,
  }) async {
    final theme = Theme.of(context);
    final result = await showNCAlertDialog(
      context: context,
      titleText: title,
      titleColor: titleColor,
      content: Text(
        content,
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
      ),
      action1: TextButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop(false);
        },
        style: TextButton.styleFrom(
          foregroundColor: cancelColor ?? theme.colorScheme.onSurface,
        ),
        child: const Text('Cancel'),
      ),
      action2: ElevatedButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop(true);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: confirmColor ?? theme.colorScheme.error,
        ),
        child: Text(confirmText),
      ),
    );
    return result ?? false;
  }

  static void showNCSnackBar({
    required BuildContext context,
    required String message,
    Color? backgroundColor,
    int? durationSeconds,
  }) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(
              message,
            ),
            backgroundColor:
                backgroundColor ?? Theme.of(context).colorScheme.primary,
            duration: Duration(seconds: durationSeconds ?? 1),
          ),
        );
    }
  }

  static RichText createRichTextValueWithUnit({
    required String value,
    required String unit,
    required TextStyle valueStyle,
    required TextStyle unitStyle,
    String? prefixText,
    TextStyle? prefixStyle,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          if (prefixText != null)
            TextSpan(
              text: prefixText,
              style: prefixStyle ?? valueStyle,
            ),
          TextSpan(
            text: value,
            style: valueStyle,
          ),
          if (unit.isNotEmpty) ...[
            TextSpan(
              text: ' $unit',
              style: unitStyle,
            ),
          ]
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  // Creates RichText for timestamps
  static RichText createRichTextTimestamp({
    required DateTime? timestamp,
    required TextStyle timeStyle,
    required TextStyle meridiemStyle,
    String? prefixText,
    TextStyle? prefixStyle,
    double? timeFontSize,
    bool isMeridiemUpperCase = true,
  }) {
    String timeText = 'Unknown';
    String meridiemIndicatorText = '';

    if (timestamp != null) {
      final timeFormat = DateFormat('h:mm');
      timeText = timeFormat.format(timestamp);
      final meridiemFormat = DateFormat('a');
      meridiemIndicatorText = meridiemFormat.format(timestamp);
      if (!isMeridiemUpperCase) {
        meridiemIndicatorText = meridiemIndicatorText.toLowerCase();
      }
    }

    return RichText(
      text: TextSpan(
        children: [
          if (prefixText != null)
            TextSpan(
              text: prefixText,
              style: prefixStyle ?? timeStyle,
            ),
          TextSpan(
            text: timeText,
            style: timeFontSize != null
                ? timeStyle.copyWith(fontSize: timeFontSize)
                : timeStyle,
          ),
          if (timestamp != null)
            TextSpan(
              text: ' $meridiemIndicatorText',
              style: meridiemStyle,
            ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
