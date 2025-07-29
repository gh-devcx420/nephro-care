import 'package:flutter/material.dart';
import 'package:nephro_care/constants/ui_helper.dart';

class NcTrackerButton extends StatelessWidget {
  const NcTrackerButton({
    super.key,
    required this.buttonColor,
    required this.icon,
    required this.buttonText,
    required this.buttonTap,
    this.buttonBorderColor,
  });

  final Color buttonColor;
  final Color? buttonBorderColor;
  final Icon icon;
  final String buttonText;
  final Function() buttonTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: buttonTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              decoration: BoxDecoration(
                color: buttonColor.withAlpha(50),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  width: 1.5,
                  color: buttonBorderColor ??
                      Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              child: icon,
            ),
            vGap8,
            Text(
              buttonText,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
