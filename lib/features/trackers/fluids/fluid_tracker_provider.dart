import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/provider_constants.dart';
import 'package:nephro_care/core/utils/date_utils.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/settings/settings_provider.dart';
import 'package:nephro_care/features/shared/generic_log_screen.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_intake_model.dart';

class FluidIntakeStateNotifier
    extends StateNotifier<AsyncValue<Cache<FluidIntakeModel>>> {
  final String userId;
  final DateTime selectedDate;
  final Ref ref;
  static final cacheDuration = Duration(minutes: kCacheDurationInMinutes);

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
          .collection('fluids')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .get();

      final fluidIntakes = snapshot.docs
          .map((doc) => FluidIntakeModel.fromJson(doc.data()))
          .toList();

      state = AsyncValue.data(Cache<FluidIntakeModel>(
        items: fluidIntakes,
        lastFetched: DateTime.now(),
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<Cache<FluidIntakeModel>> streamData() async* {
    if (state is AsyncData<Cache<FluidIntakeModel>> &&
        DateTime.now()
                .difference((state as AsyncData<Cache<FluidIntakeModel>>)
                    .value
                    .lastFetched)
                .inMinutes <
            cacheDuration.inMinutes) {
      yield (state as AsyncData<Cache<FluidIntakeModel>>).value;
    } else {
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fluids')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .snapshots();

      await for (final snapshot in stream) {
        final fluidIntakes = snapshot.docs
            .map((doc) => FluidIntakeModel.fromJson(doc.data()))
            .toList();
        final cache = Cache<FluidIntakeModel>(
          items: fluidIntakes,
          lastFetched: DateTime.now(),
        );
        state = AsyncValue.data(cache);
        yield cache;
      }
    }
  }
}

final fluidIntakeDataProvider =
    StreamProvider.family<Cache<FluidIntakeModel>, (String, DateTime)>(
        (ref, params) {
  final userId = params.$1;
  final selectedDate = params.$2;
  final notifier = FluidIntakeStateNotifier(ref, userId, selectedDate);
  return notifier.streamData();
});

final fluidIntakeListProvider = Provider<List<FluidIntakeModel>>((ref) {
  final data = ref.watch(fluidIntakeDataProvider(
    (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
  ));
  return data.when(
    data: (cache) => cache.items,
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
      final fluidIntakes = cache.items;
      double total = 0;
      DateTime? lastTime;
      int totalDrinksToday = fluidIntakes.length;
      Map<String, double> typeTotals = {};

      for (var intake in fluidIntakes) {
        total += intake.quantity;
        typeTotals[intake.fluidName] =
            (typeTotals[intake.fluidName] ?? 0) + intake.quantity;
        lastTime = intake.timestamp.toDate();
      }

      return {
        'day': DateTimeUtils.formatWeekday(selectedDate),
        'date': DateTimeUtils.formatDateDM(selectedDate),
        'total': total,
        'lastTime': lastTime,
        'totalDrinksToday': totalDrinksToday,
        'typeTotals': typeTotals,
      };
    },
    loading: () => {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': null,
      'totalDrinksToday': 0,
      'typeTotals': <String, double>{},
    },
    error: (_, __) => {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': null,
      'totalDrinksToday': 0,
      'typeTotals': <String, double>{},
    },
  );
});
