import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_strings.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/themes/theme_color_schemes.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_provider.dart';
import 'package:nephro_care/features/trackers/generic/generic_log_screen.dart';
import 'package:nephro_care/features/trackers/generic/generic_models.dart';
import 'package:nephro_care/features/trackers/urine/urine_constants.dart';
import 'package:nephro_care/features/trackers/urine/urine_details_bottom_sheet.dart';
import 'package:nephro_care/features/trackers/urine/urine_enums.dart';
import 'package:nephro_care/features/trackers/urine/urine_model.dart';
import 'package:nephro_care/features/trackers/urine/urine_provider.dart';
import 'package:nephro_care/features/trackers/urine/urine_utils.dart';

class UrineOutputLogScreen extends ConsumerWidget {
  const UrineOutputLogScreen({super.key});

  TextStyle _getValueStyle(
    BuildContext context, {
    Color? errorColor,
    required bool shouldUseErrorColors,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return theme.textTheme.titleMedium!.copyWith(
      color: shouldUseErrorColors
          ? errorColor ?? colorScheme.error
          : colorScheme.onSurface,
      fontSize: UIConstants.valueFontSize,
      fontWeight: FontWeight.w800,
    );
  }

  TextStyle _getUnitStyle(
    BuildContext context, {
    Color? errorColor,
    required bool shouldUseErrorColors,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return theme.textTheme.titleMedium!.copyWith(
      color: shouldUseErrorColors
          ? errorColor ?? colorScheme.error
          : colorScheme.onSurface,
      fontSize: UIConstants.siUnitFontSize,
      fontWeight: FontWeight.w600,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Measurement totalFormatter(List<UrineModel> items) {
      final total = items.fold<double>(0, (sum, item) => sum + item.volume);
      return UrineUtils().format(total);
    }

    return LogScreen<UrineModel>(
      appBarTitle: 'Urine Log',
      headerTitleString: 'urine output',
      dataProvider: urineOutputDataProvider,
      firestoreService: FirestoreService(),
      summaryProvider: urineOutputSummaryProvider,
      firestoreCollection: UrineConstants.urineFirebaseCollectionName,
      inputModalSheet: (item) => UrineOutputModalSheet(output: item),
      listItemBuilder: (context, item) => Stack(
        children: [
          ListTile(
            leading: Icon(
              Icons.water_drop,
              size: 20,
              color: colorScheme.onSurface,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
            dense: true,
            title: Semantics(
              label: 'Output type: ${item.outputName}',
              child: Text(
                'Output: ${item.outputName}',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            subtitle: Semantics(
              label:
                  'Quantity: ${item.volume} ${UrineUnits.milliliters.siUnit}',
              child: UIUtils.createRichTextValueWithUnit(
                value: UrineUtils().format(item.volume).formattedValue!,
                unit: UrineUtils().format(item.volume).unitString!,
                valueStyle: _getValueStyle(
                  context,
                  shouldUseErrorColors: false,
                ),
                unitStyle: _getUnitStyle(
                  context,
                  shouldUseErrorColors: false,
                ),
              ),
            ),
            trailing: Semantics(
              label:
                  'Time: ${DateTimeUtils.formatTime(item.timestamp.toDate())}',
              child: UIUtils.createRichTextTimestamp(
                timestamp: item.timestamp.toDate(),
                timeStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: UIConstants.timeFontSize,
                  fontWeight: FontWeight.w800,
                ),
                meridiemStyle: theme.textTheme.titleMedium!.copyWith(
                  color: colorScheme.onSurface,
                  fontSize: UIConstants.meridiemIndicatorFontSize,
                  fontWeight: FontWeight.w800,
                ),
                isMeridiemUpperCase: false,
              ),
            ),
          ),
          if (item.isPendingSync)
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.warningColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
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
                    prefixText: '• Number of urine outputs: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: '$totalUrineTimes',
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
                    prefixText:
                        outputPercent != null ? '• Urine output ratio: ' : '• ',
                    prefixStyle: theme.textTheme.bodySmall,
                    value: outputPercent != null
                        ? '${outputPercent.toInt()}'
                        : 'No data available for output ratio',
                    unit: outputPercent != null ? '%' : '',
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
                    prefixText: '• Last urine output at: ',
                    prefixStyle: theme.textTheme.bodySmall,
                    timestamp: lastUrineTime,
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
