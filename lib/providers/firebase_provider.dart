import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/utils/utils.dart';

final fluidIntakeListProvider = StreamProvider<List<FluidIntake>>((ref) {
  // Assume user is authenticated
  final userId = ref.watch(authProvider)!.uid;

  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
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

  // Define date range: 12:00 AM today to 12:00 AM tomorrow
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('fluid_intake')
      .where('timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
      .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
      .orderBy(
        'timestamp',
        descending: false,
      )
      .snapshots()
      .map((snapshot) {
    double total = 0;
    String lastTime = 'Time : N/A';

    for (var doc in snapshot.docs) {
      final summary = doc.data();
      total += (summary['quantity'] as num?)?.toDouble() ?? 0;
      if (summary['timestamp'] != null) {
        lastTime = DateFormat('h:mm a').format(
          (summary['timestamp'] as Timestamp).toDate(),
        );
      }
    }
    return {
      'day': Utils.formatWeekday(now),
      'date': DateFormat('MMMM d, yyyy').format(now),
      'total': total,
      'lastTime': lastTime,
    };
  }).handleError((error, stackTrace) {
    final now = DateTime.now();
    return {
      'day': Utils.formatWeekday(now),
      'date': DateFormat('MMMM d, yyyy').format(now),
      'total': 0.0,
      'lastTime': 'Time : N/A',
    };
  });
});
