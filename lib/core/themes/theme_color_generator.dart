import 'package:flutter/material.dart';

/// Enhanced color generation system that balances vibrancy with professionalism
/// Provides more saturated colors while maintaining Material Design 3 compliance
/// Optimized for medical apps that need both trustworthiness and visual appeal
class ColorGenerator {
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

  static ColorScheme _generateLightScheme(HSLColor seedHsl) {
    return ColorScheme(
      brightness: Brightness.light,

      // Primary color family - increased saturation for more vibrant appearance
      primary: seedHsl.withSaturation(0.85).withLightness(0.38).toColor(),
      onPrimary: Colors.white,
      primaryContainer:
          seedHsl.withSaturation(0.55).withLightness(0.85).toColor(),
      // More saturated, darker
      onPrimaryContainer:
          seedHsl.withSaturation(0.90).withLightness(0.15).toColor(),

      // Primary fixed colors
      primaryFixed: seedHsl.withSaturation(0.45).withLightness(0.88).toColor(),
      primaryFixedDim:
          seedHsl.withSaturation(0.55).withLightness(0.72).toColor(),
      onPrimaryFixed:
          seedHsl.withSaturation(0.90).withLightness(0.18).toColor(),
      onPrimaryFixedVariant:
          seedHsl.withSaturation(0.85).withLightness(0.32).toColor(),

      // Secondary color family - complementary harmony (30° shift)
      secondary: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.75)
          .withLightness(0.42)
          .toColor(),
      onSecondary: Colors.white,
      secondaryContainer: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.50)
          .withLightness(0.83)
          .toColor(),
      // More saturated, darker
      onSecondaryContainer: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.80)
          .withLightness(0.18)
          .toColor(),

      // Secondary fixed colors
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

      // Tertiary color family - triadic harmony (120° shift)
      tertiary: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.80)
          .withLightness(0.40)
          .toColor(),
      onTertiary: Colors.white,
      tertiaryContainer: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.52)
          .withLightness(0.81)
          .toColor(),
      // More saturated, darker
      onTertiaryContainer: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.85)
          .withLightness(0.16)
          .toColor(),

      // Tertiary fixed colors
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

      // Error colors - vibrant red for clear indication
      error: const Color(0xFFD32F2F),
      onError: Colors.white,
      errorContainer: const Color(0xFFFFEBEE),
      onErrorContainer: const Color(0xFF7F0000),

      // Surface colors - clean whites with subtle warmth
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

      // Outline colors for borders and dividers
      outline: const Color(0xFF757575),
      outlineVariant: const Color(0xFFBDBDBD),

      // System colors
      shadow: Colors.black.withValues(alpha: 0.15),
      scrim: Colors.black.withValues(alpha: 0.32),
      inverseSurface: const Color(0xFF2E2E2E),
      onInverseSurface: const Color(0xFFF5F5F5),
      inversePrimary:
          seedHsl.withSaturation(0.65).withLightness(0.75).toColor(),
      surfaceTint: seedHsl.withSaturation(0.85).withLightness(0.38).toColor(),
    );
  }

  static ColorScheme _generateDarkScheme(HSLColor seedHsl) {
    return ColorScheme(
      brightness: Brightness.dark,

      // Primary colors - vibrant but not overwhelming in dark mode
      primary: seedHsl.withSaturation(0.75).withLightness(0.75).toColor(),
      onPrimary: const Color(0xFF000000),
      primaryContainer:
          seedHsl.withSaturation(0.85).withLightness(0.25).toColor(),
      onPrimaryContainer:
          seedHsl.withSaturation(0.35).withLightness(0.92).toColor(),

      // Primary fixed colors (same as light theme per Material 3 spec)
      primaryFixed: seedHsl.withSaturation(0.45).withLightness(0.88).toColor(),
      primaryFixedDim:
          seedHsl.withSaturation(0.55).withLightness(0.72).toColor(),
      onPrimaryFixed:
          seedHsl.withSaturation(0.90).withLightness(0.18).toColor(),
      onPrimaryFixedVariant:
          seedHsl.withSaturation(0.85).withLightness(0.32).toColor(),

      // Secondary colors
      secondary: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.65)
          .withLightness(0.78)
          .toColor(),
      onSecondary: const Color(0xFF000000),
      secondaryContainer: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.80)
          .withLightness(0.22)
          .toColor(),
      onSecondaryContainer: seedHsl
          .withHue((seedHsl.hue + 30) % 360)
          .withSaturation(0.28)
          .withLightness(0.90)
          .toColor(),

      // Secondary fixed colors
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

      // Tertiary colors
      tertiary: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.70)
          .withLightness(0.76)
          .toColor(),
      onTertiary: const Color(0xFF000000),
      tertiaryContainer: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.85)
          .withLightness(0.23)
          .toColor(),
      onTertiaryContainer: seedHsl
          .withHue((seedHsl.hue + 120) % 360)
          .withSaturation(0.32)
          .withLightness(0.89)
          .toColor(),

      // Tertiary fixed colors
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

      // Error colors for dark theme
      error: const Color(0xFFEF5350),
      onError: const Color(0xFF000000),
      errorContainer: const Color(0xFFB71C1C),
      onErrorContainer: const Color(0xFFFFEBEE),

      // Dark surface colors with better contrast
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

      // Dark outline colors
      outline: const Color(0xFF757575),
      outlineVariant: const Color(0xFF424242),

      // Dark system colors
      shadow: Colors.black.withValues(alpha: 0.25),
      scrim: Colors.black.withValues(alpha: 0.5),
      inverseSurface: const Color(0xFFE8E8E8),
      onInverseSurface: const Color(0xFF2A2A2A),
      inversePrimary:
          seedHsl.withSaturation(0.85).withLightness(0.35).toColor(),
      surfaceTint: seedHsl.withSaturation(0.75).withLightness(0.75).toColor(),
    );
  }
}
