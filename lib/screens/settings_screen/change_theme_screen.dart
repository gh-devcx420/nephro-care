import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/providers/themes_provider.dart';
import 'package:nephro_care/themes/theme_config.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeHandler = ref.watch(themeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Theme'),
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
        child: ListView.builder(
          itemCount: appThemes.length,
          itemBuilder: (context, index) {
            final themeItem = appThemes.entries.elementAt(index);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeItem.value.colorScheme.light.primary,
                      themeItem.value.colorScheme.dark.primary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(
                      left: 12,
                    ),
                    child: Text(
                      themeItem.value.identifier,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: themeItem
                                .value.colorScheme.light.secondaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Iconify(
                      themeItem.value.themeIcon,
                      color: themeItem.value.colorScheme.light.primary,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  dense: false,
                  onTap: () {
                    themeHandler.setNewTheme(themeItem.key);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
