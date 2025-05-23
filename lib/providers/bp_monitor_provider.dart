import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/models/bp_monitor_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/utils/utils.dart';

class BPMonitorCache {
  final List<BPMonitor> bpMonitors;
  final DateTime lastFetched;

  BPMonitorCache({
    required this.bpMonitors,
    required this.lastFetched,
  });
}

class BPMonitorStateNotifier extends StateNotifier<AsyncValue<BPMonitorCache>> {
  final String userId;
  final DateTime selectedDate;
  final Ref ref;
  static const cacheDuration = Duration(minutes: 5);

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
        BPMonitorCache(
          bpMonitors: bpMonitors,
          lastFetched: DateTime.now(),
        ),
      );
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<BPMonitorCache> streamData() async* {
    if (state is AsyncData<BPMonitorCache> &&
        DateTime.now()
                .difference(
                    (state as AsyncData<BPMonitorCache>).value.lastFetched)
                .inMinutes <
            cacheDuration.inMinutes) {
      yield (state as AsyncData<BPMonitorCache>).value;
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
        final cache = BPMonitorCache(
          bpMonitors: bpMonitors,
          lastFetched: DateTime.now(),
        );
        state = AsyncValue.data(cache);
        yield cache;
      }
    }
  }
}

final bpMonitorDataProvider =
    StreamProvider.family<BPMonitorCache, (String, DateTime)>((ref, params) {
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
    data: (cache) => cache.bpMonitors,
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
      final bpMonitors = cache.bpMonitors;
      final selectedDate = ref.watch(selectedDateProvider);
      int totalMeasurements = bpMonitors.length;
      String lastTime = 'Unknown';
      int averageSystolic = 0;
      int averageDiastolic = 0;
      int averagePulse = 0;
      double? averageSpo2;

      if (bpMonitors.isNotEmpty) {
        int totalSystolic = 0;
        int totalDiastolic = 0;
        int totalPulse = 0;
        double totalSpo2 = 0;
        int spo2Count = 0;

        for (var bp in bpMonitors) {
          totalSystolic += bp.systolic;
          totalDiastolic += bp.diastolic;
          totalPulse += bp.pulse;
          if (bp.spo2 != null) {
            totalSpo2 += bp.spo2!;
            spo2Count++;
          }
          lastTime = DateFormat('h:mm a').format(bp.timestamp.toDate());
        }

        averageSystolic = (totalSystolic / totalMeasurements).round();
        averageDiastolic = (totalDiastolic / totalMeasurements).round();
        averagePulse = (totalPulse / totalMeasurements).round();
        if (spo2Count > 0) {
          averageSpo2 = totalSpo2 / spo2Count;
        }
      }

      return {
        'day': Utils.formatWeekday(selectedDate),
        'date': Utils.formatDateDM(selectedDate),
        'totalMeasurements': totalMeasurements,
        'lastTime': lastTime,
        'averageSystolic': averageSystolic,
        'averageDiastolic': averageDiastolic,
        'averagePulse': averagePulse,
        'averageSpo2': averageSpo2,
      };
    },
    loading: () => {
      'day': Utils.formatWeekday(ref.watch(selectedDateProvider)),
      'date': Utils.formatDateDM(ref.watch(selectedDateProvider)),
      'totalMeasurements': 0,
      'lastTime': 'Unknown',
      'averageSystolic': 0,
      'averageDiastolic': 0,
      'averagePulse': 0,
      'averageSpo2': null,
    },
    error: (_, __) => {
      'day': Utils.formatWeekday(ref.watch(selectedDateProvider)),
      'date': Utils.formatDateDM(ref.watch(selectedDateProvider)),
      'totalMeasurements': 0,
      'lastTime': 'Unknown',
      'averageSystolic': 0,
      'averageDiastolic': 0,
      'averagePulse': 0,
      'averageSpo2': null,
    },
  );
});
