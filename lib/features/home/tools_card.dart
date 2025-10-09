import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_tracker_button.dart';

class ToolsMenuCard extends ConsumerWidget {
  const ToolsMenuCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: UIConstants.cardPadding,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceBright,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  'Tools',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ],
            ),
          ),
          vGap8,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: MediaQuery.of(context).size.width * 0.005,
              children: [
                NCTrackerButton(
                  buttonTap: () {},
                  buttonColor:
                      Theme.of(context).colorScheme.surfaceContainerLow,
                  buttonIcon: Icons.note_alt_rounded,
                  buttonText: 'Notes',
                ),
                NCTrackerButton(
                  buttonTap: () {},
                  buttonColor:
                      Theme.of(context).colorScheme.surfaceContainerLow,
                  buttonIcon: Icons.notifications_on,
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
