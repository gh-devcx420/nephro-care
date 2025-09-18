import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/settings/settings_provider.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_provider.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_provider.dart';
import 'package:nephro_care/features/trackers/urine/urine_provider.dart';

final summaryProvider = Provider<
    AsyncValue<
        (Map<String, dynamic>, Map<String, dynamic>, Map<String, dynamic>)>>(
  (ref) {
    final fluidData = ref.watch(fluidIntakeDataProvider(
      (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
    ));
    final urineData = ref.watch(urineOutputDataProvider(
      (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
    ));
    final bpData = ref.watch(bpTrackerDataProvider(
      (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
    ));

    if (fluidData.isLoading || urineData.isLoading || bpData.isLoading) {
      return const AsyncValue.loading();
    }

    return fluidData.when(
      data: (fluidCache) => urineData.when(
        data: (urineCache) => bpData.when(
          data: (bpCache) {
            final fluidSummary = ref.read(fluidIntakeSummaryProvider);
            final urineSummary = ref.read(urineOutputSummaryProvider);
            final bpSummary = ref.read(bpTrackerSummaryProvider);
            return AsyncValue.data((fluidSummary, urineSummary, bpSummary));
          },
          loading: () => const AsyncValue.loading(),
          error: (e, st) => AsyncValue.error(e, st),
        ),
        loading: () => const AsyncValue.loading(),
        error: (e, st) => AsyncValue.error(e, st),
      ),
      loading: () => const AsyncValue.loading(),
      error: (e, st) => AsyncValue.error(e, st),
    );
  },
);
