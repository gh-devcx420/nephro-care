import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/models/urine_output_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';
import 'package:nephro_care/widgets/nc_textfield.dart';

import '../../../widgets/nc_divider.dart';

class UrineOutputInput extends StatefulWidget {
  final UrineOutput? output;

  const UrineOutputInput({super.key, this.output});

  @override
  State<UrineOutputInput> createState() => _UrineOutputInputState();
}

class _UrineOutputInputState extends State<UrineOutputInput> {
  late final TextEditingController quantityController;
  late final TextEditingController timeController;
  late final FocusNode quantityFocusNode;
  late final FocusNode timeFocusNode;
  TimeOfDay? selectedTime;
  bool isLoading = false;

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

  Future<void> _addOutput(WidgetRef ref) async {
    final errorColor = Theme.of(context).colorScheme.error;
    final user = ref.read(authProvider);
    final quantity = double.tryParse(quantityController.text);
    if (quantity == null) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Please enter a valid quantity',
        errorColor,
      );
      return;
    }

    if (quantity > 1500) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Quantity cannot exceed 1500ml.',
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
    final output = UrineOutput(
      id: widget.output?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      outputName: 'Urine',
      quantity: quantity,
      timestamp: Timestamp.fromDate(dateTime),
    );

    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('urine_output')
          .doc(output.id)
          .set(output.toJson());

      if (!mounted) return;

      Navigator.of(context).pop(
        DialogResult(
          isSuccess: true,
          message: widget.output != null
              ? 'Entry updated successfully'
              : 'Entry added successfully',
          backgroundColor: ComponentColors.urineColorShade2,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => isLoading = false);
      Navigator.of(context).pop(
        DialogResult(
          isSuccess: false,
          message: 'Failed to save entry: $e',
          backgroundColor: errorColor,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    quantityController = TextEditingController(
      text: widget.output?.quantity.toInt().toString() ?? '',
    );
    final initialTime = widget.output != null
        ? TimeOfDay.fromDateTime(widget.output!.timestamp.toDate())
        : TimeOfDay.now();
    timeController = TextEditingController(
      text: Utils.formatTime(
        DateTime.now().copyWith(
          hour: initialTime.hour,
          minute: initialTime.minute,
        ),
      ),
    );
    quantityFocusNode = FocusNode();
    timeFocusNode = FocusNode();
    selectedTime = initialTime;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(quantityFocusNode);
    });
  }

  @override
  void dispose() {
    quantityController.dispose();
    timeController.dispose();
    quantityFocusNode.dispose();
    timeFocusNode.dispose();
    super.dispose();
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
              const Center(
                child: NCDivider(
                  thickness: 4,
                  color: ComponentColors.urineColorShade2,
                  widthFactor: 0.2,
                ),
              ),
              vGap10,
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
                        widget.output != null
                            ? 'Edit Urine Output'
                            : 'Enter Urine Output Details:',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: ComponentColors.urineColorShade2,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              vGap8,
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
                      enabledBorderColor: ComponentColors.urineColorShade2,
                      focusedBorderColor: ComponentColors.urineColorShade2,
                      prefixIconColor: ComponentColors.urineColorShade2,
                      textColor: ComponentColors.urineColorShade2,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: ComponentColors.urineColorShade2,
                      selectionHandleColor: ComponentColors.urineColorShade2,
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
                      enabledBorderColor: ComponentColors.urineColorShade2,
                      focusedBorderColor: ComponentColors.urineColorShade2,
                      prefixIconColor: ComponentColors.urineColorShade2,
                      textColor: ComponentColors.urineColorShade2,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: ComponentColors.urineColorShade2,
                      selectionHandleColor: ComponentColors.urineColorShade2,
                      semanticsLabel: 'Time picker for urine output',
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
                      onPressed: isLoading ? null : () => _addOutput(ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ComponentColors.urineColorShade1,
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
                                    ComponentColors.urineBackgroundShade,
                                color: ComponentColors.urineColorShade2,
                              ),
                            )
                          : Text(
                              widget.output != null ? 'Update' : 'Add Output',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: ComponentColors.urineBackgroundShade,
                                  ),
                            ),
                    ),
                  );
                },
              ),
              vGap16,
            ],
          ),
        ),
      ),
    );
  }
}
