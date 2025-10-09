import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';

class NCTrackerButton extends StatefulWidget {
  const NCTrackerButton({
    super.key,
    this.buttonColor,
    this.buttonBorderColor,
    this.buttonIcon,
    this.iconifyIcon,
    this.iconSize,
    this.iconColor,
    this.buttonWidth,
    this.buttonHeight,
    required this.buttonText,
    required this.buttonTap,
  });

  final Color? buttonColor;
  final Color? buttonBorderColor;
  final IconData? buttonIcon;
  final Iconify? iconifyIcon;
  final double? iconSize;
  final Color? iconColor;
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final Function() buttonTap;

  @override
  State<NCTrackerButton> createState() => _NCTrackerButtonState();
}

class _NCTrackerButtonState extends State<NCTrackerButton> {
  bool _isPressed = false;

  Widget? _buildIcon(BuildContext context) {
    if (widget.buttonIcon != null) {
      return Icon(
        widget.buttonIcon,
        size: widget.iconSize ?? 28.0,
        color: widget.iconColor ?? Theme.of(context).colorScheme.onPrimary,
      );
    } else if (widget.iconifyIcon != null) {
      return Iconify(
        widget.iconifyIcon!.icon,
        size: widget.iconSize ?? 28.0,
        color: widget.iconColor ?? Theme.of(context).colorScheme.onPrimary,
      );
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final defaultButtonSize = screenWidth * 0.25;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        HapticFeedback.lightImpact();
        widget.buttonTap.call();
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
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: widget.buttonHeight ?? defaultButtonSize,
            minWidth: widget.buttonWidth ?? defaultButtonSize,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.buttonColor ?? colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // Centers vertically
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_buildIcon(context) != null) ...[
                  _buildIcon(context)!,
                  vGap8,
                ],
                Text(
                  widget.buttonText,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
