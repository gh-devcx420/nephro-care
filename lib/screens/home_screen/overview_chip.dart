import 'package:flutter/material.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/utils/ui_helper.dart';

class OverviewChip extends StatelessWidget {
  const OverviewChip({
    super.key,
    required this.chipIcon,
    required this.chipText,
    this.chipBackgroundColor,
    this.chipIconColor,
    this.chipTextColor,
    this.chipBorderColor,
    required this.chipLabel,
    required this.onChipTap,
    required this.chipTimestamp,
  });

  final IconData chipIcon;
  final String chipText;
  final String chipTimestamp;
  final String? chipLabel;
  final Color? chipBackgroundColor;
  final Color? chipIconColor;
  final Color? chipTextColor;
  final Color? chipBorderColor;
  final Function() onChipTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onChipTap,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
          decoration: BoxDecoration(
            color: chipBackgroundColor ?? Colors.grey.shade200,
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(
              color: chipBorderColor ?? Colors.grey.shade200,
              width: 2,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    chipIcon,
                    size: 20,
                    color: chipIconColor ?? Colors.grey.shade200,
                  ),
                  hGap8,
                  Text(
                    chipLabel ?? '',
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: chipTextColor ?? Colors.grey.shade200,
                          fontSize: 20,
                        ),
                  ),
                ],
              ),
              vGap4,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    chipText,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: chipTextColor ?? Colors.grey.shade200,
                          fontSize: 18,
                        ),
                  ),
                  // const Spacer(),
                  Text(
                    chipTimestamp,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: chipTextColor ?? Colors.grey.shade200,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
