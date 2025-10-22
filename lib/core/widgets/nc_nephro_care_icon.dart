import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NCIcon extends StatelessWidget {
  final String icon;
  final Color? color;
  final double? size;

  const NCIcon(
    this.icon, {
    super.key,
    this.color,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      icon,
      colorFilter:
          color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
      width: size,
      height: size,
      alignment: Alignment.center,
    );
  }
}
