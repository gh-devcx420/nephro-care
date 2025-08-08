import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/constants/enums.dart';

class MeasurementUtils {
  // Splits the input into number and unit for RichText creation
  // Enables flexible formatting for fluid (ml/L), BP (mmHg), weight (kg), etc.
  static ({String number, String unit}) formatValueForRichText(
    dynamic value,
    MeasurementType type,
  ) {
    if (value == null) return (number: 'N/A', unit: '');
    double? numValue;

    if (value is String) {
      final numericText = value.replaceAll(RegExp(r'[^0-9.]'), '').trim();
      numValue = double.tryParse(numericText);
    } else if (value is double) {
      numValue = value;
    } else if (value is int) {
      numValue = value.toDouble();
    }

    if (numValue == null) return (number: value.toString(), unit: '');

    switch (type) {
      case MeasurementType.fluid:
        if (numValue >= 1000) {
          final litres = numValue / 1000;
          return (
            number: litres
                .toStringAsFixed(2)
                .replaceAll(RegExp(r'0+$'), '')
                .replaceAll(RegExp(r'\.$'), ''),
            unit: siUnitEnumMap[SIUnitEnum.fluidsSIUnitLitres]!
          );
        } else {
          return (
            number: numValue.toInt().toString(),
            unit: siUnitEnumMap[SIUnitEnum.fluidsSIUnitML]!
          );
        }
      case MeasurementType.bp:
        return (
          number: numValue.toInt().toString(),
          unit: siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]!
        );
      case MeasurementType.pulse:
        return (
          number: numValue.toInt().toString(),
          unit: siUnitEnumMap[SIUnitEnum.pulseSIUnit]!
        );
      case MeasurementType.spo2:
        return (
          number: numValue.toStringAsFixed(1),
          unit: siUnitEnumMap[SIUnitEnum.percentSIUnit]!
        );
      case MeasurementType.weight:
        return (
          number: numValue
              .toStringAsFixed(2)
              .replaceAll(RegExp(r'0+$'), '')
              .replaceAll(RegExp(r'\.$'), ''),
          unit: 'kg'
        );
    }
  }

  // Creates RichText with number and unit, allowing different font sizes
  // Provides clean UI rendering for values with units (e.g., 500 ml, 120/80 mmHg)
  static RichText createRichTextValueWithUnit({
    required String value,
    required String unit,
    required TextStyle valueStyle,
    required TextStyle unitStyle,
    String? prefixText,
    TextStyle? prefixStyle,
  }) {
    return RichText(
      text: TextSpan(
        children: [
          if (prefixText != null)
            TextSpan(
              text: prefixText,
              style: prefixStyle ?? valueStyle,
            ),
          TextSpan(
            text: value,
            style: valueStyle,
          ),
          if (unit.isNotEmpty)
            TextSpan(
              text: ' $unit',
              style: unitStyle,
            ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  // Creates RichText for timestamps with customizable label and time styles
  // Ensures consistent timestamp rendering (e.g., "Time: 6:50 pm") across widgets
  // Updated to support separate styling for time and meridiem indicator
  static RichText createRichTextTimestamp({
    required DateTime? timestamp,
    required TextStyle timeStyle,
    required TextStyle meridiemStyle,
    String? prefixText,
    TextStyle? prefixStyle,
    double? timeFontSize,
    bool isMeridiemUpperCase = true,
  }) {
    String timeText = 'Unknown';
    String meridiemIndicatorText = '';

    if (timestamp != null) {
      final timeFormat = DateFormat('h:mm');
      timeText = timeFormat.format(timestamp);
      final meridiemFormat = DateFormat('a');
      meridiemIndicatorText = meridiemFormat.format(timestamp);
      if (!isMeridiemUpperCase) {
        meridiemIndicatorText = meridiemIndicatorText.toLowerCase();
      }
    }

    return RichText(
      text: TextSpan(
        children: [
          if (prefixText != null)
            TextSpan(
              text: prefixText,
              style: prefixStyle ?? timeStyle,
            ),
          TextSpan(
            text: timeText,
            style: timeFontSize != null
                ? timeStyle.copyWith(fontSize: timeFontSize)
                : timeStyle,
          ),
          if (timestamp != null)
            TextSpan(
              text: ' $meridiemIndicatorText',
              style: meridiemStyle,
            ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
