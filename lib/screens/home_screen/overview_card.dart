import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/providers/firebase_provider.dart';
import 'package:nephro_care/screens/home_screen/overview_chip.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';

class OverviewCard extends ConsumerWidget {
  const OverviewCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    final summary = ref.watch(fluidIntakeSummaryProvider);

    return Container(
      width: width * 0.95,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              hGap4,
              Text(
                'Today\'s Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sunday',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: Colors.white),
                ),
              ),
              hGap4,
            ],
          ),
          vGap16,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OverviewChip(
                chipLabel: 'Fluid Intake',
                requireLitreConversion: true,
                chipIcon: Icons.water_drop_rounded,
                chipText: '${summary['total']} ml',
                chipTimestamp: '${summary['lastTime']}',
                chipBackgroundColor: ComponentColors.waterBackgroundColor,
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
                chipText: '150 ml',
                chipTimestamp: '6:50 pm',
                chipBackgroundColor: ComponentColors.urineBackgroundColor,
                chipBorderColor: ComponentColors.urineColorShade2,
                chipIconColor: ComponentColors.urineColorShade1,
                chipTextColor: ComponentColors.urineColorShade1,
                onChipTap: () {},
              ),
            ],
          ),
          vGap10,
          Row(
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
          vGap10,
          Container(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.medication,
                  color: Colors.pink,
                ),
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
