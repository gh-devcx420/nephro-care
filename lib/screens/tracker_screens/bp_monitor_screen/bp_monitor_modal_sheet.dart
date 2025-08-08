import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nephro_care/constants/enums.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/models/tracker_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/screens/tracker_screens/generic_modal_sheet.dart';

class BPMonitorModalSheet extends StatefulWidget {
  final BPMonitor? bpMeasure;

  const BPMonitorModalSheet({
    super.key,
    this.bpMeasure,
  });

  @override
  State<BPMonitorModalSheet> createState() => _BPMonitorModalSheetState();
}

class _BPMonitorModalSheetState extends State<BPMonitorModalSheet>
    with TimePickerMixin {
  @override
  void initState() {
    super.initState();
    initTimePicker(widget.bpMeasure?.timestamp.toDate() ?? DateTime.now());
  }

  @override
  void dispose() {
    disposeTimePicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericInputModalSheet(
      title: 'Enter Blood Pressure Details:',
      editTitle: 'Edit Blood Pressure',
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      firestoreCollection: 'bp_monitor',
      dividerThickness: 2.0,
      dividerWidthFactor: 0.15,
      initialFocusFieldKey: BPMonitorFieldEnum.systolic.name,
      inputFields: [
        InputFieldConfig(
          key: BPMonitorFieldEnum.systolic.name,
          hintText:
              'Systolic (${siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.monitor_heart,
          inactiveIcon: Icons.monitor_heart_outlined,
          semanticsLabel:
              'Systolic blood pressure input in ${siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]}',
          initialValue: widget.bpMeasure?.systolic.toInt().toString() ?? '',
          validator: (value) {
            final systolic = int.tryParse(value!);
            if (systolic == null || systolic < 50 || systolic > 280) {
              return 'Please enter a valid systolic value (50–280 ${siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]})';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          nextFieldKey: BPMonitorFieldEnum.diastolic.name,
        ),
        InputFieldConfig(
          key: BPMonitorFieldEnum.diastolic.name,
          hintText:
              'Diastolic (${siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.monitor_heart,
          inactiveIcon: Icons.monitor_heart_outlined,
          semanticsLabel:
              'Diastolic blood pressure input in ${siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]}',
          initialValue: widget.bpMeasure?.diastolic.toInt().toString() ?? '',
          validator: (value) {
            final diastolic = int.tryParse(value!);
            if (diastolic == null || diastolic < 30 || diastolic > 180) {
              return 'Please enter a valid diastolic value (30–180 ${siUnitEnumMap[SIUnitEnum.bloodPressureSIUnit]})';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          nextFieldKey: BPMonitorFieldEnum.pulse.name,
        ),
        InputFieldConfig(
          key: BPMonitorFieldEnum.pulse.name,
          hintText: 'Pulse (${siUnitEnumMap[SIUnitEnum.pulseSIUnit]})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.favorite,
          inactiveIcon: Icons.favorite_border,
          semanticsLabel:
              'Pulse input in ${siUnitEnumMap[SIUnitEnum.pulseSIUnit]}',
          initialValue: widget.bpMeasure?.pulse.toInt().toString() ?? '',
          validator: (value) {
            final pulse = int.tryParse(value!);
            if (pulse == null || pulse < 20 || pulse > 250) {
              return 'Please enter a valid pulse value (20–250 ${siUnitEnumMap[SIUnitEnum.pulseSIUnit]})';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
          nextFieldKey: BPMonitorFieldEnum.spo2.name,
        ),
        InputFieldConfig(
          key: BPMonitorFieldEnum.spo2.name,
          hintText: 'SpO2 (${siUnitEnumMap[SIUnitEnum.percentSIUnit]})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.air,
          inactiveIcon: Icons.air_outlined,
          semanticsLabel:
              'SpO2 input in ${siUnitEnumMap[SIUnitEnum.percentSIUnit]}',
          initialValue: widget.bpMeasure?.spo2?.toInt().toString() ?? '',
          isOptional: true,
          validator: (value) {
            if (value!.isEmpty) return null;
            final spo2 = double.tryParse(value);
            if (spo2 == null || spo2 < 0 || spo2 > 100) {
              return 'SpO2 must be between 0–100${siUnitEnumMap[SIUnitEnum.percentSIUnit]}';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        InputFieldConfig(
          key: BPMonitorFieldEnum.time.name,
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
      initialData: widget.bpMeasure,
      layoutBuilder: (context, fields, buildSubmitButton) => Column(
        children: [
          Row(
            children: [
              Expanded(
                  child:
                      fields[bpMonitorEnumMap[BPMonitorFieldEnum.systolic]]!),
              hGap8,
              Expanded(
                  child:
                      fields[bpMonitorEnumMap[BPMonitorFieldEnum.diastolic]]!),
            ],
          ),
          vGap8,
          Row(
            children: [
              Expanded(
                  child: fields[bpMonitorEnumMap[BPMonitorFieldEnum.pulse]]!),
              hGap8,
              Expanded(
                  child: fields[bpMonitorEnumMap[BPMonitorFieldEnum.spo2]]!),
            ],
          ),
          vGap8,
          Row(children: [
            Expanded(child: fields[bpMonitorEnumMap[BPMonitorFieldEnum.time]]!)
          ]),
          vGap16,
          buildSubmitButton(context),
        ],
      ),
      onSave: (values, ref) async {
        final errorColor = Theme.of(context).colorScheme.error;
        if (selectedTime == null) {
          return DialogResult(
            isSuccess: false,
            message: 'Please select a time',
            backgroundColor: errorColor,
          );
        }
        final systolic =
            int.parse(values[bpMonitorEnumMap[BPMonitorFieldEnum.systolic]]!);
        final diastolic =
            int.parse(values[bpMonitorEnumMap[BPMonitorFieldEnum.diastolic]]!);
        if (diastolic >= systolic) {
          return DialogResult(
            isSuccess: false,
            message: 'Diastolic can\'t be greater than Systolic',
            backgroundColor: errorColor,
          );
        }
        final user = ref.read(authProvider);
        if (user == null) {
          return DialogResult(
            isSuccess: false,
            message: 'User not authenticated',
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
        final dateTime = DateTime.now().copyWith(
          hour: selectedTime!.hour,
          minute: selectedTime!.minute,
        );
        final bpData = BPMonitor(
          id: widget.bpMeasure?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          systolic: systolic,
          diastolic: diastolic,
          pulse: int.parse(values[bpMonitorEnumMap[BPMonitorFieldEnum.pulse]]!),
          spo2: values[bpMonitorEnumMap[BPMonitorFieldEnum.spo2]]!.isEmpty
              ? null
              : double.parse(
                  values[bpMonitorEnumMap[BPMonitorFieldEnum.spo2]]!),
          timestamp: Timestamp.fromDate(dateTime),
        );

        try {
          var resultColor = Theme.of(context).colorScheme.primary;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('bp_monitor')
              .doc(bpData.id)
              .set(bpData.toJson());
          return DialogResult(
            isSuccess: true,
            message: widget.bpMeasure != null
                ? 'Entry updated successfully'
                : 'Entry added successfully',
            backgroundColor: resultColor,
          );
        } catch (e) {
          return DialogResult(
            isSuccess: false,
            message: 'Failed to save entry: $e',
            backgroundColor: errorColor,
          );
        }
      },
    );
  }
}
