import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/themes/theme_color_schemes.dart';
import 'package:nephro_care/core/themes/theme_config.dart';
import 'package:nephro_care/core/themes/theme_enums.dart';
import 'package:nephro_care/core/themes/theme_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeSettingsNotifier extends StateNotifier<ThemeName> {
  final SharedPreferences prefs;
  static const String _themePreferenceKey = 'SelectedTheme';

  ThemeSettingsNotifier(this.prefs) : super(ThemeName.warmTeal) {
    _loadThemePreferences();
  }

  Future<void> _storeThemePreferences(ThemeName currentTheme) async {
    await prefs.setString(
      _themePreferenceKey,
      appThemes[currentTheme] != null
          ? currentTheme.name
          : ThemeName.warmTeal.name,
    );
  }

  void _loadThemePreferences() {
    final storedThemeName = prefs.getString(_themePreferenceKey);

    if (storedThemeName == null) {
      setNewTheme(ThemeName.warmTeal);
      return;
    }

    try {
      final currentTheme = ThemeName.values.firstWhere(
        (theme) => theme.name == storedThemeName,
        orElse: () => ThemeName.warmTeal,
      );
      setNewTheme(currentTheme);
    } catch (e) {
      setNewTheme(ThemeName.warmTeal);
    }
  }

  void setNewTheme(ThemeName newTheme) {
    state = newTheme;
    _storeThemePreferences(newTheme);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
      'sharedPreferencesProvider must be overridden in ProviderScope');
});

final themeProvider = StateNotifierProvider<ThemeSettingsNotifier, ThemeName>(
  (ref) {
    final prefs = ref.watch(sharedPreferencesProvider);
    return ThemeSettingsNotifier(prefs);
  },
);

final colorSchemesProvider = Provider<Map<ThemeMode, ColorScheme>>(
  (ref) {
    final currentTheme = ref.watch(themeProvider);
    final themeColors = AppColorScheme.getThemeColors(currentTheme);

    return {
      ThemeMode.light: themeColors.light,
      ThemeMode.dark: themeColors.dark,
    };
  },
);

final currentThemeInfoProvider = Provider<ThemeInfo>((ref) {
  final currentTheme = ref.watch(themeProvider);

  return ThemeInfo(
    name: currentTheme,
    displayName: currentTheme.displayName,
    description: currentTheme.description,
    icon: currentTheme.iconData,
    useCase: currentTheme.useCase,
  );
});

final availableThemesProvider = Provider<List<ThemePreview>>((ref) {
  return ThemeName.values.map((theme) {
    final themeColors = AppColorScheme.getThemeColors(theme);

    return ThemePreview(
      name: theme,
      displayName: theme.displayName,
      description: theme.description,
      icon: theme.iconData,
      primaryColor: themeColors.light.primary,
      primaryContainerColor: themeColors.light.primaryContainer,
    );
  }).toList();
});
