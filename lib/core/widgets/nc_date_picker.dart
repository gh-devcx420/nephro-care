import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/core/widgets/nc_icon.dart';

class NCDatePicker extends ConsumerStatefulWidget {
  final DateTime? firstDate;
  final DateTime? lastDate;
  final StateProvider<DateTime> dateProvider;
  final String Function(DateTime) dateFormatter;
  final VoidCallback? onDateSelected;
  final ColorScheme? customColorScheme;
  final IconData? prefixIcon;
  final NCIcon? prefixNCIcon;
  final double? prefixIconSize;
  final TextStyle? dateTextStyle;
  final IconData? suffixIcon;
  final NCIcon? suffixNCIcon;
  final double? suffixIconSize;

  const NCDatePicker({
    super.key,
    this.firstDate,
    this.lastDate,
    required this.dateProvider,
    required this.dateFormatter,
    this.onDateSelected,
    this.customColorScheme,
    this.prefixIcon,
    this.prefixNCIcon,
    this.prefixIconSize,
    this.dateTextStyle,
    this.suffixIcon,
    this.suffixNCIcon,
    this.suffixIconSize,
  });

  @override
  ConsumerState<NCDatePicker> createState() => _NCDatePickerState();
}

class _NCDatePickerState extends ConsumerState<NCDatePicker> {
  static const double _minButtonHeight = UIConstants.minButtonHeight;
  static const double _minButtonWidth = UIConstants.minButtonWidth;
  static const double _defaultPaddingValue = 4.0;
  static const double _defaultRadiusValue = _minButtonHeight / 2;

  static const double _innerContainerMinHeight =
      _minButtonHeight - (_defaultPaddingValue * 2);
  static const double _innerContainerMinWidth =
      _minButtonWidth - (_defaultPaddingValue * 2);

  static const double _prefixIconSize = 16.0;
  static const double _prefixBorderRadius = _minButtonHeight / 2;

  static const double _suffixIconSize = 16.0;
  static const double _suffixBorderRadius = _minButtonHeight / 2;

  bool _isPressed = false;

  final today =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  void _showDateSelectedSnackbar(DateTime date) {
    if (!context.mounted) return;

    final isToday = date.year == DateTime.now().year &&
        date.month == DateTime.now().month &&
        date.day == DateTime.now().day;

    final message = isToday
        ? 'Showing Entries for Today'
        : 'Showing Entries for ${DateTimeUtils.formatDateDM(date)}';

    UIUtils.showNCSnackBar(
      context: context,
      message: message,
      backgroundColor: widget.customColorScheme?.primary,
      durationSeconds: 2,
    );
  }

