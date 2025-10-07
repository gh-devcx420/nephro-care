import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/strings.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/date_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/core/widgets/nc_pulsing_widget.dart';
import 'package:nephro_care/core/widgets/nc_shaking_widget.dart';
import 'package:nephro_care/features/settings/settings_provider.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_constants.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_details_bottom_sheet.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_enums.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_model.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_provider.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_utils.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';

class FluidIntakeLogScreen extends ConsumerWidget {
  const FluidIntakeLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final fluidLimit = ref.watch(fluidLimitProvider);

    return LogScreen<FluidsModel>(
      appBarTitle: 'Fluid Log',
      headerTitleString: 'fluid intake',
      headerActionButton: (items) {
        if (items.isEmpty) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: colorScheme.onError,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Text(
              'No Data',
              style: theme.textTheme.titleMedium!.copyWith(
                color: colorScheme.onError,
                fontSize: kValueFontSize,
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        }

        return Consumer(
          builder: (context, ref, child) {
            final fluidLimit = ref.watch(fluidLimitProvider);
            final total =
                items.fold<double>(0, (sum, item) => sum + item.quantity);
            final isLimitExceeded = total > fluidLimit;

            final textWidget = UIUtils.createRichTextValueWithUnit(
              value: FluidUtils().format(total).formattedValue!,
              unit: FluidUtils().format(total).unitString!,
              valueStyle: theme.textTheme.titleMedium!.copyWith(
                color: isLimitExceeded
                    ? colorScheme.onErrorContainer
                    : colorScheme.onPrimaryContainer,
                fontSize: kValueFontSize,
                fontWeight: FontWeight.w800,
              ),
              unitStyle: theme.textTheme.titleMedium!.copyWith(
                color: isLimitExceeded
                    ? colorScheme.onErrorContainer
                    : colorScheme.onPrimaryContainer,
                fontSize: kSIUnitFontSize,
                fontWeight: FontWeight.w800,
              ),
            );

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isLimitExceeded
                    ? colorScheme.errorContainer
                    : colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(32),
              ),
              child: isLimitExceeded
                  ? ShakingWidget(
                      shakeDuration: const Duration(milliseconds: 500),
                      shakeInterval: const Duration(seconds: 4),
                      shakeOffset: 8.0,
                      child: textWidget,
                    )
                  : textWidget,
            );
          },
        );
      },
      listItemIcon: Icons.local_drink,
      dataProvider: fluidIntakeDataProvider,
      firestoreService: FirestoreService(),
      summaryProvider: fluidIntakeSummaryProvider,
      firestoreCollection: FluidConstants.fluidFirebaseCollectionName,
      inputModalSheet: (item) => FluidIntakeModalSheet(intake: item),
      listItemBuilder: (context, item) => ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        leading: Icon(
          Icons.local_drink,
          size: 20,
          color: colorScheme.onPrimaryContainer,
        ),
        dense: true,
        title: Semantics(
          label: 'Intake type: ${item.fluidName}',
          child: Text(
            'Drank: ${item.fluidName}',
            style: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Semantics(
          label: 'Quantity: ${item.quantity} ${FluidUnits.milliliters.siUnit}',
          child: UIUtils.createRichTextValueWithUnit(
            value: FluidUtils().format(item.quantity).formattedValue!,
            unit: FluidUtils().format(item.quantity).unitString!,
            valueStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: kValueFontSize,
              fontWeight: FontWeight.w800,
            ),
            unitStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
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
              color: colorScheme.onPrimaryContainer,
              fontSize: kTimeFontSize,
              fontWeight: FontWeight.w800,
            ),
            meridiemStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
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
        final isLimitExceeded = totalFluidQuantityToday > fluidLimit;

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
                  isLimitExceeded
                      ? PulsingWidget(
                          errorColor: colorScheme.error,
                          normalColor: colorScheme.primary.withValues(alpha: 0),
                          duration: const Duration(seconds: 1),
                          builder: (color) =>
                              UIUtils.createRichTextValueWithUnit(
                            prefixText: '• Total Fluid Quantity: ',
                            prefixStyle: theme.textTheme.bodySmall,
                            value: FluidUtils()
                                .format(totalFluidQuantityToday)
                                .formattedValue!,
                            unit: FluidUtils()
                                .format(totalFluidQuantityToday)
                                .unitString!,
                            valueStyle: theme.textTheme.titleMedium!.copyWith(
                              color: color,
                              fontSize: kValueFontSize,
                              fontWeight: FontWeight.w800,
                            ),
                            unitStyle: theme.textTheme.titleMedium!.copyWith(
                              color: color,
                              fontSize: kSIUnitFontSize,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        )
                      : UIUtils.createRichTextValueWithUnit(
                          prefixText: '• Total Fluid Quantity: ',
                          prefixStyle: theme.textTheme.bodySmall,
                          value: FluidUtils()
                              .format(totalFluidQuantityToday)
                              .formattedValue!,
                          unit: FluidUtils()
                              .format(totalFluidQuantityToday)
                              .unitString!,
                          valueStyle: theme.textTheme.titleMedium!.copyWith(
                            color: colorScheme.onPrimary,
                            fontSize: kValueFontSize,
                            fontWeight: FontWeight.w800,
                          ),
                          unitStyle: theme.textTheme.titleMedium!.copyWith(
                            color: colorScheme.onPrimary,
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
                            value: FluidUtils()
                                .format(entry.value)
                                .formattedValue!,
                            valueStyle: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: kValueFontSize,
                              fontWeight: FontWeight.w800,
                            ),
                            unit: FluidUtils().format(entry.value).unitString!,
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
                      fontWeight: FontWeight.w800,
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
