import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/constants.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/widgets/nc_tracker_button.dart';

class ToolsMenuCard extends ConsumerWidget {
  const ToolsMenuCard({super.key});

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
            spacing: 1,
            children: [
              hGap8,
              Text(
                'Tools',
                style: theme.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          vGap4,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: MediaQuery.of(context).size.width * 0.005,
              children: [
                NcTrackerButton(
                  buttonTap: () {},
                  buttonColor:
                      Theme.of(context).colorScheme.surfaceContainerLow,
                  icon: Icon(
                    Icons.note_alt_rounded,
                    size: kToolsIconSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: 'Notes',
                ),
                NcTrackerButton(
                  buttonTap: () {},
                  buttonColor:
                      Theme.of(context).colorScheme.surfaceContainerLow,
                  icon: Icon(
                    Icons.notifications_on,
                    size: kToolsIconSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  buttonText: 'Reminders',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