  void _updateSelectedDate(DateTime newDate) {
    final updatedDate = DateTime(newDate.year, newDate.month, newDate.day);
    ref.read(widget.dateProvider.notifier).state = updatedDate;
    _showDateSelectedSnackbar(updatedDate);
    widget.onDateSelected?.call();
  }

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(widget.dateProvider);
    final isToday = selectedDate.year == DateTime.now().year &&
        selectedDate.month == DateTime.now().month &&
        selectedDate.day == DateTime.now().day;
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
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  datePickerTheme: DatePickerThemeData(
                    headerBackgroundColor: widget.customColorScheme?.primary ??
                        Theme.of(context).colorScheme.primary,
                    headerForegroundColor:
                        Theme.of(context).colorScheme.onPrimary,
                    dayBackgroundColor:
                        WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return widget.customColorScheme?.primary ??
                            Theme.of(context).colorScheme.primary;
                      }
                      return null;
                    }),
                    dayForegroundColor:
                        WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Theme.of(context).colorScheme.onPrimary;
                      }
                      if (states.contains(WidgetState.disabled)) {
                        return Theme.of(context).colorScheme.outline;
                      }
                      return Theme.of(context).colorScheme.onSurface;
                    }),
                    todayBackgroundColor: WidgetStateProperty.all(
                      widget.customColorScheme?.primary ??
                          Theme.of(context).colorScheme.primary,
                    ),
                    todayForegroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.onPrimary,
                    ),
                    confirmButtonStyle: TextButton.styleFrom(
                      foregroundColor: widget.customColorScheme?.onPrimary ??
                          Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: widget.customColorScheme?.primary ??
                          Theme.of(context).colorScheme.primary,
                    ),
                    cancelButtonStyle: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );

          HapticFeedback.lightImpact();

          if (pickedDate != null) {
            _updateSelectedDate(pickedDate);
          }
        },
        onHighlightChanged: (isHighlighted) {
          setState(() {
            _isPressed = isHighlighted;
          });
        },
        child: AnimatedScale(
          scale: _isPressed
              ? UIConstants.animationScaleMin
              : UIConstants.animationScaleMax,
          duration: UIConstants.buttonTapDuration,
          curve: Curves.easeInOut,
          child: Container(
            constraints: const BoxConstraints(
              minHeight: _minButtonHeight,
              minWidth: _minButtonHeight,
            ),
            padding: const EdgeInsets.all(_defaultPaddingValue),
            decoration: BoxDecoration(
              color: widget.customColorScheme?.primary ??
                  Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(_defaultRadiusValue),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isToday) ...[
                  Container(
                    constraints: const BoxConstraints(
                      minHeight: _innerContainerMinHeight,
                      minWidth: _innerContainerMinWidth,
                    ),
                    decoration: BoxDecoration(
                      color: widget.customColorScheme?.surface ??
                          Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(_prefixBorderRadius),
                    ),
                    padding: const EdgeInsets.all(_defaultPaddingValue),
                    child: widget.prefixIcon != null
                        ? Icon(
                            widget.prefixIcon ?? Icons.calendar_month_outlined,
                            size: widget.prefixIconSize ?? _prefixIconSize,
                            color: widget.customColorScheme?.primary ??
                                Theme.of(context).colorScheme.primary)
                        : NCIcon(
                            widget.prefixNCIcon!.icon,
                            size: widget.prefixIconSize ?? _prefixIconSize,
                            color: widget.customColorScheme?.primary ??
                                Theme.of(context).colorScheme.primary,
                          ),
                  ),
                  hGap6,
                ],
                Container(
                  padding: EdgeInsets.fromLTRB(
                      isToday ? 0.0 : 8.0, 0, !isToday ? 0 : 8.0, 0),
                  child: Text(
                    widget.dateFormatter(selectedDate),
                    style: widget.dateTextStyle ??
                        Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: widget.customColorScheme?.onPrimary ??
                                  Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w800,
                              height: 1.0,
                            ),
                  ),
                ),
                if (!isToday) ...[
                  hGap6,
                  InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () {
                      HapticFeedback.lightImpact();
                      _updateSelectedDate(DateTime.now());
                    },
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: _innerContainerMinHeight,
                        minWidth: _innerContainerMinWidth,
                      ),
                      decoration: BoxDecoration(
                        color: widget.customColorScheme?.surface ??
                            Theme.of(context).colorScheme.surface,
                        borderRadius:
                            BorderRadius.circular(_suffixBorderRadius),
                      ),
                      padding: const EdgeInsets.all(_defaultPaddingValue),
                      child: widget.suffixIcon != null
                          ? Icon(
                              widget.suffixIcon ?? Icons.restart_alt,
                              size: widget.suffixIconSize ?? _suffixIconSize,
                              color: widget.customColorScheme?.primary ??
                                  Theme.of(context).colorScheme.primary,
                            )
                          : NCIcon(
                              widget.suffixNCIcon!.icon,
                              size: widget.suffixIconSize ?? _suffixIconSize,
                              color: widget.customColorScheme?.primary ??
                                  Theme.of(context).colorScheme.primary,
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
