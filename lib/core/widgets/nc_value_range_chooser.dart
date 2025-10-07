import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_utils.dart';

class NCValueRange extends StatelessWidget {
  const NCValueRange({
    super.key,
    required this.value,
    required this.onValueChanged,
    this.step = 50,
    this.minValue = 50,
    this.color,
  });

  final double value;
  final ValueChanged<double> onValueChanged;
  final int step;
  final int minValue;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    void updateValue(double newValue) {
      if (newValue >= minValue) {
        onValueChanged(newValue);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              updateValue(value - step);
            },
            child: Icon(
              Icons.remove_circle,
              color: color ?? Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          hGap4,
          Container(
            constraints: const BoxConstraints(maxHeight: 30, maxWidth: 60),
            child: Center(
              child: UIUtils.createRichTextValueWithUnit(
                value: FluidUtils().format(value).formattedValue!,
                unit: FluidUtils().format(value).unitString!,
                valueStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: color ?? Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                unitStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: color ?? Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
              ),
            ),
          ),
          hGap4,
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              updateValue(value + step);
            },
            child: Icon(
              Icons.add_circle,
              color: color ?? Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }
}
