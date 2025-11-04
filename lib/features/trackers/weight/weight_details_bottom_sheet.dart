import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/themes/theme_color_schemes.dart';
import 'package:nephro_care/core/widgets/nc_text_controller.dart';
import 'package:nephro_care/core/widgets/nc_textfield_config.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/trackers/generic/generic_modal_sheet.dart';
import 'package:nephro_care/features/trackers/weight/weight_constants.dart';
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
      suffix: WeightUnits.kilograms.siUnit,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return GenericInputModalSheet(
      addModeTitle: 'Enter Weight Details:',
      editingModeTitle: 'Edit Weight',
      primaryColor: colorScheme.primary,
      secondaryColor: colorScheme.primaryContainer,
      backgroundColor: colorScheme.surfaceContainerLow,
      firestoreService: FirestoreService(),
      dividerThickness: 2.0,
      dividerWidthFactor: 0.15,
      inputFields: [
        NCTextFieldConfig(
          key: Weight.weightValue.fieldKey,
          controller: _weightController,
          hintText: Weight.weightValue.hintText,
          keyboardType: TextInputType.number,
          activeIcon: Icons.monitor_weight,
          inactiveIcon: Icons.monitor_weight_outlined,
          semanticsLabel: Weight.weightValue.hintText,
          initialValue: widget.weightInput?.weight.toString() ?? '',
          validator: (value) {
            final numericValue = _weightController.numericValue;
            final weight = double.tryParse(numericValue);
            if (weight == null ||
                weight < WeightConstants.minWeightInKG ||
                weight > WeightConstants.maxWeightInKG) {
              return 'Weight  must be between ${WeightConstants.minWeightInKG.toInt()} – ${WeightConstants.maxWeightInKG.toInt()} ${WeightUnits.kilograms.siUnit}.';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        NCTextFieldConfig(
          key: Weight.time.fieldKey,
          hintText: Weight.time.hintText,
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
      initialData: widget.weightInput,
      layoutConfig: (context, fields, buildSubmitButton) => Column(
        children: [
          Row(
            children: [
              Expanded(child: fields[Weight.weightValue.fieldKey]!),
              hGap8,
              Expanded(child: fields[Weight.time.fieldKey]!),
            ],
          ),
          vGap16,
          buildSubmitButton(context),
        ],
      ),
      onSave: (values, ref, FirestoreService firestoreService) async {
        const successColor = AppColors.successColor;
        final errorColor = colorScheme.error;

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

        // Check if online
        final isOnlineAsync = ref.watch(connectivityProvider);
        final isOnline = isOnlineAsync.maybeWhen(
          data: (online) => online,
          orElse: () => true,
        );

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
          collection: WeightConstants.weightFirebaseCollectionName,
          docId: weightData.id,
          data: weightData.toJson(),
          successMessage: widget.weightInput != null
              ? 'Entry updated successfully'
              : 'Entry added successfully',
          successMessageColor: successColor,
          errorMessagePrefix: 'Failed to save entry: ',
          errorMessageColor: errorColor,
          isOnline: isOnline,
        );
      },
    );
  }
}
