import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/widgets/nc_divider.dart';
import 'package:nephro_care/widgets/nc_value_range_chooser.dart';

class TrackersSettingsScreen extends ConsumerWidget {
  const TrackersSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowDeleteAll = ref.watch(allowDeleteAllProvider);
    final allowEditPastEntries = ref.watch(allowEditPastEntriesProvider);
    final allowDeletePastEntries = ref.watch(allowDeletePastEntriesProvider);
    final isReminderActive = ref.watch(remindersActiveProvider);
    final fluidLimit = ref.watch(fluidLimitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trackers Settings'),
        titleSpacing: 0,
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          color: Theme.of(context).colorScheme.primary,
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kScaffoldBodyPadding),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.edit,
                size: 28,
              ),
              tileColor: Colors.transparent,
              title: const Text('Edit Past Entries'),
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w800),
              subtitle: Text(
                allowEditPastEntries == true
                    ? 'Past entries can be deleted'
                    : 'Past entries can\'t be deleted',
              ),
              trailing: Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: allowEditPastEntries,
                  onChanged: (value) {
                    ref.read(allowEditPastEntriesProvider.notifier).state =
                        value;
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                size: 28,
              ),
              tileColor: Colors.transparent,
              title: const Text('Delete Past Entries'),
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w800),
              subtitle: Text(allowDeletePastEntries
                  ? 'Past entries can be deleted'
                  : 'Past entries can\'t be deleted'),
              trailing: Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: allowDeletePastEntries,
                  onChanged: (value) {
                    ref.read(allowDeletePastEntriesProvider.notifier).state =
                        value;
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_forever,
                size: 28,
              ),
              tileColor: Colors.transparent,
              title: const Text('Delete All Option'),
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w800),
              subtitle: Text(allowDeleteAll
                  ? 'Show delete all button in menu'
                  : 'Hide delete all button in menu'),
              trailing: Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: allowDeleteAll,
                  onChanged: (value) {
                    ref.read(allowDeleteAllProvider.notifier).state = value;
                  },
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.notifications_active,
                size: 28,
              ),
              tileColor: Colors.transparent,
              title: const Text('Reminder Alerts'),
              titleTextStyle: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w800),
              trailing: Transform.scale(
                scale: 0.75,
                child: Switch(
                  value: isReminderActive,
                  onChanged: (newValue) {
                    ref.read(remindersActiveProvider.notifier).state = newValue;
                  },
                ),
              ),
            ),
            vGap8,
            const NCDivider(
              widthFactor: 0.9,
            ),
            vGap8,
            ListTile(
                leading: const Icon(
                  Icons.water_drop,
                  size: 28,
                ),
                tileColor: Colors.transparent,
                title: const Text('Fluid Intake Limit'),
                titleTextStyle: Theme.of(context).textTheme.titleMedium,
                trailing: ValueRangeChooser(
                  value: fluidLimit,
                  onValueChanged: (newValue) {
                    ref
                        .read(fluidLimitProvider.notifier)
                        .setFluidLimit(newValue);
                  },
                  step: 50,
                  minValue: 50,
                )),
          ],
        ),
      ),
    );
  }
}
