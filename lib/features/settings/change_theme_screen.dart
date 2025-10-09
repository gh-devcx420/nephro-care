import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/themes/theme_config.dart';
import 'package:nephro_care/core/themes/theme_enums.dart';
import 'package:nephro_care/core/themes/theme_provider.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeHandler = ref.watch(themeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Accent Color'),
        titleSpacing: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          color: Theme.of(context).colorScheme.onSurface,
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: UIConstants.scaffoldBodyPadding,
        child: ListView.builder(
          itemCount: appThemes.length,
          itemBuilder: (context, index) {
            final themeItem = appThemes.entries.elementAt(index);
            final isDark = Theme.of(context).brightness == Brightness.dark;
            final tileColorScheme = isDark
                ? themeItem.value.colorScheme.dark
                : themeItem.value.colorScheme.light;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                onTap: () {
                  HapticFeedback.lightImpact();
                  themeHandler.setNewTheme(themeItem.key);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -2),
                leading: Container(
                  decoration: BoxDecoration(
                    color: tileColorScheme.primary,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      themeItem.key.iconData,
                      size: 14,
                      color: tileColorScheme.primaryContainer,
                    ),
                  ),
                ),
                tileColor: tileColorScheme.primaryContainer,
                title: Text(
                  themeItem.value.displayName,
                ),
                titleTextStyle:
                    Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: tileColorScheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                subtitle: Text(
                  themeItem.key.description,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitleTextStyle:
                    Theme.of(context).textTheme.titleSmall!.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
              ),
            );
          },
        ),
      ),
    );
  }
}
