import 'package:flutter/material.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';

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
    this.requireLitreConversion,
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
  final bool? requireLitreConversion;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onChipTap,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: chipBackgroundColor ?? Colors.grey.shade200,
            borderRadius: BorderRadius.circular(kBorderRadius),
            border: Border.all(
              color: chipBorderColor ?? Colors.grey.shade200,
              width: 2.5,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                children: [
                  vGap2,
                  Icon(
                    chipIcon,
                    size: 20,
                    color: chipIconColor ?? Colors.grey.shade200,
                  ),
                ],
              ),
              hGap8,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chipLabel ?? '',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: chipTextColor ?? Colors.grey.shade200,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    hGap2,
                    Text(
                      // CHANGE 1: Use formatFluidAmount for conditional formatting
                      requireLitreConversion ?? false
                          ? Utils.formatFluidAmount(chipText)
                          : chipText,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: chipTextColor ?? Colors.grey.shade200,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    hGap2,
                    Text(
                      chipTimestamp,
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: chipTextColor ?? Colors.grey.shade200,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
