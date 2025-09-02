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

  @override
  Widget build(BuildContext context) {
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
        scale: _isPressed ? 0.9 : 1.0,
        duration: kButtonTapDuration,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            //minHeight: widget.buttonHeight ?? 90,
            minWidth: widget.buttonWidth ?? 90,
          ),
          child: Container(
            width: widget.buttonWidth,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: widget.buttonColor ??
                  Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                width: 1.5,
                color: widget.buttonBorderColor ??
                    Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  if (widget.buttonIcon != null)
                    Icon(
                      widget.buttonIcon,
                      size: widget.iconSize ?? 28.0,
                      color: widget.iconColor ??
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    )
                  else if (widget.iconifyIcon != null)
                    Iconify(
                      widget.iconifyIcon!.icon,
                      size: widget.iconSize ?? 28.0,
                      color: widget.iconColor ??
                          Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  vGap8,
                  Text(
                    widget.buttonText,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
