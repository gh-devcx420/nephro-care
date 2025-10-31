import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_constants.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_model.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';

class BPMonitorStateNotifier
    extends StateNotifier<AsyncValue<Cache<BPTrackerModel>>> {
  final String userId;
  final DateTime selectedDate;
  final Ref ref;
  static const cacheDuration =
      Duration(minutes: AppConstants.cacheDurationMinutes);

  BPMonitorStateNotifier(this.ref, this.userId, this.selectedDate)
      : super(const AsyncValue.loading()) {
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(
        const Duration(days: 1),
      );

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection(BloodPressureConstants.bpFirebaseCollectionName)
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .get();

      final bpMonitors = snapshot.docs
          .map((doc) => BPTrackerModel.fromFirestore(doc))
          .toList();

      state = AsyncValue.data(
        Cache<BPTrackerModel>(
          items: bpMonitors,
          lastFetched: DateTime.now(),
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<Cache<BPTrackerModel>> streamData() async* {
    if (state is AsyncData<Cache<BPTrackerModel>> &&
        DateTime.now()
                .difference((state as AsyncData<Cache<BPTrackerModel>>)
                    .value
                    .lastFetched)
                .inMinutes <
            cacheDuration.inMinutes) {
      yield (state as AsyncData<Cache<BPTrackerModel>>).value;
      return;
    }

    final startOfDay =
        DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final stream = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection(BloodPressureConstants.bpFirebaseCollectionName)
        .where('timestamp',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
        .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
        .orderBy('timestamp', descending: false)
        .snapshots(includeMetadataChanges: true);

    await for (final snapshot in stream) {
      final bpMonitors = snapshot.docs
          .map((doc) =>
              BPTrackerModel.fromFirestore(doc)) // ✅ Use fromFirestore!
          .toList();
      final cache = Cache<BPTrackerModel>(
        items: bpMonitors,
        lastFetched: DateTime.now(),
      );
      state = AsyncValue.data(cache);
      yield cache;
    }
  }
}

final bpTrackerDataProvider =
    StreamProvider.family<Cache<BPTrackerModel>, (String, DateTime)>(
        (ref, params) {
  final userId = params.$1;
  final selectedDate = params.$2;

  final user = ref.watch(authProvider);
  if (user == null || user.uid != userId) {
    return Stream.value(Cache<BPTrackerModel>(
      items: [],
      lastFetched: DateTime.now(),
    ));
  }

  final notifier = BPMonitorStateNotifier(ref, userId, selectedDate);
  return notifier.streamData();
});

final bpTrackerListProvider = Provider<List<BPTrackerModel>>((ref) {
  final user = ref.watch(authProvider);
  if (user == null) return [];

  final data = ref.watch(bpTrackerDataProvider(
    (user.uid, ref.watch(selectedDateProvider)),
  ));
  return data.when(
    data: (cache) => cache.items,
    loading: () => [],
    error: (_, __) => [],
  );
});

final bpTrackerSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final selectedDate = ref.watch(selectedDateProvider);
  final user = ref.watch(authProvider);

  if (user == null) {
    return {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'totalMeasurements': 0,
      'lastTime': null,
      'averageSystolic': 0,
      'averageDiastolic': 0,
      'averagePulse': 0,
      'averageSpo2': null,
      'lastSystolic': null,
      'lastDiastolic': null,
    };
  }

  final data = ref.watch(bpTrackerDataProvider(
    (user.uid, selectedDate),
  ));

  return data.when(
    data: (cache) {
      final bpMonitors = cache.items;
      if (bpMonitors.isEmpty) {
        return {
          'day': DateTimeUtils.formatWeekday(selectedDate),
          'date': DateTimeUtils.formatDateDM(selectedDate),
          'totalMeasurements': 0,
          'lastTime': null,
          'averageSystolic': 0,
          'averageDiastolic': 0,
          'averagePulse': 0,
          'averageSpo2': null,
          'lastSystolic': null,
          'lastDiastolic': null,
        };
      }

      final totalMeasurements = bpMonitors.length;
      final totalSystolic =
          bpMonitors.fold<int>(0, (total, bp) => total + bp.systolic);
      final totalDiastolic =
          bpMonitors.fold<int>(0, (total, bp) => total + bp.diastolic);
      final totalPulse =
          bpMonitors.fold<int>(0, (total, bp) => total + bp.pulse);
      final spo2Data = bpMonitors
          .where((bp) => bp.spo2 != null)
          .fold<double>(0, (total, bp) => total + bp.spo2!);
      final spo2Count = bpMonitors.where((bp) => bp.spo2 != null).length;

      final latest = bpMonitors.last;

      return {
        'day': DateTimeUtils.formatWeekday(selectedDate),
        'date': DateTimeUtils.formatDateDM(selectedDate),
        'totalMeasurements': totalMeasurements,
        'lastTime': latest.timestamp.toDate(),
        'averageSystolic': totalSystolic / totalMeasurements,
        'averageDiastolic': totalDiastolic / totalMeasurements,
        'averagePulse': totalPulse / totalMeasurements,
        'averageSpo2': spo2Count > 0 ? spo2Data / spo2Count : null,
        'lastSystolic': latest.systolic,
        'lastDiastolic': latest.diastolic,
      };
    },
    loading: () => {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'totalMeasurements': 0,
      'lastTime': null,
      'averageSystolic': 0,
      'averageDiastolic': 0,
      'averagePulse': 0,
      'averageSpo2': null,
      'lastSystolic': null,
      'lastDiastolic': null,
    },
    error: (_, __) => {
      'day': DateTimeUtils.formatWeekday(selectedDate),
      'date': DateTimeUtils.formatDateDM(selectedDate),
      'totalMeasurements': 0,
      'lastTime': null,
      'averageSystolic': 0,
      'averageDiastolic': 0,
      'averagePulse': 0,
      'averageSpo2': null,
      'lastSystolic': null,
      'lastDiastolic': null,
    },
  );
});
