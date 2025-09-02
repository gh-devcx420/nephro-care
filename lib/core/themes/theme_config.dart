import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/whh.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/themes/color_schemes.dart';
import 'package:nephro_care/core/themes/theme_enums.dart';
import 'package:nephro_care/core/themes/theme_model.dart';

Map<ThemeName, AppThemeItem> appThemes = {
  ThemeName.eightball: AppThemeItem(
    identifier: 'Eight Ball',
    colorScheme: AppColorScheme.eightball,
    themeIcon: Whh.eightball,
  ),
};

abstract class AppTheme {
  static lightTheme(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        toolbarHeight: 48,
        leadingWidth: 48,
        backgroundColor: colorScheme.surfaceContainerLow,
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          color: colorScheme.onPrimaryContainer,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimaryContainer,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onPrimaryContainer,
        ),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colorScheme.primaryContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: kBorderThickness,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: kBorderThickness,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: kBorderThickness,
          ),
        ),
        prefixIconColor: colorScheme.primary,
        filled: true,
        fillColor: colorScheme.surfaceDim,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(kTextButtonPadding),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(colorScheme.primary),
          textStyle: WidgetStateProperty.all(
            TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
              color: colorScheme.onPrimary,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          minimumSize: WidgetStateProperty.all(
            const Size(0, 0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(kElevatedButtonPadding),
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          textStyle: WidgetStateProperty.all(
            TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kElevatedButtonFontSize,
              fontWeight: FontWeight.w800,
              color: colorScheme.onPrimary,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          minimumSize: WidgetStateProperty.all(
            const Size(0, 0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surface,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surface;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.3);
          }
          return colorScheme.onSurface;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        todayBorder: BorderSide.none,
        cancelButtonStyle: ButtonStyle(
          padding: WidgetStateProperty.all(kTextButtonPadding),
          foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          padding: WidgetStateProperty.all(kElevatedButtonPadding),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colorScheme.surface,
        hourMinuteTextColor: colorScheme.onSurface,
        // Static color for hour/minute text
        dayPeriodTextColor: colorScheme.onSurface,
        // Static color for AM/PM text
        dialBackgroundColor: colorScheme.onInverseSurface,
        dialHandColor: colorScheme.primary,
        entryModeIconColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12), // Matches DatePickerThemeData
        ),
        cancelButtonStyle: ButtonStyle(
          padding: WidgetStateProperty.all(kTextButtonPadding),
          foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          padding: WidgetStateProperty.all(kElevatedButtonPadding),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        iconColor: colorScheme.primary,
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
        visualDensity: VisualDensity.comfortable,
        subtitleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.primary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
        backgroundColor: colorScheme.primary,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        circularTrackColor: colorScheme.primary,
        color: colorScheme.primaryContainer,
      ),
      textTheme: textTheme(
        colorScheme.onPrimaryContainer,
      ),
    );
  }

  static darkTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          color: colorScheme.onPrimaryContainer,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(
        color: colorScheme.onPrimary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colorScheme.secondaryContainer,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: kBorderThickness,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: kBorderThickness,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: kBorderThickness,
          ),
        ),
        prefixIconColor: colorScheme.primary,
        filled: true,
        fillColor: colorScheme.surfaceDim,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          textStyle: WidgetStateProperty.all(
            TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
              color: colorScheme.onPrimary,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          minimumSize: WidgetStateProperty.all(
            const Size(0, 0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(kElevatedButtonPadding),
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          textStyle: WidgetStateProperty.all(
            TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kElevatedButtonFontSize,
              fontWeight: FontWeight.w800,
              color: colorScheme.onPrimary,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          minimumSize: WidgetStateProperty.all(
            const Size(0, 0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surface,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.surface;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withOpacity(0.3);
          }
          return colorScheme.onSurface;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        todayBorder: BorderSide.none,
        cancelButtonStyle: ButtonStyle(
          padding: WidgetStateProperty.all(kTextButtonPadding),
          foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          padding: WidgetStateProperty.all(kElevatedButtonPadding),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colorScheme.surface,
        hourMinuteTextColor: colorScheme.onSurface,
        // Static color for hour/minute text
        dayPeriodTextColor: colorScheme.onSurface,
        // Static color for AM/PM text
        dialBackgroundColor: colorScheme.onSecondary,
        dialHandColor: colorScheme.primary,
        entryModeIconColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12), // Matches DatePickerThemeData
        ),
        cancelButtonStyle: ButtonStyle(
          padding: WidgetStateProperty.all(kTextButtonPadding),
          foregroundColor: WidgetStateProperty.all(colorScheme.onSurface),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        confirmButtonStyle: ButtonStyle(
          padding: WidgetStateProperty.all(kElevatedButtonPadding),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius),
            ),
          ),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: kTextButtonFontSize,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.primary,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kBorderRadius),
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colorScheme.onPrimary,
        ),
        dense: true,
      ),
      dialogTheme: DialogThemeData(
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.onPrimary,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        contentTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: colorScheme.onPrimary,
        ),
        backgroundColor: colorScheme.primary,
      ),
      textTheme: textTheme(
        colorScheme.onPrimaryContainer,
      ),
    );
  }

  static TextTheme textTheme(Color fontColor) {
    return TextTheme(
      // Display styles (for large headers, e.g., app title or major stats)
      displayLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: -0.5,
        // Slightly negative for larger fonts to improve readability
        textBaseline: TextBaseline.alphabetic, // Consistent baseline
      ),
      displayMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: -0.25,
        // Slightly negative for larger fonts
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      displaySmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.0,
        // Neutral for smaller display size
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      // Headline styles (for section titles, e.g., "Your Progress")
      headlineLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Matches titleLarge for consistency
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      headlineMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Matches titleLarge
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      headlineSmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Matches titleLarge
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      // Title styles (for card titles, e.g., "Taco" or "Calories")
      titleLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: fontColor,
        height: 1.3,
        // Retained as it fixed alignment in NCAppbar
        letterSpacing: 0.1,
        // Retained for consistency
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      titleMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Added to match titleLarge
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      titleSmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Added to match titleLarge
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      // Body styles (for descriptions, e.g., "72g" or "70 bpm")
      bodyLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Added for consistency
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      bodyMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Added for consistency
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      bodySmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Added for consistency
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      // Label styles (for small annotations, e.g., "Today" or "%")
      labelLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Added for consistency
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      labelMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Added for consistency
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
      labelSmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: fontColor,
        height: 1.3,
        // Added for consistent vertical spacing
        letterSpacing: 0.1,
        // Added for consistency
        textBaseline: TextBaseline.alphabetic, // Added for consistency
      ),
    );
  }
}
