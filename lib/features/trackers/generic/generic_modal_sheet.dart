import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/core/widgets/nc_textfield.dart';
import 'package:nephro_care/core/widgets/nc_textfield_config.dart';

mixin TimePickerMixin<T extends StatefulWidget> on State<T> {
  TimeOfDay? selectedTime;
  late TextEditingController timeController;

  void initTimePicker(DateTime initialTime) {
    selectedTime = TimeOfDay.fromDateTime(initialTime);
    timeController = TextEditingController(
      text: DateTimeUtils.formatTime(initialTime),
    );
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
        selectedTime = TimeOfDay.now();
        timeController.text = selectedTime!.format(context);
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
      setState(() {
        selectedTime = TimeOfDay.now();
        timeController.text = selectedTime!.format(context);
      });
      UIUtils.showNCSnackBar(
        context: context,
        message: 'Cannot select a future time',
        backgroundColor: Theme.of(context).colorScheme.error,
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
  final String addModeTitle;
  final String editingModeTitle;
  final T? initialData;
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? backgroundColor;
  final List<NCTextFieldConfig> inputFields;
  final String? initialFocusFieldKey;
  final Widget Function(
    BuildContext,
    Map<String, Widget>,
    Widget Function(BuildContext),
  ) layoutConfig;
  final FirestoreService firestoreService;
  final Future<Result> Function(
    Map<String, String>,
    WidgetRef,
    FirestoreService,
  ) onSave;
  final double dividerThickness;
  final double dividerWidthFactor;

  const GenericInputModalSheet({
    super.key,
    required this.addModeTitle,
    required this.editingModeTitle,
    required this.primaryColor,
    required this.secondaryColor,
    this.backgroundColor,
    required this.inputFields,
    this.initialData,
    this.initialFocusFieldKey,
    required this.layoutConfig,
    required this.firestoreService,
    required this.onSave,
    this.dividerThickness = 2.0,
    this.dividerWidthFactor = 0.15,
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
      for (var inputField in widget.inputFields)
        inputField.key: inputField.controller ??
            TextEditingController(
              text: inputField.initialValue,
            )
    };
    focusNodes = {
      for (var inputField in widget.inputFields)
        inputField.key: inputField.focusNode ?? FocusNode()
    };
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NCTextfield.isFirstFocus = true;
      final focusKey =
          widget.initialFocusFieldKey ?? widget.inputFields.first.key;
      if (focusNodes.containsKey(focusKey)) {
        focusNodes[focusKey]!.requestFocus();
      }
      Future.microtask(() => NCTextfield.isFirstFocus = false);
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

  @override
  Widget build(BuildContext context) {
    final fields = {
      for (var config in widget.inputFields) config.key: _buildTextField(config)
    };

    return Consumer(
      builder: (context, ref, child) {
        final isOnlineAsync = ref.watch(connectivityProvider);

        return isOnlineAsync.when(
          data: (isOnline) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                widget.layoutConfig(
                  context,
                  fields,
                  (ctx) => _buildSubmitButton(ctx, isOnline),
                ),
              ],
            );
          },
          loading: () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => SizedBox(
            height: 100,
            child: Center(child: Text('Error: $e')),
          ),
        );
      },
    );
  }

  Widget _buildTextField(NCTextFieldConfig ncTextFieldConfig) {
    return NCTextfield(
      key: ValueKey(ncTextFieldConfig.key),
      textFieldController: controllers[ncTextFieldConfig.key]!,
      hintText: ncTextFieldConfig.hintText,
      semanticsLabel: ncTextFieldConfig.semanticsLabel,
      focusNode: focusNodes[ncTextFieldConfig.key]!,
      keyboardType: ncTextFieldConfig.keyboardType ?? TextInputType.text,
      activeFieldPrefixIcon: Icon(ncTextFieldConfig.activeIcon),
      inactiveFieldPrefixIcon: Icon(ncTextFieldConfig.inactiveIcon),
      textCapitalization: TextCapitalization.words,
      readOnly: ncTextFieldConfig.readOnly ?? false,
      onTap: ncTextFieldConfig.onTap,
      onChanged: (value) => ncTextFieldConfig.onChanged?.call(value),
      onSubmitted: (value) {
        if (ncTextFieldConfig.nextFieldKey != null &&
            focusNodes.containsKey(ncTextFieldConfig.nextFieldKey)) {
          focusNodes[ncTextFieldConfig.nextFieldKey]!.requestFocus();
        }
        ncTextFieldConfig.onSubmitted?.call(value);
      },
      textInputAction:
          ncTextFieldConfig.textInputAction ?? TextInputAction.next,
      onSuffixIconTap: () {
        HapticFeedback.lightImpact();
        ncTextFieldConfig.onSuffixIconTap?.call();
        controllers[ncTextFieldConfig.key]!.clear();
        focusNodes[ncTextFieldConfig.key]!.requestFocus();
      },
      enabledBorderColor: ncTextFieldConfig.inputWidgetColor,
      focusedBorderColor: ncTextFieldConfig.inputWidgetColor,
      prefixIconColor: ncTextFieldConfig.inputWidgetColor,
      cursorColor: ncTextFieldConfig.inputWidgetColor,
      textColor: ncTextFieldConfig.inputWidgetColor,
      selectionHandleColor: ncTextFieldConfig.inputWidgetColor,
    );
  }

  Widget _buildSubmitButton(BuildContext context, bool isOnline) {
    return Consumer(
      builder: (context, ref, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    HapticFeedback.lightImpact();
                    _submit(ref, isOnline);
                  },
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            child: isLoading
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    widget.initialData == null ? 'Add Entry' : 'Update',
                  ),
          ),
        );
      },
    );
  }

  Future<void> _submit(WidgetRef ref, bool isOnline) async {
    final errorColor = Theme.of(context).colorScheme.error;
    final values = <String, String>{};

    for (var inputField in widget.inputFields) {
      final capturedInputValue = controllers[inputField.key]!.text.trim();
      if (inputField.validator != null) {
        final validationError = inputField.validator!(capturedInputValue);
        if (validationError != null) {
          Navigator.of(context).pop();
          UIUtils.showNCSnackBar(
            context: context,
            message: validationError,
            backgroundColor: errorColor,
            durationSeconds: 4,
          );
          return;
        }
      }
      values[inputField.key] = capturedInputValue;
    }

    setState(() => isLoading = true);

    final result = await widget.onSave(values, ref, widget.firestoreService);

    if (!mounted) {
      return;
    }

    setState(() => isLoading = false);

    Navigator.of(context).pop(result);

    if (!result.isSuccess || result.isPendingSync) {
      UIUtils.showNCSnackBar(
        context: context,
        message: result.message,
        backgroundColor: result.backgroundColor,
        durationSeconds: 3,
      );
    }
  }
}
