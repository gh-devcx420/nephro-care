import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/whh.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/models/theme_model.dart';
import 'package:nephro_care/themes/color_schemes.dart';

enum ThemeName { eightball }

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
        backgroundColor: colorScheme.surfaceContainerLow,
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          color: colorScheme.primary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.primary,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.surface,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.primary,
      ),
      scaffoldBackgroundColor: colorScheme.surfaceContainerLow,
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
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          foregroundColor: colorScheme.primary,
          backgroundColor: Colors.transparent,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
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
      dialogTheme: DialogTheme(
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
        colorScheme.primary,
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
          color: colorScheme.onPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onPrimary,
        ),
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: colorScheme.primary,
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
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: Colors.transparent,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kBorderRadius),
          ),
          foregroundColor: colorScheme.onPrimary,
          backgroundColor: colorScheme.primary,
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
      dialogTheme: DialogTheme(
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
        colorScheme.onPrimary,
      ),
    );
  }

  static textTheme(Color fontColor) {
    return TextTheme(
      // Display styles
      displayLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: fontColor,
      ),
      displayMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: fontColor,
      ),
      displaySmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: fontColor,
      ),
      // Headline styles
      headlineLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: fontColor,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: fontColor,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: fontColor,
      ),
      // Title styles
      titleLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: fontColor,
      ),
      titleMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: fontColor,
      ),
      titleSmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: fontColor,
      ),
      // Body text styles
      bodyLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: fontColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: fontColor,
      ),
      bodySmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: fontColor,
      ),
      // Label styles
      labelLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: fontColor,
      ),
      labelMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: fontColor,
      ),
      labelSmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: fontColor,
      ),
    );
  }
}
