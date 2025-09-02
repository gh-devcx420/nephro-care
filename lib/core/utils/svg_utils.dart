import 'package:flutter/material.dart';
import 'package:nephro_care/core/utils/color_utils.dart';

class SVGUtils {
  static Future<String?> convertSvgToString(
      BuildContext context, String assetPath) async {
    try {
      return await DefaultAssetBundle.of(context).loadString(assetPath);
    } catch (e) {
      debugPrint('Failed to load SVG: $assetPath');
      return null;
    }
  }

  static String? replaceSvgColors(
      String? svgString, Map<String, Color> colorMap) {
    if (svgString == null) return null;

    String result = svgString;
    colorMap.forEach((oldColor, newColor) {
      result = result.replaceAll(
        oldColor,
        ColorUtils.colorToHex(newColor),
      );
    });
    return result;
  }

  static Future<String?> loadColoredSvg({
    required BuildContext context,
    required String assetPath,
    required String sourceColor,
    required Color targetColor,
  }) async {
    final svgString = await convertSvgToString(context, assetPath);
    return replaceSvgColors(svgString, {sourceColor: targetColor});
  }

  static Future<String?> loadMultiColorSvg(
    BuildContext context,
    String assetPath,
    Map<String, Color> colors,
  ) async {
    final svgString = await convertSvgToString(context, assetPath);
    return replaceSvgColors(svgString, colors);
  }
}
