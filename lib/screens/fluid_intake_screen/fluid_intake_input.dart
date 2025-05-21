import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/models/other_generic_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';
import 'package:nephro_care/widgets/nc_textfield.dart';

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
  late final FocusNode timeFocusNode;
  TimeOfDay? selectedTime;
  bool isLoading = false;

  final _fluidColors = {
    'shade1': ComponentColors.waterColorShade1,
    'shade2': ComponentColors.waterColorShade2,
    'background': ComponentColors.waterBackgroundShade,
  };

  @override
  void initState() {
    super.initState();
    fluidNameController =
        TextEditingController(text: widget.intake?.fluidName ?? 'Water');
    quantityController = TextEditingController(
        text: widget.intake?.quantity.toInt().toString() ?? '');
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
    timeFocusNode = FocusNode();
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
    timeFocusNode.dispose();
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
      Navigator.of(context).pop();
      Utils.showSnackBar(
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

    FocusScope.of(context).unfocus();
  }

  Future<void> _addIntake(WidgetRef ref) async {
    final errorColor = Theme.of(context).colorScheme.error;
    final fluidName = fluidNameController.text.trim();
    final user = ref.read(authProvider);

    if (fluidName.isEmpty) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Please enter a valid fluid name',
        errorColor,
      );
      return;
    }

    final quantity = double.tryParse(quantityController.text);
    if (quantity == null) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Please enter a valid quantity.',
        errorColor,
      );
      return;
    }

    if (quantity > 1000) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Quantity cannot exceed 1000ml.',
        errorColor,
      );
      return;
    }

    if (selectedTime == null) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Please select a time.',
        errorColor,
      );
      return;
    }

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
          .doc(user!.uid)
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
          backgroundColor: _fluidColors['shade2']!,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      Utils.showSnackBar(
        context,
        'Failed to save entry: $e',
        errorColor,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Center(
                child: SizedBox(
                  width: 60,
                  child: Divider(
                    thickness: 4,
                    color: _fluidColors['shade2'],
                  ),
                ),
              ),
              vGap8,
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
                            .copyWith(color: _fluidColors['shade2']!),
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
                enabledBorderColor: _fluidColors['shade2']!,
                focusedBorderColor: _fluidColors['shade2']!,
                prefixIconColor: _fluidColors['shade2']!,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                textColor: _fluidColors['shade2']!,
                hintTextColor: Theme.of(context).colorScheme.secondaryContainer,
                cursorColor: _fluidColors['shade2']!,
                selectionHandleColor: _fluidColors['shade2']!,
                semanticsLabel: 'Fluid name input',
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
                              offset: quantityController.text.length,
                            ),
                          );
                        }
                      },
                      onSuffixIconTap: () => quantityController.clear(),
                      enabledBorderColor: _fluidColors['shade2']!,
                      focusedBorderColor: _fluidColors['shade2']!,
                      prefixIconColor: _fluidColors['shade2']!,
                      textColor: _fluidColors['shade2']!,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: _fluidColors['shade2']!,
                      selectionHandleColor: _fluidColors['shade2']!,
                      semanticsLabel: 'Quantity input in milliliters',
                    ),
                  ),
                  hGap8,
                  Expanded(
                    child: NCTextfield(
                      key: const ValueKey('timepicker_textfield'),
                      hintText: 'Time',
                      textFieldController: timeController,
                      focusNode: timeFocusNode,
                      activeFieldIcon: const Icon(Icons.timer_rounded),
                      inactiveFieldIcon: const Icon(Icons.timer_outlined),
                      textCapitalization: TextCapitalization.none,
                      readOnly: true,
                      keyboardType: TextInputType.none,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showTimePicker();
                      },
                      onSuffixIconTap: () {
                        setState(() {
                          selectedTime = TimeOfDay.now();
                          timeController.clear();
                        });
                        FocusScope.of(context).unfocus();
                        _showTimePicker();
                      },
                      enabledBorderColor: _fluidColors['shade2']!,
                      focusedBorderColor: _fluidColors['shade2']!,
                      prefixIconColor: _fluidColors['shade2']!,
                      textColor: _fluidColors['shade2']!,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: _fluidColors['shade2']!,
                      selectionHandleColor: _fluidColors['shade2']!,
                      semanticsLabel: 'Time picker for fluid intake',
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
                        backgroundColor: _fluidColors['shade1']!,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                backgroundColor:
                                    ComponentColors.waterBackgroundShade,
                                color: ComponentColors.waterColorShade2,
                              ),
                            )
                          : Text(
                              widget.intake != null ? 'Update' : 'Add Intake',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: _fluidColors['background']!,
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
