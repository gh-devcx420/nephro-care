import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';
import 'package:nephro_care/features/trackers/weight/weight_constants.dart';
import 'package:nephro_care/features/trackers/weight/weight_model.dart';

class WeightStateNotifier
    extends StateNotifier<AsyncValue<Cache<WeightModel>>> {
  final String userId;
  final DateTime selectedDate;
  final Ref ref;
  static const cacheDuration =
      Duration(minutes: AppConstants.cacheDurationMinutes);

  WeightStateNotifier(this.ref, this.userId, this.selectedDate)
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
          .collection(WeightConstants.weightFirebaseCollectionName)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .get();

      final weights =
          snapshot.docs.map((doc) => WeightModel.fromJson(doc.data())).toList();

      state = AsyncValue.data(
        Cache<WeightModel>(
          items: weights,
          lastFetched: DateTime.now(),
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<Cache<WeightModel>> streamData() async* {
    final currentUser = ref.read(authProvider);
    if (currentUser == null || currentUser.uid != userId) {
      return;
    }

    if (state is AsyncData<Cache<WeightModel>> &&
        DateTime.now()
                .difference(
                    (state as AsyncData<Cache<WeightModel>>).value.lastFetched)
                .inMinutes <
            cacheDuration.inMinutes) {
      yield (state as AsyncData<Cache<WeightModel>>).value;
    } else {
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(WeightConstants.weightFirebaseCollectionName)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .snapshots();

      await for (final snapshot in stream) {
        final user = ref.read(authProvider);
        if (user == null || user.uid != userId) {
          return;
        }

        final weights = snapshot.docs
            .map((doc) => WeightModel.fromJson(doc.data()))
            .toList();
        final cache = Cache<WeightModel>(
          items: weights,
          lastFetched: DateTime.now(),
        );
        state = AsyncValue.data(cache);
        yield cache;
      }
    }
  }
}

final weightDataProvider =
    StreamProvider.family<Cache<WeightModel>, (String, DateTime)>(
        (ref, params) {
  final userId = params.$1;
  final selectedDate = params.$2;

  final user = ref.watch(authProvider);
  if (user == null || user.uid != userId) {
    return Stream.value(Cache<WeightModel>(
      items: [],
      lastFetched: DateTime.now(),
    ));
  }

  final notifier = WeightStateNotifier(ref, userId, selectedDate);
  return notifier.streamData();
});

final weightListProvider = Provider<List<WeightModel>>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) return [];

  final data = ref.watch(weightDataProvider(
    (user.uid, ref.watch(selectedDateProvider)),
  ));
  return data.when(
    data: (cache) => cache.items,
    loading: () => [],
    error: (_, __) => [],
  );
});

final weightSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final user = ref.watch(authProvider);

  if (user == null) {
    return {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'totalMeasurements': 0,
      'lastTime': null,
      'averageWeight': 0,
    };
  }

  final data = ref.watch(weightDataProvider(
    (user.uid, selectedDate),
  ));

  return data.when(
    data: (cache) {
      final weights = cache.items;
      if (weights.isEmpty) {
        return {
          'day': DateTimeUtils.formatWeekday(selectedDate),
          'date': DateTimeUtils.formatDateDM(selectedDate),
          'totalMeasurements': 0,
          'lastTime': null,
          'averageWeight': 0,
        };
      }

      final totalMeasurements = weights.length;
      final totalWeight =
          weights.fold<double>(0, (total, w) => total + w.weight);
      final latest = weights.last;

      return {
        'day': DateTimeUtils.formatWeekday(selectedDate),
        'date': DateTimeUtils.formatDateDM(selectedDate),
        'totalMeasurements': totalMeasurements,
        'lastTime': latest.timestamp.toDate(),
        'averageWeight': totalWeight / totalMeasurements,
      };
    },
    loading: () => {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'totalMeasurements': 0,
      'lastTime': null,
      'averageWeight': 0,
    },
    error: (_, __) => {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'totalMeasurements': 0,
      'lastTime': null,
      'averageWeight': 0,
    },
  );
});
