import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/widgets/nc_alert_dialogue.dart';

class Utils {
  /// *DATE & TIME CONVERSIONS* ///
  // Utility Function to format Date in dd MMM yyyy format (18 May 2025).
  static String formatDateDMY(DateTime? pickedDate) {
    final formatter = DateFormat('dd MMM yyyy');
    if (pickedDate != null) {
      return formatter.format(pickedDate);
    } else {
      return 'No Date Picked';
    }
  }

  // Utility Function to format Date in dd MMM format (18 May).
  static String formatDateDM(DateTime? pickedDate) {
    final formatter = DateFormat('dd MMM');
    if (pickedDate != null) {
      return formatter.format(pickedDate);
    } else {
      return 'No Date Picked';
    }
  }

  // Utility Function to format Date in weekday format (Wednesday).
  static String formatWeekday(DateTime date) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return days[date.weekday - 1];
  }

  //Utility Function to check if Date 1 & Date 2 are same or not.
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Utility Function to format Time in hh:mm a format (10:00 am).
  static String formatTime(DateTime? pickedTime) {
    final formatter = DateFormat('h:mm a');
    if (pickedTime != null) {
      return formatter.format(pickedTime);
    } else {
      return 'No Time Picked';
    }
  }

  /// *FLUID CONVERSIONS* ///
  // Utility Function to convert a millilitre value to litres (1.2 L).
  static String convertToLitres(dynamic input) {
    double? mlValue;
    if (input is String) {
      final numericText = input.replaceAll(RegExp(r'[^0-9.]'), '').trim();
      mlValue = double.tryParse(numericText);
    } else if (input is double) {
      mlValue = input;
    }
    if (mlValue == null) {
      return input is String ? input : 'Invalid Input';
    }
    final litres = mlValue / 1000;
    if (litres == litres.roundToDouble()) {
      return '${litres.toInt()} L';
    } else {
      return '${litres.toStringAsFixed(2).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '')} L';
    }
  }

  // Utility Function to format a fluid amount based on its value.
  static String formatFluidValue(dynamic input) {
    double? mlValue;
    if (input is String) {
      final numericText = input.replaceAll(RegExp(r'[^0-9.]'), '').trim();
      mlValue = double.tryParse(numericText);
    } else if (input is double) {
      mlValue = input;
    }
    if (mlValue == null) {
      return input is String ? input : 'Invalid Input';
    }
    if (mlValue >= 1000) {
      return convertToLitres(mlValue);
    } else {
      return '${mlValue.toInt()} ml';
    }
  }

  /// *UI UTILITY FUNCTIONS* ///
  // Utility Function to show a Snackbar with consistent styling.
  static void showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: backgroundColor,
            duration: const Duration(seconds: 2),
          ),
        );
    }
  }

  // Utility Function to  show a confirmation dialog with
  // customizable title, content, and confirm button.
  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = 'Confirm',
    Color? confirmColor,
  }) async {
    final theme = Theme.of(context);
    final result = await showNCAlertDialogue(
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
