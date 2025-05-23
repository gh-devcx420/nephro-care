import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/utils/utils.dart';

class FluidIntakeCache {
  final List<FluidIntake> fluidIntakes;
  final DateTime lastFetched;

  FluidIntakeCache({
    required this.fluidIntakes,
    required this.lastFetched,
  });
}

class FluidIntakeStateNotifier
    extends StateNotifier<AsyncValue<FluidIntakeCache>> {
  final String userId;
  final DateTime selectedDate;
  final Ref ref;
  static const cacheDuration = Duration(minutes: 5);

  FluidIntakeStateNotifier(this.ref, this.userId, this.selectedDate)
      : super(const AsyncValue.loading()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fluid_intake')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .get();

      final fluidIntakes =
          snapshot.docs.map((doc) => FluidIntake.fromJson(doc.data())).toList();

      state = AsyncValue.data(FluidIntakeCache(
        fluidIntakes: fluidIntakes,
        lastFetched: DateTime.now(),
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<FluidIntakeCache> streamData() async* {
    if (state is AsyncData<FluidIntakeCache> &&
        DateTime.now()
                .difference(
                    (state as AsyncData<FluidIntakeCache>).value.lastFetched)
                .inMinutes <
            cacheDuration.inMinutes) {
      yield (state as AsyncData<FluidIntakeCache>).value;
    } else {
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fluid_intake')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .snapshots();

      await for (final snapshot in stream) {
        final fluidIntakes = snapshot.docs
            .map((doc) => FluidIntake.fromJson(doc.data()))
            .toList();
        final cache = FluidIntakeCache(
          fluidIntakes: fluidIntakes,
          lastFetched: DateTime.now(),
        );
        state = AsyncValue.data(cache);
        yield cache;
      }
    }
  }
}

final fluidIntakeDataProvider =
    StreamProvider.family<FluidIntakeCache, (String, DateTime)>((ref, params) {
  final userId = params.$1;
  final selectedDate = params.$2;
  final notifier = FluidIntakeStateNotifier(ref, userId, selectedDate);
  return notifier.streamData();
});

final fluidIntakeListProvider = Provider<List<FluidIntake>>((ref) {
  final data = ref.watch(fluidIntakeDataProvider(
    (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
  ));
  return data.when(
    data: (cache) => cache.fluidIntakes,
    loading: () => [],
    error: (_, __) => [],
  );
});

final fluidIntakeSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final data = ref.watch(fluidIntakeDataProvider(
    (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
  ));
  final selectedDate = ref.watch(selectedDateProvider);

  return data.when(
    data: (cache) {
      final fluidIntakes = cache.fluidIntakes;
      double total = 0;
      String lastTime = 'Unknown';
      int totalDrinksToday = fluidIntakes.length;
      Map<String, double> typeTotals = {};

      for (var intake in fluidIntakes) {
        total += intake.quantity;
        typeTotals[intake.fluidName] =
            (typeTotals[intake.fluidName] ?? 0) + intake.quantity;
        lastTime = DateFormat('h:mm a').format(intake.timestamp.toDate());
      }

      return {
        'day': Utils.formatWeekday(selectedDate),
        'date': Utils.formatDateDM(selectedDate),
        'total': total,
        'lastTime': lastTime,
        'totalDrinksToday': totalDrinksToday,
        'typeTotals': typeTotals,
      };
    },
    loading: () => {
      'day': Utils.formatWeekday(selectedDate),
      'date': Utils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': 'Unknown',
      'totalDrinksToday': 0,
      'typeTotals': <String, double>{},
    },
    error: (_, __) => {
      'day': Utils.formatWeekday(selectedDate),
      'date': Utils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': 'Unknown',
      'totalDrinksToday': 0,
      'typeTotals': <String, double>{},
    },
  );
});
