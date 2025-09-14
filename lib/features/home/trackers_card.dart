import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/ic.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_tracker_button.dart';

class TrackersMenuCard extends ConsumerWidget {
  const TrackersMenuCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Trackers',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
        vGap4,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: IntrinsicHeight(
            child: Row(
              children: [
                NCTrackerButton(
                  buttonTap: () {
                    Navigator.pushNamed(context, '/fluid_log');
                  },
                  iconifyIcon: const Iconify(Mdi.water_outline),
                  buttonText: 'Fluids',
                ),
                NCTrackerButton(
                  buttonTap: () {
                    Navigator.pushNamed(context, '/urine_log');
                  },
                  iconifyIcon: const Iconify(Mdi.toilet),
                  buttonText: 'Urine',
                ),
                NCTrackerButton(
                  buttonTap: () {
                    Navigator.pushNamed(context, '/bp_tracker_log');
                  },
                  iconifyIcon: const Iconify(Mdi.heart_outline),
                  buttonText: 'BP',
                ),
                NCTrackerButton(
                  buttonTap: () {
                    Navigator.pushNamed(context, '/weight_tracker_log');
                  },
                  iconifyIcon: const Iconify(Ic.outline_monitor_weight),
                  buttonText: 'Weight',
                ),
                NCTrackerButton(
                  buttonTap: () {},
                  buttonIcon: Icons.health_and_safety_outlined,
                  buttonText: 'Dialysis',
                ),
                NCTrackerButton(
                  buttonTap: () {},
                  buttonIcon: Icons.medication_outlined,
                  buttonText: 'Medicine',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
