import 'package:flutter/material.dart';

class InputFieldConfig {
  final String key;
  final String hintText;
  final TextInputType keyboardType;
  final IconData activeIcon;
  final IconData inactiveIcon;
  final String semanticsLabel;
  final bool isOptional;
  final String? Function(String?) validator;
  final String? initialValue;
  final TextInputAction textInputAction;
  final void Function(String)? onSubmitted;
  final String? nextFieldKey;
  final bool readOnly;
  final VoidCallback? onTap;
  final VoidCallback? onSuffixIconTap;
  final TextEditingController? controller;

  InputFieldConfig(
      {required this.key,
      required this.hintText,
      required this.keyboardType,
      required this.activeIcon,
      required this.inactiveIcon,
      required this.semanticsLabel,
      this.isOptional = false,
      required this.validator,
      this.initialValue,
      this.textInputAction = TextInputAction.next,
      this.onSubmitted,
      this.nextFieldKey,
      this.readOnly = false,
      this.onTap,
      this.onSuffixIconTap,
      this.controller});
}

class DialogResult {
  final bool isSuccess;
  final String message;
  final Color backgroundColor;

  const DialogResult({
    required this.isSuccess,
    required this.message,
    required this.backgroundColor,
  });
}
