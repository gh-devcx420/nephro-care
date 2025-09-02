import 'package:flutter/material.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_intake_enums.dart';

class NCValueRange extends StatelessWidget {
  const NCValueRange({
    super.key,
    required this.value,
    required this.onValueChanged,
    this.step = 50,
    this.minValue = 50,
    this.color,
  });

  final int value;
  final ValueChanged<int> onValueChanged;
  final int step;
  final int minValue;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    void updateValue(int newValue) {
      if (newValue >= minValue) {
        onValueChanged(newValue);
      }
    }

    final formattedValue = FluidIntakeField.fluidQuantityMl.format(value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => updateValue(value - step),
            borderRadius: BorderRadius.circular(6),
            child: Icon(
              Icons.remove_circle,
              color: color ?? Theme.of(context).colorScheme.primary,
              size: 30,
            ),
          ),
          hGap8,
          UIUtils.createRichTextValueWithUnit(
            value: formattedValue.numericValue,
            unit: formattedValue.unitValue,
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
          hGap8,
          InkWell(
            onTap: () => updateValue(value + step),
            borderRadius: BorderRadius.circular(12),
            child: Icon(
              Icons.add_circle,
              color: color ?? Theme.of(context).colorScheme.primary,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }
}
