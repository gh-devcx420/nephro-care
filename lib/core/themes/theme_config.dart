import 'package:flutter/material.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/themes/theme_color_schemes.dart';
import 'package:nephro_care/core/themes/theme_enums.dart';
import 'package:nephro_care/core/themes/theme_model.dart';

Map<ThemeName, AppThemeItem> get appThemes {
  return {
    for (ThemeName theme in ThemeName.values)
      theme: AppThemeItem(
        displayName: theme.displayName,
        colorScheme: AppColorScheme.getThemeColors(theme),
        themeIcon: theme.iconData,
      ),
  };
}

abstract class AppTheme {
  static ThemeData lightTheme(ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        toolbarHeight: 48,
        leadingWidth: 48,
        backgroundColor: colorScheme.surfaceContainerLow,
        foregroundColor: colorScheme.onSurfaceVariant,
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          color: colorScheme.onSurfaceVariant,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          height: 1.27,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
        ),
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(
        color: colorScheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colorScheme.primaryContainer,
        cursorColor: colorScheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: UIConstants.borderThickness,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: UIConstants.borderThickness * 1.5, // Thicker when focused
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: UIConstants.borderThickness,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: UIConstants.borderThickness * 1.5,
          ),
        ),
        prefixIconColor: colorScheme.primary,
        suffixIconColor: colorScheme.onSurfaceVariant,
        filled: true,
        fillColor: colorScheme.surfaceContainerLowest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(UIConstants.textButtonPadding),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.primary;
          }),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: UIConstants.textButtonFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            ),
          ),
          overlayColor: WidgetStateProperty.all(
            colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(UIConstants.elevatedButtonPadding),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.12);
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.onPrimary;
          }),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: UIConstants.elevatedButtonFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            ),
          ),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return 0;
            if (states.contains(WidgetState.pressed)) return 1;
            return 2;
          }),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        dayStyle: const TextStyle(
          fontFamily: 'JosefinSans',
          fontWeight: FontWeight.w500,
        ),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.primaryContainer;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
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
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        hourMinuteTextColor: colorScheme.onSurface,
        dayPeriodTextColor: colorScheme.onSurfaceVariant,
        dialBackgroundColor: colorScheme.surfaceContainerHighest,
        dialHandColor: colorScheme.primary,
        dialTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurface;
        }),
        entryModeIconColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surfaceContainerLowest,
        selectedTileColor: colorScheme.primaryContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        ),
        iconColor: colorScheme.primary,
        selectedColor: colorScheme.onPrimaryContainer,
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.primaryContainer,
        contentTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onInverseSurface,
        ),
        behavior: SnackBarBehavior.fixed,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primaryContainer,
        circularTrackColor: colorScheme.primary,
        linearTrackColor: colorScheme.primary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        modalBackgroundColor: colorScheme.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        dragHandleColor: colorScheme.onSurfaceVariant,
      ),
      textTheme: textTheme(colorScheme.onSurface),
    );
  }

  static ThemeData darkTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        toolbarHeight: 48,
        leadingWidth: 48,
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.onSurface,
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          color: colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          height: 1.27,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        actionsIconTheme: IconThemeData(
          color: colorScheme.onSurface,
        ),
        elevation: 0,
      ),
      scaffoldBackgroundColor: colorScheme.surface,
      iconTheme: IconThemeData(
        color: colorScheme.primary,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 2,
      ),
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: colorScheme.primaryContainer,
        cursorColor: colorScheme.primary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: UIConstants.borderThickness,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: UIConstants.borderThickness * 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: UIConstants.borderThickness,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          borderSide: BorderSide(
            color: colorScheme.error,
            width: UIConstants.borderThickness * 1.5,
          ),
        ),
        prefixIconColor: colorScheme.primary,
        suffixIconColor: colorScheme.onSurfaceVariant,
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(UIConstants.textButtonPadding),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.primary;
          }),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: UIConstants.textButtonFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            ),
          ),
          overlayColor: WidgetStateProperty.all(
            colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          padding: WidgetStateProperty.all(UIConstants.elevatedButtonPadding),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.12);
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withValues(alpha: 0.38);
            }
            return colorScheme.onPrimary;
          }),
          textStyle: WidgetStateProperty.all(
            const TextStyle(
              fontFamily: 'JosefinSans',
              fontSize: UIConstants.elevatedButtonFontSize,
              fontWeight: FontWeight.w700,
            ),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(UIConstants.borderRadius),
            ),
          ),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) return 0;
            if (states.contains(WidgetState.pressed)) return 1;
            return 2;
          }),
        ),
      ),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        headerBackgroundColor: colorScheme.primary,
        headerForegroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        dayStyle: const TextStyle(
          fontFamily: 'JosefinSans',
          fontWeight: FontWeight.w500,
        ),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.primaryContainer;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          if (states.contains(WidgetState.disabled)) {
            return colorScheme.onSurface.withValues(alpha: 0.38);
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
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        hourMinuteTextColor: colorScheme.onSurface,
        dayPeriodTextColor: colorScheme.onSurfaceVariant,
        dialBackgroundColor: colorScheme.surfaceContainerHighest,
        dialHandColor: colorScheme.primary,
        dialTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurface;
        }),
        entryModeIconColor: colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.surfaceContainerLow,
        selectedTileColor: colorScheme.primaryContainer,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        ),
        iconColor: colorScheme.primary,
        selectedColor: colorScheme.onPrimaryContainer,
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurface,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colorScheme.primaryContainer,
        contentTextStyle: TextStyle(
          fontFamily: 'JosefinSans',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
        behavior: SnackBarBehavior.fixed,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primaryContainer,
        circularTrackColor: colorScheme.primary,
        linearTrackColor: colorScheme.primary,
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        modalBackgroundColor: colorScheme.surfaceContainer,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        dragHandleColor: colorScheme.onSurfaceVariant,
      ),
      textTheme: textTheme(colorScheme.onSurface),
    );
  }

  static TextTheme textTheme(Color fontColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.12,
        letterSpacing: -0.25,
      ),
      displayMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.16,
        letterSpacing: 0,
      ),
      displaySmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.22,
        letterSpacing: 0,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.25,
        letterSpacing: 0,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 28,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.29,
        letterSpacing: 0,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 24,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.33,
        letterSpacing: 0,
      ),
      titleLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: fontColor,
        height: 1.27,
        letterSpacing: 0,
      ),
      titleMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: fontColor,
        height: 1.5,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: fontColor,
        height: 1.43,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 18,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.5,
        letterSpacing: 0.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.43,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: fontColor,
        height: 1.33,
        letterSpacing: 0.4,
      ),
      labelLarge: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: fontColor,
        height: 1.43,
        letterSpacing: 0.1,
      ),
      labelMedium: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: fontColor,
        height: 1.33,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontFamily: 'JosefinSans',
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: fontColor,
        height: 1.45,
        letterSpacing: 0.5,
      ),
    );
  }
}
