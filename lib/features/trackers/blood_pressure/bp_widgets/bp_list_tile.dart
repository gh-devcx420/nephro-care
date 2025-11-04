import 'package:flutter/material.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/themes/theme_color_schemes.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_model.dart';

/// A list tile widget for displaying blood pressure tracker measurements.
///
/// Displays:
/// - Blood pressure reading (systolic/diastolic)
/// - Pulse rate
/// - SpO2 (if available)
/// - Timestamp
/// - Sync status indicator
class BPLogListTile extends StatelessWidget {
  final BPTrackerModel item;

  const BPLogListTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Stack(
      children: [
        ListTile(
          leading: Icon(
            Icons.monitor_heart_sharp,
            size: 20,
            color: colorScheme.onSurface,
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
              valueStyle: UIUtils.valueStyle(context),
              unitStyle: UIUtils.unitStyle(context),
            ),
          ),
          subtitle: _buildSubtitle(context),
          trailing: Semantics(
            label: 'Time: ${DateTimeUtils.formatTime(item.timestamp.toDate())}',
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
                fontWeight: FontWeight.w600,
              ),
              isMeridiemUpperCase: false,
            ),
          ),
        ),
        if (item.isPendingSync)
          const Positioned(
            top: 8,
            right: 8,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.warningColor,
                shape: BoxShape.circle,
              ),
              child: SizedBox(width: 4, height: 4),
            ),
          ),
      ],
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Semantics(
      label:
          '${BloodPressureField.pulse.hintText}: ${item.pulse} ${BloodPressureField.pulse.siUnit}, ${BloodPressureField.spo2.hintText}: ${item.spo2?.toInt() ?? 'N/A'} ${BloodPressureField.spo2.siUnit}',
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.titleMedium!.copyWith(
            color: colorScheme.onSurface,
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
    );
  }
}
