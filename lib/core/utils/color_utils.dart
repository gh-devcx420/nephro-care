import 'package:flutter/material.dart';

class ColorUtils {
  /// Convert a [Color] to a [Hex] string.
  static String colorToHex(Color color) {
    String hexString =
        '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2)}';
    return hexString;
  }
}
