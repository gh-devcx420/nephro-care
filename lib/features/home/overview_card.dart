import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_enums.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';

class OverviewCard extends ConsumerStatefulWidget {
  const OverviewCard({super.key});

  @override
  ConsumerState<OverviewCard> createState() => _OverviewCardState();
}

class _OverviewCardState extends ConsumerState<OverviewCard> {
  ComparisonMode _comparisonMode = ComparisonMode.today;

  String get _comparisonText {
    return _comparisonMode == ComparisonMode.lastDialysis
        ? 'Last Dialysis'
        : 'Today';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget buildToggleOption(String label, ComparisonMode mode) {
      final isSelected = _comparisonMode == mode;

      return InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          setState(() {
            _comparisonMode = mode;
          });
        },
        borderRadius: BorderRadius.circular(UIConstants.borderRadius * 0.5),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(UIConstants.borderRadius * 0.5),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall!.copyWith(
              color: isSelected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    return Container(
      padding: UIConstants.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius:
                      BorderRadius.circular(UIConstants.borderRadius * 0.5),
                ),
                child: Icon(
                  Icons.health_and_safety,
                  size: 24,
                  color: theme.colorScheme.primary,
                ),
              ),
              hGap6,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _comparisonText,
                          style: theme.textTheme.titleSmall!.copyWith(
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                            fontWeight: FontWeight.w800,
                            height: 0.9,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLowest,
                  borderRadius:
                      BorderRadius.circular(UIConstants.borderRadius * 0.5),
                ),
                child: Row(
                  children: [
                    buildToggleOption('D', ComparisonMode.lastDialysis),
                    buildToggleOption('T', ComparisonMode.today),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
