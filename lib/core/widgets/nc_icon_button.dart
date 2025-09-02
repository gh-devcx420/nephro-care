import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';

class NCIconButton extends StatefulWidget {
  const NCIconButton({
    super.key,
    required this.onButtonTap,
    this.buttonBackgroundColor,
    this.buttonPadding,
    this.buttonIcon,
    this.iconifyIcon,
    this.iconSize,
    this.iconColor,
    this.buttonSpacing,
    this.buttonText,
    this.buttonTextStyle,
    this.buttonChild,
  });

  const NCIconButton.icon({
    super.key,
    required this.onButtonTap,
    this.buttonBackgroundColor,
    this.buttonPadding,
    this.buttonIcon,
    this.iconifyIcon,
    this.iconSize,
    this.iconColor,
    this.buttonSpacing,
    this.buttonText,
    this.buttonTextStyle,
    this.buttonChild,
  }) : assert(buttonIcon != null || iconifyIcon != null,
            'Either buttonIcon or iconifyIcon must be provided');

  final VoidCallback onButtonTap;
  final Color? buttonBackgroundColor;
  final EdgeInsets? buttonPadding;
  final IconData? buttonIcon;
  final Iconify? iconifyIcon;
  final double? iconSize;
  final Color? iconColor;
  final SizedBox? buttonSpacing;
  final String? buttonText;
  final TextStyle? buttonTextStyle;
  final Widget? buttonChild;

  @override
  State<NCIconButton> createState() => _NCIconButtonState();
}

class _NCIconButtonState extends State<NCIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final iconSize = widget.iconSize ?? kButtonIconSize;

    return AnimatedScale(
      scale: _isPressed ? 0.9 : 1.0,
      duration: kButtonTapDuration,
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
          padding: widget.buttonPadding ?? const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(48.0),
            color: widget.buttonBackgroundColor ??
                Theme.of(context).colorScheme.primary,
          ),
          child: widget.buttonChild != null
              ? SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: Center(child: widget.buttonChild!),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.buttonIcon != null)
                      Icon(
                        widget.buttonIcon,
                        size: iconSize,
                        color: widget.iconColor ??
                            Theme.of(context).colorScheme.onPrimary,
                      )
                    else if (widget.iconifyIcon != null)
                      Iconify(
                        widget.iconifyIcon!.icon,
                        size: iconSize,
                        color: widget.iconColor ??
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      )
                    else
                      Icon(
                        Icons.help_outline,
                        size: iconSize,
                        color: widget.iconColor ??
                            Theme.of(context).colorScheme.onPrimaryContainer,
                      ),
                    if (widget.buttonText != null) ...[
                      widget.buttonSpacing ?? hGap6,
                      Text(
                        widget.buttonText!,
                        style: widget.buttonTextStyle ??
                            Theme.of(context).textTheme.titleSmall!.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                    ],
                  ],
                ),
        ),
      ),
    );
  }
}
