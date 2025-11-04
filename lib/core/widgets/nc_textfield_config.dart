import 'package:flutter/material.dart';

class NCTextFieldConfig {
  final String key;

  /// Controller managing the text field's state
  final TextEditingController? controller;

  /// Focus Node for managing the text field's focus state
  final FocusNode? focusNode;

  /// Initial text value when the field is first displayed
  final String? initialValue;

  /// Hint text shown when the field is empty
  final String hintText;

  /// Accessibility label for assistive technologies
  final String semanticsLabel;

  /// Icon displayed when the field is focused/active
  final IconData activeIcon;

  /// Icon displayed when the field is unfocused/inactive
  final IconData inactiveIcon;

  /// If true, disables text input
  final bool? readOnly;

  /// Color for the input widget
  final Color? inputWidgetColor;

  /// Type of keyboard to display
  final TextInputType? keyboardType;

  /// Keyboard action button type
  final TextInputAction? textInputAction;

  /// Field validation error message
  final String? errorText;

  /// Callback triggered on field tap
  final VoidCallback? onTap;

  /// Callback triggered on text change
  final void Function(String)? onChanged;

  /// Validation logic callback
  final String? Function(String?)? validator;

  /// Callback triggered on submit action
  final void Function(String)? onSubmitted;

  /// Callback triggered on suffix icon tap
  final VoidCallback? onSuffixIconTap;

  /// Identifier for the next input field to focus
  final String? nextFieldKey;

  const NCTextFieldConfig({
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

  /// Creates a copy of this config with some fields replaced
  NCTextFieldConfig copyWith({
    String? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? initialValue,
    String? hintText,
    String? semanticsLabel,
    IconData? activeIcon,
    IconData? inactiveIcon,
    bool? readOnly,
    Color? inputWidgetColor,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    String? errorText,
    VoidCallback? onTap,
    void Function(String)? onChanged,
    String? Function(String?)? validator,
    void Function(String)? onSubmitted,
    VoidCallback? onSuffixIconTap,
    String? nextFieldKey,
  }) {
    return NCTextFieldConfig(
      key: key ?? this.key,
      controller: controller ?? this.controller,
      focusNode: focusNode ?? this.focusNode,
      initialValue: initialValue ?? this.initialValue,
      hintText: hintText ?? this.hintText,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      activeIcon: activeIcon ?? this.activeIcon,
      inactiveIcon: inactiveIcon ?? this.inactiveIcon,
      readOnly: readOnly ?? this.readOnly,
      inputWidgetColor: inputWidgetColor ?? this.inputWidgetColor,
      keyboardType: keyboardType ?? this.keyboardType,
      textInputAction: textInputAction ?? this.textInputAction,
      errorText: errorText ?? this.errorText,
      onTap: onTap ?? this.onTap,
      onChanged: onChanged ?? this.onChanged,
      validator: validator ?? this.validator,
      onSubmitted: onSubmitted ?? this.onSubmitted,
      onSuffixIconTap: onSuffixIconTap ?? this.onSuffixIconTap,
      nextFieldKey: nextFieldKey ?? this.nextFieldKey,
    );
  }

  @override
  String toString() {
    return 'NCTextFieldConfig(key: $key, hintText: $hintText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NCTextFieldConfig &&
        other.key == key &&
        other.hintText == hintText &&
        other.semanticsLabel == semanticsLabel;
  }

  @override
  int get hashCode => Object.hash(key, hintText, semanticsLabel);
}
