import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';

class NCHealthMetricChip extends ConsumerStatefulWidget {
  const NCHealthMetricChip({
    super.key,
    required this.chipTitle,
    required this.onChipTap,
    required this.dataValue,
    required this.siUnit,
    this.lastEntryDateTime,
  });

  final String chipTitle;
  final Function() onChipTap;
  final String? dataValue; // Now nullable
  final String siUnit;
  final DateTime? lastEntryDateTime;

  @override
  NCHealthMetricChipState createState() => NCHealthMetricChipState();
}

class NCHealthMetricChipState extends ConsumerState<NCHealthMetricChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final hasData = widget.dataValue != null && widget.dataValue != '--';

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onChipTap();
      },
      onHighlightChanged: (value) {
        setState(() {
          _isPressed = value;
        });
      },
      child: AnimatedScale(
        scale: _isPressed
            ? UIConstants.animationScaleMin
            : UIConstants.animationScaleMax,
        duration: UIConstants.buttonTapDuration,
        child: Container(
          padding: UIConstants.overviewChipPadding,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(UIConstants.borderRadius * 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.chipTitle,
                textAlign: TextAlign.start,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelLarge!.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
              ),
              vGap4,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  UIUtils.createRichTextValueWithUnit(
                    value: hasData ? widget.dataValue! : '--',
                    valueStyle: theme.textTheme.labelMedium!.copyWith(
                      color: colorScheme.primary.withValues(
                        alpha: 1.0,
                      ),
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                    unit: widget.siUnit,
                    unitStyle: theme.textTheme.labelSmall!.copyWith(
                      color: colorScheme.onSurface.withValues(
                        alpha: hasData ? 0.7 : 0.3,
                      ),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
