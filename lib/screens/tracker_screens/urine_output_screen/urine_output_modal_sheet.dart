import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nephro_care/constants/enums.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/models/urine_output_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/screens/tracker_screens/generic_modal_sheet.dart';

class UrineOutputModalSheet extends StatefulWidget {
  final UrineOutput? output;

  const UrineOutputModalSheet({super.key, this.output});

  @override
  State<UrineOutputModalSheet> createState() => _UrineOutputModalSheetState();
}

class _UrineOutputModalSheetState extends State<UrineOutputModalSheet>
    with TimePickerMixin {
  @override
  void initState() {
    super.initState();
    initTimePicker(widget.output?.timestamp.toDate() ?? DateTime.now());
  }

  @override
  void dispose() {
    disposeTimePicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericInputModalSheet(
      title: 'Enter Urine Output Details:',
      editTitle: 'Edit Urine Output',
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      firestoreCollection: 'urine_output',
      dividerThickness: 2.0,
      dividerWidthFactor: 0.15,
      inputFields: [
        InputFieldConfig(
          key: UrineOutputFieldEnum.quantity.name,
          hintText: 'Quantity (${siUnitEnumMap[SIUnitEnum.fluidsSIUnitML]})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.water_drop,
          inactiveIcon: Icons.water_drop_outlined,
          semanticsLabel:
              'Quantity input in ${siUnitEnumMap[SIUnitEnum.fluidsSIUnitML]}',
          initialValue: widget.output?.quantity.toInt().toString() ?? '',
          validator: (value) {
            final quantity = double.tryParse(value!);
            if (quantity == null) {
              return 'Please enter a valid quantity';
            }
            if (quantity > 1500) {
              return 'Quantity cannot exceed 1500${siUnitEnumMap[SIUnitEnum.fluidsSIUnitML]}';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        InputFieldConfig(
          key: UrineOutputFieldEnum.time.name,
          hintText: 'Time',
          keyboardType: TextInputType.none,
          activeIcon: Icons.timer_rounded,
          inactiveIcon: Icons.timer_outlined,
          semanticsLabel: 'Time picker',
          initialValue: timeController.text,
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
      initialData: widget.output,
      layoutBuilder: (context, fields, buildSubmitButton) => Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: fields[
                      urineOutputEnumMap[UrineOutputFieldEnum.quantity]]!),
              hGap8,
              Expanded(
                  child:
                      fields[urineOutputEnumMap[UrineOutputFieldEnum.time]]!),
            ],
          ),
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
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
        final user = ref.read(authProvider);
        if (user == null) {
          return DialogResult(
            isSuccess: false,
            message: 'User not authenticated',
            backgroundColor: errorColor,
          );
        }
        final dateTime = DateTime.now().copyWith(
          hour: selectedTime!.hour,
          minute: selectedTime!.minute,
        );
        final outputData = UrineOutput(
          id: widget.output?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          outputName: 'Urine',
          quantity: double.parse(
              values[urineOutputEnumMap[UrineOutputFieldEnum.quantity]]!),
          timestamp: Timestamp.fromDate(dateTime),
        );

        try {
          var resultColor = Theme.of(context).colorScheme.primary;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('urine_output')
              .doc(outputData.id)
              .set(outputData.toJson());
          return DialogResult(
            isSuccess: true,
            message: widget.output != null
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
