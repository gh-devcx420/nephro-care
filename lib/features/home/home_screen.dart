import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_appbar.dart';
import 'package:nephro_care/features/home/summary_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NCAppbar(),
                vGap10,
                SummaryCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
