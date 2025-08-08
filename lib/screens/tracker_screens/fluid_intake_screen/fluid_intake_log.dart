import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/constants.dart';
import 'package:nephro_care/constants/enums.dart';
import 'package:nephro_care/constants/strings_constants.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/tracker_models.dart';
import 'package:nephro_care/providers/fluid_intake_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/screens/tracker_screens/fluid_intake_screen/fluid_intake_modal_sheet.dart';
import 'package:nephro_care/screens/tracker_screens/generic_log_screen.dart';
import 'package:nephro_care/utils/date_time_utils.dart';
import 'package:nephro_care/utils/measurement_utils.dart';

class FluidIntakeLogScreen extends ConsumerWidget {
  const FluidIntakeLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ({String number, String unit}) totalFormatter(List<FluidIntake> items) {
      final total = items.fold<double>(0, (sum, item) => sum + item.quantity);
      final formatted =
          MeasurementUtils.formatValueForRichText(total, MeasurementType.fluid);
      return (number: formatted.number, unit: formatted.unit);
    }

    return LogScreen<FluidIntake>(
      appBarTitle: 'Fluid Log',
      headerTitleString: 'fluid intake',
      headerActionButton: (items) => Consumer(
        builder: (context, ref, child) {
          final fluidLimit = ref.watch(fluidLimitProvider);
          final total =
              items.fold<double>(0, (sum, item) => sum + item.quantity);
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: total > fluidLimit
                  ? Theme.of(context).colorScheme.error
                  : Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(32),
            ),
            child: MeasurementUtils.createRichTextValueWithUnit(
              value: totalFormatter(items).number,
              unit: totalFormatter(items).unit,
              valueStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: kValueFontSize,
                    fontWeight: FontWeight.w800,
                  ),
              unitStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.w400,
                    fontSize: kSIUnitFontSize,
                  ),
            ),
          );
        },
      ),
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      listItemIcon: Icons.local_drink,
      dataProvider: fluidIntakeDataProvider,
      summaryProvider: fluidIntakeSummaryProvider,
      firestoreCollection: 'fluid_intake',
      inputWidgetBuilder: (item) => FluidIntakeModalSheet(intake: item),
      listItemBuilder: (context, item) => ListTile(
        leading: Icon(
          Icons.local_drink,
          size: 20,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        dense: true,
        title: Semantics(
          label: 'Intake type: ${item.fluidName}',
          child: Text(
            'Drank: ${item.fluidName}',
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
              fontWeight: FontWeight.w600,
            ),
            isMeridiemUpperCase: false,
          ),
        ),
      ),
      logDetailsDialogBuilder: (context, summary) {
        final lastDrinkTime = summary['lastTime'];
        final totalDrinksToday = summary['totalDrinksToday'] ?? 0;
        final totalFluidQuantityToday = summary['total'] ?? 0;
        final selectedDate = ref.watch(selectedDateProvider);
        final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());

        return totalDrinksToday == 0
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
                    prefixText: '• Number of drinks today: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: '$totalDrinksToday',
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kValueFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                    unit: '',
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kSIUnitFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  vGap16,
                  MeasurementUtils.createRichTextValueWithUnit(
                    prefixText: '• Total fluid intake: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: MeasurementUtils.formatValueForRichText(
                            totalFluidQuantityToday, MeasurementType.fluid)
                        .number,
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    unit: MeasurementUtils.formatValueForRichText(
                            totalFluidQuantityToday, MeasurementType.fluid)
                        .unit,
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kSIUnitFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  ...(summary['typeTotals'] as Map<String, dynamic>? ?? {})
                      .entries
                      .map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: MeasurementUtils.createRichTextValueWithUnit(
                            prefixText: '• ${entry.key}: ',
                            prefixStyle: theme.textTheme.bodySmall,
                            value: MeasurementUtils.formatValueForRichText(
                                    entry.value, MeasurementType.fluid)
                                .number,
                            valueStyle: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: kValueFontSize,
                              fontWeight: FontWeight.w800,
                            ),
                            unit: MeasurementUtils.formatValueForRichText(
                              entry.value,
                              MeasurementType.fluid,
                            ).unit,
                            unitStyle: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: kSIUnitFontSize,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  vGap16,
                  MeasurementUtils.createRichTextTimestamp(
                    prefixText: '• Last drink at: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    timestamp: lastDrinkTime,
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
