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
import 'package:nephro_care/features/trackers/fluids/fluid_intake_enums.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_intake_model.dart';

class FluidIntakeModalSheet extends StatefulWidget {
  final FluidIntakeModel? intake;

  const FluidIntakeModalSheet({super.key, this.intake});

  @override
  State<FluidIntakeModalSheet> createState() => _FluidIntakeModalSheetState();
}

class _FluidIntakeModalSheetState extends State<FluidIntakeModalSheet>
    with TimePickerMixin {
  late final NCTextEditingController _fluidQuantityController;

  @override
  void initState() {
    super.initState();
    _fluidQuantityController = NCTextEditingController(
      suffix: FluidIntakeField.fluidQuantityMl.unit ?? 'ml',
    )..text = widget.intake?.quantity.toInt().toString() ?? '';
    initTimePicker(widget.intake?.timestamp.toDate() ?? DateTime.now());
  }

  @override
  void dispose() {
    _fluidQuantityController.dispose();
    disposeTimePicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericInputModalSheet(
      title: 'Enter Fluid Intake Details:',
      editTitle: 'Edit Fluid Intake:',
      initialData: widget.intake,
      firestoreService: FirestoreService(),
      initialFocusFieldKey: FluidIntakeField.fluidType.name,
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      inputFields: [
        NCTextFieldConfig(
          key: FluidIntakeField.fluidType.name,
          initialValue: widget.intake?.fluidName ?? 'Water',
          hintText: 'Fluid Name',
          semanticsLabel: 'Fluid name input',
          activeIcon: Icons.local_drink,
          inactiveIcon: Icons.local_drink_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid fluids name';
            }
            if (value.length > 18) {
              return 'Fluid name too long';
            }
            return null;
          },
          nextFieldKey: FluidIntakeField.fluidQuantityMl.name,
        ),
        NCTextFieldConfig(
          key: FluidIntakeField.fluidQuantityMl.name,
          controller: _fluidQuantityController,
          hintText: 'Quantity (${FluidIntakeField.fluidQuantityMl.unit})',
          semanticsLabel:
              'Quantity input in ${FluidIntakeField.fluidQuantityMl.unit}',
          activeIcon: Icons.water_drop,
          inactiveIcon: Icons.water_drop_outlined,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          validator: (value) {
            final numericValue = _fluidQuantityController.numericValue;

            final quantity = double.tryParse(numericValue);

            if (quantity == null) {
              return 'Please enter a valid quantity';
            }
            if (quantity <= 0) {
              return 'Quantity cannot be 0 ${FluidIntakeField.fluidQuantityMl.unit}.';
            }
            if (quantity > 1500) {
              return 'Quantity cannot exceed 1500 ${FluidIntakeField.fluidQuantityMl.unit}.';
            }
            return null;
          },
          nextFieldKey: FluidIntakeField.time.name,
        ),
        NCTextFieldConfig(
          key: FluidIntakeField.time.name,
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
              HapticFeedback.selectionClick();
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
          Row(children: [
            Expanded(child: fields[FluidIntakeField.fluidType.name]!)
          ]),
          vGap8,
          Row(
            children: [
              Expanded(child: fields[FluidIntakeField.fluidQuantityMl.name]!),
              hGap8,
              Expanded(child: fields[FluidIntakeField.time.name]!),
            ],
          ),
          vGap16,
          buildSubmitButton(context),
        ],
      ),
      onSave: (values, ref, FirestoreService firestoreService) async {
        final successColor = AppColors.successColor;
        final errorColor = Theme.of(context).colorScheme.error;

        if (selectedTime == null) {
          return Result(
            isSuccess: false,
            message: 'Please select a time',
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }

        final user = ref.read(authProvider);

        if (user == null) {
          return Result(
            isSuccess: false,
            message: 'User not authenticated',
            backgroundColor: errorColor,
          );
        }

        final dateTime = DateTime.now().copyWith(
          hour: selectedTime!.hour,
          minute: selectedTime!.minute,
        );

        final intakeData = FluidIntakeModel(
          id: widget.intake?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          fluidName: values[FluidIntakeField.fluidType.name]!,
          quantity: double.parse(_fluidQuantityController.numericValue),
          timestamp: Timestamp.fromDate(dateTime),
        );

        return await firestoreService.saveEntry(
          userId: user.uid,
          collection: 'fluids',
          docId: intakeData.id,
          data: intakeData.toJson(),
          successMessage: widget.intake != null
              ? 'Entry updated successfully'
              : 'Entry added successfully',
          successMessageColor: successColor,
          errorMessagePrefix: 'Failed to save entry: ',
          errorMessageColor: errorColor,
        );
      },
    );
  }
}
