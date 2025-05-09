import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/firebase_provider.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';
import 'package:nephro_care/widgets/nc_textfield.dart';

const waterBackgroundShade = ComponentColors.waterBackgroundColor;
const waterShade1 = ComponentColors.waterColorShade1;
const waterShade2 = ComponentColors.waterColorShade2;

class DialogResult {
  final bool isSuccess;
  final String message;
  final Color backgroundColor;

  DialogResult({
    required this.isSuccess,
    required this.message,
    required this.backgroundColor,
  });
}

class AddFluidIntakeDialog extends StatefulWidget {
  const AddFluidIntakeDialog({super.key});

  @override
  State<AddFluidIntakeDialog> createState() => _AddFluidIntakeDialogState();
}

class _AddFluidIntakeDialogState extends State<AddFluidIntakeDialog> {
  late final TextEditingController fluidNameController;
  late final TextEditingController quantityController;
  late final TextEditingController timeController;
  late final FocusNode quantityFocusNode;
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    fluidNameController = TextEditingController(text: 'Water');
    quantityController = TextEditingController();
    timeController = TextEditingController(
      text: Utils.formatTime(
        DateTime.now(),
      ),
    );
    quantityFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(quantityFocusNode);
    });
  }

  @override
  void dispose() {
    fluidNameController.dispose();
    quantityController.dispose();
    timeController.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  hGap4,
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      child: Text(
                        'Enter Fluid Intake Details:',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: waterShade2,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              vGap8,
              // Textfield for entering Fluid Name.
              NCTextfield(
                key: const ValueKey('fluidName_textfield'),
                hintText: 'Fluid Name',
                textFieldController: fluidNameController,
                onSuffixIconTap: () {
                  setState(() {
                    fluidNameController.text = '';
                  });
                },
                activeFieldIcon: const Icon(Icons.local_drink),
                inactiveFieldIcon: const Icon(Icons.local_drink_outlined),
                enabledBorderColor: waterShade2,
                focusedBorderColor: waterShade2,
                prefixIconColor: waterShade2,
                fillColor: Theme.of(context).colorScheme.surfaceContainerLowest,
                textColor: waterShade2,
                hintTextColor: Theme.of(context).colorScheme.secondaryContainer,
                cursorColor: waterShade2,
                selectionHandleColor: waterShade2,
              ),
              vGap16,
              Row(
                children: [
                  Expanded(
                    // Textfield for entering Quantity.
                    child: NCTextfield(
                      key: const ValueKey('quantity_textfield'),
                      hintText: 'Quantity (Ml)',
                      textFieldController: quantityController,
                      focusNode: quantityFocusNode,
                      keyboardType: TextInputType.number,
                      activeFieldIcon: const Icon(Icons.water_drop),
                      inactiveFieldIcon: const Icon(Icons.water_drop_outlined),
                      textCapitalization: TextCapitalization.none,
                      onChanged: (value) {
                        if (value.isNotEmpty &&
                            double.tryParse(value) == null) {
                          quantityController.text =
                              value.substring(0, value.length - 1);
                          quantityController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: quantityController.text.length),
                          );
                        }
                      },
                      onSuffixIconTap: () {
                        setState(() {
                          quantityController.text = '';
                        });
                      },
                      enabledBorderColor: waterShade2,
                      focusedBorderColor: waterShade2,
                      prefixIconColor: waterShade2,
                      textColor: waterShade2,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: waterShade2,
                      selectionHandleColor: waterShade2,
                    ),
                  ),
                  hGap8,
                  Expanded(
                    // Textfield for entering Time.
                    child: NCTextfield(
                      key: const ValueKey('timepicker_textfield'),
                      hintText: 'Time',
                      textFieldController: timeController,
                      activeFieldIcon: const Icon(Icons.timer_rounded),
                      inactiveFieldIcon: const Icon(Icons.timer_outlined),
                      textCapitalization: TextCapitalization.none,
                      onTap: () async {
                        final errorColor = Theme.of(context).colorScheme.error;
                        final navigator = Navigator.of(context);
                        FocusScope.of(context).requestFocus(FocusNode());
                        final now = TimeOfDay.now();
                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: selectedTime,
                        );
                        if (pickedTime != null) {
                          final currentDateTime = DateTime.now();
                          final pickedDateTime = DateTime(
                            currentDateTime.year,
                            currentDateTime.month,
                            currentDateTime.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          final nowDateTime = DateTime(
                            currentDateTime.year,
                            currentDateTime.month,
                            currentDateTime.day,
                            now.hour,
                            now.minute,
                          );
                          if (pickedDateTime.isAfter(nowDateTime)) {
                            navigator.pop(
                              DialogResult(
                                isSuccess: false,
                                message: 'Cannot select a future time',
                                backgroundColor: errorColor,
                              ),
                            );
                            return;
                          }
                          setState(() {
                            selectedTime = pickedTime;
                            timeController.text = pickedTime.format(context);
                          });
                        }
                      },
                      onSuffixIconTap: () {
                        setState(() {
                          selectedTime = TimeOfDay.now();
                          timeController.text = '';
                        });
                      },
                      enabledBorderColor: waterShade2,
                      focusedBorderColor: waterShade2,
                      prefixIconColor: waterShade2,
                      textColor: waterShade2,
                      fillColor:
                          Theme.of(context).colorScheme.surfaceContainerLowest,
                      hintTextColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      cursorColor: waterShade2,
                      selectionHandleColor: waterShade2,
                    ),
                  )
                ],
              ),
              vGap16,
              Consumer(
                builder: (context, ref, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      final errorColor = Theme.of(context).colorScheme.error;
                      final navigator = Navigator.of(context);
                      double? quantity;
                      try {
                        quantity = double.parse(quantityController.text);
                      } catch (e) {
                        FocusScope.of(context).unfocus();
                        navigator.pop(
                          DialogResult(
                            isSuccess: false,
                            message: 'Please enter a valid quantity',
                            backgroundColor: errorColor,
                          ),
                        );
                        return;
                      }

                      if (quantity > 1000) {
                        FocusScope.of(context).unfocus();
                        navigator.pop(
                          DialogResult(
                            isSuccess: false,
                            message: 'Quantity cannot exceed 1000ml',
                            backgroundColor: errorColor,
                          ),
                        );
                        return;
                      }

                      final user = ref.read(authProvider);
                      if (user == null) {
                        FocusScope.of(context).unfocus();
                        navigator.pop(
                          DialogResult(
                            isSuccess: false,
                            message: 'Please sign in to add entries',
                            backgroundColor: errorColor,
                          ),
                        );
                        return;
                      }
                      final userId = user.uid;

                      final today = DateTime.now();
                      final dateTime = DateTime(
                        today.year,
                        today.month,
                        today.day,
                        selectedTime.hour,
                        selectedTime.minute,
                      );

                      final intake = FluidIntake(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        fluidName: fluidNameController.text,
                        quantity: quantity,
                        timestamp: Timestamp.fromDate(dateTime),
                      );

                      FocusScope.of(context).unfocus();

                      try {
                        navigator.pop(
                          DialogResult(
                            isSuccess: true,
                            message: 'Entry added successfully',
                            backgroundColor: Colors.green,
                          ),
                        );
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(userId)
                            .collection('fluid_intake')
                            .doc(intake.id)
                            .set(intake.toJson());
                      } catch (e) {
                        navigator.pop(
                          DialogResult(
                            isSuccess: false,
                            message: 'Failed to save entry: $e',
                            backgroundColor: errorColor,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: waterShade2,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    child: Text(
                      'Add Intake',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: waterBackgroundShade,
                          ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class FluidIntakeLog extends ConsumerStatefulWidget {
  const FluidIntakeLog({super.key});

  @override
  FluidIntakeLogState createState() => FluidIntakeLogState();
}

class FluidIntakeLogState extends ConsumerState<FluidIntakeLog> {
  void _showAddFluidIntakeDialog(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: waterBackgroundShade,
      builder: (modalContext) => const AddFluidIntakeDialog(),
    );

    if (!mounted) return;

    if (result != null) {
      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.backgroundColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back,
            color: waterShade2,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          'Fluid Log',
          style: themeContext.textTheme.headlineSmall!.copyWith(
            color: waterShade2,
          ),
        ),
        backgroundColor: waterBackgroundShade,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () {
                _showAddFluidIntakeDialog(context);
              },
              color: waterShade2,
              icon: const Icon(
                Icons.add,
                color: waterShade2,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: waterBackgroundShade,
      extendBodyBehindAppBar: false,
      body: SafeArea(
        top: false,
        child: Consumer(
          builder: (context, ref, child) {
            final fluidIntakeAsync = ref.watch(fluidIntakeListProvider);
            return fluidIntakeAsync.when(
              data: (intakes) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (intakes.isNotEmpty)
                      Container(
                        width: double.infinity,
                        color: waterBackgroundShade,
                        padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
                        child: Row(
                          children: [
                            Text(
                              "Today's Fluid Intake",
                              style:
                                  themeContext.textTheme.titleLarge!.copyWith(
                                color: waterShade2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: waterShade2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                Utils.formatFluidAmount(intakes.fold<double>(
                                    0,
                                    (total, intake) =>
                                        total + intake.quantity)),
                                style: themeContext.textTheme.titleMedium!
                                    .copyWith(
                                  color: waterBackgroundShade,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ClipRect(
                        child: intakes.isEmpty
                            ? Center(
                                child: Text(
                                  'No entries for today',
                                  style: themeContext.textTheme.titleMedium!
                                      .copyWith(color: waterShade2),
                                ),
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  left: kScaffoldBodyPadding,
                                  right: kScaffoldBodyPadding,
                                  bottom: kScaffoldBodyPadding,
                                ),
                                itemCount: intakes.length,
                                itemBuilder: (context, index) {
                                  final intake = intakes[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.water_drop,
                                        color: waterBackgroundShade,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 12,
                                      ),
                                      tileColor: waterShade2,
                                      title: Text(
                                        'Drank ${intake.fluidName} : ${intake.quantity.toInt()} ml',
                                        style: themeContext
                                            .textTheme.titleMedium!
                                            .copyWith(
                                          color: waterBackgroundShade,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Text(
                                        Utils.formatTime(
                                            intake.timestamp.toDate()),
                                        style: themeContext
                                            .textTheme.bodyMedium!
                                            .copyWith(
                                          color: waterBackgroundShade,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            );
          },
        ),
      ),
    );
  }
}
