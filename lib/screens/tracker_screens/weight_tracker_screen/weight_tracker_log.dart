import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/constants.dart';
import 'package:nephro_care/constants/enums.dart';
import 'package:nephro_care/constants/strings_constants.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/tracker_models.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/providers/weight_provider.dart';
import 'package:nephro_care/screens/tracker_screens/generic_log_screen.dart';
import 'package:nephro_care/screens/tracker_screens/weight_tracker_screen/weight_tracker_modal_sheet.dart';
import 'package:nephro_care/utils/date_time_utils.dart';
import 'package:nephro_care/utils/measurement_utils.dart';

class WeightTrackerLogScreen extends ConsumerWidget {
  const WeightTrackerLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ({String number, String unit}) totalFormatter(List<Weight> items) {
      if (items.isEmpty) return (number: 'N/A', unit: '');
      final avgWeight =
          items.fold<double>(0, (sum, item) => sum + item.weight) /
              items.length;
      final formatted = MeasurementUtils.formatValueForRichText(
          avgWeight, MeasurementType.weight);
      return (number: formatted.number, unit: formatted.unit);
    }

    return LogScreen<Weight>(
      appBarTitle: 'Weight Log',
      headerTitleString: 'weight',
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      listItemIcon: Icons.fitness_center,
      dataProvider: weightDataProvider,
      summaryProvider: weightSummaryProvider,
      firestoreCollection: 'weight',
      inputWidgetBuilder: (item) => WeightModalSheet(weight: item),
      listItemBuilder: (context, item) => ListTile(
        leading: Icon(
          Icons.fitness_center,
          size: 20,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        dense: true,
        title: Semantics(
          label: 'Weight',
          child: Text(
            'Weight',
            style: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Semantics(
          label: 'Weight: ',
          child: MeasurementUtils.createRichTextValueWithUnit(
            value: MeasurementUtils.formatValueForRichText(
              item.weight,
              MeasurementType.weight,
            ).number,
            unit: MeasurementUtils.formatValueForRichText(
              item.weight,
              MeasurementType.weight,
            ).unit,
            valueStyle: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: kValueFontSize,
              fontWeight: FontWeight.w800,
            ),
            unitStyle: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: kSIUnitFontSize,
              fontWeight: FontWeight.w600,
            ),
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
        final lastWeightTime = summary['lastTime'];
        final totalMeasurements = summary['totalMeasurements'] ?? 0;
        final averageWeight = summary['averageWeight'] ?? 0;
        final selectedDate = ref.watch(selectedDateProvider);
        final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());

        return totalMeasurements == 0
            ? Text(
                '${Strings.noEntriesPrefix}${isToday ? 'today.' : DateTimeUtils.formatDateDMY(selectedDate)}.',
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
                    prefixText: '• Average weight: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: MeasurementUtils.formatValueForRichText(
                            averageWeight, MeasurementType.weight)
                        .number,
                    unit: MeasurementUtils.formatValueForRichText(
                            averageWeight, MeasurementType.weight)
                        .unit,
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
                    timestamp: lastWeightTime,
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
