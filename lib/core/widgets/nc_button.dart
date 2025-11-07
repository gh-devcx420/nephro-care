import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/widgets/nc_icon.dart';

class NCButton extends StatefulWidget {
  const NCButton({
    super.key,
    required this.onButtonTap,
    this.buttonBackgroundColor,
    this.buttonPadding,
    this.borderRadius,
    this.buttonIcon,
    this.ncButtonIcon,
    this.iconSize,
    this.iconColor,
    this.iconGap,
    this.buttonText,
    this.buttonTextStyle,
    this.buttonChild,
  });

  const NCButton.icon({
    super.key,
    required this.onButtonTap,
    this.buttonBackgroundColor,
    this.buttonPadding,
    this.borderRadius,
    this.buttonIcon,
    this.ncButtonIcon,
    this.iconSize,
    this.iconColor,
    this.iconGap,
    this.buttonText,
    this.buttonTextStyle,
    this.buttonChild,
  }) : assert(buttonIcon != null || ncButtonIcon != null,
            'Either buttonIcon or ncButtonIcon must be provided');

  final VoidCallback onButtonTap;
  final Color? buttonBackgroundColor;
  final EdgeInsets? buttonPadding;
  final double? borderRadius;
  final IconData? buttonIcon;
  final NCIcon? ncButtonIcon;
  final double? iconSize;
  final Color? iconColor;
  final SizedBox? iconGap;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final Widget? buttonChild;

  @override
  State<NCButton> createState() => _NCButtonState();
}

class _NCButtonState extends State<NCButton> {
  static const double _minButtonHeight = UIConstants.minButtonHeight;
  static const double _minButtonWidth = UIConstants.minButtonWidth;
  static const double _defaultPaddingValue = 4.0;
  static const double _defaultRadiusValue = (_minButtonHeight * 2);

  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed
          ? UIConstants.animationScaleMin
          : UIConstants.animationScaleMax,
      duration: UIConstants.buttonTapDuration,
      curve: Curves.easeInOut,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          HapticFeedback.lightImpact();
          widget.onButtonTap();
        },
        onHighlightChanged: (isHighlighted) {
          setState(() {
            _isPressed = isHighlighted;
          });
        },
        child: Container(
          constraints: const BoxConstraints(
            minHeight: _minButtonHeight,
            minWidth: _minButtonWidth,
          ),
          padding: widget.buttonPadding ??
              const EdgeInsets.all(_defaultPaddingValue),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
                widget.borderRadius ?? _defaultRadiusValue),
            color: widget.buttonBackgroundColor ??
                Theme.of(context).colorScheme.primary,
          ),
          child: widget.buttonChild != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: widget.buttonChild!,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_buildIcon(context) != null) ...[
                      _buildIcon(context)!,
                    ],
                    if (widget.buttonText != null) ...[
                      widget.iconGap ?? hGap6,
                      Text(
                        widget.buttonText!,
                        style: widget.buttonTextStyle ??
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      hGap6,
                    ],
                  ],
                ),
        ),
      ),
    );
  }

  Widget? _buildIcon(BuildContext context) {
    if (widget.buttonIcon != null) {
      return Icon(
        widget.buttonIcon,
        size: widget.iconSize ?? UIConstants.overviewChipIconSize,
        color: widget.iconColor ?? Theme.of(context).colorScheme.onPrimary,
      );
    } else if (widget.ncButtonIcon != null) {
      return NCIcon(
        widget.ncButtonIcon!.icon,
        size: widget.iconSize ?? UIConstants.overviewChipIconSize,
        color: widget.iconColor ?? Theme.of(context).colorScheme.onPrimary,
      );
    } else {
      Icon(
        Icons.help_outline,
        size: widget.iconSize ?? UIConstants.overviewChipIconSize,
        color: widget.iconColor ?? Theme.of(context).colorScheme.onPrimary,
      );
    }
    return null;
  }
}
