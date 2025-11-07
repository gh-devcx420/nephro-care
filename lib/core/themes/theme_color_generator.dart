import 'package:flutter/material.dart';

class ColorGenerator {
  /// Generate a color scheme based on a HSL seed color.
  static ColorScheme generateColorScheme({
    required Color seedColor,
    required Brightness brightness,
  }) {
    final hsl = HSLColor.fromColor(seedColor);

    if (brightness == Brightness.light) {
      return _generateLightScheme(hsl);
    } else {
      return _generateDarkScheme(hsl);
    }
  }

  /// Private method to generate a light color scheme based on a HSL seed color.
  static ColorScheme _generateLightScheme(HSLColor seedHsl) {
    return ColorScheme(
      brightness: Brightness.light,
      primary: seedHsl.withSaturation(0.75).withLightness(0.38).toColor(),
      onPrimary: Colors.white,
      primaryContainer:
          seedHsl.withSaturation(0.75).withLightness(0.85).toColor(),
      onPrimaryContainer:
          seedHsl.withSaturation(0.80).withLightness(0.15).toColor(),
      primaryFixed: seedHsl.withSaturation(0.70).withLightness(0.88).toColor(),
      primaryFixedDim:
          seedHsl.withSaturation(0.75).withLightness(0.72).toColor(),
      onPrimaryFixed:
          seedHsl.withSaturation(0.80).withLightness(0.18).toColor(),
      onPrimaryFixedVariant:
          seedHsl.withSaturation(0.75).withLightness(0.32).toColor(),
      secondary: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.70)
          .withLightness(0.42)
          .toColor(),
      onSecondary: Colors.white,
      secondaryContainer: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.75)
          .withLightness(0.83)
          .toColor(),
      onSecondaryContainer: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.75)
          .withLightness(0.18)
          .toColor(),
      secondaryFixed: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.70)
          .withLightness(0.86)
          .toColor(),
      secondaryFixedDim: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.75)
          .withLightness(0.70)
          .toColor(),
      onSecondaryFixed: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.75)
          .withLightness(0.21)
          .toColor(),
      onSecondaryFixedVariant: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.70)
          .withLightness(0.35)
          .toColor(),
      tertiary: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.75)
          .withLightness(0.40)
          .toColor(),
      onTertiary: Colors.white,
      tertiaryContainer: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.75)
          .withLightness(0.81)
          .toColor(),
      onTertiaryContainer: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.80)
          .withLightness(0.16)
          .toColor(),
      tertiaryFixed: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.70)
          .withLightness(0.85)
          .toColor(),
      tertiaryFixedDim: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.75)
          .withLightness(0.68)
          .toColor(),
      onTertiaryFixed: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.80)
          .withLightness(0.19)
          .toColor(),
      onTertiaryFixedVariant: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.75)
          .withLightness(0.33)
          .toColor(),
      error: const Color(0xFFBA1A1A),
      onError: Colors.white,
      errorContainer: const Color(0xFFAD251C),
      onErrorContainer: Colors.white,
      surface: const Color(0xFFFFFFF8),
      onSurface: const Color(0xFF1A1A1A),
      surfaceDim: const Color(0xFFE8E8E8),
      surfaceBright: const Color(0xFFFFFFFF),
      surfaceContainerLowest: const Color(0xFFFFFFFF),
      surfaceContainerLow: const Color(0xFFFAFAFA),
      surfaceContainer: const Color(0xFFF5F5F5),
      surfaceContainerHigh: const Color(0xFFEFEFEF),
      surfaceContainerHighest: const Color(0xFFE9E9E9),
      onSurfaceVariant: const Color(0xFF424242),
      outline: const Color(0xFF757575),
      outlineVariant: const Color(0xFFBDBDBD),
      shadow: Colors.black.withValues(alpha: 0.15),
      scrim: Colors.black.withValues(alpha: 0.32),
      inverseSurface: const Color(0xFF2E2E2E),
      onInverseSurface: const Color(0xFFF5F5F5),
      inversePrimary:
          seedHsl.withSaturation(0.55).withLightness(0.75).toColor(),
      surfaceTint: seedHsl.withSaturation(0.75).withLightness(0.38).toColor(),
    );
  }

  /// Private method to generate a dark color scheme based on a HSL seed color.
  static ColorScheme _generateDarkScheme(HSLColor seedHsl) {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: seedHsl.withSaturation(0.65).withLightness(0.75).toColor(),
      onPrimary: const Color(0xFF000000),
      primaryContainer:
          seedHsl.withSaturation(0.55).withLightness(0.25).toColor(),
      onPrimaryContainer:
          seedHsl.withSaturation(0.35).withLightness(0.92).toColor(),
      primaryFixed: seedHsl.withSaturation(0.45).withLightness(0.88).toColor(),
      primaryFixedDim:
          seedHsl.withSaturation(0.55).withLightness(0.72).toColor(),
      onPrimaryFixed:
          seedHsl.withSaturation(0.90).withLightness(0.18).toColor(),
      onPrimaryFixedVariant:
          seedHsl.withSaturation(0.85).withLightness(0.32).toColor(),
      secondary: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.55)
          .withLightness(0.78)
          .toColor(),
      onSecondary: const Color(0xFF000000),
      secondaryContainer: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.50)
          .withLightness(0.22)
          .toColor(),
      onSecondaryContainer: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.28)
          .withLightness(0.90)
          .toColor(),
      secondaryFixed: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.42)
          .withLightness(0.86)
          .toColor(),
      secondaryFixedDim: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.52)
          .withLightness(0.70)
          .toColor(),
      onSecondaryFixed: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.80)
          .withLightness(0.21)
          .toColor(),
      onSecondaryFixedVariant: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.75)
          .withLightness(0.35)
          .toColor(),
      tertiary: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.60)
          .withLightness(0.76)
          .toColor(),
      onTertiary: const Color(0xFF000000),
      tertiaryContainer: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.55)
          .withLightness(0.23)
          .toColor(),
      onTertiaryContainer: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.32)
          .withLightness(0.89)
          .toColor(),
      tertiaryFixed: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.45)
          .withLightness(0.85)
          .toColor(),
      tertiaryFixedDim: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.55)
          .withLightness(0.68)
          .toColor(),
      onTertiaryFixed: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.85)
          .withLightness(0.19)
          .toColor(),
      onTertiaryFixedVariant: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.80)
          .withLightness(0.33)
          .toColor(),
      error: const Color(0xFFFFB4AB),
      onError: const Color(0xFF690005),
      errorContainer: const Color(0xFFF1B7B5),
      onErrorContainer: const Color(0xFF000000),
      surface: const Color(0xFF0F0F0F),
      onSurface: const Color(0xFFE8E8E8),
      surfaceDim: const Color(0xFF0A0A0A),
      surfaceBright: const Color(0xFF2A2A2A),
      surfaceContainerLowest: const Color(0xFF050505),
      surfaceContainerLow: const Color(0xFF141414),
      surfaceContainer: const Color(0xFF1A1A1A),
      surfaceContainerHigh: const Color(0xFF242424),
      surfaceContainerHighest: const Color(0xFF2E2E2E),
      onSurfaceVariant: const Color(0xFFBDBDBD),
      outline: const Color(0xFF757575),
      outlineVariant: const Color(0xFF424242),
      shadow: Colors.black.withValues(alpha: 0.25),
      scrim: Colors.black.withValues(alpha: 0.5),
      inverseSurface: const Color(0xFFE8E8E8),
      onInverseSurface: const Color(0xFF2A2A2A),
      inversePrimary:
          seedHsl.withSaturation(0.85).withLightness(0.35).toColor(),
      surfaceTint: seedHsl.withSaturation(0.65).withLightness(0.75).toColor(),
    );
  }
}
