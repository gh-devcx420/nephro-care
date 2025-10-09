import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/app_strings.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/date_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/features/settings/settings_provider.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';
import 'package:nephro_care/features/trackers/generic/tracker_utils.dart';
import 'package:nephro_care/features/trackers/weight/weight_constants.dart';
import 'package:nephro_care/features/trackers/weight/weight_details_bottom_sheet.dart';
import 'package:nephro_care/features/trackers/weight/weight_model.dart';
import 'package:nephro_care/features/trackers/weight/weight_provider.dart';
import 'package:nephro_care/features/trackers/weight/weight_utils.dart';

class WeightTrackerLogScreen extends ConsumerWidget {
  const WeightTrackerLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Measurement totalFormatter(List<WeightModel> items) {
      if (items.isEmpty) return Measurement.invalid();
      final averageWeight =
          items.fold<double>(0, (sum, item) => sum + item.weight);
      return WeightUtils().format(averageWeight);
    }

    return LogScreen<WeightModel>(
      appBarTitle: 'Weight Log',
      headerTitleString: 'weight',
      listItemIcon: Icons.fitness_center,
      dataProvider: weightDataProvider,
      summaryProvider: weightSummaryProvider,
      firestoreService: FirestoreService(),
      firestoreCollection: WeightConstants.weightFirebaseCollectionName,
      inputModalSheet: (item) => WeightModalSheet(weightInput: item),
      listItemBuilder: (context, item) => ListTile(
        leading: Icon(
          Icons.fitness_center,
          size: 20,
          color: colorScheme.onPrimaryContainer,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
        dense: true,
        title: Semantics(
          label: 'Weight',
          child: Text(
            'Weight',
            style: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        subtitle: Semantics(
          label: 'Weight: ',
          child: UIUtils.createRichTextValueWithUnit(
            value: WeightUtils().format(item.weight).formattedValue!,
            unit: WeightUtils().format(item.weight).unitString!,
            valueStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: UIConstants.valueFontSize,
              fontWeight: FontWeight.w800,
            ),
            unitStyle: theme.textTheme.titleMedium!.copyWith(
              color: colorScheme.onPrimaryContainer,
              fontSize: UIConstants.siUnitFontSize,
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
        final lastWeightTime = summary['lastTime'];
        final totalMeasurements = summary['totalMeasurements'] ?? 0;
        final averageWeight = summary['averageWeight'] ?? 0;
        final selectedDate = ref.watch(selectedDateProvider);
        final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());

        return totalMeasurements == 0
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
                    prefixText: '• Average weight: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: WeightUtils().format(averageWeight).formattedValue!,
                    unit: WeightUtils().format(averageWeight).unitString!,
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
                    timestamp: lastWeightTime,
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
      headerValue: totalFormatter,
    );
  }
}
