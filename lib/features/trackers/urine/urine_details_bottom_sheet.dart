import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/themes/color_schemes.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_text_controller.dart';
import 'package:nephro_care/core/widgets/nc_textfield_config.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/shared/generic_modal_sheet.dart';
import 'package:nephro_care/features/trackers/urine/urine_constants.dart';
import 'package:nephro_care/features/trackers/urine/urine_enums.dart';
import 'package:nephro_care/features/trackers/urine/urine_model.dart';

class UrineOutputModalSheet extends StatefulWidget {
  final UrineModel? output;

  const UrineOutputModalSheet({super.key, this.output});

  @override
  State<UrineOutputModalSheet> createState() => _UrineOutputModalSheetState();
}

class _UrineOutputModalSheetState extends State<UrineOutputModalSheet>
    with TimePickerMixin {
  late final NCTextEditingController _urineQuantityController;

  @override
  void initState() {
    super.initState();
    _urineQuantityController = NCTextEditingController(
      suffix: UrineUnits.milliliters.siUnit,
    )..text = widget.output?.quantity.toInt().toString() ?? '';
    initTimePicker(widget.output?.timestamp.toDate() ?? DateTime.now());
  }

  @override
  void dispose() {
    _urineQuantityController.dispose();
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
      firestoreService: FirestoreService(),
      dividerThickness: 2.0,
      dividerWidthFactor: 0.15,
      inputFields: [
        NCTextFieldConfig(
          key: Urine.quantity.fieldKey,
          controller: _urineQuantityController,
          hintText:
              '${Urine.quantity.hintText} in ${UrineUnits.milliliters.siUnit}',
          keyboardType: TextInputType.number,
          activeIcon: Icons.water_drop,
          inactiveIcon: Icons.water_drop_outlined,
          semanticsLabel:
              '${Urine.quantity.hintText} in ${UrineUnits.milliliters.siUnit}',
          initialValue: widget.output?.quantity.toInt().toString() ?? '',
          validator: (value) {
            final numericQuantity = _urineQuantityController.numericValue;
            final quantity = double.tryParse(numericQuantity);
            if (quantity == null) {
              return 'Please enter a valid quantity.';
            }
            if (quantity <= 0) {
              return 'Quantity cannot be 0 ${UrineUnits.milliliters.siUnit}.';
            }
            if (quantity > 1500) {
              return 'Quantity won\'t usually exceed ${UrineConstants.urineBladderMaxCapacity} ${UrineUnits.milliliters.siUnit}.';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        NCTextFieldConfig(
          key: Urine.time.fieldKey,
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
      layoutConfig: (context, fields, buildSubmitButton) => Column(
        children: [
          Row(
            children: [
              Expanded(child: fields[Urine.quantity.fieldKey]!),
              hGap8,
              Expanded(child: fields[Urine.time.fieldKey]!),
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
        final outputData = UrineModel(
          id: widget.output?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          outputName: 'Urine',
          quantity: double.parse(
            _urineQuantityController.numericValue.isEmpty
                ? '0'
                : _urineQuantityController.numericValue,
          ),
          timestamp: Timestamp.fromDate(dateTime),
        );
        return await firestoreService.saveEntry(
          userId: user.uid,
          collection: UrineConstants.urineFirebaseCollectionName,
          docId: outputData.id,
          data: outputData.toJson(),
          successMessage: widget.output != null
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
