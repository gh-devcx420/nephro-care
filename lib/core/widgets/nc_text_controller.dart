import 'package:flutter/material.dart';

class NCTextEditingController extends TextEditingController {
  final String suffix;
  String _numericValue = '';

  NCTextEditingController({required this.suffix});

  @override
  String get text => _numericValue.isEmpty ? '' : '$_numericValue $suffix';

  String get numericValue => _numericValue;

  @override
  set text(String newValue) {
    _numericValue = newValue.replaceAll(' $suffix', '');
    super.text = _numericValue;
  }

  @override
  TextEditingValue get value {
    return TextEditingValue(
      text: _numericValue.isEmpty ? '' : '$_numericValue $suffix',
      selection: TextSelection.collapsed(
        offset: _numericValue.length,
      ),
    );
  }

  @override
  set value(TextEditingValue newValue) {
    final valueWithoutSuffix = newValue.text.replaceAll(' $suffix', '');
    _numericValue = valueWithoutSuffix;
    super.value = TextEditingValue(
      text: _numericValue,
      selection: TextSelection.collapsed(
        offset: valueWithoutSuffix.length,
      ),
    );
  }
}
