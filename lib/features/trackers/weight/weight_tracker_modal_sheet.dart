import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/themes/color_schemes.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_text_controller.dart';
import 'package:nephro_care/core/widgets/nc_textfield_config.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/shared/generic_modal_sheet.dart';
import 'package:nephro_care/features/trackers/weight/weight_enums.dart';
import 'package:nephro_care/features/trackers/weight/weight_model.dart';

class WeightModalSheet extends StatefulWidget {
  final WeightModel? weightInput;

  const WeightModalSheet({super.key, this.weightInput});

  @override
  State<WeightModalSheet> createState() => _WeightModalSheetState();
}

class _WeightModalSheetState extends State<WeightModalSheet>
    with TimePickerMixin {
  late final NCTextEditingController _weightController;

  @override
  void initState() {
    super.initState();
    _weightController = NCTextEditingController(
      suffix: WeightField.weightValue.unit ?? 'kg',
    )..text = widget.weightInput?.weight.toInt().toString() ?? '';
    initTimePicker(
      widget.weightInput?.timestamp.toDate() ?? DateTime.now(),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    disposeTimePicker();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GenericInputModalSheet(
      title: 'Enter Weight Details:',
      editTitle: 'Edit Weight',
      primaryColor: Theme.of(context).colorScheme.primary,
      secondaryColor: Theme.of(context).colorScheme.primaryContainer,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      firestoreService: FirestoreService(),
      dividerThickness: 2.0,
      dividerWidthFactor: 0.15,
      inputFields: [
        NCTextFieldConfig(
          key: WeightField.weightValue.name,
          controller: _weightController,
          hintText: 'Weight (${WeightField.weightValue.unit})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.monitor_weight,
          inactiveIcon: Icons.monitor_weight_outlined,
          semanticsLabel: 'Weight input in ${WeightField.weightValue.unit}',
          initialValue: widget.weightInput?.weight.toString() ?? '',
          validator: (value) {
            final numericValue = _weightController.numericValue;
            final weight = double.tryParse(numericValue);
            if (weight == null || weight < 10 || weight > 300) {
              return 'Please enter a valid weight (10–300 ${WeightField.weightValue.unit})';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        NCTextFieldConfig(
          key: WeightField.time.name,
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
      initialData: widget.weightInput,
      layoutConfig: (context, fields, buildSubmitButton) => Column(
        children: [
          Row(
            children: [
              Expanded(child: fields[WeightField.weightValue.name]!),
              hGap8,
              Expanded(child: fields[WeightField.time.name]!),
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
            backgroundColor: errorColor,
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

        final weightData = WeightModel(
          id: widget.weightInput?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          weight: double.parse(_weightController.numericValue),
          timestamp: Timestamp.fromDate(dateTime),
        );

        return await firestoreService.saveEntry(
          userId: user.uid,
          collection: 'weight',
          docId: weightData.id,
          data: weightData.toJson(),
          successMessage: widget.weightInput != null
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
