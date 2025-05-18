import 'package:flutter/material.dart';

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
