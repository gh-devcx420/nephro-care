import 'package:flutter/material.dart';
import 'package:nephro_care/constants/enums.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/utils/measurement_utils.dart';

class ValueRangeChooser extends StatelessWidget {
  const ValueRangeChooser({
    super.key,
    required this.value,
    required this.onValueChanged,
    this.step = 50,
    this.minValue = 50,
    this.color,
    this.type = MeasurementType.fluid,
  });

  final int value;
  final ValueChanged<int> onValueChanged;
  final int step;
  final int minValue;
  final Color? color;
  final MeasurementType type;

  @override
  Widget build(BuildContext context) {
    void updateValue(int newValue) {
      if (newValue >= minValue) {
        onValueChanged(newValue);
      }
    }


    final formattedValue = MeasurementUtils.formatValueForRichText(value, type);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
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
          MeasurementUtils.createRichTextValueWithUnit(
            value: formattedValue.number,
            unit: formattedValue.unit,
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
