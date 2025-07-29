import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nephro_care/constants/enums.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/screens/tracker_screens/generic_modal_sheet.dart';
import 'package:nephro_care/utils/ui_utils.dart';

class FluidIntakeModalSheet extends StatefulWidget {
  final FluidIntake? intake;

  const FluidIntakeModalSheet({super.key, this.intake});

  @override
  State<FluidIntakeModalSheet> createState() => _FluidIntakeModalSheetState();
}

class _FluidIntakeModalSheetState extends State<FluidIntakeModalSheet>
    with TimePickerMixin {
  @override
  void initState() {
    super.initState();
    initTimePicker(widget.intake?.timestamp.toDate() ?? DateTime.now());
  }

  @override
  void dispose() {
    disposeTimePicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericInputModalSheet(
      title: 'Enter Fluid Intake Details:',
      editTitle: 'Edit Fluid Intake',
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      firestoreCollection: 'fluid_intake',
      dividerThickness: 2.0,
      dividerWidthFactor: 0.15,
      inputFields: [
        InputFieldConfig(
          key: FluidIntakeFieldEnum.fluidName.name,
          hintText: 'Fluid Name',
          keyboardType: TextInputType.text,
          activeIcon: Icons.local_drink,
          inactiveIcon: Icons.local_drink_outlined,
          semanticsLabel: 'Fluid name input',
          initialValue: widget.intake?.fluidName ?? 'Water',
          validator: (value) =>
              value!.isEmpty ? 'Please enter a valid fluid name' : null,
          textInputAction: TextInputAction.next,
          onSubmitted: (value) {
            if (value.length > 18) {
              UIUtils.showSnackBar(
                context,
                'Fluid name cannot exceed 18 characters',
                Theme.of(context).colorScheme.error,
              );
            }
          },
        ),
        InputFieldConfig(
          key: FluidIntakeFieldEnum.quantity.name,
          hintText: 'Quantity (${siUnitEnumMap[SIUnitEnum.fluidsSIUnitML]})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.water_drop,
          inactiveIcon: Icons.water_drop_outlined,
          semanticsLabel:
              'Quantity input in ${siUnitEnumMap[SIUnitEnum.fluidsSIUnitML]}',
          initialValue: widget.intake?.quantity.toInt().toString() ?? '',
          validator: (value) {
            final quantity = double.tryParse(value!);
            if (quantity == null) {
              return 'Please enter a valid quantity';
            }
            if (quantity > 1000) {
              return 'Quantity cannot exceed 1000${siUnitEnumMap[SIUnitEnum.fluidsSIUnitML]}';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        InputFieldConfig(
          key: FluidIntakeFieldEnum.time.name,
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
      initialData: widget.intake,
      layoutBuilder: (context, fields, buildSubmitButton) => Column(
        children: [
          Row(children: [
            Expanded(
                child:
                    fields[fluidIntakeEnumMap[FluidIntakeFieldEnum.fluidName]]!)
          ]),
          vGap8,
          Row(
            children: [
              Expanded(
                  child: fields[
                      fluidIntakeEnumMap[FluidIntakeFieldEnum.quantity]]!),
              hGap8,
              Expanded(
                  child:
                      fields[fluidIntakeEnumMap[FluidIntakeFieldEnum.time]]!),
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
        final intakeData = FluidIntake(
          id: widget.intake?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          fluidName:
              values[fluidIntakeEnumMap[FluidIntakeFieldEnum.fluidName]]!,
          quantity: double.parse(
              values[fluidIntakeEnumMap[FluidIntakeFieldEnum.quantity]]!),
          timestamp: Timestamp.fromDate(dateTime),
        );

        try {
          var resultColor = Theme.of(context).colorScheme.primary;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('fluid_intake')
              .doc(intakeData.id)
              .set(intakeData.toJson());
          return DialogResult(
            isSuccess: true,
            message: widget.intake != null
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
