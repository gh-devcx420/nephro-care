import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/core/widgets/nc_foldable_card.dart';
import 'package:nephro_care/features/home/homescreen_widgets/nc_health_metric_animated_display.dart';
import 'package:nephro_care/features/home/homescreen_widgets/nc_health_metric_chip.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_provider.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_utils.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_provider.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_utils.dart';
import 'package:nephro_care/features/trackers/urine/urine_provider.dart';
import 'package:nephro_care/features/trackers/urine/urine_utils.dart';
import 'package:nephro_care/features/trackers/weight/weight_provider.dart';
import 'package:nephro_care/features/trackers/weight/weight_utils.dart';

class HealthMetricsCard extends ConsumerStatefulWidget {
  const HealthMetricsCard({super.key});

  @override
  HealthMetricsCardState createState() => HealthMetricsCardState();
}

class HealthMetricsCardState extends ConsumerState<HealthMetricsCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final fluidSummary = ref.watch(fluidIntakeSummaryProvider);
    final urineSummary = ref.watch(urineOutputSummaryProvider);
    final bpSummary = ref.watch(bpTrackerSummaryProvider);
    final weightSummary = ref.watch(weightSummaryProvider);

    final hasData =
        _hasAnyData(fluidSummary, urineSummary, bpSummary, weightSummary);

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
    final dateLabel = _getDateLabel(selectedDate);

    const initiallyExpanded = false;

    return NCFoldableCard(
      title: '',
      initiallyExpanded: initiallyExpanded,
      onExpansionChanged: (isExpanded) {
        setState(() {
          _isExpanded = isExpanded;
        });
      },
      customHeader: _buildCustomCardHeader(
        theme,
        selectedDate,
        lastUpdated,
        dateLabel,
        hasData,
        fluidMeasurement.formattedValue,
        fluidMeasurement.unitString,
        fluidSummary['lastTime'],
        urineMeasurement.formattedValue,
        urineMeasurement.unitString,
        urineSummary['lastTime'],
        bpMeasurement.displayValue,
        bpMeasurement.unitString,
        bpSummary['lastTime'],
        weightMeasurement.formattedValue,
        weightMeasurement.unitString,
        weightSummary['lastTime'],
        _isExpanded,
      ),
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: NCHealthMetricChip(
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
                child: NCHealthMetricChip(
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
                child: NCHealthMetricChip(
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
                child: NCHealthMetricChip(
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
    );
  }

  DateTime? _getLatestUpdateTime(List<DateTime?> times) {
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
      return '--/--';
    }
    return formattedValue;
  }

  String _getDateLabel(DateTime selectedDate) {
    if (DateTimeUtils.isToday(selectedDate)) {
      return 'Today';
    } else {
      return DateTimeUtils.formatWeekday(selectedDate);
    }
  }

  Widget _buildCustomCardHeader(
    ThemeData theme,
    DateTime selectedDate,
    DateTime? lastUpdated,
    String dateLabel,
    bool hasData,
    String? fluidValue,
    String? fluidUnit,
    DateTime? fluidTime,
    String? urineValue,
    String? urineUnit,
    DateTime? urineTime,
    String? bpValue,
    String? bpUnit,
    DateTime? bpTime,
    String? weightValue,
    String? weightUnit,
    DateTime? weightTime,
    bool isExpanded,
  ) {
    final animatedDisplayBaseTextStyle = theme.textTheme.titleSmall!.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      fontWeight: FontWeight.w800,
      height: 1.0,
    );

    return Row(
      children: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(UIConstants.borderRadius * 0.5),
          ),
          child: Icon(
            Icons.bar_chart,
            size: 24,
            color: theme.colorScheme.primary,
          ),
        ),
        hGap8,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Health Metrics',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (hasData && !isExpanded)
                Row(
                  children: [
                    Text(
                      dateLabel,
                      style: theme.textTheme.titleSmall!.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    hGap4,
                    // Static bullet with fixed width
                    Text(
                      '•',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleSmall!.copyWith(
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    hGap4,

                    NCHealthMetricAnimatedDisplay(
                      fluidValue: _getDisplayValue(fluidValue, fluidUnit),
                      fluidUnit: fluidUnit,
                      fluidTime: fluidTime,
                      urineValue: _getDisplayValue(urineValue, urineUnit),
                      urineUnit: urineUnit,
                      urineTime: urineTime,
                      bpValue: _getDisplayValue(bpValue, bpUnit),
                      bpUnit: bpUnit,
                      bpTime: bpTime,
                      weightValue: _getDisplayValue(weightValue, weightUnit),
                      weightUnit: weightUnit,
                      weightTime: weightTime,
                      textStyle: animatedDisplayBaseTextStyle,
                    ),
                  ],
                )
              else if (hasData && isExpanded)
                Text(
                  dateLabel,
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                )
              else
                Text(
                  '$dateLabel • No Data',
                  style: theme.textTheme.titleSmall!.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  bool _hasAnyData(
      Map<String, dynamic> fluidSummary,
      Map<String, dynamic> urineSummary,
      Map<String, dynamic> bpSummary,
      Map<String, dynamic> weightSummary) {
    final hasFluid = fluidSummary['total'] != null && fluidSummary['total'] > 0;
    final hasUrine = urineSummary['total'] != null && urineSummary['total'] > 0;
    final hasBP = (bpSummary['lastSystolic'] != null &&
            bpSummary['lastSystolic'] > 0) ||
        (bpSummary['lastDiastolic'] != null && bpSummary['lastDiastolic'] > 0);
    final hasWeight = weightSummary['averageWeight'] != null &&
        weightSummary['averageWeight'] > 0;

    return hasFluid || hasUrine || hasBP || hasWeight;
  }
}
