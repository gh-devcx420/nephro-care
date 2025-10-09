import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/app_strings.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/date_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/features/settings/settings_provider.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_constants.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_details_bottom_sheet.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_model.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_provider.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';

class BPTrackerLogScreen extends ConsumerWidget {
  const BPTrackerLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return LogScreen<BPTrackerModel>(
      appBarTitle: 'Blood Pressure Log',
      headerText:
          'Average BP for ${DateTimeUtils.isSameDay(ref.watch(selectedDateProvider), DateTime.now()) ? 'today :' : 'on ${DateTimeUtils.formatDateDM(ref.watch(selectedDateProvider))}'}',
      headerActionButton: (items) {
        if (items.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              'No Data',
              style: theme.textTheme.titleMedium!.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontSize: UIConstants.valueFontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }

        final avgSystolic =
            items.fold<double>(0, (sum, item) => sum + item.systolic) /
                items.length;
        final avgDiastolic =
            items.fold<double>(0, (sum, item) => sum + item.diastolic) /
                items.length;
        final bpReading = '${avgSystolic.round()}/${avgDiastolic.round()}';

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(32),
          ),
          child: UIUtils.createRichTextValueWithUnit(
            value: bpReading,
            unit: BloodPressureField.systolic.siUnit,
            valueStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: UIConstants.valueFontSize,
              fontWeight: FontWeight.w800,
            ),
            unitStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: UIConstants.siUnitFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      },
      listItemIcon: Icons.monitor_heart_sharp,
      dataProvider: bpTrackerDataProvider,
      firestoreService: FirestoreService(),
      summaryProvider: bpTrackerSummaryProvider,
      firestoreCollection: BloodPressureConstants.bpFirebaseCollectionName,
      inputModalSheet: (item) => BPTrackerModalSheet(bpMeasure: item),
      listItemBuilder: (context, item) => ListTile(
        leading: Icon(
          Icons.monitor_heart_sharp,
          size: 20,
          color: colorScheme.onPrimaryContainer,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        dense: true,
        title: Semantics(
          label: 'Blood Pressure: ${item.systolic}/${item.diastolic}',
          child: UIUtils.createRichTextValueWithUnit(
            prefixText: 'BP: ',
            value: '${item.systolic}/${item.diastolic}',
            unit: BloodPressureField.systolic.siUnit,
            valueStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: UIConstants.valueFontSize,
              fontWeight: FontWeight.w800,
            ),
            unitStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: UIConstants.siUnitFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        subtitle: Semantics(
          label:
              '${BloodPressureField.pulse.hintText}: ${item.pulse} ${BloodPressureField.pulse.siUnit}, ${BloodPressureField.spo2.hintText}: ${item.spo2?.toInt() ?? 'N/A'} ${BloodPressureField.spo2.siUnit}',
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.titleMedium!.copyWith(
                color: colorScheme.onPrimaryContainer,
                fontSize: UIConstants.valueFontSize,
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(
                  text: '${BloodPressureField.pulse.hintText}: ${item.pulse}',
                  style: const TextStyle(
                    fontSize: UIConstants.valueFontSize,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ' ${BloodPressureField.pulse.siUnit}',
                  style: const TextStyle(
                    fontSize: UIConstants.siUnitFontSize,
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
                    text:
                        '${BloodPressureField.spo2.hintText}: ${item.spo2!.toInt()}',
                    style: const TextStyle(
                      fontSize: UIConstants.valueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: ' ${BloodPressureField.spo2.siUnit}',
                    style: const TextStyle(
                      fontSize: UIConstants.siUnitFontSize,
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
              color: colorScheme.onPrimaryContainer,
              fontSize: UIConstants.timeFontSize,
              fontWeight: FontWeight.w800,
            ),
            meridiemStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: UIConstants.meridiemIndicatorFontSize,
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
                AppStrings.noEntriesMessage(isToday
                    ? 'today'
                    : DateTimeUtils.formatDateDMY(selectedDate)),
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
                      fontSize: UIConstants.valueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: UIConstants.siUnitFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  vGap16,
                  UIUtils.createRichTextValueWithUnit(
                    prefixText: '• Average BP: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value:
                        '${averageSystolic.toInt()}/${averageDiastolic.toInt()}',
                    unit: BloodPressureField.systolic.siUnit,
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: UIConstants.valueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: UIConstants.siUnitFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  vGap16,
                  UIUtils.createRichTextValueWithUnit(
                    prefixText: '• Average Pulse: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: '$averagePulse',
                    unit: BloodPressureField.systolic.siUnit,
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: UIConstants.valueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: UIConstants.siUnitFontSize,
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
                        : BloodPressureField.spo2.siUnit,
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: UIConstants.valueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: UIConstants.siUnitFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  vGap16,
                  UIUtils.createRichTextTimestamp(
                    prefixText: '• Last measured at: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    timestamp: lastBpTime,
                    timeStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: UIConstants.timeFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    meridiemStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: UIConstants.meridiemIndicatorFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                    isMeridiemUpperCase: false,
                  ),
                  vGap16,
                ],
              );
      },
      itemsExtractor: (cache) => cache.items,
    );
  }
}
