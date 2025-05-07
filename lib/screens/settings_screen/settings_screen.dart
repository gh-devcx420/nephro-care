import 'package:flutter/material.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/screens/settings_screen/change_theme_screen.dart';
import 'package:nephro_care/themes/theme_config.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                leading: Icon(
                  Icons.color_lens_rounded,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                title: Text(
                  'Change Theme',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Text(
                  'Available App Colors: ${appThemes.length}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
