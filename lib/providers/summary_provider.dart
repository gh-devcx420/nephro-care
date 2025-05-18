import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/providers/fluid_input_provider.dart';
import 'package:nephro_care/providers/urine_output_provider.dart';

final summaryProvider =
    Provider<AsyncValue<(Map<String, dynamic>, Map<String, dynamic>)>>((ref) {
  final fluidSummary = ref.watch(fluidIntakeSummaryProvider);
  final urineSummary = ref.watch(urineOutputSummaryProvider);

  if (fluidSummary.isLoading || urineSummary.isLoading) {
    return const AsyncValue.loading();
  }
  if (fluidSummary.hasError) {
    return AsyncValue.error(fluidSummary.error!, fluidSummary.stackTrace!);
  }
  if (urineSummary.hasError) {
    return AsyncValue.error(urineSummary.error!, urineSummary.stackTrace!);
  }
  return AsyncValue.data((fluidSummary.value!, urineSummary.value!));
});
