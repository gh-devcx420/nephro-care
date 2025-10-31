class Measurement<T extends Enum> {
  final double? value;
  final String? formattedValue;
  final T? unit;
  final String? unitString;
  final String? displayValue;
  final bool isValid;

  const Measurement({
    required this.value,
    required this.formattedValue,
    required this.unit,
    required this.unitString,
    this.displayValue,
    required this.isValid,
  });

  static Measurement<T> invalid<T extends Enum>() => Measurement<T>(
        value: null,
        formattedValue: null,
        unit: null,
        unitString: null,
        displayValue: null,
        isValid: false,
      );
}
