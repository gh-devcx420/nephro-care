import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/services/firebase_options.dart';
import 'package:nephro_care/core/themes/theme_config.dart';
import 'package:nephro_care/core/themes/theme_provider.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/auth/login_screen.dart';
import 'package:nephro_care/features/home/home_screen.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_log_screen.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_log_screen.dart';
import 'package:nephro_care/features/trackers/urine/urine_log_screen.dart';
import 'package:nephro_care/features/trackers/weight/weight_log_screen.dart';
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

    return user == null ? LoginScreen(key: UniqueKey()) : const HomeScreen();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
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
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(colorSchemes[ThemeMode.light]!),
        darkTheme: AppTheme.darkTheme(colorSchemes[ThemeMode.dark]!),
        themeMode: ThemeMode.system,
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/home': (context) => const HomeScreen(),
          '/fluid_log': (context) => const FluidIntakeLogScreen(),
          '/urine_log': (context) => const UrineOutputLogScreen(),
          '/bp_tracker_log': (context) => const BPTrackerLogScreen(),
          '/weight_tracker_log': (context) => const WeightTrackerLogScreen(),
        },
      );
    } catch (e) {
      return const LoadingScreen();
    }
  }
}
