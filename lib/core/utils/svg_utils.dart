import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/utils/color_utils.dart';

class SVGUtils {
  /// Load SVG without caching - bypasses DefaultAssetBundle cache
  static Future<String?> _loadSvgWithoutCache(String assetPath) async {
    try {
      final ByteData byteData = await rootBundle.load(assetPath);
      final String svgContent =
          String.fromCharCodes(byteData.buffer.asUint8List());
      return svgContent;
    } catch (e) {
      debugPrint('Failed to load SVG: $assetPath - Error: $e');
      return null;
    }
  }

  static Future<String?> convertSvgToString(
      BuildContext context, String assetPath) async {
    try {
      return await _loadSvgWithoutCache(assetPath);
    } catch (e) {
      debugPrint('Failed to load SVG: $assetPath - Error: $e');
      return null;
    }
  }

  static String? replaceSvgColors(
      String? svgString, Map<String, Color> colorMap) {
    if (svgString == null) return null;

    String result = svgString;

    colorMap.forEach((oldColor, newColor) {
      final hex = ColorUtils.colorToHex(newColor);
      result = result.replaceAll(oldColor, hex);
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
