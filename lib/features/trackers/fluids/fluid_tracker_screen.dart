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
import 'package:nephro_care/features/trackers/fluids/fluid_intake_enums.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_intake_model.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_tracker_modal_sheet.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_tracker_provider.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_utils.dart';

class FluidIntakeLogScreen extends ConsumerWidget {
  const FluidIntakeLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    ({String number, String unit}) totalFormatter(
        List<FluidIntakeModel> items) {
      final total = items.fold<double>(0, (sum, item) => sum + item.quantity);
      final formatted = FluidUnit().format(total);
      return (number: formatted.numericValue, unit: formatted.unitValue);
    }

    return LogScreen<FluidIntakeModel>(
      appBarTitle: 'Fluid Log',
      headerTitleString: 'fluids intake',
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
            child: UIUtils.createRichTextValueWithUnit(
              value: totalFormatter(items).number,
              unit: totalFormatter(items).unit,
              valueStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: kValueFontSize,
                    fontWeight: FontWeight.w800,
                  ),
              unitStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: kSIUnitFontSize,
                    fontWeight: FontWeight.w800,
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
      firestoreService: FirestoreService(),
      summaryProvider: fluidIntakeSummaryProvider,
      firestoreCollection: 'fluids',
      inputModalSheet: (item) => FluidIntakeModalSheet(intake: item),
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
              'Quantity: ${item.quantity} ${FluidIntakeField.fluidQuantityMl.unit}',
          child: UIUtils.createRichTextValueWithUnit(
            value: FluidUnit().format(item.quantity).numericValue,
            unit: FluidUnit().format(item.quantity).unitValue,
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
        final lastDrinkTime = summary['lastTime'];
        final totalDrinksToday = summary['totalDrinksToday'] ?? 0;
        final totalFluidQuantityToday = summary['total'] ?? 0;
        final selectedDate = ref.watch(selectedDateProvider);
        final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());

        return totalDrinksToday == 0
            ? Text(
                '${Strings.noEntriesPrefix}${isToday ? 'today' : DateTimeUtils.formatDateDMY(selectedDate)}.',
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  vGap8,
                  UIUtils.createRichTextValueWithUnit(
                    prefixText: '• Number of drinks today: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: '$totalDrinksToday',
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    unit: '',
                    unitStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: kSIUnitFontSize,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  vGap16,
                  UIUtils.createRichTextValueWithUnit(
                    prefixText: '• Total fluids intake: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: FluidUnit().format(totalFluidQuantityToday).numericValue,
                    valueStyle: theme.textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                    unit: FluidUnit().format(totalFluidQuantityToday).unitValue,
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
                          child: UIUtils.createRichTextValueWithUnit(
                            prefixText: '• ${entry.key}: ',
                            prefixStyle: theme.textTheme.bodySmall,
                            value: FluidUnit().format(entry.value).numericValue,
                            valueStyle: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: kValueFontSize,
                              fontWeight: FontWeight.w800,
                            ),
                            unit: FluidUnit().format(entry.value).unitValue,
                            unitStyle: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: kSIUnitFontSize,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                  vGap16,
                  UIUtils.createRichTextTimestamp(
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
