import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/widgets/nc_icon.dart';

class NcInfoChip extends StatefulWidget {
  final IconData? chipIcon;
  final String? ncChipIcon;
  final double? iconSize;
  final Color? iconColor;
  final Color? chipColor;
  final String chipText;
  final num? chipValue;
  final String? chipSuffix;
  final VoidCallback? onTap;

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

  @override
  State<NcInfoChip> createState() => _NcInfoChipState();
}

class _NcInfoChipState extends State<NcInfoChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final displayText = _buildDisplayText();

    return AnimatedScale(
      scale: _isPressed
          ? UIConstants.animationScaleMin
          : UIConstants.animationScaleMax,
      duration: UIConstants.chipTapDuration,
      child: InkWell(
        onTap: () => _handleTap(),
        onHighlightChanged: (isHighlighted) {
          setState(() => _isPressed = isHighlighted);
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
              _buildIcon(context),
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

  Widget _buildIcon(BuildContext context) {
    final defaultSize = widget.iconSize ?? UIConstants.infoChipIconSize;
    final defaultColor =
        widget.iconColor ?? Theme.of(context).colorScheme.primary;

    if (widget.chipIcon != null) {
      return Icon(
        widget.chipIcon,
        size: defaultSize,
        color: defaultColor,
      );
    } else if (widget.ncChipIcon != null) {
      return NCIcon(
        widget.ncChipIcon!,
        size: defaultSize,
        color: defaultColor,
      );
    } else {
      return Icon(
        Icons.help_outline,
        size: defaultSize,
        color: defaultColor,
      );
    }
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    widget.onTap?.call();
  }

  String _buildDisplayText() {
    return [
      widget.chipText,
      if (widget.chipValue != null)
        ': ${widget.chipValue}'
      else if (widget.chipSuffix != null)
        ': ${widget.chipSuffix}',
    ].join();
  }
}
