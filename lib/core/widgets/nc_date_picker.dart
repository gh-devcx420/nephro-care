import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';

class NCDatePicker extends ConsumerStatefulWidget {
  final DateTime? firstDate;
  final DateTime? lastDate;
  final StateProvider<DateTime> dateProvider;
  final String Function(DateTime) dateFormatter;
  final VoidCallback? onDateSelected;
  final Color? backgroundColor;
  final IconData? prefixIcon;
  final Iconify? prefixIconifyIcon;
  final double? prefixIconSize;
  final Color? prefixIconColor;
  final TextStyle? dateTextStyle;
  final IconData? suffixIcon;
  final Iconify? suffixIconifyIcon;
  final double? suffixIconSize;
  final Color? suffixIconBackgroundColor;
  final Color? suffixIconForegroundColor;

  const NCDatePicker({
    super.key,
    this.firstDate,
    this.lastDate,
    required this.dateProvider,
    required this.dateFormatter,
    this.onDateSelected,
    this.backgroundColor,
    this.prefixIcon,
    this.prefixIconifyIcon,
    this.prefixIconSize,
    this.prefixIconColor,
    this.dateTextStyle,
    this.suffixIcon,
    this.suffixIconifyIcon,
    this.suffixIconSize,
    this.suffixIconBackgroundColor,
    this.suffixIconForegroundColor,
  });

  @override
  ConsumerState<NCDatePicker> createState() => _NCDatePickerState();
}

class _NCDatePickerState extends ConsumerState<NCDatePicker> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(widget.dateProvider);
    final isNotToday = selectedDate.year != DateTime.now().year ||
        selectedDate.month != DateTime.now().month ||
        selectedDate.day != DateTime.now().day;
    final effectiveFirstDate = widget.firstDate ?? DateTime(1990);
    final effectiveLastDate = widget.lastDate ?? DateTime.now();

    return Semantics(
      label: 'Select date',
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () async {
          HapticFeedback.lightImpact();
          final pickedDate = await showDatePicker(
            context: context,
            initialDate: selectedDate,
            firstDate: effectiveFirstDate,
            lastDate: effectiveLastDate,
          );
          HapticFeedback.lightImpact();
          if (pickedDate != null && context.mounted) {
            ref.read(widget.dateProvider.notifier).state = DateTime(
              pickedDate.year,
              pickedDate.month,
              pickedDate.day,
            );
            widget.onDateSelected?.call();
          }
        },
        onHighlightChanged: (isHighlighted) {
          setState(() {
            _isPressed = isHighlighted;
          });
        },
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: kButtonTapDuration,
          curve: Curves.easeInOut,
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor ??
                  Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(24),
              // boxShadow: [
              //   BoxShadow(
              //     color: Colors.black.withOpacity(0.1), // Subtle shadow color
              //     spreadRadius: 0, // Minimal spread
              //     blurRadius: 4, // Soft blur
              //     offset: const Offset(0, 2), // Slight vertical offset
              //   ),
              // ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 8.0,
                  ),
                  child: widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon ?? Icons.calendar_month_outlined,
                          size: widget.prefixIconSize ?? 16.0,
                          color: widget.prefixIconColor ??
                              Theme.of(context).colorScheme.onPrimary,
                        )
                      : Iconify(
                          widget.prefixIconifyIcon!.icon,
                          size: widget.prefixIconSize ?? 16.0,
                          color: widget.prefixIconColor ??
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                ),
                Padding(
                  padding:
                      EdgeInsets.fromLTRB(0, 8.0, isNotToday ? 0 : 10.0, 8.0),
                  child: Text(
                    widget.dateFormatter(selectedDate),
                    style: widget.dateTextStyle ??
                        Theme.of(context).textTheme.labelMedium!.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                ),
                if (isNotToday) ...[
                  hGap8,
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      ref.read(widget.dateProvider.notifier).state = DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                      );
                      widget.onDateSelected?.call();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: widget.suffixIconBackgroundColor ??
                              Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: widget.suffixIcon != null
                              ? Icon(
                                  widget.suffixIcon ?? Icons.restart_alt,
                                  size: widget.suffixIconSize ?? 16.0,
                                  color: widget.suffixIconForegroundColor ??
                                      Theme.of(context).colorScheme.onPrimary,
                                )
                              : Iconify(
                                  widget.suffixIconifyIcon!.icon,
                                  size: widget.suffixIconSize ?? 16.0,
                                  color: widget.suffixIconForegroundColor ??
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
