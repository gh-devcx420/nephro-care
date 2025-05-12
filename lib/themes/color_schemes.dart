import 'package:flutter/material.dart';
import 'package:nephro_care/models/theme_model.dart';

abstract class AppColorScheme {
  static ThemeColorScheme eightball = const ThemeColorScheme(
    light: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF000000),
      onPrimary: Color(0xFFE3E3E3),
      primaryContainer: Color(0xFFB3B3B3),
      onPrimaryContainer: Color(0xFF000000),
      secondary: Color(0xFF1A1A1A),
      onSecondary: Color(0xFFFFFFFF),
      secondaryContainer: Color(0xFFBFBFBF),
      onSecondaryContainer: Color(0xFF000000),
      tertiary: Color(0xFF333333),
      onTertiary: Color(0xFFFFFFFF),
      tertiaryContainer: Color(0xFFCCCCCC),
      onTertiaryContainer: Color(0xFF000000),
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFFD9D9D9),
      onErrorContainer: Color(0xFF410002),
      surface: Color(0xFFD3D3D3),
      onSurface: Color(0xFF0D0D0D),
      surfaceDim: Color(0xFFCCCCCC),
      surfaceBright: Color(0xFFFFFFFF),
      surfaceContainerLowest: Color(0xFFFFFFFF),
      surfaceContainerLow: Color(0xFFF5F5F5),
      surfaceContainer: Color(0xFFF0F0F0),
      surfaceContainerHigh: Color(0xFFE8E8E8),
      surfaceContainerHighest: Color(0xFFE0E0E0),
      onSurfaceVariant: Color(0xFF424242),
      outline: Color(0xFF757575),
      outlineVariant: Color(0xFFB0B0B0),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFF0D0D0D),
      onInverseSurface: Color(0xFFE6E6E6),
      inversePrimary: Color(0xFF808080),
      surfaceTint: Color(0xFF000000),
    ),
    dark: ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFB3B3B3),
      onPrimary: Color(0xFF000000),
      primaryContainer: Color(0xFF080808),
      onPrimaryContainer: Color(0xFFB3B3B3),
      secondary: Color(0xFF808080),
      onSecondary: Color(0xFF000000),
      secondaryContainer: Color(0xFF1A1A1A),
      onSecondaryContainer: Color(0xFFB3B3B3),
      tertiary: Color(0xFF999999),
      onTertiary: Color(0xFF000000),
      tertiaryContainer: Color(0xFF141414),
      onTertiaryContainer: Color(0xFFB3B3B3),
      error: Color(0xFFB00020),
      onError: Color(0xFFFFFFFF),
      errorContainer: Color(0xFF93000A),
      onErrorContainer: Color(0xFFFFDAD6),
      surface: Color(0xFF000000),
      onSurface: Color(0xFFB3B3B3),
      surfaceDim: Color(0xFF080808),
      surfaceBright: Color(0xFF0D0D0D),
      surfaceContainerLowest: Color(0xFF000000),
      surfaceContainerLow: Color(0xFF080808),
      surfaceContainer: Color(0xFF0D0D0D),
      surfaceContainerHigh: Color(0xFF141414),
      surfaceContainerHighest: Color(0xFF1A1A1A),
      onSurfaceVariant: Color(0xFF808080),
      outline: Color(0xFF424242),
      outlineVariant: Color(0xFF666666),
      shadow: Color(0xFF000000),
      scrim: Color(0xFF000000),
      inverseSurface: Color(0xFFB3B3B3),
      onInverseSurface: Color(0xFF000000),
      inversePrimary: Color(0xFF333333),
      surfaceTint: Color(0xFFB3B3B3),
    ),
  );
}

abstract class ComponentColors {
  // Water Theme
  static const Color waterBackgroundColor = Color(0xFFDFEDFD);
  static const Color waterColorShade1 = Color(0xFF0BA5D9);
  static const Color waterColorShade2 = Color(0xFF438BBE);

  // Urine Theme
  static const Color urineBackgroundColor = Color(0xFFFFF8DE);
  static const Color urineColorShade1 = Color(0xFFCE7F07);
  static const Color urineColorShade2 = Color(0xFFBD9D3F);

  // Blood Theme
  static const Color bloodBackgroundColor = Color(0xFFFDE5E5);
  static const Color bloodColorShade1 = Color(0xFFD50C0C);
  static const Color bloodColorShade2 = Color(0xFFC73838);

  // Weight Theme
  static const Color weightBackgroundColor = Color(0xFFE3F8EA);
  static const Color weightColorShade1 = Color(0xFF209F24);
  static const Color weightColorShade2 = Color(0xFF36863C);

  // Other Component Colors
  static const Color greenSuccess = Colors.green;
  static const Color orangeAlert = Colors.orange;
}
