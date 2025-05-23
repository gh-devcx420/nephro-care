import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/models/bp_monitor_model.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';
import 'package:nephro_care/widgets/nc_divider.dart';
import 'package:nephro_care/widgets/nc_textfield.dart';

class BPMonitorInput extends StatefulWidget {
  final BPMonitor? bpMeasure;

  const BPMonitorInput({super.key, this.bpMeasure});

  @override
  State<BPMonitorInput> createState() => _BPMonitorInputState();
}

class _BPMonitorInputState extends State<BPMonitorInput> {
  late final TextEditingController systolicController;
  late final TextEditingController diastolicController;
  late final TextEditingController pulseController;
  late final TextEditingController spo2Controller;
  late final TextEditingController timeController;
  late final FocusNode systolicFocusNode;
  late final FocusNode diastolicFocusNode;
  late final FocusNode pulseFocusNode;
  late final FocusNode spo2FocusNode;
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

  Future<void> _addBPMeasure(WidgetRef ref) async {
    final errorColor = Theme.of(context).colorScheme.error;
    final user = ref.read(authProvider);

    final systolic = int.tryParse(systolicController.text);
    if (systolic == null || systolic < 50 || systolic > 280) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Please enter a valid systolic value (50–280 mmHg)',
        errorColor,
        durationSeconds: 3,
      );
      return;
    }

    final diastolic = int.tryParse(diastolicController.text);
    if (diastolic == null || diastolic < 30 || diastolic > 180) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Please enter a valid diastolic value (30–180 mmHg)',
        errorColor,
        durationSeconds: 3,
      );
      return;
    }

    if (diastolic >= systolic) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Diastolic can\'t be greater than Systolic',
        errorColor,
        durationSeconds: 3,
      );
      return;
    }

    final pulse = int.tryParse(pulseController.text);
    if (pulse == null || pulse < 20 || pulse > 250) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Please enter a valid pulse value (20–250 bpm)',
        errorColor,
      );
      return;
    }

    final spo2 = spo2Controller.text.isEmpty
        ? null
        : double.tryParse(spo2Controller.text);
    if (spo2 != null && (spo2 < 0 || spo2 > 100)) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'SpO2 must be between 0–100%',
        errorColor,
      );
      return;
    }

    if (selectedTime == null) {
      Navigator.of(context).pop();
      Utils.showSnackBar(
        context,
        'Please select a time',
        errorColor,
      );
      return;
    }

    final dateTime = DateTime.now().copyWith(
      hour: selectedTime!.hour,
      minute: selectedTime!.minute,
    );
    final bpMeasure = BPMonitor(
      id: widget.bpMeasure?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      systolic: systolic,
      diastolic: diastolic,
      pulse: pulse,
      spo2: spo2,
      timestamp: Timestamp.fromDate(dateTime),
    );

    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('bp_monitor')
          .doc(bpMeasure.id)
          .set(bpMeasure.toJson());

      if (!mounted) return;

      Navigator.of(context).pop(
        DialogResult(
          isSuccess: true,
          message: widget.bpMeasure != null
              ? 'Entry updated successfully'
              : 'Entry added successfully',
          backgroundColor: ComponentColors.bloodColorShade2,
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
  void initState() {
    super.initState();
    systolicController = TextEditingController(
      text: widget.bpMeasure?.systolic.toInt().toString() ?? '',
    );
    diastolicController = TextEditingController(
      text: widget.bpMeasure?.diastolic.toInt().toString() ?? '',
    );
    pulseController = TextEditingController(
      text: widget.bpMeasure?.pulse.toInt().toString() ?? '',
    );
    spo2Controller = TextEditingController(
      text: widget.bpMeasure?.spo2?.toInt().toString() ?? '',
    );
    final initialTime = widget.bpMeasure != null
        ? TimeOfDay.fromDateTime(widget.bpMeasure!.timestamp.toDate())
        : TimeOfDay.now();
    timeController = TextEditingController(
      text: Utils.formatTime(
        DateTime.now().copyWith(
          hour: initialTime.hour,
          minute: initialTime.minute,
        ),
      ),
    );
    systolicFocusNode = FocusNode();
    diastolicFocusNode = FocusNode();
    pulseFocusNode = FocusNode();
    spo2FocusNode = FocusNode();
    timeFocusNode = FocusNode();
    selectedTime = initialTime;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(systolicFocusNode);
    });
  }

  @override
  void dispose() {
    systolicController.dispose();
    diastolicController.dispose();
    pulseController.dispose();
    spo2Controller.dispose();
    timeController.dispose();
    systolicFocusNode.dispose();
    diastolicFocusNode.dispose();
    pulseFocusNode.dispose();
    spo2FocusNode.dispose();
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
              const NCDivider(
                thickness: 4,
                color: ComponentColors.bloodColorShade2,
                widthFactor: 0.2,
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
                        widget.bpMeasure != null
                            ? 'Edit Blood Pressure'
                            : 'Enter Blood Pressure Details:',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: ComponentColors.bloodColorShade2,
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
                      key: const ValueKey('systolic_textfield'),
                      hintText: 'Systolic (mmHg)',
                      textFieldController: systolicController,
                      focusNode: systolicFocusNode,
                      keyboardType: TextInputType.number,
                      activeFieldIcon: const Icon(Icons.monitor_heart),
                      inactiveFieldIcon:
                          const Icon(Icons.monitor_heart_outlined),
                      textCapitalization: TextCapitalization.none,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            double.tryParse(value) == null) {
                          systolicController.text =
                              value.substring(0, value.length - 1);
                          systolicController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: systolicController.text.length,
                            ),
                          );
                        }
                      },
                      onSubmitted: (value) {
                        final systolic = int.tryParse(value);
                        if (systolic == null ||
                            systolic < 50 ||
                            systolic > 250) {
                          Navigator.of(context).pop();
                          Utils.showSnackBar(
                            context,
                            'Please enter a valid systolic value (50–250 mmHg)',
                            Theme.of(context).colorScheme.error,
                            durationSeconds: 3,
                          );
                          systolicFocusNode.requestFocus();
                          return;
                        }
                        diastolicFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                      onSuffixIconTap: () => systolicController.clear(),
                      enabledBorderColor: ComponentColors.bloodColorShade2,
                      focusedBorderColor: ComponentColors.bloodColorShade2,
                      prefixIconColor: ComponentColors.bloodColorShade2,
                      textColor: ComponentColors.bloodColorShade2,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: ComponentColors.bloodColorShade2,
                      selectionHandleColor: ComponentColors.bloodColorShade2,
                      semanticsLabel: 'Systolic blood pressure input in mmHg',
                    ),
                  ),
                  hGap8,
                  Expanded(
                    child: NCTextfield(
                      key: const ValueKey('diastolic_textfield'),
                      hintText: 'Diastolic (mmHg)',
                      textFieldController: diastolicController,
                      focusNode: diastolicFocusNode,
                      keyboardType: TextInputType.number,
                      activeFieldIcon: const Icon(Icons.monitor_heart),
                      inactiveFieldIcon:
                          const Icon(Icons.monitor_heart_outlined),
                      textCapitalization: TextCapitalization.none,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            double.tryParse(value) == null) {
                          diastolicController.text =
                              value.substring(0, value.length - 1);
                          diastolicController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: diastolicController.text.length,
                            ),
                          );
                        }
                      },
                      onSubmitted: (value) {
                        final diastolic = int.tryParse(value);
                        if (diastolic == null ||
                            diastolic < 30 ||
                            diastolic > 150) {
                          Navigator.of(context).pop();
                          Utils.showSnackBar(
                            context,
                            'Please enter a valid diastolic value (30–150 mmHg)',
                            Theme.of(context).colorScheme.error,
                            durationSeconds: 3,
                          );
                          diastolicFocusNode.requestFocus();
                          return;
                        }
                        pulseFocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.next,
                      onSuffixIconTap: () => diastolicController.clear(),
                      enabledBorderColor: ComponentColors.bloodColorShade2,
                      focusedBorderColor: ComponentColors.bloodColorShade2,
                      prefixIconColor: ComponentColors.bloodColorShade2,
                      textColor: ComponentColors.bloodColorShade2,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: ComponentColors.bloodColorShade2,
                      selectionHandleColor: ComponentColors.bloodColorShade2,
                      semanticsLabel: 'Diastolic blood pressure input in mmHg',
                    ),
                  ),
                ],
              ),
              vGap8,
              Row(
                children: [
                  Expanded(
                    child: NCTextfield(
                      key: const ValueKey('pulse_textfield'),
                      hintText: 'Pulse (bpm)',
                      textFieldController: pulseController,
                      focusNode: pulseFocusNode,
                      keyboardType: TextInputType.number,
                      activeFieldIcon: const Icon(Icons.favorite),
                      inactiveFieldIcon: const Icon(Icons.favorite_border),
                      textCapitalization: TextCapitalization.none,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            double.tryParse(value) == null) {
                          pulseController.text =
                              value.substring(0, value.length - 1);
                          pulseController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                              offset: pulseController.text.length,
                            ),
                          );
                        }
                      },
                      onSubmitted: (value) {
                        final pulse = int.tryParse(value);
                        if (pulse == null || pulse < 20 || pulse > 250) {
                          Navigator.of(context).pop();
                          Utils.showSnackBar(
                            context,
                            'Please enter a valid pulse value (20–250 bpm)',
                            Theme.of(context).colorScheme.error,
                          );
                          pulseFocusNode.requestFocus();
                          return;
                        }
                        spo2FocusNode.requestFocus();
                      },
                      textInputAction: TextInputAction.done,
                      onSuffixIconTap: () => pulseController.clear(),
                      enabledBorderColor: ComponentColors.bloodColorShade2,
                      focusedBorderColor: ComponentColors.bloodColorShade2,
                      prefixIconColor: ComponentColors.bloodColorShade2,
                      textColor: ComponentColors.bloodColorShade2,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: ComponentColors.bloodColorShade2,
                      selectionHandleColor: ComponentColors.bloodColorShade2,
                      semanticsLabel: 'Pulse input in beats per minute',
                    ),
                  ),
                  hGap8,
                  Expanded(
                    child: NCTextfield(
                      key: const ValueKey('spo2_textfield'),
                      hintText: 'SpO2 (%)',
                      textFieldController: spo2Controller,
                      focusNode: spo2FocusNode,
                      keyboardType: TextInputType.number,
                      activeFieldIcon: const Icon(Icons.air),
                      inactiveFieldIcon: const Icon(Icons.air_outlined),
                      textCapitalization: TextCapitalization.none,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            double.tryParse(value) == null) {
                          spo2Controller.text =
                              value.substring(0, value.length - 1);
                          spo2Controller.selection = TextSelection.fromPosition(
                            TextPosition(
                              offset: spo2Controller.text.length,
                            ),
                          );
                        }
                      },
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          final spo2 = double.tryParse(value);
                          if (spo2 == null || spo2 < 0 || spo2 > 100) {
                            Navigator.of(context).pop();
                            Utils.showSnackBar(
                              context,
                              'SpO2 must be between 0–100%',
                              Theme.of(context).colorScheme.error,
                            );
                            spo2FocusNode.requestFocus();
                            return;
                          }
                        }
                        FocusScope.of(context).unfocus();
                      },
                      textInputAction: TextInputAction.done,
                      onSuffixIconTap: () => spo2Controller.clear(),
                      enabledBorderColor: ComponentColors.bloodColorShade2,
                      focusedBorderColor: ComponentColors.bloodColorShade2,
                      prefixIconColor: ComponentColors.bloodColorShade2,
                      textColor: ComponentColors.bloodColorShade2,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: ComponentColors.bloodColorShade2,
                      selectionHandleColor: ComponentColors.bloodColorShade2,
                      semanticsLabel: 'SpO2 input in percentage',
                    ),
                  ),
                ],
              ),
              vGap8,
              NCTextfield(
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
                enabledBorderColor: ComponentColors.bloodColorShade2,
                focusedBorderColor: ComponentColors.bloodColorShade2,
                prefixIconColor: ComponentColors.bloodColorShade2,
                textColor: ComponentColors.bloodColorShade2,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                hintTextColor: Theme.of(context).colorScheme.secondaryContainer,
                cursorColor: ComponentColors.bloodColorShade2,
                selectionHandleColor: ComponentColors.bloodColorShade2,
                semanticsLabel: 'Time picker for blood pressure measurement',
              ),
              vGap16,
              Consumer(
                builder: (context, ref, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _addBPMeasure(ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ComponentColors.bloodColorShade1,
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
                                    ComponentColors.bloodBackgroundShade,
                                color: ComponentColors.bloodColorShade2,
                              ),
                            )
                          : Text(
                              widget.bpMeasure != null
                                  ? 'Update'
                                  : 'Add Measurement',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: ComponentColors.bloodBackgroundShade,
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
