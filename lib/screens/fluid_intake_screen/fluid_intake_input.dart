import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';
import 'package:nephro_care/widgets/nc_textfield.dart';

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

class FluidIntakeInput extends StatefulWidget {
  final FluidIntake? intake;

  const FluidIntakeInput({super.key, this.intake});

  @override
  State<FluidIntakeInput> createState() => _FluidIntakeInputState();
}

class _FluidIntakeInputState extends State<FluidIntakeInput> {
  late final TextEditingController fluidNameController;
  late final TextEditingController quantityController;
  late final TextEditingController timeController;
  late final FocusNode fluidNameFocusNode;
  late final FocusNode quantityFocusNode;
  TimeOfDay? selectedTime;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fluidNameController =
        TextEditingController(text: widget.intake?.fluidName ?? 'Water');
    quantityController =
        TextEditingController(text: widget.intake?.quantity.toString() ?? '');
    final initialTime = widget.intake != null
        ? TimeOfDay.fromDateTime(widget.intake!.timestamp.toDate())
        : TimeOfDay.now();
    timeController = TextEditingController(
      text: Utils.formatTime(DateTime.now().copyWith(
        hour: initialTime.hour,
        minute: initialTime.minute,
      )),
    );
    fluidNameFocusNode = FocusNode();
    quantityFocusNode = FocusNode();
    selectedTime = initialTime;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(quantityFocusNode);
    });
  }

  @override
  void dispose() {
    fluidNameController.dispose();
    quantityController.dispose();
    timeController.dispose();
    fluidNameFocusNode.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  Future<void> _showTimePicker() async {
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
      Utils.showSnackBar(context, 'Cannot select a future time',
          Theme.of(context).colorScheme.error);
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      selectedTime = pickedTime;
      timeController.text = pickedTime.format(context);
    });
  }

  Future<void> _addIntake(WidgetRef ref) async {
    final errorColor = Theme.of(context).colorScheme.error;
    final fluidName = fluidNameController.text.trim();

    // Validate inputs
    if (fluidName.isEmpty) {
      Utils.showSnackBar(
          context, 'Please enter a valid fluid name', errorColor);
      return Navigator.of(context).pop();
    }

    final quantity = double.tryParse(quantityController.text);
    if (quantity == null) {
      Utils.showSnackBar(context, 'Please enter a valid quantity', errorColor);
      return Navigator.of(context).pop();
    }

    if (quantity > 1000) {
      Utils.showSnackBar(context, 'Quantity cannot exceed 1000ml', errorColor);
      return Navigator.of(context).pop();
    }

    if (selectedTime == null) {
      Utils.showSnackBar(context, 'Please select a time', errorColor);
      return Navigator.of(context).pop();
    }

    final user = ref.read(authProvider);
    if (user == null) {
      Utils.showSnackBar(context, 'Please sign in to add entries', errorColor);
      return Navigator.of(context).pop();
    }

    // Construct FluidIntake instance
    final dateTime = DateTime.now().copyWith(
      hour: selectedTime!.hour,
      minute: selectedTime!.minute,
    );
    final intake = FluidIntake(
      id: widget.intake?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      fluidName: fluidName,
      quantity: quantity,
      timestamp: Timestamp.fromDate(dateTime),
    );

    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fluid_intake')
          .doc(intake.id)
          .set(intake.toJson());

      if (!mounted) return;

      Navigator.of(context).pop(
        DialogResult(
          isSuccess: true,
          message: widget.intake != null
              ? 'Entry updated successfully'
              : 'Entry added successfully',
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      Utils.showSnackBar(context, 'Failed to save entry: $e', errorColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    const waterShade = ComponentColors.waterColorShade2;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  hGap4,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Text(
                        widget.intake != null
                            ? 'Edit Fluid Intake'
                            : 'Enter Fluid Intake Details:',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: waterShade),
                      ),
                    ),
                  ),
                ],
              ),
              vGap8,
              NCTextfield(
                key: const ValueKey('fluidName_textfield'),
                hintText: 'Fluid Name',
                textFieldController: fluidNameController,
                focusNode: fluidNameFocusNode,
                maxLength: 18,
                onSuffixIconTap: () {
                  setState(() {
                    fluidNameController.clear();
                    fluidNameFocusNode.requestFocus();
                  });
                },
                activeFieldIcon: const Icon(Icons.local_drink),
                inactiveFieldIcon: const Icon(Icons.local_drink_outlined),
                enabledBorderColor: waterShade,
                focusedBorderColor: waterShade,
                prefixIconColor: waterShade,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                textColor: waterShade,
                hintTextColor: Theme.of(context).colorScheme.secondaryContainer,
                cursorColor: waterShade,
                selectionHandleColor: waterShade,
              ),
              vGap16,
              Row(
                children: [
                  Expanded(
                    child: NCTextfield(
                      key: const ValueKey('quantity_textfield'),
                      hintText: 'Quantity (ml)',
                      textFieldController: quantityController,
                      focusNode: quantityFocusNode,
                      keyboardType: TextInputType.number,
                      activeFieldIcon: const Icon(Icons.water_drop),
                      inactiveFieldIcon: const Icon(Icons.water_drop_outlined),
                      textCapitalization: TextCapitalization.none,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            double.tryParse(value) == null) {
                          quantityController.text =
                              value.substring(0, value.length - 1);
                          quantityController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: quantityController.text.length),
                          );
                        }
                      },
                      onSuffixIconTap: () => quantityController.clear(),
                      enabledBorderColor: waterShade,
                      focusedBorderColor: waterShade,
                      prefixIconColor: waterShade,
                      textColor: waterShade,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: waterShade,
                      selectionHandleColor: waterShade,
                    ),
                  ),
                  hGap8,
                  Expanded(
                    child: NCTextfield(
                      key: const ValueKey('timepicker_textfield'),
                      hintText: 'Time',
                      textFieldController: timeController,
                      activeFieldIcon: const Icon(Icons.timer_rounded),
                      inactiveFieldIcon: const Icon(Icons.timer_outlined),
                      textCapitalization: TextCapitalization.none,
                      onTap: _showTimePicker,
                      onSuffixIconTap: () {
                        setState(() {
                          selectedTime = TimeOfDay.now();
                          timeController.clear();
                        });
                        _showTimePicker();
                      },
                      enabledBorderColor: waterShade,
                      focusedBorderColor: waterShade,
                      prefixIconColor: waterShade,
                      textColor: waterShade,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: waterShade,
                      selectionHandleColor: waterShade,
                    ),
                  ),
                ],
              ),
              vGap16,
              Consumer(
                builder: (context, ref, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _addIntake(ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: waterShade,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                backgroundColor:
                                    ComponentColors.waterBackgroundColor,
                                color: ComponentColors.waterColorShade2,
                              ),
                            )
                          : Text(
                              widget.intake != null ? 'Update' : 'Add Intake',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: ComponentColors.waterBackgroundColor,
                                  ),
                            ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
