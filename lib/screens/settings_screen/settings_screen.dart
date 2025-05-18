import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/main.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/screens/settings_screen/change_theme_screen.dart';
import 'package:nephro_care/screens/settings_screen/entries_settings_screen.dart';
import 'package:nephro_care/themes/theme_config.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/widgets/nc_alert_dialogue.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final authAsync = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(kScaffoldBodyPadding),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ThemeSettingsScreen(),
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(
                  Icons.color_lens_rounded,
                ),
                title: const Text(
                  'Change Theme',
                ),
                subtitle: Text(
                  'Available App Colors: ${appThemes.length}',
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
              ),
            ),

            vGap8,
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EntriesSettingsScreen(),
                  ),
                );
              },
              child: const ListTile(
                leading: Icon(
                  Icons.edit_document,
                ),
                title: Text(
                  'Entries Settings',
                ),
                subtitle: Text(
                  'Allow editing or deleting past entries',
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
              ),
            ),
            vGap8,
            // Logout user settings tile.
            InkWell(
              onTap: () async {
                final navigator = Navigator.of(context);
                showNCAlertDialogue(
                  context: context,
                  titleText: 'Logout User',
                  content: const Text(
                    'Are you sure you want to logout?',
                  ),
                  action1: TextButton(
                    onPressed: () => navigator.pop(false),
                    child: const Text(
                      'Cancel',
                    ),
                  ),
                  action2: ElevatedButton(
                    onPressed: () async {
                      await authAsync.signOut();
                      if (context.mounted) {
                        navigator.pop(true);
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const AuthWrapper(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: Text(
                      'Logout',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surfaceBright,
                      ),
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text(
                  'Logout',
                ),
                subtitle: Text(
                  user?.displayName ?? 'User',
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
