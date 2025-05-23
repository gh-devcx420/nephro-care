import 'package:flutter/material.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';

class ValueRangeChooser extends StatelessWidget {
  const ValueRangeChooser({
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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(kBorderRadius),
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
          Text(
            Utils.formatFluidValue(value),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: color ?? Theme.of(context).colorScheme.primary,
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
