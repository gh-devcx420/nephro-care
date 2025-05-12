import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  /// Utility Function to format Date in dd MMM yyyy format.
  static String formatDateDMY(DateTime? pickedDate) {
    final formatter = DateFormat('dd MMM yyyy');
    if (pickedDate != null) {
      return formatter.format(pickedDate);
    } else {
      return 'No Date Picked';
    }
  }

  /// Utility Function to format Date in dd MMM format.
  static String formatDateDM(DateTime? pickedDate) {
    final formatter = DateFormat('dd MMM');
    if (pickedDate != null) {
      return formatter.format(pickedDate);
    } else {
      return 'No Date Picked';
    }
  }

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

  /// Utility Function to format Time.
  static String formatTime(DateTime? pickedTime) {
    final formatter = DateFormat('hh:mm a');
    if (pickedTime != null) {
      return formatter.format(pickedTime);
    } else {
      return 'No Time Picked';
    }
  }

  // Show a Snackbar with consistent styling.
  static void showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
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

  /// Utility Function to convert a millilitre value to litres.
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

  /// Utility Function to format a fluid amount based on its value.
  static String formatFluidAmount(dynamic input) {
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
    if (mlValue > 1000) {
      return convertToLitres(mlValue);
    } else {
      return '${mlValue.toInt()} ml';
    }
  }
}
