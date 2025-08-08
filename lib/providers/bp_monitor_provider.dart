import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/constants.dart';
import 'package:nephro_care/models/tracker_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/utils/date_time_utils.dart';

class BPMonitorStateNotifier
    extends StateNotifier<AsyncValue<Cache<BPMonitor>>> {
  final String userId;
  final DateTime selectedDate;
  final Ref ref;
  static final cacheDuration = Duration(minutes: kCacheDurationInMinutes);

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
          .collection('bp_monitor')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .get();

      final bpMonitors =
          snapshot.docs.map((doc) => BPMonitor.fromJson(doc.data())).toList();

      state = AsyncValue.data(
        Cache<BPMonitor>(
          items: bpMonitors,
          lastFetched: DateTime.now(),
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<Cache<BPMonitor>> streamData() async* {
    if (state is AsyncData<Cache<BPMonitor>> &&
        DateTime.now()
                .difference(
                    (state as AsyncData<Cache<BPMonitor>>).value.lastFetched)
                .inMinutes <
            cacheDuration.inMinutes) {
      yield (state as AsyncData<Cache<BPMonitor>>).value;
    } else {
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('bp_monitor')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .snapshots();

      await for (final snapshot in stream) {
        final bpMonitors =
            snapshot.docs.map((doc) => BPMonitor.fromJson(doc.data())).toList();
        final cache = Cache<BPMonitor>(
          items: bpMonitors,
          lastFetched: DateTime.now(),
        );
        state = AsyncValue.data(cache);
        yield cache;
      }
    }
  }
}

final bpMonitorDataProvider =
    StreamProvider.family<Cache<BPMonitor>, (String, DateTime)>((ref, params) {
  final userId = params.$1;
  final selectedDate = params.$2;
  final notifier = BPMonitorStateNotifier(ref, userId, selectedDate);
  return notifier.streamData();
});

final bpMonitorListProvider = Provider<List<BPMonitor>>((ref) {
  final data = ref.watch(bpMonitorDataProvider(
    (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
  ));
  return data.when(
    data: (cache) => cache.items,
    loading: () => [],
    error: (_, __) => [],
  );
});

final bpMonitorSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final data = ref.watch(bpMonitorDataProvider(
    (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
  ));

  return data.when(
    data: (cache) {
      final bpMonitors = cache.items;
      final selectedDate = ref.watch(selectedDateProvider);
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
      'day': DateTimeUtils.formatWeekday(ref.watch(selectedDateProvider)),
      'date': DateTimeUtils.formatDateDM(ref.watch(selectedDateProvider)),
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
      'day': DateTimeUtils.formatWeekday(ref.watch(selectedDateProvider)),
      'date': DateTimeUtils.formatDateDM(ref.watch(selectedDateProvider)),
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
