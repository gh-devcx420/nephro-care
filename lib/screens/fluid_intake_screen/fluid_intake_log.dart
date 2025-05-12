import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/firebase_provider.dart';
import 'package:nephro_care/screens/fluid_intake_screen/fluid_intake_input.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';
import 'package:nephro_care/widgets/nc_alert_dialogue.dart';

class FluidIntakeLogScreen extends ConsumerStatefulWidget {
  const FluidIntakeLogScreen({super.key});

  @override
  FluidIntakeLogScreenState createState() => FluidIntakeLogScreenState();
}

class FluidIntakeLogScreenState extends ConsumerState<FluidIntakeLogScreen> {
  DateTime selectedDate = DateTime.now();

  void _showAddFluidIntakeDialog() async {
    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ComponentColors.waterBackgroundColor,
      builder: (_) => const FluidIntakeInput(),
    );

    if (result != null && mounted) {
      Utils.showSnackBar(context, result.message, result.backgroundColor);
    }
  }

  Future<bool> _showEditConfirmationDialog() async {
    final result = await showNCAlertDialogue(
      context: context,
      titleText: 'Edit this entry?',
      content:
          const Text('Are you sure you want to edit this fluid intake entry?'),
      action1: TextButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('Cancel'),
      ),
      action2: ElevatedButton(
        onPressed: () => Navigator.of(context).pop(true),
        style: ElevatedButton.styleFrom(
          backgroundColor: ComponentColors.waterColorShade1,
        ),
        child: Text(
          'Edit',
          style: TextStyle(
            color: Theme.of(context).colorScheme.surfaceBright,
          ),
        ),
      ),
    );
    return result ?? false;
  }

  void _showEditFluidIntakeDialog(FluidIntake intake) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final entryDate = intake.timestamp.toDate();

    if (entryDate.isBefore(startOfDay)) {
      Utils.showSnackBar(context, 'Can only edit entries from today',
          Theme.of(context).colorScheme.error);
      return;
    }

    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ComponentColors.waterBackgroundColor,
      builder: (_) => FluidIntakeInput(intake: intake),
    );

    if (result != null && mounted) {
      Utils.showSnackBar(context, result.message, result.backgroundColor);
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
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
            color: Theme.of(context).colorScheme.surfaceBright,
          ),
        ),
      ),
    );
    return result ?? false;
  }

  Future<void> _deleteFluidIntake(String userId, String intakeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('fluid_intake')
          .doc(intakeId)
          .delete();
      if (mounted) {
        Utils.showSnackBar(
          context,
          'Entry deleted successfully',
          ComponentColors.greenSuccess,
        );
      }
    } catch (e) {
      if (mounted) {
        Utils.showSnackBar(
          context,
          'Failed to delete entry: $e',
          Theme.of(context).colorScheme.error,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: ComponentColors.waterColorShade2,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          'Fluid Log',
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ComponentColors.waterColorShade2,
          ),
        ),
        backgroundColor: ComponentColors.waterBackgroundColor,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {},
              enableFeedback: true,
              icon: const Icon(
                Icons.more_vert,
                color: ComponentColors.waterColorShade2,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: ComponentColors.waterBackgroundColor,
      body: SafeArea(
        top: false,
        child: Consumer(
          builder: (context, ref, _) {
            final fluidIntakeAsync = ref.watch(fluidIntakeListProvider);
            return fluidIntakeAsync.when(
              data: (intakes) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (intakes.isNotEmpty)
                    Container(
                      width: double.infinity,
                      color: ComponentColors.waterBackgroundColor,
                      padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
                      child: Row(
                        children: [
                          Text(
                            "Fluid Intake for today:",
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: ComponentColors.waterColorShade2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: ComponentColors.waterColorShade2,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              Utils.formatFluidAmount(intakes.fold<double>(0,
                                  (total, intake) => total + intake.quantity)),
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: ComponentColors.waterBackgroundColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: intakes.isEmpty
                        ? Center(
                            child: Text(
                              'No entries for today\nAdd a fluid intake to track now',
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: ComponentColors.waterColorShade2,
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
                                direction: DismissDirection.horizontal,
                                confirmDismiss: (direction) async {
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    return _showDeleteConfirmationDialog();
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
                                    final confirmed =
                                        await _showEditConfirmationDialog();
                                    if (confirmed) {
                                      _showEditFluidIntakeDialog(intake);
                                    }
                                    return false;
                                  }
                                  return false;
                                },
                                onDismissed: (direction) {
                                  final user = ref.read(authProvider);
                                  if (user == null) {
                                    return;
                                  }
                                  if (direction ==
                                      DismissDirection.endToStart) {
                                    _deleteFluidIntake(user.uid, intake.id);
                                  } else if (direction ==
                                      DismissDirection.startToEnd) {
                                    _showEditFluidIntakeDialog(intake);
                                  }
                                },
                                secondaryBackground: Container(
                                  margin: const EdgeInsets.only(
                                    left: 4,
                                    bottom: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Delete this Entry',
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                          color: ComponentColors
                                              .waterBackgroundColor,
                                        ),
                                      ),
                                      hGap16,
                                      Icon(
                                        Icons.delete,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceBright,
                                      ),
                                      hGap8,
                                    ],
                                  ),
                                ),
                                background: Container(
                                  margin: const EdgeInsets.only(
                                    right: 4,
                                    bottom: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ComponentColors.waterColorShade1,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .surfaceBright,
                                      ),
                                      hGap16,
                                      Text(
                                        'Edit this Entry',
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                          color: ComponentColors
                                              .waterBackgroundColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ComponentColors.waterColorShade2,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(
                                        Icons.water_drop,
                                        color: ComponentColors
                                            .waterBackgroundColor,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        vertical: 2,
                                        horizontal: 12,
                                      ),
                                      title: Text(
                                        'Drank: ${intake.fluidName}',
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                          color: ComponentColors
                                              .waterBackgroundColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      subtitle: Text(
                                        '${intake.quantity.toInt()} ml',
                                        style: theme.textTheme.titleMedium!
                                            .copyWith(
                                          color: ComponentColors
                                              .waterBackgroundColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      trailing: Text(
                                        Utils.formatTime(
                                            intake.timestamp.toDate()),
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(
                                          color: ComponentColors
                                              .waterBackgroundColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: ComponentColors.waterColorShade2,
                ),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFluidIntakeDialog,
        elevation: 10,
        backgroundColor: ComponentColors.waterColorShade1,
        child: const Icon(Icons.add),
      ),
    );
  }
}
