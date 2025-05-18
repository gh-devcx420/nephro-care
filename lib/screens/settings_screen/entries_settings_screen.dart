import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/utils/ui_helper.dart';

class EntriesSettingsScreen extends ConsumerWidget {
  const EntriesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allowDeleteAll = ref.watch(allowDeleteAllProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Entries Settings'),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kScaffoldBodyPadding),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.delete_sweep,
              ),
              title: const Text('Allow Delete All Option'),
              subtitle: const Text('Show delete all option in log screens'),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              trailing: Switch(
                value: allowDeleteAll,
                onChanged: (value) {
                  ref.read(allowDeleteAllProvider.notifier).state = value;
                },
              ),
            ),
            vGap8,
          ],
        ),
      ),
    );
  }
}
