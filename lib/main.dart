import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/providers/themes_provider.dart';
import 'package:nephro_care/screens/fluid_intake_log_screen/fluid_intake_log.dart';
import 'package:nephro_care/screens/home_screen/home_screen.dart';
import 'package:nephro_care/screens/login_screen/login_screen.dart';
import 'package:nephro_care/themes/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const NephroCare(),
    ),
  );
}

class NephroCare extends ConsumerWidget {
  const NephroCare({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorSchemes = ref.watch(colorSchemesProvider);
    return MaterialApp(
      theme: AppTheme.lightTheme(colorSchemes[ThemeMode.light]!),
      darkTheme: AppTheme.darkTheme(colorSchemes[ThemeMode.dark]!),
      themeMode: ThemeMode.system,
      home: const LoginScreen(),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/fluid_log': (context) => const FluidIntakeLog(),
      },
    );
  }
}
