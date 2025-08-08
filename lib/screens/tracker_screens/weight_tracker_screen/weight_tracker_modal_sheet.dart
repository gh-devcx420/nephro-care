import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nephro_care/constants/enums.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/models/tracker_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/screens/tracker_screens/generic_modal_sheet.dart';

// WeightModalSheet is a StatefulWidget for entering or editing weight data
class WeightModalSheet extends StatefulWidget {
  final Weight? weight;

  const WeightModalSheet({super.key, this.weight});

  @override
  State<WeightModalSheet> createState() => _WeightModalSheetState();
}

class _WeightModalSheetState extends State<WeightModalSheet>
    with TimePickerMixin {
  @override
  void initState() {
    super.initState();
    // Initialize time picker with existing timestamp or current time
    initTimePicker(widget.weight?.timestamp.toDate() ?? DateTime.now());
  }

  @override
  void dispose() {
    // Dispose time picker resources
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
      firestoreCollection: 'weight',
      dividerThickness: 2.0,
      dividerWidthFactor: 0.15,
      inputFields: [
        InputFieldConfig(
          key: WeightFieldEnum.weight.name,
          hintText: 'Weight (${siUnitEnumMap[SIUnitEnum.weightSIUnit]})',
          keyboardType: TextInputType.number,
          activeIcon: Icons.fitness_center,
          inactiveIcon: Icons.fitness_center_outlined,
          semanticsLabel:
              'Weight input in ${siUnitEnumMap[SIUnitEnum.weightSIUnit]}',
          initialValue: widget.weight?.weight.toString() ?? '',
          validator: (value) {
            final weight = double.tryParse(value!);
            if (weight == null || weight < 20 || weight > 300) {
              return 'Please enter a valid weight (20–300 ${siUnitEnumMap[SIUnitEnum.weightSIUnit]})';
            }
            return null;
          },
          textInputAction: TextInputAction.next,
        ),
        InputFieldConfig(
          key: WeightFieldEnum.time.name,
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
      initialData: widget.weight,
      layoutBuilder: (context, fields, buildSubmitButton) => Column(
        children: [
          Row(
            children: [
              Expanded(child: fields[weightEnumMap[WeightFieldEnum.weight]]!),
              hGap8,
              Expanded(child: fields[weightEnumMap[WeightFieldEnum.time]]!),
            ],
          ),
          vGap16,
          buildSubmitButton(context),
        ],
      ),
      onSave: (values, ref) async {
        final errorColor = Theme.of(context).colorScheme.error;

        // Validate time selection
        if (selectedTime == null) {
          return DialogResult(
            isSuccess: false,
            message: 'Please select a time',
            backgroundColor: errorColor,
          );
        }

        // Validate user authentication
        final user = ref.read(authProvider);
        if (user == null) {
          return DialogResult(
            isSuccess: false,
            message: 'User not authenticated',
            backgroundColor: errorColor,
          );
        }

        // Create timestamp from selected time
        final dateTime = DateTime.now().copyWith(
          hour: selectedTime!.hour,
          minute: selectedTime!.minute,
        );

        // Create Weight object
        final weightData = Weight(
          id: widget.weight?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          weight: double.parse(values[weightEnumMap[WeightFieldEnum.weight]]!),
          timestamp: Timestamp.fromDate(dateTime),
        );

        try {
          // Save data to Firestore
          var resultColor = Theme.of(context).colorScheme.primary;
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('weight')
              .doc(weightData.id)
              .set(weightData.toJson());
          return DialogResult(
            isSuccess: true,
            message: widget.weight != null
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
