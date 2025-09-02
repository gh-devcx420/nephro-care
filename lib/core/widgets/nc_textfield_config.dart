import 'package:flutter/material.dart';

class NCTextFieldConfig {
  // Identification & Core Control
  final String key; // Unique identifier for the widget instance
  final TextEditingController?
      controller; // Controller managing the text field's state
  final FocusNode?
      focusNode; // Focus Node for managing the text field's focus state
  final String?
      initialValue; // Initial text value when the field is first displayed

  // Content & Accessibility
  final String hintText; // Hint text shown when the field is empty
  final String semanticsLabel; // Accessibility label for assistive technologies
  final IconData activeIcon; // Icon displayed when the field is focused/active
  final IconData
      inactiveIcon; // Icon displayed when the field is unfocused/inactive

  // Input Behavior & Configuration
  final bool? readOnly; // If true, disables text input
  final Color? inputWidgetColor;
  final TextInputType? keyboardType; // Type of keyboard to display
  final TextInputAction? textInputAction; // Keyboard action button type
  final String? errorText; // Field validation error message

  // Event Callbacks
  final VoidCallback? onTap; // Callback triggered on field tap
  final void Function(String)? onChanged; // Callback triggered on text change
  final String? Function(String?)? validator; // Validation logic callback
  final void Function(String)?
      onSubmitted; // Callback triggered on submit action
  final VoidCallback? onSuffixIconTap; // Callback triggered on suffix icon tap

  // Navigation & Field Chaining
  final String? nextFieldKey; // Identifier for the next input field to focus

  NCTextFieldConfig({
    // Identification & Core Control
    required this.key,
    this.controller,
    this.focusNode,
    this.initialValue,

    // Content & Accessibility
    required this.hintText,
    required this.semanticsLabel,
    required this.activeIcon,
    required this.inactiveIcon,

    // Input Behavior & Configuration
    this.readOnly,
    this.inputWidgetColor,
    this.keyboardType,
    this.textInputAction,
    this.errorText,

    // Event Callbacks
    this.onTap,
    this.onChanged,
    this.validator,
    this.onSubmitted,
    this.onSuffixIconTap,

    // Navigation & Field Chaining
    this.nextFieldKey,
  });
}
