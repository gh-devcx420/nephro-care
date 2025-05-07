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

    // Get the fluid intake summary from the provider
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
              Text(
                'Today\'s Overview',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Spacer(),
              Text(
                'Sunday',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          vGap16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OverviewChip(
                chipLabel: 'Fluid Intake',
                chipIcon: Icons.water_drop_rounded,
                chipText: '${summary['total']} ml',
                chipTimestamp: '${summary['lastTime']}',
                chipBackgroundColor: ChipColors.waterBackgroundColor,
                chipBorderColor: ChipColors.waterBorderColor,
                chipIconColor: ChipColors.waterIconColor,
                chipTextColor: ChipColors.waterIconColor,
                onChipTap: () {
                  Navigator.pushNamed(context, '/fluid_log');
                },
              ),
              hGap16,
              OverviewChip(
                chipLabel: 'Urine Output',
                chipIcon: Icons.water_drop_rounded,
                chipText: '150 ml',
                chipTimestamp: '6:50 pm',
                chipBackgroundColor: ChipColors.urineBackgroundColor,
                chipBorderColor: ChipColors.urineBorderColor,
                chipIconColor: ChipColors.urineIconColor,
                chipTextColor: ChipColors.urineIconColor,
                onChipTap: () {},
              ),
            ],
          ),
          vGap16,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OverviewChip(
                chipLabel: 'BP',
                chipIcon: Icons.monitor_heart,
                chipText: '140 / 90',
                chipTimestamp: '6:50 pm',
                chipBackgroundColor: ChipColors.bloodBackgroundColor,
                chipBorderColor: ChipColors.bloodBorderColor,
                chipIconColor: ChipColors.bloodIconColor,
                chipTextColor: ChipColors.bloodIconColor,
                onChipTap: () {},
              ),
              hGap16,
              OverviewChip(
                chipLabel: 'Weight',
                chipIcon: Icons.monitor_weight,
                chipText: '66.50 Kg',
                chipTimestamp: '6:50 pm',
                chipBackgroundColor: ChipColors.weightBackgroundColor,
                chipBorderColor: ChipColors.weightBorderColor,
                chipIconColor: ChipColors.weightIconColor,
                chipTextColor: ChipColors.weightIconColor,
                onChipTap: () {},
              ),
            ],
          ),
          vGap16,
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
          vGap30,
          Row(
            children: [
              Text(
                'Notes :',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
