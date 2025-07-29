import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/constants.dart';
import 'package:nephro_care/constants/enums.dart';
import 'package:nephro_care/constants/strings_constants.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/bp_monitor_model.dart';
import 'package:nephro_care/providers/bp_monitor_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/screens/tracker_screens/bp_monitor_screen/bp_monitor_modal_sheet.dart';
import 'package:nephro_care/screens/tracker_screens/generic_log_screen.dart';
import 'package:nephro_care/utils/date_time_utils.dart';
import 'package:nephro_care/utils/measurement_utils.dart';

class BPMonitorLogScreen extends ConsumerWidget {
  const BPMonitorLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    ({String number, String unit}) totalFormatter(List<BPMonitor> items) {
      if (items.isEmpty) return (number: 'N/A', unit: '');
      final avgSystolic =
          items.fold<double>(0, (sum, item) => sum + item.systolic) /
              items.length;
      final avgDiastolic =
          items.fold<double>(0, (sum, item) => sum + item.diastolic) /
              items.length;
      return (
        number: '${avgSystolic.toInt()}/${avgDiastolic.toInt()}',
        unit: siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]!
      );
    }

    return LogScreen<BPMonitor>(
      appBarTitle: 'Blood Pressure Log',
      headerText:
          'Average BP for ${DateTimeUtils.isSameDay(ref.watch(selectedDateProvider), DateTime.now()) ? 'today :' : 'on ${DateTimeUtils.formatDateDM(ref.watch(selectedDateProvider))}'}',
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      listItemIcon: Icons.monitor_heart_sharp,
      dataProvider: bpMonitorDataProvider,
      summaryProvider: bpMonitorSummaryProvider,
      firestoreCollection: 'bp_monitor',
      inputWidgetBuilder: (item) => BPMonitorModalSheet(bpMeasure: item),
      listItemBuilder: (context, item) => ListTile(
        leading: Icon(
          Icons.monitor_heart_sharp,
          size: 20,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        dense: true,
        title: Semantics(
          label: 'Blood Pressure: ${item.systolic}/${item.diastolic}',
          child: MeasurementUtils.createRichTextValueWithUnit(
            prefixText: 'BP: ',
            value: '${item.systolic}/${item.diastolic}',
            unit: siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]!,
            valueStyle: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: kValueFontSize,
              fontWeight: FontWeight.w800,
            ),
            unitStyle: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: kSIUnitFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        subtitle: Semantics(
          label:
              'Pulse: ${item.pulse} ${siUnitEnumMap[SIUnitEnum.pulseSIUnit]}, SpO2: ${item.spo2?.toInt() ?? 'N/A'} ${siUnitEnumMap[SIUnitEnum.percentSIUnit]}',
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: kValueFontSize,
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(
                  text: 'Pulse: ${item.pulse}',
                  style: const TextStyle(
                    fontSize: kValueFontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ' ${siUnitEnumMap[SIUnitEnum.pulseSIUnit]}',
                  style: const TextStyle(
                    fontSize: kSIUnitFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (item.spo2 != null) ...[
                  const TextSpan(
                    text: '  •  ',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: 'SpO2: ${item.spo2!.toInt()}',
                    style: const TextStyle(
                      fontSize: kValueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: ' ${siUnitEnumMap[SIUnitEnum.percentSIUnit]}',
                    style: const TextStyle(
                      fontSize: kSIUnitFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Semantics(
          label: 'Time: ${DateTimeUtils.formatTime(item.timestamp.toDate())}',
          child: MeasurementUtils.createRichTextTimestamp(
            timestamp: item.timestamp.toDate(),
            timeStyle: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: kTimeFontSize,
              fontWeight: FontWeight.w800,
            ),
            meridiemStyle: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: kMeridiemIndicatorFontSize,
              fontWeight: FontWeight.w600,
            ),
            isMeridiemUpperCase: false,
          ),
        ),
      ),
      logDetailsDialogBuilder: (context, summary) {
        final lastBpTime = summary['lastTime'];
        final totalMeasurements = summary['totalMeasurements'] ?? 0;
        final averageSystolic = summary['averageSystolic'] ?? 0;
        final averageDiastolic = summary['averageDiastolic'] ?? 0;
        final averagePulse = summary['averagePulse'] ?? 0;
        final averageSpo2 = summary['averageSpo2'] != null
            ? '${summary['averageSpo2'].toInt()}'
            : 'N/A';
        final selectedDate = ref.watch(selectedDateProvider);
        final isToday = DateTimeUtils.isSameDay(
          selectedDate,
          DateTime.now(),
        );

        return lastBpTime == null
            ? Text(
                '${Strings.noEntriesPrefix}${isToday ? 'today.' : DateTimeUtils.formatDateDMY(selectedDate)}',
                style: Theme.of(context).textTheme.bodySmall,
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  vGap8,
                  MeasurementUtils.createRichTextValueWithUnit(
                    prefixText: '• Number of measurements: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: '$totalMeasurements',
                    unit: '',
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kValueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kSIUnitFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  vGap16,
                  MeasurementUtils.createRichTextValueWithUnit(
                    prefixText: '• Average BP: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value:
                        '${averageSystolic.toInt()}/${averageDiastolic.toInt()}',
                    unit: siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]!,
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kValueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kSIUnitFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  vGap16,
                  MeasurementUtils.createRichTextValueWithUnit(
                    prefixText: '• Average Pulse: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: MeasurementUtils.formatValueForRichText(
                      averagePulse,
                      MeasurementType.pulse,
                    ).number,
                    unit: siUnitEnumMap[SIUnitEnum.pulseSIUnit]!,
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kValueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kSIUnitFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  vGap16,
                  MeasurementUtils.createRichTextValueWithUnit(
                    prefixText: '• Average SpO2: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: averageSpo2 == 'N/A' ? 'N/A' : averageSpo2,
                    unit: averageSpo2 == 'N/A'
                        ? ''
                        : siUnitEnumMap[SIUnitEnum.percentSIUnit]!,
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kValueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kSIUnitFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  vGap16,
                  MeasurementUtils.createRichTextTimestamp(
                    prefixText: '• Last measured at: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    timestamp: lastBpTime,
                    timeStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kTimeFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    meridiemStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kMeridiemIndicatorFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    isMeridiemUpperCase: false,
                  ),
                  vGap16,
                ],
              );
      },
      itemsExtractor: (cache) => cache.bpMonitors,
      totalFormatter: totalFormatter,
    );
  }
}
