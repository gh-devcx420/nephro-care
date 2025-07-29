import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/constants.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/widgets/nc_tracker_button.dart';

class TrackersMenuCard extends ConsumerWidget {
  const TrackersMenuCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(kBorderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              hGap8,
              Text(
                'Trackers',
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          vGap8,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 1,
              children: [
                NcTrackerButton(
                  buttonTap: () {
                    Navigator.pushNamed(context, '/fluid_log');
                  },
                  buttonColor: Theme.of(context).colorScheme.surfaceContainer,
                  icon: Icon(
                    Icons.water_drop_rounded,
                    size: kTrackerIconSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: 'Fluids',
                ),
                NcTrackerButton(
                  buttonTap: () {
                    Navigator.pushNamed(context, '/urine_log');
                  },
                  buttonColor: Theme.of(context).colorScheme.surfaceContainer,
                  icon: Icon(
                    Icons.water_drop_rounded,
                    size: kTrackerIconSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: 'Urine',
                ),
                NcTrackerButton(
                  buttonTap: () {
                    Navigator.pushNamed(context, '/bp_monitor_log');
                  },
                  buttonColor: Theme.of(context).colorScheme.surfaceContainer,
                  icon: Icon(
                    Icons.monitor_heart,
                    size: kTrackerIconSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: 'BP',
                ),
                NcTrackerButton(
                  buttonTap: () {},
                  buttonColor: Theme.of(context).colorScheme.surfaceContainer,
                  icon: Icon(
                    Icons.monitor_weight,
                    size: kTrackerIconSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: 'Weight',
                ),
                NcTrackerButton(
                  buttonTap: () {},
                  buttonColor: Theme.of(context).colorScheme.surfaceContainer,
                  icon: Icon(
                    Icons.health_and_safety,
                    size: kTrackerIconSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: 'Dialysis',
                ),
                NcTrackerButton(
                  buttonTap: () {},
                  buttonColor: Theme.of(context).colorScheme.surfaceContainer,
                  icon: Icon(
                    Icons.medication,
                    size: kTrackerIconSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: 'Medicine',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
