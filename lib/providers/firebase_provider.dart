import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';

final fluidIntakeListProvider = StreamProvider<List<FluidIntake>>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) {
    return Stream.value([]);
  }

  final userId = user.uid;
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
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => FluidIntake.fromJson(doc.data()))
          .toList());
});

final fluidIntakeSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final fluidIntakeAsync = ref.watch(fluidIntakeListProvider);

  return fluidIntakeAsync.when(
    data: (intakes) {
      if (intakes.isEmpty) {
        return {'total': 0.0, 'lastTime': 'N/A'};
      }
      final total = intakes.fold<double>(
        0.0,
        (totalSoFar, intake) => totalSoFar + intake.quantity,
      );
      final lastTime =
          DateFormat('h:mm a').format(intakes.first.timestamp.toDate());
      return {'total': total, 'lastTime': lastTime};
    },
    loading: () => {'total': 0.0, 'lastTime': 'Loading...'},
    error: (error, stack) => {'total': 0.0, 'lastTime': 'Error'},
  );
});
