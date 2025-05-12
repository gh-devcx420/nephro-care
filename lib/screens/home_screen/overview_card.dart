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
    double width = MediaQuery.of(context).size.width;

    final summary = ref.watch(fluidIntakeSummaryProvider);

    return Container(
      width: width * 0.95,
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                hGap4,
                Text(
                  'Your Summary',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.90),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: InkWell(
                    onTap: () {
                      // TODO: Implement alert dialogue with today's date and fluid cycle time
                    },
                    child: Text(
                      summary.when(
                        data: (data) => data['day'] as String,
                        loading: () => 'Loading...',
                        error: (e, _) => 'Today',
                      ),
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.surfaceBright,
                          ),
                    ),
                  ),
                ),
                hGap4,
              ],
            ),
          ),
          vGap10,
          vGap2,
          summary.when(
            data: (intake) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OverviewChip(
                  chipLabel: 'Fluid Intake',
                  requireLitreConversion: true,
                  chipIcon: Icons.water_drop_rounded,
                  chipText: '${intake['total']} ml',
                  chipTimestamp: intake['lastTime'] as String,
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
                  // TODO: Replace with dynamic data
                  chipTimestamp: '6:50 pm',
                  // TODO: Replace with dynamic data
                  chipBackgroundColor: ComponentColors.urineBackgroundColor,
                  chipBorderColor: ComponentColors.urineColorShade2,
                  chipIconColor: ComponentColors.urineColorShade1,
                  chipTextColor: ComponentColors.urineColorShade1,
                  onChipTap: () {},
                ),
              ],
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
              ),
            ),
            error: (e, _) => Center(
              child: Text('Error: $e'),
            ),
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
                  // TODO: Replace with dynamic data
                  chipTimestamp: '6:50 pm',
                  // TODO: Replace with dynamic data
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
                  // TODO: Replace with dynamic data
                  chipTimestamp: '6:50 pm',
                  // TODO: Replace with dynamic data
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
                const Icon(
                  Icons.medication,
                  color: Colors.pink,
                ),
                hGap8,
                Text(
                  'Medications last taken on : 9:10 am.',
                  // TODO: Replace with dynamic data
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
