import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';

class NCOverviewChip extends ConsumerStatefulWidget {
  const NCOverviewChip({
    super.key,
    required this.chipTitle,
    required this.onChipTap,
    required this.dataValue,
    required this.siUnit,
    this.lastEntryDateTime,
  });

  final String chipTitle;
  final Function() onChipTap;
  final String dataValue;
  final String siUnit;
  final DateTime? lastEntryDateTime;

  @override
  NCOverviewChipState createState() => NCOverviewChipState();
}

class NCOverviewChipState extends ConsumerState<NCOverviewChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
          padding: UIConstants.chipPadding,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(UIConstants.borderRadius * 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    widget.chipTitle,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium!.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      height: 0,
                    ),
                  ),
                ],
              ),
              vGap8,
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  UIUtils.createRichTextValueWithUnit(
                    value: widget.dataValue,
                    valueStyle: theme.textTheme.labelMedium!.copyWith(
                      color: colorScheme.onPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      height: 0.8,
                    ),
                    unit: widget.siUnit,
                    unitStyle: theme.textTheme.labelSmall!.copyWith(
                      color: colorScheme.onPrimary.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w600,
                      height: 1,
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
