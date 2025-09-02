import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/strings.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/date_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/features/settings/settings_provider.dart';
import 'package:nephro_care/features/shared/generic_log_screen.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_monitor_model.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_tracker_modal_sheet.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_tracker_provider.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_utils.dart';

class BPTrackerLogScreen extends ConsumerWidget {
  const BPTrackerLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ({String number, String unit}) totalFormatter(List<BPTrackerModel> items) {
      if (items.isEmpty) return (number: 'N/A', unit: '');
      final avgSystolic =
          items.fold<double>(0, (sum, item) => sum + item.systolic) /
              items.length;
      final avgDiastolic =
          items.fold<double>(0, (sum, item) => sum + item.diastolic) /
              items.length;
      return (
        number: '${avgSystolic.toInt()}/${avgDiastolic.toInt()}',
        unit: BloodPressureField.systolic.unit!
      );
    }

    return LogScreen<BPTrackerModel>(
      appBarTitle: 'Blood Pressure Log',
      headerText:
          'Average BP for ${DateTimeUtils.isSameDay(ref.watch(selectedDateProvider), DateTime.now()) ? 'today :' : 'on ${DateTimeUtils.formatDateDM(ref.watch(selectedDateProvider))}'}',
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      listItemIcon: Icons.monitor_heart_sharp,
      dataProvider: bpTrackerDataProvider,
      firestoreService: FirestoreService(),
      summaryProvider: bpTrackerSummaryProvider,
      firestoreCollection: 'blood_pressure',
      inputModalSheet: (item) => BPTrackerModalSheet(bpMeasure: item),
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
          child: UIUtils.createRichTextValueWithUnit(
            prefixText: 'BP: ',
            value: '${item.systolic}/${item.diastolic}',
            unit: BloodPressureField.systolic.unit!,
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
              'Pulse: ${item.pulse} ${BloodPressureField.pulse.unit}, SpO2: ${item.spo2?.toInt() ?? 'N/A'} ${BloodPressureField.spo2.unit}',
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
                  text: ' ${BloodPressureField.pulse.unit}',
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
                    text: ' ${BloodPressureField.spo2.unit}',
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
          child: UIUtils.createRichTextTimestamp(
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
                '${Strings.noEntriesPrefix}${isToday ? 'today' : DateTimeUtils.formatDateDMY(selectedDate)}.',
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  vGap8,
                  UIUtils.createRichTextValueWithUnit(
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
                  UIUtils.createRichTextValueWithUnit(
                    prefixText: '• Average BP: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value:
                        '${averageSystolic.toInt()}/${averageDiastolic.toInt()}',
                    unit: BloodPressureField.systolic.unit!,
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
                  UIUtils.createRichTextValueWithUnit(
                    prefixText: '• Average Pulse: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: BloodPressureField.systolic
                        .format(averagePulse)
                        .numericValue,
                    unit: BloodPressureUnit(averagePulse)
                        .format(averagePulse)
                        .unitValue,
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
                  UIUtils.createRichTextValueWithUnit(
                    prefixText: '• Average SpO2: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: averageSpo2 == 'N/A' ? 'N/A' : averageSpo2,
                    unit: averageSpo2 == 'N/A'
                        ? ''
                        : BloodPressureField.spo2.unit!,
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
                  UIUtils.createRichTextTimestamp(
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
      itemsExtractor: (cache) => cache.items,
      totalFormatter: totalFormatter,
    );
  }
}
