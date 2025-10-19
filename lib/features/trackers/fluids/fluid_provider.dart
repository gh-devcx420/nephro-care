import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_constants.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_model.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FluidIntakeStateNotifier
    extends StateNotifier<AsyncValue<Cache<FluidsModel>>> {
  final String userId;
  final DateTime selectedDate;
  final Ref ref;
  static const cacheDuration =
      Duration(minutes: AppConstants.cacheDurationMinutes);

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
          .collection(FluidConstants.fluidFirebaseCollectionName)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .get();

      final fluidIntakes =
          snapshot.docs.map((doc) => FluidsModel.fromJson(doc.data())).toList();

      state = AsyncValue.data(Cache<FluidsModel>(
        items: fluidIntakes,
        lastFetched: DateTime.now(),
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<Cache<FluidsModel>> streamData() async* {
    // Check authentication at the start
    final currentUser = ref.read(authProvider);
    if (currentUser == null || currentUser.uid != userId) {
      return;
    }

    if (state is AsyncData<Cache<FluidsModel>> &&
        DateTime.now()
                .difference(
                    (state as AsyncData<Cache<FluidsModel>>).value.lastFetched)
                .inMinutes <
            cacheDuration.inMinutes) {
      yield (state as AsyncData<Cache<FluidsModel>>).value;
    } else {
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(FluidConstants.fluidFirebaseCollectionName)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .snapshots();

      await for (final snapshot in stream) {
        // Verify user is still authenticated and matches the userId
        final user = ref.read(authProvider);
        if (user == null || user.uid != userId) {
          return;
        }

        final fluidIntakes = snapshot.docs
            .map((doc) => FluidsModel.fromJson(doc.data()))
            .toList();
        final cache = Cache<FluidsModel>(
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
    StreamProvider.family<Cache<FluidsModel>, (String, DateTime)>(
        (ref, params) {
  final userId = params.$1;
  final selectedDate = params.$2;

  final user = ref.watch(authProvider);
  if (user == null || user.uid != userId) {
    return Stream.value(Cache<FluidsModel>(
      items: [],
      lastFetched: DateTime.now(),
    ));
  }

  final notifier = FluidIntakeStateNotifier(ref, userId, selectedDate);
  return notifier.streamData();
});

final fluidIntakeListProvider = Provider<List<FluidsModel>>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) return [];

  final data = ref.watch(fluidIntakeDataProvider(
    (user.uid, ref.watch(selectedDateProvider)),
  ));
  return data.when(
    data: (cache) => cache.items,
    loading: () => [],
    error: (_, __) => [],
  );
});

final fluidIntakeSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final user = ref.watch(authProvider);

  if (user == null) {
    return {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': null,
      'totalDrinksToday': 0,
      'typeTotals': <String, double>{},
    };
  }

  final data = ref.watch(fluidIntakeDataProvider(
    (user.uid, selectedDate),
  ));

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

class FluidLimitNotifier extends StateNotifier<double> {
  FluidLimitNotifier() : super(FluidConstants.fluidDailyLimit) {
    _loadFluidLimit();
  }

  Future<void> _loadFluidLimit() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLimit =
        prefs.getDouble('fluidLimit') ?? FluidConstants.fluidDailyLimit;
    state = savedLimit;
  }

  Future<void> setFluidLimit(double newLimit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fluidLimit', newLimit);
    state = newLimit;
  }
}

final fluidLimitProvider =
    StateNotifierProvider<FluidLimitNotifier, double>((ref) {
  return FluidLimitNotifier();
});
