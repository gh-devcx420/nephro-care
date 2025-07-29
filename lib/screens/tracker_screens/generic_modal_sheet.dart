import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/utils/date_time_utils.dart';
import 'package:nephro_care/utils/ui_utils.dart';
import 'package:nephro_care/widgets/nc_divider.dart';
import 'package:nephro_care/widgets/nc_textfield.dart';

mixin TimePickerMixin<T extends StatefulWidget> on State<T> {
  TimeOfDay? selectedTime;
  late TextEditingController timeController;

  void initTimePicker(DateTime initialTime) {
    selectedTime = TimeOfDay.fromDateTime(initialTime);
    timeController =
        TextEditingController(text: DateTimeUtils.formatTime(initialTime));
  }

  void disposeTimePicker() {
    timeController.dispose();
  }

  Future<void> showTimePickerDialog() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (!mounted) return;

    if (pickedTime == null) {
      setState(() {
        selectedTime = null;
        timeController.text = '';
      });
      return;
    }

    final now = DateTime.now();
    final pickedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (pickedDateTime.isAfter(now)) {
      UIUtils.showSnackBar(
        context,
        'Cannot select a future time',
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    setState(() {
      selectedTime = pickedTime;
      timeController.text = pickedTime.format(context);
    });
  }
}

class GenericInputModalSheet<T> extends StatefulWidget {
  final String title;
  final String editTitle;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final String firestoreCollection;
  final List<InputFieldConfig> inputFields;
  final T? initialData;
  final String? initialFocusFieldKey;
  final Widget Function(
    BuildContext,
    Map<String, Widget>,
    Widget Function(BuildContext),
  ) layoutBuilder;
  final Future<DialogResult> Function(
    Map<String, String>,
    WidgetRef,
  ) onSave;
  final double dividerThickness;
  final double dividerWidthFactor;

  const GenericInputModalSheet({
    super.key,
    required this.title,
    required this.editTitle,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.firestoreCollection,
    required this.inputFields,
    this.initialData,
    this.initialFocusFieldKey,
    required this.layoutBuilder,
    required this.onSave,
    this.dividerThickness = 4.0,
    this.dividerWidthFactor = 0.2,
  });

  @override
  State<GenericInputModalSheet<T>> createState() =>
      _GenericInputModalSheetState<T>();
}

class _GenericInputModalSheetState<T> extends State<GenericInputModalSheet<T>> {
  late final Map<String, TextEditingController> controllers;
  late final Map<String, FocusNode> focusNodes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    controllers = {
      for (var inputFields in widget.inputFields)
        inputFields.key: inputFields.controller ??
            TextEditingController(text: inputFields.initialValue)
    };
    focusNodes = {
      for (var inputFields in widget.inputFields) inputFields.key: FocusNode()
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final focusKey =
          widget.initialFocusFieldKey ?? widget.inputFields.first.key;
      if (focusNodes.containsKey(focusKey)) {
        focusNodes[focusKey]!.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      if (!widget.inputFields.any((inputFields) =>
          inputFields.key == key && inputFields.controller == controller)) {
        controller.dispose();
      }
    });
    focusNodes.forEach((_, focusNode) => focusNode.dispose());
    super.dispose();
  }

  Future<void> _submit(WidgetRef ref) async {
    final errorColor = Theme.of(context).colorScheme.error;
    final values = <String, String>{};
    for (var inputFields in widget.inputFields) {
      final value = controllers[inputFields.key]!.text.trim();
      if (!inputFields.isOptional && value.isEmpty) {
        Navigator.of(context).pop();
        UIUtils.showSnackBar(
          context,
          'Please enter a valid ${inputFields.hintText.toLowerCase()}',
          errorColor,
        );
        return;
      }
      final validationError = inputFields.validator(value);
      if (validationError != null) {
        Navigator.of(context).pop();
        UIUtils.showSnackBar(context, validationError, errorColor);
        return;
      }
      values[inputFields.key] = value;
    }

    setState(() => isLoading = true);
    final result = await widget.onSave(values, ref);
    if (!mounted) return;
    setState(() => isLoading = false);
    Navigator.of(context).pop(result);
  }

  Widget _buildTextField(InputFieldConfig inputFieldConfig) {
    return NCTextfield(
      key: ValueKey(inputFieldConfig.key),
      hintText: inputFieldConfig.hintText,
      textFieldController: controllers[inputFieldConfig.key]!,
      focusNode: focusNodes[inputFieldConfig.key]!,
      keyboardType: inputFieldConfig.keyboardType,
      activeFieldIcon: Icon(inputFieldConfig.activeIcon),
      inactiveFieldIcon: Icon(inputFieldConfig.inactiveIcon),
      textCapitalization: TextCapitalization.words,
      readOnly: inputFieldConfig.readOnly,
      onTap: inputFieldConfig.onTap,
      onChanged: (value) {
        if (value.isNotEmpty &&
            inputFieldConfig.keyboardType == TextInputType.number &&
            double.tryParse(value) == null) {
          controllers[inputFieldConfig.key]!.text =
              value.substring(0, value.length - 1);
          controllers[inputFieldConfig.key]!.selection =
              TextSelection.fromPosition(
            TextPosition(
                offset: controllers[inputFieldConfig.key]!.text.length),
          );
        }
      },
      onSubmitted: (value) {
        inputFieldConfig.onSubmitted?.call(value);
        if (inputFieldConfig.nextFieldKey != null &&
            focusNodes.containsKey(inputFieldConfig.nextFieldKey)) {
          focusNodes[inputFieldConfig.nextFieldKey]!.requestFocus();
        }
      },
      textInputAction: inputFieldConfig.textInputAction,
      onSuffixIconTap: inputFieldConfig.onSuffixIconTap ??
          () => controllers[inputFieldConfig.key]!.clear(),
      enabledBorderColor: widget.primaryColor,
      focusedBorderColor: widget.primaryColor,
      prefixIconColor: widget.primaryColor,
      textColor: widget.primaryColor,
      fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      hintTextColor: Theme.of(context).colorScheme.secondaryContainer,
      cursorColor: widget.primaryColor,
      selectionHandleColor: widget.primaryColor,
      semanticsLabel: inputFieldConfig.semanticsLabel,
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : () => _submit(ref),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => widget.primaryColor,
              ),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              foregroundColor: WidgetStateProperty.all(
                widget.backgroundColor,
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      backgroundColor: widget.backgroundColor,
                      color: widget.primaryColor,
                    ),
                  )
                : Text(
                    widget.initialData != null ? 'Update' : 'Add Entry',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: widget.backgroundColor,
                        ),
                  ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final fields = {
      for (var config in widget.inputFields) config.key: _buildTextField(config)
    };

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NCDivider(
                thickness: widget.dividerThickness,
                color: widget.primaryColor,
                widthFactor: widget.dividerWidthFactor,
              ),
              vGap4,
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Text(
                        widget.initialData != null
                            ? widget.editTitle
                            : widget.title,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: widget.primaryColor,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              vGap8,
              widget.layoutBuilder(context, fields, _buildSubmitButton),
              vGap16,
            ],
          ),
        ),
      ),
    );
  }
}
