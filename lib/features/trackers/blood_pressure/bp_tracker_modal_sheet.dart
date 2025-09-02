import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/themes/color_schemes.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_text_controller.dart';
import 'package:nephro_care/core/widgets/nc_textfield_config.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/shared/generic_modal_sheet.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_monitor_model.dart';

class BPTrackerModalSheet extends StatefulWidget {
  final BPTrackerModel? bpMeasure;

  const BPTrackerModalSheet({
    super.key,
    this.bpMeasure,
  });

  @override
  State<BPTrackerModalSheet> createState() => _BPTrackerModalSheetState();
}

class _BPTrackerModalSheetState extends State<BPTrackerModalSheet>
    with TimePickerMixin {
  late final NCTextEditingController _systolicController;
  late final NCTextEditingController _diastolicController;
  late final NCTextEditingController _pulseController;
  late final NCTextEditingController _spo2Controller;

  @override
  void initState() {
    super.initState();
    _systolicController = NCTextEditingController(
        suffix: BloodPressureField.systolic.unit ?? 'mmhg')
      ..text = widget.bpMeasure?.systolic.toInt().toString() ?? '';
    _diastolicController = NCTextEditingController(
        suffix: BloodPressureField.diastolic.unit ?? 'mmhg')
      ..text = widget.bpMeasure?.diastolic.toInt().toString() ?? '';
    _pulseController =
        NCTextEditingController(suffix: BloodPressureField.pulse.unit ?? 'bpm')
          ..text = widget.bpMeasure?.pulse.toInt().toString() ?? '';
    _spo2Controller =
        NCTextEditingController(suffix: BloodPressureField.spo2.unit ?? '%')
          ..text = widget.bpMeasure?.spo2?.toInt().toString() ?? '';
    initTimePicker(widget.bpMeasure?.timestamp.toDate() ?? DateTime.now());
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _pulseController.dispose();
    _spo2Controller.dispose();
    disposeTimePicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericInputModalSheet(
      dividerThickness: 2.0,
      dividerWidthFactor: 0.15,
      title: 'Enter Blood Pressure Details:',
      editTitle: 'Edit Blood Pressure',
      firestoreService: FirestoreService(),
      initialData: widget.bpMeasure,
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      initialFocusFieldKey: BloodPressureField.systolic.name,
      inputFields: [
        NCTextFieldConfig(
          key: BloodPressureField.systolic.name,
          controller: _systolicController,
          hintText: 'Systolic (${BloodPressureField.systolic.unit})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.monitor_heart,
          inactiveIcon: Icons.monitor_heart_outlined,
          semanticsLabel:
              'Systolic blood pressure input in $BloodPressureField.systolic.unit}',
          validator: (value) {
            final numericSystolic = _systolicController.numericValue;
            final systolic = int.tryParse(numericSystolic);
            if (systolic == null || systolic < 50 || systolic > 280) {
              return 'Please enter a valid systolic value (50–280 ${BloodPressureField.systolic.unit})';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          nextFieldKey: BloodPressureField.diastolic.name,
        ),
        NCTextFieldConfig(
          key: BloodPressureField.diastolic.name,
          controller: _diastolicController,
          hintText: 'Diastolic (${BloodPressureField.diastolic.unit})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.monitor_heart,
          inactiveIcon: Icons.monitor_heart_outlined,
          semanticsLabel:
              'Diastolic blood pressure input in ${BloodPressureField.diastolic.unit}',
          validator: (value) {
            final numericDiastolic = _diastolicController.numericValue;
            final diastolic = int.tryParse(numericDiastolic);
            if (diastolic == null || diastolic < 30 || diastolic > 180) {
              return 'Please enter a valid diastolic value (30–180 ${BloodPressureField.diastolic.unit})';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          nextFieldKey: BloodPressureField.pulse.name,
        ),
        NCTextFieldConfig(
          key: BloodPressureField.pulse.name,
          controller: _pulseController,
          hintText: 'Pulse (${BloodPressureField.pulse.unit})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.favorite,
          inactiveIcon: Icons.favorite_border,
          semanticsLabel: 'Pulse input in ${BloodPressureField.pulse.unit}',
          validator: (value) {
            final numericPulse = _pulseController.numericValue;
            final pulse = int.tryParse(numericPulse);
            if (pulse == null || pulse < 20 || pulse > 250) {
              return 'Please enter a valid pulse value (20–250 ${BloodPressureField.pulse.unit})';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          nextFieldKey: BloodPressureField.spo2.name,
        ),
        NCTextFieldConfig(
          key: BloodPressureField.spo2.name,
          controller: _spo2Controller,
          hintText: 'SpO2 (${BloodPressureField.spo2.unit})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.air,
          inactiveIcon: Icons.air_outlined,
          semanticsLabel: 'SpO2 input in ${BloodPressureField.spo2.unit}',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            final numericSpo2 = _spo2Controller.numericValue;
            final spo2 = double.tryParse(numericSpo2);
            if (spo2 == null || spo2 <= 0 || spo2 > 100) {
              return 'SpO2 must be between 0 – 100 ${BloodPressureField.spo2.unit}';
            }
            return null;
          },
        ),
        NCTextFieldConfig(
          key: BloodPressureField.time.name,
          hintText: 'Time',
          controller: timeController,
          keyboardType: TextInputType.none,
          activeIcon: Icons.timer_rounded,
          inactiveIcon: Icons.timer_outlined,
          semanticsLabel: 'Time picker',
          readOnly: true,
          onTap: showTimePickerDialog,
          onSuffixIconTap: () {
            setState(() {
              selectedTime = TimeOfDay.now();
              timeController.text = selectedTime!.format(context);
            });
            showTimePickerDialog();
          },
          validator: (value) => value!.isEmpty ? 'Please select a time' : null,
          textInputAction: TextInputAction.done,
        ),
      ],
      layoutConfig: (context, fields, buildSubmitButton) => Column(
        children: [
          Row(
            children: [
              Expanded(child: fields[BloodPressureField.systolic.name]!),
              hGap8,
              Expanded(child: fields[BloodPressureField.diastolic.name]!),
            ],
          ),
          vGap8,
          Row(
            children: [
              Expanded(child: fields[BloodPressureField.pulse.name]!),
              hGap8,
              Expanded(child: fields[BloodPressureField.spo2.name]!),
            ],
          ),
          vGap8,
          Row(children: [
            Expanded(child: fields[BloodPressureField.time.name]!)
          ]),
          vGap16,
          buildSubmitButton(context),
        ],
      ),
      onSave: (values, ref, FirestoreService firestoreService) async {
        HapticFeedback.selectionClick();

        final successColor = AppColors.successColor;
        final errorColor = Theme.of(context).colorScheme.error;

        final user = ref.read(authProvider);
        if (user == null) {
          return Result(
            isSuccess: false,
            message: 'User not authenticated',
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }

        if (selectedTime == null) {
          return Result(
            isSuccess: false,
            message: 'Please select a time',
            backgroundColor: errorColor,
          );
        }

        final systolic = int.parse(_systolicController.numericValue);
        final diastolic = int.parse(_diastolicController.numericValue);

        if (diastolic >= systolic) {
          return Result(
            isSuccess: false,
            message: 'Diastolic can\'t be greater than Systolic',
            backgroundColor: errorColor,
          );
        }

        final dateTime = DateTime.now().copyWith(
          hour: selectedTime!.hour,
          minute: selectedTime!.minute,
        );

        final bpData = BPTrackerModel(
          id: widget.bpMeasure?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          systolic: systolic,
          diastolic: diastolic,
          pulse: int.parse(_pulseController.numericValue),
          spo2: _spo2Controller.numericValue.isEmpty
              ? null
              : double.parse(_spo2Controller.numericValue),
          timestamp: Timestamp.fromDate(dateTime),
        );

        return await firestoreService.saveEntry(
          userId: user.uid,
          collection: 'blood_pressure',
          docId: bpData.id,
          data: bpData.toJson(),
          successMessage: widget.bpMeasure != null
              ? 'Entry updated successfully'
              : 'Entry added successfully',
          errorMessagePrefix: 'Failed to save entry: ',
          successMessageColor: successColor,
          errorMessageColor: errorColor,
        );
      },
    );
  }
}
