import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/firebase_provider.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/widgets/nc_textfield.dart';

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
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    fluidNameController = TextEditingController(text: 'Water');
    quantityController = TextEditingController();
  }

  @override
  void dispose() {
    fluidNameController.dispose();
    quantityController.dispose();
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
              NCTextfield(
                textFieldController: fluidNameController,
                hintText: 'Fluid Name',
                activeFieldIcon: const Icon(Icons.local_drink),
                inactiveFieldIcon: const Icon(Icons.local_drink_outlined),
              ),
              vGap16,
              NCTextfield(
                key: const ValueKey('quantity_textfield'),
                textFieldController: quantityController,
                hintText: 'Quantity (ml)',
                activeFieldIcon: const Icon(Icons.numbers),
                inactiveFieldIcon: const Icon(Icons.numbers_outlined),
                textCapitalization: TextCapitalization.none,
                onChanged: (value) {
                  if (value.isNotEmpty && double.tryParse(value) == null) {
                    quantityController.text =
                        value.substring(0, value.length - 1);
                    quantityController.selection = TextSelection.fromPosition(
                      TextPosition(offset: quantityController.text.length),
                    );
                  }
                },
              ),
              vGap16,
              ElevatedButton.icon(
                onPressed: () async {
                  final errorColor = Theme.of(context).colorScheme.error;
                  final navigator = Navigator.of(context);

                  FocusScope.of(context).unfocus();

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
                    });
                  }
                },
                icon: const Icon(Icons.access_time),
                label: Text('Time: ${selectedTime.format(context)}'),
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
                        return;
                      }
                    },
                    child: const Text('Add Intake'),
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Fluid Log'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kScaffoldBodyPadding),
        child: Consumer(
          builder: (context, ref, child) {
            final fluidIntakeAsync = ref.watch(fluidIntakeListProvider);

            return fluidIntakeAsync.when(
              data: (intakes) {
                if (intakes.isEmpty) {
                  return const Center(child: Text('No entries for today'));
                }
                return ListView.builder(
                  itemCount: intakes.length,
                  itemBuilder: (context, index) {
                    final intake = intakes[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(
                          Icons.water_drop,
                          color: Colors.blue,
                        ),
                        title:
                            Text('${intake.fluidName}: ${intake.quantity} ml'),
                        subtitle: Text(
                          DateFormat('h:mm a')
                              .format(intake.timestamp.toDate()),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(child: Text('Error: $error')),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFluidIntakeDialog(context),
        backgroundColor: ChipColors.waterBackgroundColor,
        foregroundColor: ChipColors.waterIconColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
