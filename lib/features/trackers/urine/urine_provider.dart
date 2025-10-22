import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';
import 'package:nephro_care/features/trackers/urine/urine_constants.dart';
import 'package:nephro_care/features/trackers/urine/urine_model.dart';

class UrineOutputStateNotifier
    extends StateNotifier<AsyncValue<Cache<UrineModel>>> {
  final String userId;
  final DateTime selectedDate;
  final Ref ref;
  static const cacheDuration =
      Duration(minutes: AppConstants.cacheDurationMinutes);

  UrineOutputStateNotifier(this.ref, this.userId, this.selectedDate)
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
          .collection(UrineConstants.urineFirebaseCollectionName)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .get();

      final urineOutputs =
          snapshot.docs.map((doc) => UrineModel.fromJson(doc.data())).toList();

      state = AsyncValue.data(Cache<UrineModel>(
        items: urineOutputs,
        lastFetched: DateTime.now(),
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<Cache<UrineModel>> streamData() async* {
    if (state is AsyncData<Cache<UrineModel>> &&
        DateTime.now()
                .difference(
                    (state as AsyncData<Cache<UrineModel>>).value.lastFetched)
                .inMinutes <
            cacheDuration.inMinutes) {
      yield (state as AsyncData<Cache<UrineModel>>).value;
      return;
    }

    final startOfDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final stream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(UrineConstants.urineFirebaseCollectionName)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('timestamp', descending: false)
        .snapshots(includeMetadataChanges: true);

    await for (final snapshot in stream) {
      final urineOutputs =
          snapshot.docs.map((doc) => UrineModel.fromJson(doc.data())).toList();
      final cache = Cache<UrineModel>(
        items: urineOutputs,
        lastFetched: DateTime.now(),
      );
      state = AsyncValue.data(cache);
      yield cache;
    }
  }
}

final urineOutputDataProvider =
    StreamProvider.family<Cache<UrineModel>, (String, DateTime)>((ref, params) {
  final userId = params.$1;
  final selectedDate = params.$2;

  final user = ref.watch(authProvider);
  if (user == null || user.uid != userId) {
    return Stream.value(Cache<UrineModel>(
      items: [],
      lastFetched: DateTime.now(),
    ));
  }

  final notifier = UrineOutputStateNotifier(ref, userId, selectedDate);
  return notifier.streamData();
});

final urineOutputListProvider = Provider<List<UrineModel>>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) return [];

  final data = ref.watch(urineOutputDataProvider(
    (user.uid, ref.watch(selectedDateProvider)),
  ));
  return data.when(
    data: (cache) => cache.items,
    loading: () => [],
    error: (_, __) => [],
  );
});

final urineOutputSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final user = ref.watch(authProvider);

  if (user == null) {
    return {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': null,
      'totalUrineToday': 0,
    };
  }

  final data = ref.watch(urineOutputDataProvider(
    (user.uid, selectedDate),
  ));

  return data.when(
    data: (cache) {
      final urineOutputs = cache.items;
      double total = 0;
      DateTime? lastTime;
      int totalUrineToday = urineOutputs.length;

      for (var output in urineOutputs) {
        total += output.quantity;
        lastTime = output.timestamp.toDate();
      }

      return {
        'day': DateTimeUtils.formatWeekday(selectedDate),
        'date': DateTimeUtils.formatDateDM(selectedDate),
        'total': total,
        'lastTime': lastTime,
        'totalUrineToday': totalUrineToday,
      };
    },
    loading: () => {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': null,
      'totalUrineToday': 0,
    },
    error: (_, __) => {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': null,
      'totalUrineToday': 0,
    },
  );
});
