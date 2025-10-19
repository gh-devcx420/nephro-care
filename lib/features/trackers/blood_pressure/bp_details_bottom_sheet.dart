import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/themes/theme_color_schemes.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_text_controller.dart';
import 'package:nephro_care/core/widgets/nc_textfield_config.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_constants.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_enums.dart';
import 'package:nephro_care/features/trackers/blood_pressure/bp_model.dart';
import 'package:nephro_care/features/trackers/generic/generic_modal_sheet.dart';

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
    _systolicController =
        NCTextEditingController(suffix: BloodPressureField.systolic.siUnit)
          ..text = widget.bpMeasure?.systolic.toInt().toString() ?? '';
    _diastolicController =
        NCTextEditingController(suffix: BloodPressureField.diastolic.siUnit)
          ..text = widget.bpMeasure?.diastolic.toInt().toString() ?? '';
    _pulseController =
        NCTextEditingController(suffix: BloodPressureField.pulse.siUnit)
          ..text = widget.bpMeasure?.pulse.toInt().toString() ?? '';
    _spo2Controller =
        NCTextEditingController(suffix: BloodPressureField.spo2.siUnit)
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GenericInputModalSheet(
      dividerThickness: 2.0,
      dividerWidthFactor: 0.15,
      addModeTitle: 'Enter Blood Pressure Details:',
      editingModeTitle: 'Edit Blood Pressure',
      firestoreService: FirestoreService(),
      initialData: widget.bpMeasure,
      primaryColor: colorScheme.primary,
      secondaryColor: colorScheme.primaryContainer,
      backgroundColor: colorScheme.surfaceContainerLow,
      initialFocusFieldKey: BloodPressureField.systolic.fieldKey,
      inputFields: [
        NCTextFieldConfig(
          key: BloodPressureField.systolic.fieldKey,
          controller: _systolicController,
          hintText: BloodPressureField.systolic.hintText,
          keyboardType: TextInputType.number,
          activeIcon: Icons.monitor_heart,
          inactiveIcon: Icons.monitor_heart_outlined,
          semanticsLabel: BloodPressureField.systolic.hintText,
          validator: (value) {
            final numericSystolic = _systolicController.numericValue;
            final systolic = int.tryParse(numericSystolic);
            if (systolic == null ||
                systolic < BloodPressureConstants.systolicMin ||
                systolic > BloodPressureConstants.systolicMax) {
              return 'Systolic must be between ${BloodPressureConstants.systolicMin.toInt()}–${BloodPressureConstants.systolicMax.toInt()} ${BloodPressureField.systolic.siUnit}.';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          nextFieldKey: BloodPressureField.diastolic.fieldKey,
        ),
        NCTextFieldConfig(
          key: BloodPressureField.diastolic.fieldKey,
          controller: _diastolicController,
          hintText: BloodPressureField.diastolic.hintText,
          keyboardType: TextInputType.number,
          activeIcon: Icons.monitor_heart,
          inactiveIcon: Icons.monitor_heart_outlined,
          semanticsLabel: BloodPressureField.diastolic.hintText,
          validator: (value) {
            final numericDiastolic = _diastolicController.numericValue;
            final diastolic = int.tryParse(numericDiastolic);
            if (diastolic == null ||
                diastolic < BloodPressureConstants.diastolicMin ||
                diastolic > BloodPressureConstants.diastolicMax) {
              return 'Diastolic must be between ${BloodPressureConstants.diastolicMin.toInt()} – ${BloodPressureConstants.diastolicMax.toInt()} ${BloodPressureField.diastolic.siUnit}.';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          nextFieldKey: BloodPressureField.pulse.fieldKey,
        ),
        NCTextFieldConfig(
          key: BloodPressureField.pulse.fieldKey,
          controller: _pulseController,
          hintText: BloodPressureField.pulse.hintText,
          keyboardType: TextInputType.number,
          activeIcon: Icons.favorite,
          inactiveIcon: Icons.favorite_border,
          semanticsLabel: BloodPressureField.pulse.hintText,
          validator: (value) {
            final numericPulse = _pulseController.numericValue;
            final pulse = int.tryParse(numericPulse);
            if (pulse == null ||
                pulse < BloodPressureConstants.pulseMin ||
                pulse > BloodPressureConstants.pulseMax) {
              return 'Pulse must be between  ${BloodPressureConstants.pulseMin.toInt()}–${BloodPressureConstants.pulseMax.toInt()} ${BloodPressureField.pulse.siUnit}.';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          nextFieldKey: BloodPressureField.spo2.fieldKey,
        ),
        NCTextFieldConfig(
          key: BloodPressureField.spo2.fieldKey,
          controller: _spo2Controller,
          hintText: BloodPressureField.spo2.hintText,
          keyboardType: TextInputType.number,
          activeIcon: Icons.air,
          inactiveIcon: Icons.air_outlined,
          semanticsLabel: BloodPressureField.spo2.hintText,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return null;
            }
            final numericSpo2 = _spo2Controller.numericValue;
            final spo2 = double.tryParse(numericSpo2);
            if (spo2 == null ||
                spo2 <= BloodPressureConstants.spo2Min ||
                spo2 > BloodPressureConstants.spo2Max) {
              return 'SpO2 must be between ${BloodPressureConstants.spo2Min.toInt()}–${BloodPressureConstants.spo2Max.toInt()} ${BloodPressureField.spo2.siUnit}.';
            }
            return null;
          },
        ),
        NCTextFieldConfig(
          key: BloodPressureField.time.fieldKey,
          hintText: BloodPressureField.time.hintText,
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
          validator: (value) => value!.isEmpty ? 'Please select a time.' : null,
          textInputAction: TextInputAction.done,
        ),
      ],
      layoutConfig: (context, fields, buildSubmitButton) => Column(
        children: [
          Row(
            children: [
              Expanded(child: fields[BloodPressureField.systolic.fieldKey]!),
              hGap8,
              Expanded(child: fields[BloodPressureField.diastolic.fieldKey]!),
            ],
          ),
          vGap8,
          Row(
            children: [
              Expanded(child: fields[BloodPressureField.pulse.fieldKey]!),
              hGap8,
              Expanded(child: fields[BloodPressureField.spo2.fieldKey]!),
            ],
          ),
          vGap8,
          Row(children: [
            Expanded(child: fields[BloodPressureField.time.fieldKey]!)
          ]),
          vGap16,
          buildSubmitButton(context),
        ],
      ),
      onSave: (values, ref, FirestoreService firestoreService) async {
        HapticFeedback.selectionClick();

        const successColor = AppColors.successColor;
        final errorColor = colorScheme.error;

        final user = ref.read(authProvider);
        if (user == null) {
          return Result(
            isSuccess: false,
            message: 'User not authenticated',
            backgroundColor: colorScheme.error,
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
          collection: BloodPressureConstants.bpFirebaseCollectionName,
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
