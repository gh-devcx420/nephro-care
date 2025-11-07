import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_icons.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/constants/nc_app_strings.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_constants.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_details_bottom_sheet.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_model.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_provider.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_widgets/bp_list_tile.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';

class BPTrackerLogScreen extends ConsumerWidget {
  const BPTrackerLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LogScreen<BPTrackerModel>(
      appBarTitle: 'Blood Pressure Log',
      headerText:
          'Average BP for ${DateTimeUtils.isSameDay(ref.watch(selectedDateProvider), DateTime.now()) ? 'today :' : 'on ${DateTimeUtils.formatDateDM(ref.watch(selectedDateProvider))}'}',
      headerActionButton: (items) => _buildHeaderAction(context, items),
      logItemIcon: NCIcons.heartBeat,
      dataProvider: bpTrackerDataProvider,
      firestoreService: FirestoreService(),
      summaryProvider: bpTrackerSummaryProvider,
      firestoreCollection: BloodPressureConstants.bpFirebaseCollectionName,
      inputModalSheet: (item) => BPTrackerModalSheet(bpMeasure: item),
      listItemBuilder: (context, item) => BPLogListTile(item: item),
      logDetailsDialogBuilder: (context, summary) =>
          _buildSummaryDialog(context, ref, summary),
      itemsExtractor: (cache) => cache.items,
    );
  }

  Widget _buildHeaderAction(BuildContext context, List<BPTrackerModel> items) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(32),
      ),
      child: UIUtils.createRichTextValueWithUnit(
        value: bpReading,
        unit: BloodPressureField.systolic.siUnit,
        valueStyle: UIUtils.valueStyle(context),
        unitStyle: UIUtils.unitStyle(context),
      ),
    );
  }

  Widget _buildSummaryDialog(
      BuildContext context, WidgetRef ref, Map<String, dynamic> summary) {
    final theme = Theme.of(context);
    final lastBpTime = summary['lastTime'];
    final totalMeasurements = summary['totalMeasurements'] ?? 0;
    final averageSystolic = summary['averageSystolic'] ?? 0;
    final averageDiastolic = summary['averageDiastolic'] ?? 0;
    final averagePulse = summary['averagePulse'] ?? 0;
    final averageSpo2 = summary['averageSpo2'] != null
        ? '${summary['averageSpo2'].toInt()}'
        : 'N/A';
    final selectedDate = ref.watch(selectedDateProvider);
    final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());

    if (lastBpTime == null) {
      return Text(
        AppStrings.noEntriesMessage(
            isToday ? 'today' : DateTimeUtils.formatDateDMY(selectedDate)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        vGap8,
        _summaryRow(
            context, 'Number of measurements: ', '$totalMeasurements', ''),
        vGap16,
        _summaryRow(
            context,
            'Average BP: ',
            '${averageSystolic.toInt()}/${averageDiastolic.toInt()}',
            BloodPressureField.systolic.siUnit),
        vGap16,
        _summaryRow(context, 'Average Pulse: ', '$averagePulse',
            BloodPressureField.pulse.siUnit),
        vGap16,
        _summaryRow(context, 'Average SpO2: ', averageSpo2,
            averageSpo2 == 'N/A' ? '' : BloodPressureField.spo2.siUnit),
        vGap16,
        UIUtils.createRichTextTimestamp(
          prefixText: '• Last measured at: ',
          prefixStyle: theme.textTheme.bodySmall,
          timestamp: lastBpTime,
          timeStyle: theme.textTheme.bodyMedium!.copyWith(
              fontSize: UIConstants.timeFontSize, fontWeight: FontWeight.w800),
          meridiemStyle: theme.textTheme.bodyMedium!.copyWith(
              fontSize: UIConstants.meridiemIndicatorFontSize,
              fontWeight: FontWeight.w600),
          isMeridiemUpperCase: false,
        ),
        vGap16,
      ],
    );
  }

  Widget _summaryRow(
      BuildContext context, String label, String value, String unit) {
    final theme = Theme.of(context);
    return UIUtils.createRichTextValueWithUnit(
      prefixText: '• $label',
      prefixStyle: theme.textTheme.bodySmall,
      value: value,
      unit: unit,
      valueStyle: theme.textTheme.bodyMedium!.copyWith(
          fontSize: UIConstants.valueFontSize, fontWeight: FontWeight.w800),
      unitStyle: theme.textTheme.bodyMedium!.copyWith(
          fontSize: UIConstants.siUnitFontSize, fontWeight: FontWeight.w600),
    );
  }
}
