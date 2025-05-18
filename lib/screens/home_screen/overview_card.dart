import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/providers/summary_provider.dart';
import 'package:nephro_care/screens/home_screen/overview_chip.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';

class OverviewCard extends ConsumerWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;
    final summary = ref.watch(summaryProvider);
    final selectedDate = ref.watch(selectedDateProvider);

    return Container(
      width: width * 0.95,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              hGap4,
              Text(
                'Summary',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.90),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null && context.mounted) {
                      ref.read(selectedDateProvider.notifier).state = DateTime(
                        pickedDate.year,
                        pickedDate.month,
                        pickedDate.day,
                      );
                    }
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month_outlined),
                      hGap8,
                      Text(
                        summary.when(
                          data: (data) => data.$1['date'] as String,
                          loading: () => 'Loading',
                          error: (e, _) => 'Error',
                        ),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color:
                                  Theme.of(context).colorScheme.surfaceBright,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              hGap4,
            ],
          ),
          vGap10,
          vGap2,
          summary.when(
            data: (data) {
              final fluidData = data.$1;
              final urineData = data.$2;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OverviewChip(
                    chipLabel: 'Fluid Intake',
                    requireLitreConversion: true,
                    chipIcon: Icons.water_drop_rounded,
                    chipText: '${fluidData['total']} ml',
                    chipTimestamp: fluidData['lastTime'] as String,
                    chipBackgroundColor: ComponentColors.waterBackgroundShade,
                    chipBorderColor: ComponentColors.waterColorShade2,
                    chipIconColor: ComponentColors.waterColorShade1,
                    chipTextColor: ComponentColors.waterColorShade1,
                    onChipTap: () {
                      Navigator.pushNamed(context, '/fluid_log');
                    },
                  ),
                  hGap10,
                  OverviewChip(
                    chipLabel: 'Urine Output',
                    requireLitreConversion: true,
                    chipIcon: Icons.water_drop_rounded,
                    chipText: '${urineData['total']} ml',
                    chipTimestamp: urineData['lastTime'] as String,
                    chipBackgroundColor: ComponentColors.urineBackgroundShade,
                    chipBorderColor: ComponentColors.urineColorShade2,
                    chipIconColor: ComponentColors.urineColorShade1,
                    chipTextColor: ComponentColors.urineColorShade1,
                    onChipTap: () {
                      Navigator.pushNamed(context, '/urine_log');
                    },
                  ),
                ],
              );
            },
            loading: () =>
                const Center(child: CircularProgressIndicator(strokeWidth: 3)),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          vGap10,
          summary.when(
            data: (data) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OverviewChip(
                  chipLabel: 'BP Monitor',
                  chipIcon: Icons.monitor_heart,
                  chipText: '140 / 90',
                  chipTimestamp: '6:50 pm',
                  chipBackgroundColor: ComponentColors.bloodBackgroundColor,
                  chipBorderColor: ComponentColors.bloodColorShade2,
                  chipIconColor: ComponentColors.bloodColorShade1,
                  chipTextColor: ComponentColors.bloodColorShade1,
                  onChipTap: () {},
                ),
                hGap10,
                OverviewChip(
                  chipLabel: 'Weight Tracker',
                  chipIcon: Icons.monitor_weight,
                  chipText: '66.50 Kg',
                  chipTimestamp: '6:50 pm',
                  chipBackgroundColor: ComponentColors.weightBackgroundColor,
                  chipBorderColor: ComponentColors.weightColorShade2,
                  chipIconColor: ComponentColors.weightColorShade1,
                  chipTextColor: ComponentColors.weightColorShade1,
                  onChipTap: () {},
                ),
              ],
            ),
            loading: () => const SizedBox.shrink(),
            error: (e, _) => const SizedBox.shrink(),
          ),
          vGap10,
          Container(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.medication, color: Colors.pink),
                hGap8,
                Text(
                  'Medications last taken on : 9:10 am.',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.pink,
                        fontSize: 20,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
