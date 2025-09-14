import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/themes/color_schemes.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_text_controller.dart';
import 'package:nephro_care/core/widgets/nc_textfield_config.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_constants.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_enums.dart';
import 'package:nephro_care/features/trackers/fluids/fluids_model.dart';
import 'package:nephro_care/features/trackers/fluids/fluids_provider.dart';
import 'package:nephro_care/features/trackers/generic/generic_modal_sheet.dart';

class FluidIntakeModalSheet extends ConsumerStatefulWidget {
  final FluidsModel? intake;

  const FluidIntakeModalSheet({super.key, this.intake});

  @override
  ConsumerState<FluidIntakeModalSheet> createState() =>
      _FluidIntakeModalSheetState();
}

class _FluidIntakeModalSheetState extends ConsumerState<FluidIntakeModalSheet>
    with TimePickerMixin {
  late final NCTextEditingController _fluidQuantityController;

  @override
  void initState() {
    super.initState();
    _fluidQuantityController = NCTextEditingController(
      suffix: FluidUnits.milliliters.siUnit,
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
    final fluidDailyLimitProvider = ref.watch(fluidLimitProvider);

    return GenericInputModalSheet(
      title: 'Enter Fluid Intake Details:',
      editTitle: 'Edit Fluid Intake:',
      initialData: widget.intake,
      firestoreService: FirestoreService(),
      initialFocusFieldKey: Fluids.name.fieldKey,
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      inputFields: [
        NCTextFieldConfig(
          key: Fluids.name.fieldKey,
          initialValue: widget.intake?.fluidName ?? 'Water',
          hintText: 'Fluid Name',
          semanticsLabel: 'Fluid name input',
          activeIcon: Icons.local_drink,
          inactiveIcon: Icons.local_drink_outlined,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a valid fluids name';
            }
            if (value.length > FluidConstants.fluidNameMaxChars) {
              return 'Fluid name too long.\nMaximum ${FluidConstants.fluidNameMaxChars} characters allowed.';
            }
            return null;
          },
          nextFieldKey: Fluids.quantity.fieldKey,
        ),
        NCTextFieldConfig(
          key: Fluids.quantity.fieldKey,
          controller: _fluidQuantityController,
          hintText:
              '${Fluids.quantity.hintText} in ${FluidUnits.milliliters.siUnit}',
          semanticsLabel:
              '${Fluids.quantity.hintText} in ${FluidUnits.milliliters.siUnit}',
          activeIcon: Icons.water_drop,
          inactiveIcon: Icons.water_drop_outlined,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          validator: (value) {
            final numericValue = _fluidQuantityController.numericValue;

            final quantity = double.tryParse(numericValue);

            if (quantity == null) {
              return 'Please enter a valid quantity.';
            }
            if (quantity <= 0) {
              return 'Quantity cannot be 0 ${FluidUnits.milliliters.siUnit}.';
            }
            if (quantity > fluidDailyLimitProvider) {
              return 'Quantity cannot exceed $fluidDailyLimitProvider ${FluidUnits.milliliters.siUnit}.\nAdjust the limit in settings.';
            }
            return null;
          },
          nextFieldKey: Fluids.time.fieldKey,
        ),
        NCTextFieldConfig(
          key: Fluids.time.fieldKey,
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
          Row(children: [Expanded(child: fields[Fluids.name.fieldKey]!)]),
          vGap8,
          Row(
            children: [
              Expanded(child: fields[Fluids.quantity.fieldKey]!),
              hGap8,
              Expanded(child: fields[Fluids.time.fieldKey]!),
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

        final intakeData = FluidsModel(
          id: widget.intake?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          fluidName: values[Fluids.name.fieldKey]!,
          quantity: double.parse(_fluidQuantityController.numericValue),
          timestamp: Timestamp.fromDate(dateTime),
        );

        return await firestoreService.saveEntry(
          userId: user.uid,
          collection: FluidConstants.fluidFirebaseCollectionName,
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
