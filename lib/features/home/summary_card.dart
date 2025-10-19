import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/core/widgets/nc_overview_chip.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_provider.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_utils.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_provider.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_utils.dart';
import 'package:nephro_care/features/trackers/urine/urine_provider.dart';
import 'package:nephro_care/features/trackers/urine/urine_utils.dart';
import 'package:nephro_care/features/trackers/weight/weight_provider.dart';
import 'package:nephro_care/features/trackers/weight/weight_utils.dart';

class SummaryCard extends ConsumerWidget {
  const SummaryCard({super.key});

  DateTime? _getLatestUpdateTime(
    List<DateTime?> times,
  ) {
    final validTimes = times.whereType<DateTime>().toList();
    if (validTimes.isEmpty) {
      return null;
    }

    validTimes.sort((a, b) => b.compareTo(a));
    return validTimes.first;
  }

  String _getDisplayValue(String? formattedValue, String? unitString) {
    if (formattedValue == null ||
        formattedValue.isEmpty ||
        formattedValue == '--' ||
        unitString == null ||
        unitString.isEmpty) {
      return '--';
    }
    return formattedValue;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fluidSummary = ref.watch(fluidIntakeSummaryProvider);
    final urineSummary = ref.watch(urineOutputSummaryProvider);
    final bpSummary = ref.watch(bpTrackerSummaryProvider);
    final weightSummary = ref.watch(weightSummaryProvider);

    final lastUpdated = _getLatestUpdateTime(
      [
        fluidSummary['lastTime'],
        urineSummary['lastTime'],
        bpSummary['lastTime'],
        weightSummary['lastTime'],
      ],
    );

    // Format data using utility classes
    final fluidMeasurement = FluidUtils().format(fluidSummary['total'] ?? 0);
    final urineMeasurement = UrineUtils().format(urineSummary['total'] ?? 0);
    final weightMeasurement =
        WeightUtils().format(weightSummary['averageWeight'] ?? 0);

    // Format BP reading
    final bpUtils = BloodPressureUtils();
    final systolic = bpUtils.formatSystolic(bpSummary['lastSystolic'] ?? 0);
    final diastolic = bpUtils.formatDiastolic(bpSummary['lastDiastolic'] ?? 0);
    final bpMeasurement =
        bpUtils.formatBPReading(systolic: systolic, diastolic: diastolic);

    final theme = Theme.of(context);

    return Container(
      padding: UIConstants.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius:
                      BorderRadius.circular(UIConstants.borderRadius * 0.5),
                ),
                child: Icon(
                  Icons.health_and_safety,
                  size: 24,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
              hGap6,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Health Metrics',
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (lastUpdated != null)
                    UIUtils.createRichTextTimestamp(
                      prefixText: 'Today • ',
                      prefixStyle: theme.textTheme.titleSmall!.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w800,
                        height: 0.9,
                      ),
                      timestamp: lastUpdated,
                      timeStyle: theme.textTheme.titleSmall!.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w800,
                        height: 0.9,
                      ),
                      meridiemStyle: theme.textTheme.titleSmall!.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w800,
                        height: 0.9,
                      ),
                      isMeridiemUpperCase: false,
                    ),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: Icon(
                  Icons.more_vert_rounded,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          vGap12,
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: NCOverviewChip(
                      onChipTap: () {
                        Navigator.pushNamed(context, '/fluid_log');
                      },
                      chipTitle: 'Fluid Intake',
                      dataValue: _getDisplayValue(
                        fluidMeasurement.formattedValue,
                        fluidMeasurement.unitString,
                      ),
                      siUnit: fluidMeasurement.unitString ?? 'ml',
                      lastEntryDateTime: fluidSummary['lastTime'],
                    ),
                  ),
                  hGap12,
                  Expanded(
                    child: NCOverviewChip(
                      onChipTap: () {
                        Navigator.pushNamed(context, '/urine_log');
                      },
                      chipTitle: 'Urine Output',
                      dataValue: _getDisplayValue(
                        urineMeasurement.formattedValue,
                        urineMeasurement.unitString,
                      ),
                      siUnit: urineMeasurement.unitString ?? 'ml',
                      lastEntryDateTime: urineSummary['lastTime'],
                    ),
                  ),
                ],
              ),
              vGap12,
              Row(
                children: [
                  Expanded(
                    child: NCOverviewChip(
                      onChipTap: () {
                        Navigator.pushNamed(context, '/bp_tracker_log');
                      },
                      chipTitle: 'Blood Pressure',
                      dataValue: _getDisplayValue(
                        bpMeasurement.displayValue,
                        bpMeasurement.unitString,
                      ),
                      siUnit: bpMeasurement.unitString ?? 'mmHg',
                      lastEntryDateTime: bpSummary['lastTime'],
                    ),
                  ),
                  hGap12,
                  Expanded(
                    child: NCOverviewChip(
                      onChipTap: () {
                        Navigator.pushNamed(context, '/weight_tracker_log');
                      },
                      chipTitle: 'Weight',
                      dataValue: _getDisplayValue(
                        weightMeasurement.formattedValue,
                        weightMeasurement.unitString,
                      ),
                      siUnit: weightMeasurement.unitString ?? 'Kg',
                      lastEntryDateTime: weightSummary['lastTime'],
                    ),
                  ),
                ],
              )
            ],
          ),
          vGap2,
        ],
      ),
    );
  }
}
