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
import 'package:nephro_care/widgets/nc_alert_dialogue.dart';
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

class ShowFluidInputOptions extends StatefulWidget {
  final FluidIntake? intake;

  const ShowFluidInputOptions({super.key, this.intake});

  @override
  State<ShowFluidInputOptions> createState() => _ShowFluidInputOptionsState();
}

class _ShowFluidInputOptionsState extends State<ShowFluidInputOptions> {
  late final TextEditingController fluidNameController;
  late final TextEditingController quantityController;
  late final TextEditingController timeController;
  late final FocusNode fluidNameFocusNode;
  late final FocusNode quantityFocusNode;
  TimeOfDay? selectedTime;
  bool isLoading = false; // Added: Track loading state

  @override
  void initState() {
    super.initState();
    fluidNameController =
        TextEditingController(text: widget.intake?.fluidName ?? 'Water');
    quantityController = TextEditingController(
        text: widget.intake != null ? widget.intake!.quantity.toString() : '');
    final initialTime = widget.intake != null
        ? TimeOfDay.fromDateTime(widget.intake!.timestamp.toDate())
        : TimeOfDay.now();
    timeController = TextEditingController(
      text: Utils.formatTime(DateTime.now().copyWith(
        hour: initialTime.hour,
        minute: initialTime.minute,
      )),
    );
    fluidNameFocusNode = FocusNode();
    quantityFocusNode = FocusNode();
    selectedTime = initialTime;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(quantityFocusNode);
    });
  }

  @override
  void dispose() {
    fluidNameController.dispose();
    quantityController.dispose();
    timeController.dispose();
    fluidNameFocusNode.dispose();
    quantityFocusNode.dispose();
    super.dispose();
  }

  /// Function to show a reusable Time Picker.
  Future<void> _showTimePicker() async {
    final errorColor = Theme.of(context).colorScheme.error;
    final navigator = Navigator.of(context);
    FocusScope.of(context).requestFocus(FocusNode());
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
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
        currentDateTime.hour,
        currentDateTime.minute,
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
    } else {
      setState(() {
        selectedTime = null;
        timeController.text = '';
      });
    }
  }

  /// Helper function to handle validation errors
  void _handleValidationError(String message, Color errorColor) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: errorColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Function to add or update fluid intake in Firestore
  Future<void> _addIntake(WidgetRef ref) async {
    final errorColor = Theme.of(context).colorScheme.error;

    // Step 1: Validate inputs
    final fluidName = fluidNameController.text.trim();
    if (fluidName.isEmpty) {
      Navigator.of(context).pop();
      _handleValidationError('Please enter a valid fluid name', errorColor);
      return;
    }

    double? quantity;
    try {
      quantity = double.parse(quantityController.text);
    } catch (e) {
      Navigator.of(context).pop();
      _handleValidationError('Please enter a valid quantity', errorColor);
      return;
    }

    if (quantity > 1000) {
      Navigator.of(context).pop();
      _handleValidationError('Quantity cannot exceed 1000ml', errorColor);
      return;
    }

    if (selectedTime == null) {
      Navigator.of(context).pop();
      _handleValidationError('Please select a time', errorColor);
      return;
    }

    final user = ref.read(authProvider);
    if (user == null) {
      Navigator.of(context).pop();
      _handleValidationError('Please sign in to add entries', errorColor);
      return;
    }
    final userId = user.uid;

    // Step 2: Construct FluidIntake
    final today = DateTime.now();
    final dateTime = DateTime(
      today.year,
      today.month,
      today.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );
    final intake = FluidIntake(
      id: widget.intake?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      fluidName: fluidName,
      quantity: quantity,
      timestamp: Timestamp.fromDate(dateTime),
    );

    // Step 3: Save to Firestore with loading state
    setState(() => isLoading = true);
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fluid_intake')
          .doc(intake.id)
          .set(intake.toJson());
      // Step 4: Pop dialog with success result after save
      if (!mounted) return;
      Navigator.of(context).pop(
        DialogResult(
          isSuccess: true,
          message: widget.intake != null
              ? 'Entry updated successfully'
              : 'Entry added successfully',
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      _handleValidationError('Failed to save entry: $e', errorColor);
    }
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
                        horizontal: 8,
                        vertical: 8,
                      ),
                      child: Text(
                        widget.intake != null
                            ? 'Edit Fluid Intake'
                            : 'Enter Fluid Intake Details:',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: waterShade2,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              vGap8,
              NCTextfield(
                key: const ValueKey('fluidName_textfield'),
                hintText: 'Fluid Name',
                textFieldController: fluidNameController,
                focusNode: fluidNameFocusNode,
                maxLength: 18,
                onSuffixIconTap: () {
                  setState(() {
                    fluidNameController.text = '';
                    FocusScope.of(context).requestFocus(fluidNameFocusNode);
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
                    child: NCTextfield(
                      key: const ValueKey('quantity_textfield'),
                      hintText: 'Quantity (ml)',
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
                    child: NCTextfield(
                      key: const ValueKey('timepicker_textfield'),
                      hintText: 'Time',
                      textFieldController: timeController,
                      activeFieldIcon: const Icon(Icons.timer_rounded),
                      inactiveFieldIcon: const Icon(Icons.timer_outlined),
                      textCapitalization: TextCapitalization.none,
                      onTap: _showTimePicker,
                      onSuffixIconTap: () {
                        setState(() {
                          selectedTime = TimeOfDay.now();
                          timeController.text = '';
                        });
                        _showTimePicker();
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
                ],
              ),
              vGap16,
              Consumer(
                builder: (context, ref, child) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _addIntake(ref),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: waterShade2,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: waterShade2,
                              ),
                            )
                          : Text(
                              widget.intake != null ? 'Update' : 'Add Intake',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                    color: waterBackgroundShade,
                                  ),
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
  DateTime selectedDate = DateTime.now(); // Added: State for date selection

  /// Named callback method for deleteFluidIntake completion.
  void _onDeleteComplete(bool isSuccess, String message, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Reusable function to delete a fluid intake entry from Firestore
  Future<void> deleteFluidIntake({
    required String userId,
    required String intakeId,
    required Function(bool, String, Color) onComplete,
  }) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fluid_intake')
          .doc(intakeId)
          .delete();
      onComplete(true, 'Entry deleted successfully', Colors.green);
    } catch (e) {
      // Modified: Pass error color via onComplete, removing context dependency
      onComplete(false, 'Failed to delete entry: $e', Colors.red);
    }
  }

  /// Function to show delete confirmation before deleting an entry.
  Future<bool> _showDeleteConfirmationDialog(BuildContext context) async {
    final result = await showNCAlertDialogue(
      context: context,
      titleText: 'Delete Entry',
      content: const Text(
          'Are you sure you want to delete this fluid intake entry?'),
      action1: TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Cancel'),
      ),
      action2: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
        child: Text(
          'Delete',
          style: TextStyle(
            color: Theme.of(context).colorScheme.surfaceContainerLowest,
          ),
        ),
      ),
    );
    return result ?? false;
  }

  /// Function to show a bottom modal sheet to add fluid intake.
  void _showAddFluidIntakeDialog(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: waterBackgroundShade,
      builder: (modalContext) => const ShowFluidInputOptions(),
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

  /// Added: Placeholder for editing fluid intake
  void _showEditFluidIntakeDialog(
      BuildContext context, FluidIntake intake) async {
    // Future: Check if intake.timestamp is between today 12 AM and tomorrow 12 AM
    final messenger = ScaffoldMessenger.of(context);

    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: waterBackgroundShade,
      builder: (modalContext) => ShowFluidInputOptions(intake: intake),
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
          onTap: () => Navigator.of(context).pop(),
          child: const Icon(Icons.arrow_back, color: waterShade2),
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.calendar_today,
              color: waterShade2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton(
              onPressed: () => _showAddFluidIntakeDialog(context),
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
            // Modified: Pass selectedDate to provider (requires provider update)
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
                              "Fluid Intake for today :",
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
                                  'No entries for today \n Add a fluid intake to track now',
                                  style: themeContext.textTheme.titleMedium!
                                      .copyWith(
                                    color: waterShade2,
                                  ),
                                  textAlign: TextAlign.center,
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
                                  return Dismissible(
                                    key: Key(intake.id),
                                    direction: DismissDirection.endToStart,
                                    confirmDismiss: (direction) async {
                                      return await _showDeleteConfirmationDialog(
                                          context);
                                    },
                                    onDismissed: (direction) {
                                      final user = ref.read(authProvider);
                                      if (user == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: const Text(
                                              'Please sign in to delete entries',
                                            ),
                                            backgroundColor:
                                                themeContext.colorScheme.error,
                                            duration:
                                                const Duration(seconds: 2),
                                          ),
                                        );
                                        return;
                                      }
                                      deleteFluidIntake(
                                        userId: user.uid,
                                        intakeId: intake.id,
                                        onComplete: _onDeleteComplete,
                                      );
                                    },
                                    background: Container(
                                      margin: const EdgeInsets.only(
                                        left: 4,
                                        bottom: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: themeContext.colorScheme.error,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      alignment: Alignment.centerRight,
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          hGap16,
                                          Text(
                                            'Delete this Entry',
                                            style: themeContext
                                                .textTheme.titleMedium!
                                                .copyWith(
                                              color: waterBackgroundShade,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          hGap8,
                                        ],
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: waterShade2,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
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
                                          title: Text(
                                            'Drank: ${intake.fluidName}',
                                            style: themeContext
                                                .textTheme.titleMedium!
                                                .copyWith(
                                              color: waterBackgroundShade,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            '${intake.quantity.toInt()} ml',
                                            style: themeContext
                                                .textTheme.titleMedium!
                                                .copyWith(
                                              color: waterBackgroundShade,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // Added: Placeholder edit button
                                              const IconButton(
                                                icon: Icon(
                                                  Icons.edit,
                                                  color: waterBackgroundShade,
                                                ),
                                                onPressed:
                                                    null, // Future: Enable for editing
                                              ),
                                              Text(
                                                Utils.formatTime(
                                                    intake.timestamp.toDate()),
                                                style: themeContext
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  color: waterBackgroundShade,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
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
