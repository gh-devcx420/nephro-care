import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/utils/ui_helper.dart';

class ValueRangeChooser extends ConsumerWidget {
  const ValueRangeChooser({
    super.key,
    required this.provider,
    this.step = 50,
    this.minValue = 50,
    this.color,
  });

  final StateProvider<int> provider;
  final int step;
  final int minValue;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);

    void updateValue(int newValue) {
      if (newValue >= minValue) {
        ref.read(provider.notifier).state = newValue;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color ?? Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
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
            '$value ml',
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
