import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/constants.dart';
import 'package:nephro_care/constants/enums.dart';
import 'package:nephro_care/constants/strings_constants.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/urine_output_model.dart';
import 'package:nephro_care/providers/fluid_input_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/providers/urine_output_provider.dart';
import 'package:nephro_care/screens/tracker_screens/generic_log_screen.dart';
import 'package:nephro_care/screens/tracker_screens/urine_output_screen/urine_output_modal_sheet.dart';
import 'package:nephro_care/utils/date_time_utils.dart';
import 'package:nephro_care/utils/measurement_utils.dart';

class UrineOutputLogScreen extends ConsumerWidget {
  const UrineOutputLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    ({String number, String unit}) totalFormatter(List<UrineOutput> items) {
      final total = items.fold<double>(0, (sum, item) => sum + item.quantity);
      final formatted =
          MeasurementUtils.formatValueForRichText(total, MeasurementType.fluid);
      return (number: formatted.number, unit: formatted.unit);
    }

    return LogScreen<UrineOutput>(
      appBarTitle: 'Urine Log',
      headerTitleString: 'urine output',
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      listItemIcon: Icons.water_drop,
      dataProvider: urineOutputDataProvider,
      summaryProvider: urineOutputSummaryProvider,
      firestoreCollection: 'urine_output',
      inputWidgetBuilder: (item) => UrineOutputModalSheet(output: item),
      listItemBuilder: (context, item) => ListTile(
        leading: Icon(
          Icons.water_drop,
          size: 20,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        dense: true,
        title: Semantics(
          label: 'Output type: ${item.outputName}',
          child: Text(
            'Output: ${item.outputName}',
            style: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Semantics(
          label:
              'Quantity: ${item.quantity} ${siUnitEnumMap[SIUnitEnum.fluidsSIUnitML]}',
          child: MeasurementUtils.createRichTextValueWithUnit(
            value: MeasurementUtils.formatValueForRichText(
              item.quantity,
              MeasurementType.fluid,
            ).number,
            unit: MeasurementUtils.formatValueForRichText(
              item.quantity,
              MeasurementType.fluid,
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
              fontWeight: FontWeight.w800,
            ),
            isMeridiemUpperCase: false,
          ),
        ),
      ),
      logDetailsDialogBuilder: (context, summary) {
        final lastUrineTime = summary['lastTime'];
        final totalUrineTimes = summary['totalUrineToday'] ?? 0;
        final fluidSummary = ref.read(fluidIntakeSummaryProvider);
        final selectedDate = ref.watch(selectedDateProvider);
        final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());
        double? outputPercent;
        if (fluidSummary['total'] != 0) {
          outputPercent = (summary['total'] / fluidSummary['total']) * 100;
        }
        return totalUrineTimes == 0
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
                    prefixText: '• Number of urine outputs: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: '$totalUrineTimes',
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
                    prefixText:
                        outputPercent != null ? '• Urine output ratio: ' : '• ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: outputPercent != null
                        ? '${outputPercent.toInt()}'
                        : 'No data available for output ratio',
                    unit: outputPercent != null
                        ? siUnitEnumMap[SIUnitEnum.percentSIUnit]!
                        : '',
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
                    prefixText: '• Last urine output at: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    timestamp: lastUrineTime,
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
      itemsExtractor: (cache) => cache.urineOutputs,
      totalFormatter: totalFormatter,
    );
  }
}
