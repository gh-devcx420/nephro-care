import 'package:flutter/material.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Summary',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
        vGap4,
        Container(
          padding: UIConstants.cardPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '• Placeholder text 1',
              ),
              vGap10,
              Text('• Placeholder text 2'),
              vGap10,
              Text('• Placeholder text 3'),
              vGap10,
              Text('• Placeholder text 4'),
            ],
          ),
        ),
      ],
    );
  }
}
