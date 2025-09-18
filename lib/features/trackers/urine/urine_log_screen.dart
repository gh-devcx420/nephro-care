import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/strings.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/date_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/features/settings/settings_provider.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_provider.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';
import 'package:nephro_care/features/trackers/generic/tracker_utils.dart';
import 'package:nephro_care/features/trackers/urine/urine_constants.dart';
import 'package:nephro_care/features/trackers/urine/urine_details_bottom_sheet.dart';
import 'package:nephro_care/features/trackers/urine/urine_enums.dart';
import 'package:nephro_care/features/trackers/urine/urine_model.dart';
import 'package:nephro_care/features/trackers/urine/urine_provider.dart';
import 'package:nephro_care/features/trackers/urine/urine_utils.dart';

class UrineOutputLogScreen extends ConsumerWidget {
  const UrineOutputLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    Measurement totalFormatter(List<UrineModel> items) {
      final total = items.fold<double>(0, (sum, item) => sum + item.quantity);
      return UrineUtils().format(total);
    }

    return LogScreen<UrineModel>(
      appBarTitle: 'Urine Log',
      headerTitleString: 'urine output',
      listItemIcon: Icons.water_drop,
      dataProvider: urineOutputDataProvider,
      firestoreService: FirestoreService(),
      summaryProvider: urineOutputSummaryProvider,
      firestoreCollection: UrineConstants.urineFirebaseCollectionName,
      inputModalSheet: (item) => UrineOutputModalSheet(output: item),
      listItemBuilder: (context, item) => ListTile(
        leading: Icon(
          Icons.water_drop,
          size: 20,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        dense: true,
        title: Semantics(
          label: 'Output type: ${item.outputName}',
          child: Text(
            'Output: ${item.outputName}',
            style: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Semantics(
          label: 'Quantity: ${item.quantity} ${UrineUnits.milliliters.siUnit}',
          child: UIUtils.createRichTextValueWithUnit(
            value: UrineUtils().format(item.quantity).formattedValue!,
            unit: UrineUtils().format(item.quantity).unitString!,
            valueStyle: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: kValueFontSize,
              fontWeight: FontWeight.w800,
            ),
            unitStyle: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
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
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              fontSize: kTimeFontSize,
              fontWeight: FontWeight.w800,
            ),
            meridiemStyle: theme.textTheme.titleMedium!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                '${Strings.noEntriesPrefix}${isToday ? 'today' : DateTimeUtils.formatDateDMY(selectedDate)}',
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  vGap8,
                  UIUtils.createRichTextValueWithUnit(
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
                  UIUtils.createRichTextValueWithUnit(
                    prefixText:
                        outputPercent != null ? '• Urine output ratio: ' : '• ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: outputPercent != null
                        ? '${outputPercent.toInt()}'
                        : 'No data available for output ratio',
                    unit: outputPercent != null ? '%' : '',
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
      itemsExtractor: (cache) => cache.items,
      headerValue: totalFormatter,
    );
  }
}
