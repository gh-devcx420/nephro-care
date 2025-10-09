import 'package:intl/intl.dart';

class DateTimeUtils {
  //Utility Function to format Date in dd MMM yyyy format (18 May 2025).
  static String formatDateDMY(DateTime? pickedDate) {
    final formatter = DateFormat('dd MMM yyyy');
    if (pickedDate != null) {
      return formatter.format(pickedDate);
    } else {
      return 'No Date Picked';
    }
  }

  //Utility Function to format Date in dd MMM format (18 May).
  static String formatDateDM(DateTime? pickedDate) {
    final formatter = DateFormat('dd MMM');
    if (pickedDate != null) {
      return formatter.format(pickedDate);
    } else {
      return 'No Date Picked';
    }
  }

  //Utility Function to format Date in weekday format (Wednesday).
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

  static String getTimeOfDay(DateTime dateTime) {
    final hour = dateTime.hour;

    if (hour >= 5 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Evening';
    } else {
      return 'Night';
    }
  }
}
