import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/screens/home_screen/notes_section.dart';
import 'package:nephro_care/screens/home_screen/overview_card.dart';
import 'package:nephro_care/screens/settings_screen/settings_screen.dart';
import 'package:nephro_care/utils/ui_helper.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final user = ref.watch(authProvider);
    //final userName = user?.displayName ?? 'User';

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Nephro Care'),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
            icon: Icon(
              Icons.settings,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: const Padding(
        padding: EdgeInsets.all(kScaffoldBodyPadding),
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          children: [
            OverviewCard(),
            vGap10,
            NotesCard(),
          ],
        ),
      ),
    );
  }
}
