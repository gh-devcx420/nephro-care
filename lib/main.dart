import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/themes_provider.dart';
import 'package:nephro_care/screens/fluid_intake_screen/fluid_intake_log.dart';
import 'package:nephro_care/screens/home_screen/home_screen.dart';
import 'package:nephro_care/screens/login_screen/login_screen.dart';
import 'package:nephro_care/themes/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);

    return user == null ? const LoginScreen() : const HomeScreen();
  }
}

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
    try {
      final colorSchemes = ref.watch(colorSchemesProvider);
      return MaterialApp(
        theme: AppTheme.lightTheme(colorSchemes[ThemeMode.light]!),
        darkTheme: AppTheme.darkTheme(colorSchemes[ThemeMode.dark]!),
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/fluid_log': (context) => const FluidIntakeLogScreen(),
        },
      );
    } catch (e) {
      return const LoadingScreen();
    }
  }
}
