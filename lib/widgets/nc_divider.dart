import 'package:flutter/material.dart';

class NCDivider extends StatelessWidget {
  const NCDivider({
    super.key,
    this.color,
    this.widthFactor,
    this.thickness,
  });

  final Color? color;
  final num? widthFactor;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * (widthFactor ?? 0.9),
        child: Divider(
          color: color ?? Theme.of(context).colorScheme.primary,
          endIndent: 0.5,
          thickness: thickness ?? 0.5,
          radius: BorderRadius.circular(thickness ?? 1),
        ),
      ),
    );
  }
}
