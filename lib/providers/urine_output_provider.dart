import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/models/urine_output_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/utils/utils.dart';

class UrineOutputCache {
  final List<UrineOutput> urineOutputs;
  final DateTime lastFetched;

  UrineOutputCache({
    required this.urineOutputs,
    required this.lastFetched,
  });
}

class UrineOutputStateNotifier
    extends StateNotifier<AsyncValue<UrineOutputCache>> {
  final String userId;
  final DateTime selectedDate;
  final Ref ref;
  static const cacheDuration = Duration(minutes: 5);

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
          .collection('urine_output')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .get();

      final urineOutputs =
          snapshot.docs.map((doc) => UrineOutput.fromJson(doc.data())).toList();

      state = AsyncValue.data(UrineOutputCache(
        urineOutputs: urineOutputs,
        lastFetched: DateTime.now(),
      ));
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Stream<UrineOutputCache> streamData() async* {
    if (state is AsyncData<UrineOutputCache> &&
        DateTime.now()
                .difference(
                    (state as AsyncData<UrineOutputCache>).value.lastFetched)
                .inMinutes <
            cacheDuration.inMinutes) {
      yield (state as AsyncData<UrineOutputCache>).value;
    } else {
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final stream = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('urine_output')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .orderBy('timestamp', descending: false)
          .snapshots();

      await for (final snapshot in stream) {
        final urineOutputs = snapshot.docs
            .map((doc) => UrineOutput.fromJson(doc.data()))
            .toList();
        final cache = UrineOutputCache(
          urineOutputs: urineOutputs,
          lastFetched: DateTime.now(),
        );
        state = AsyncValue.data(cache);
        yield cache;
      }
    }
  }
}

final urineOutputDataProvider =
    StreamProvider.family<UrineOutputCache, (String, DateTime)>((ref, params) {
  final userId = params.$1;
  final selectedDate = params.$2;
  final notifier = UrineOutputStateNotifier(ref, userId, selectedDate);
  return notifier.streamData();
});

final urineOutputListProvider = Provider<List<UrineOutput>>((ref) {
  final data = ref.watch(urineOutputDataProvider(
    (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
  ));
  return data.when(
    data: (cache) => cache.urineOutputs,
    loading: () => [],
    error: (_, __) => [],
  );
});

final urineOutputSummaryProvider = Provider<Map<String, dynamic>>((ref) {
  final data = ref.watch(urineOutputDataProvider(
    (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
  ));
  final selectedDate = ref.watch(selectedDateProvider);

  return data.when(
    data: (cache) {
      final urineOutputs = cache.urineOutputs;
      double total = 0;
      String lastTime = 'Unknown';
      int totalUrineToday = urineOutputs.length;

      for (var output in urineOutputs) {
        total += output.quantity;
        lastTime = DateFormat('h:mm a').format(output.timestamp.toDate());
      }

      return {
        'day': Utils.formatWeekday(selectedDate),
        'date': Utils.formatDateDM(selectedDate),
        'total': total,
        'lastTime': lastTime,
        'totalUrineToday': totalUrineToday,
      };
    },
    loading: () => {
      'day': Utils.formatWeekday(selectedDate),
      'date': Utils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': 'Unknown',
      'totalUrineToday': 0,
    },
    error: (_, __) => {
      'day': Utils.formatWeekday(selectedDate),
      'date': Utils.formatDateDM(selectedDate),
      'total': 0,
      'lastTime': 'Unknown',
      'totalUrineToday': 0,
    },
  );
});
