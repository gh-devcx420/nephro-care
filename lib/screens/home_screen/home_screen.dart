import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/constants.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/providers/summary_provider.dart';
import 'package:nephro_care/screens/home_screen/tools_card.dart';
import 'package:nephro_care/screens/home_screen/trackers_card.dart';
import 'package:nephro_care/screens/settings_screen/settings_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final summary = ref.watch(summaryProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu,
              size: 25,
              color: Theme.of(context).colorScheme.primary,
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text('Nephro Care'),
        titleSpacing: 0,
        actions: [
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: selectedDate,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (pickedDate != null && context.mounted) {
                ref.read(selectedDateProvider.notifier).state = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                );
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.80),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.calendar_month_outlined,
                    size: 16,
                  ),
                  hGap6,
                  Text(
                    summary.when(
                      data: (data) => data.$1['date']?.toString() ?? 'N/A',
                      loading: () => 'Loading',
                      error: (e, _) => 'Error',
                    ),
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).colorScheme.surfaceBright,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  hGap4,
                ],
              ),
            ),
          ),
          hGap8,
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SettingsScreen(),
              ),
            ),
            icon: Icon(
              Icons.settings_rounded,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          hGap8,
        ],
      ),
      drawer: const Drawer(),
      body: const Padding(
        padding: EdgeInsets.all(kScaffoldBodyPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TrackersMenuCard(),
              vGap10,
              ToolsMenuCard(),
            ],
          ),
        ),
      ),
    );
  }
}
