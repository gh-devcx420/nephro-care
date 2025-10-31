import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_icon.dart';

class NcInfoChip extends StatefulWidget {
  const NcInfoChip({
    super.key,
    required this.chipText,
    this.chipValue,
    this.chipSuffix,
    this.chipIcon,
    this.ncChipIcon,
    this.iconSize,
    this.iconColor,
    this.chipColor,
    this.onTap,
  });

  final IconData? chipIcon;
  final String? ncChipIcon;
  final double? iconSize;
  final Color? iconColor;
  final Color? chipColor;
  final String chipText;
  final num? chipValue;
  final String? chipSuffix;
  final Function? onTap;

  @override
  State<NcInfoChip> createState() => _NcInfoChipState();
}

class _NcInfoChipState extends State<NcInfoChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    // Build display text in one line
    final displayText = [
      widget.chipText,
      if (widget.chipValue != null)
        ': ${widget.chipValue}'
      else if (widget.chipSuffix != null)
        ': ${widget.chipSuffix}',
    ].join();

    Widget? buildIcon(BuildContext context) {
      if (widget.chipIcon != null) {
        return Icon(
          widget.chipIcon,
          size: widget.iconSize ?? UIConstants.infoChipIconSize,
          color: widget.iconColor ?? Theme.of(context).colorScheme.primary,
        );
      } else if (widget.ncChipIcon != null) {
        return NCIcon(
          widget.ncChipIcon!,
          size: widget.iconSize ?? UIConstants.infoChipIconSize,
          color: widget.iconColor ?? Theme.of(context).colorScheme.primary,
        );
      } else {
        Icon(
          Icons.help_outline,
          size: widget.iconSize ?? UIConstants.infoChipIconSize,
          color: widget.iconColor ?? Theme.of(context).colorScheme.primary,
        );
      }
      return null;
    }

    return AnimatedScale(
      scale: _isPressed
          ? UIConstants.animationScaleMin
          : UIConstants.animationScaleMax,
      duration: UIConstants.chipTapDuration,
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        onHighlightChanged: (isHighlighted) {
          setState(() {
            _isPressed = isHighlighted;
          });
        },
        child: Container(
          padding: UIConstants.infoChipPadding,
          decoration: BoxDecoration(
            color: widget.chipColor ?? colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (buildIcon(context) != null) buildIcon(context)!,
              hGap6,
              Text(
                displayText,
                style: textTheme.titleSmall?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
