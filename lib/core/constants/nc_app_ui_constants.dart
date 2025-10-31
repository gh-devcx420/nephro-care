import 'package:flutter/material.dart';

class UIConstants {
  UIConstants._();

  // Border & Shape Constants
  static const double borderRadius = 12.0;
  static const double borderThickness = 2.0;

  // Icon Constants
  static const double buttonIconSize = 20.0;
  static const double overviewChipIconSize = 28.0;
  static const double infoChipIconSize = 16.0;

  // Button Constants
  static const double minButtonHeight = 32.0;
  static const double minButtonWidth = 32.0;
  static const double screenWidthThreshold = 400.0; //For Responsive Buttons
  static const double buttonWidthMultiplierSmallDPI =
      0.25; // For Responsive buttons
  static const double buttonWidthMultiplierLargeDPI =
      0.20; // For Responsive buttons
  static const double buttonHorizontalPadding = 8.0;
  static const double buttonVerticalPadding = 8.0;
  static const Duration buttonTapDuration = Duration(milliseconds: 100);
  static const double switchButtonScale = 0.75;

  // Chip Constants
  static const Duration chipTapDuration = Duration(milliseconds: 100);

  // Font Constants
  static const double elevatedButtonFontSize = 16.0;
  static const double textButtonFontSize = 16.0;
  static const double valueFontSize = 14.0;
  static const double siUnitFontSize = 12.0;
  static const double timeFontSize = 14.0;
  static const double meridiemIndicatorFontSize = 12.0;

  // Padding Value Constants

  // Padding Preset Constants
  static const EdgeInsets scaffoldBodyPadding =
      EdgeInsets.symmetric(horizontal: 12);
  static const EdgeInsets cardPadding =
      EdgeInsets.symmetric(horizontal: 12, vertical: 12);
  static const EdgeInsets overviewChipPadding =
      EdgeInsets.symmetric(horizontal: 10, vertical: 12);
  static const EdgeInsets infoChipPadding =
      EdgeInsets.symmetric(horizontal: 8, vertical: 8);
  static const EdgeInsets bottomModalSheetPadding =
      EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
  static const EdgeInsets elevatedButtonPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);
  static const EdgeInsets textButtonPadding =
      EdgeInsets.symmetric(horizontal: 20, vertical: 10);

  // Animation Constants
  static const double animationScaleMin = 0.95;
  static const double animationScaleMax = 1.0;
}
