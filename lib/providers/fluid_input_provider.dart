import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/utils/utils.dart';

final fluidIntakeListProvider = StreamProvider<List<FluidIntake>>((ref) {
  final userId = ref.watch(authProvider)!.uid;
  final selectedDate = ref.watch(selectedDateProvider);

  final startOfDay =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('fluid_intake')
      .where('timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FluidIntake.fromJson(doc.data()))
          .toList());
});

final fluidIntakeSummaryProvider = StreamProvider<Map<String, dynamic>>((ref) {
  final userId = ref.watch(authProvider)!.uid;
  final selectedDate = ref.watch(selectedDateProvider);
  final startOfDay =
      DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('fluid_intake')
      .where('timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
      .orderBy('timestamp', descending: false)
      .snapshots()
      .map((snapshot) {
    double total = 0;
    String lastTime = 'Unknown';
    int totalDrinksToday = snapshot.docs.length;
    Map<String, double> typeTotals = {};

    for (var doc in snapshot.docs) {
      final summary = doc.data();
      final quantity = (summary['quantity'] as num?)?.toDouble() ?? 0;
      final type = (summary['fluidName'] as String?) ?? 'Unknown';
      total += quantity;
      typeTotals[type] = (typeTotals[type] ?? 0) + quantity;
      if (summary['timestamp'] != null) {
        lastTime = DateFormat('h:mm a')
            .format((summary['timestamp'] as Timestamp).toDate());
      }
    }
    return {
      'day': Utils.formatWeekday(selectedDate),
      'date': Utils.formatDateDM(selectedDate),
      'total': total,
      'lastTime': lastTime,
      'totalDrinksToday': totalDrinksToday,
      'typeTotals': typeTotals,
    };
  }).handleError((error, stackTrace) {
    return {
      'day': Utils.formatWeekday(selectedDate),
      'date': Utils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': 'Unknown',
      'totalDrinksToday': 0,
      'typeTotals': <String, double>{},
    };
  });
});
