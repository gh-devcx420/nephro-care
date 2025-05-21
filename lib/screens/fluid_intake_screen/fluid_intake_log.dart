import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/models/fluid_intake_model.dart';
import 'package:nephro_care/models/other_generic_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/fluid_input_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/screens/fluid_intake_screen/fluid_intake_input.dart';
import 'package:nephro_care/screens/fluid_intake_screen/fluid_intake_settings.dart';
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
  final _colors = {
    'shade1': ComponentColors.waterColorShade1,
    'shade2': ComponentColors.waterColorShade2,
    'background': ComponentColors.waterBackgroundShade,
  };

  void _showSnackBar(String message, Color backgroundColor) {
    Utils.showSnackBar(context, message, backgroundColor);
  }

  Future<void> _showAddFluidIntakeModalSheet() async {
    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _colors['background']!,
      builder: (_) => const FluidIntakeInput(),
    );

    if (result != null) {
      _showSnackBar(result.message, result.backgroundColor);
    }
  }

  Future<bool> _showEditConfirmationModalSheet() async {
    return Utils.showConfirmationDialog(
      context: context,
      title: 'Edit Entry',
      content: 'Do you want to edit this fluid intake entry?',
      confirmText: 'Edit',
      confirmColor: _colors['shade1'],
    );
  }

  void _showEditFluidIntakeDialog(FluidIntake intake) async {
    final selectedDate = ref.read(selectedDateProvider);
    final entryDate = intake.timestamp.toDate();

    if (!Utils.isSameDay(entryDate, selectedDate)) {
      _showSnackBar(
        'Can only edit entries from today',
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _colors['background']!,
      builder: (_) => FluidIntakeInput(intake: intake),
    );

    if (result != null) {
      _showSnackBar(result.message, result.backgroundColor);
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return Utils.showConfirmationDialog(
      context: context,
      title: 'Delete Entry',
      content: 'Are you sure you want to delete this fluid intake entry?',
      confirmText: 'Delete',
    );
  }

  Future<bool> _showDeleteAllConfirmationDialog() async {
    return Utils.showConfirmationDialog(
      context: context,
      title: 'Delete All Entries',
      content:
          'Are you sure you want to delete all fluid intake entries for this date?',
      confirmText: 'Delete All',
    );
  }

  Future<void> _deleteAllFluidIntakes(
      String userId, DateTime selectedDate, Color errorColor) async {
    try {
      final user = ref.read(authProvider);
      if (user == null) {
        _showSnackBar(
          'User not authenticated. Please log in.',
          errorColor,
        );
        return;
      }
      final startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fluid_intake')
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('timestamp', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      final batch = FirebaseFirestore.instance.batch();
      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      _showSnackBar(
        'All fluid intake entries deleted successfully',
        _colors['shade2']!,
      );
    } catch (e) {
      _showSnackBar('Failed to delete entries: $e', errorColor);
    }
  }

  Future<void> _deleteFluidIntake(
      String userId, String intakeId, Color errorColor) async {
    try {
      final user = ref.read(authProvider);
      if (user == null) {
        _showSnackBar(
          'User not authenticated. Please log in.',
          errorColor,
        );
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('fluid_intake')
          .doc(intakeId)
          .delete();
      _showSnackBar(
        'Entry deleted successfully',
        _colors['shade2']!,
      );
    } catch (e) {
      _showSnackBar(
        'Failed to delete entry: $e',
        errorColor,
      );
    }
  }

  Future<bool> _showFluidIntakeInformationDialogue() async {
    final fluidInputSummary = ref.watch(fluidIntakeSummaryProvider);

    return fluidInputSummary.when(
      data: (fluidSummary) async {
        final lastDrinkTime = fluidSummary['lastTime'] ?? 'N/A';
        final totalDrinksToday = fluidSummary['totalDrinksToday'] ?? '0';
        final totalFluidQuantityToday = fluidSummary['total'] ?? 0;

        final result = await showNCAlertDialogue(
          context: context,
          titleText: 'Fluid Intake Details',
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              vGap8,
              Text('• Number of drinks today: $totalDrinksToday'),
              ...(fluidSummary['typeTotals'] as Map<String, dynamic>? ?? {})
                  .entries
                  .map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                          '• ${entry.key}: ${Utils.formatFluidValue(entry.value)}'),
                    ),
                  ),
              vGap16,
              Text(
                  '• Total fluid intake: ${Utils.formatFluidValue(totalFluidQuantityToday)}'),
              vGap16,
              Text('• Last Drink at: $lastDrinkTime'),
            ],
          ),
          action1: const SizedBox(),
          action2: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: _colors['shade2']!,
            ),
            child: Text(
              'Ok',
              style: TextStyle(
                color: Theme.of(context).colorScheme.surfaceBright,
              ),
            ),
          ),
        );
        return result ?? false;
      },
      loading: () {
        _showSnackBar(
          'Loading fluid intake summary...',
          _colors['shade2']!,
        );
        return false;
      },
      error: (e, _) {
        _showSnackBar(
          'Failed to load summary: $e',
          Theme.of(context).colorScheme.error,
        );
        return false;
      },
    );
  }

  Widget _buildHeader(
    bool isToday,
    String totalFluidQuantityFormatted,
    ThemeData theme,
    double fluidLimit,
    double totalFluidQuantity,
    DateTime selectedDate,
  ) {
    return Container(
      width: double.infinity,
      color: _colors['background']!,
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
      child: Row(
        children: [
          Text(
            'Showing entries for ${isToday ? 'Today' : Utils.formatDateDM(selectedDate)}',
            style: theme.textTheme.titleMedium!.copyWith(
              color: _colors['shade2']!,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: totalFluidQuantity > fluidLimit
                  ? theme.colorScheme.error
                  : _colors['shade2']!,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              totalFluidQuantityFormatted,
              style: theme.textTheme.titleMedium!.copyWith(
                color: _colors['background']!,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final fluidIntakeAsync = ref.watch(fluidIntakeListProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final fluidLimit = ref.watch(fluidLimitProvider);
    final allowDeleteAll = ref.watch(allowDeleteAllProvider);
    final isToday = Utils.isSameDay(selectedDate, DateTime.now());
    final isFluidLogEmpty = fluidIntakeAsync.asData?.value.isEmpty == false;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          color: _colors['shade2']!,
          icon: const Icon(Icons.arrow_back),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          'Fluid Log',
          style: theme.textTheme.headlineSmall!.copyWith(
            color: _colors['shade2']!,
          ),
        ),
        backgroundColor: _colors['background']!,
        surfaceTintColor: Colors.transparent,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: _colors['shade2']!,
            ),
            color: _colors['background']!,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            itemBuilder: (context) {
              final items = <PopupMenuItem<String>>[
                PopupMenuItem<String>(
                  value: 'fluidSettings',
                  padding: EdgeInsets.zero,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context, 'fluidSettings');
                          },
                          borderRadius: BorderRadius.circular(8),
                          splashColor: _colors['shade2']!.withOpacity(0.3),
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 6,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.settings,
                                  size: 30,
                                  color: _colors['shade2']!,
                                ),
                                hGap8,
                                Text(
                                  'Fluid Settings',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: _colors['shade2']!,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'details',
                  padding: EdgeInsets.zero,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context, 'details');
                          },
                          borderRadius: BorderRadius.circular(8),
                          splashColor: _colors['shade2']!.withOpacity(0.3),
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 6,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 30,
                                  color: _colors['shade2']!,
                                ),
                                hGap8,
                                Text(
                                  'Log Details',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: _colors['shade2']!,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ];

              if (allowDeleteAll && isFluidLogEmpty) {
                items.insert(
                  1,
                  PopupMenuItem<String>(
                    value: 'delete_all',
                    padding: EdgeInsets.zero,
                    child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context, 'delete_all');
                            },
                            borderRadius: BorderRadius.circular(8),
                            splashColor: _colors['shade2']!.withOpacity(0.3),
                            highlightColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_forever,
                                    size: 30,
                                    color: _colors['shade2']!,
                                  ),
                                  hGap8,
                                  Text(
                                    'Delete All',
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      color: _colors['shade2']!,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return items;
            },
            onSelected: (value) async {
              if (value == 'delete_all') {
                final isConfirmed = await _showDeleteAllConfirmationDialog();
                if (isConfirmed) {
                  final user = ref.read(authProvider);
                  if (user != null) {
                    await _deleteAllFluidIntakes(
                        user.uid, selectedDate, errorColor);
                  }
                }
              } else if (value == 'fluidSettings') {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const FluidIntakeSettings(),
                  ),
                );
              } else if (value == 'details') {
                await _showFluidIntakeInformationDialogue();
              }
            },
          ),
          hGap8,
        ],
      ),
      backgroundColor: _colors['background']!,
      body: SafeArea(
        top: false,
        child: fluidIntakeAsync.when(
          data: (intakes) {
            final totalFluidQuantity = intakes.fold<double>(
                0, (total, intake) => total + intake.quantity);
            final totalFluidQuantityFormatted =
                Utils.formatFluidValue(totalFluidQuantity);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (intakes.isNotEmpty)
                  _buildHeader(
                    isToday,
                    totalFluidQuantityFormatted,
                    theme,
                    fluidLimit.toDouble(),
                    totalFluidQuantity,
                    selectedDate,
                  ),
                Expanded(
                  child: intakes.isEmpty
                      ? Center(
                          child: Text(
                            'No entries for ${isToday ? 'today.' : Utils.formatDateDMY(selectedDate)} ${isToday ? '\n Add a fluid intake to track now.' : ''}',
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: _colors['shade2']!,
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
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: _colors['shade2']!,
                                  child: Dismissible(
                                    key: Key(intake.id),
                                    direction: isToday
                                        ? DismissDirection.horizontal
                                        : DismissDirection.endToStart,
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        return _showDeleteConfirmationDialog();
                                      } else if (direction ==
                                          DismissDirection.startToEnd) {
                                        final confirmed =
                                            await _showEditConfirmationModalSheet();
                                        if (confirmed) {
                                          _showEditFluidIntakeDialog(intake);
                                        }
                                        return false;
                                      }
                                      return false;
                                    },
                                    onDismissed: (direction) {
                                      final user = ref.read(authProvider);
                                      if (user == null) return;
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        _deleteFluidIntake(
                                            user.uid, intake.id, errorColor);
                                      } else if (direction ==
                                          DismissDirection.startToEnd) {
                                        _showEditFluidIntakeDialog(intake);
                                      }
                                    },
                                    background: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: _colors['shade1']!,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
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
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                color: _colors['background']!,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    secondaryBackground: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.error,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'Delete this Entry',
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                color: _colors['background']!,
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
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _colors['shade2']!,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ListTile(
                                        leading: Icon(
                                          Icons.water_drop,
                                          color: _colors['background']!,
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 12),
                                        title: Semantics(
                                          label:
                                              'Fluid type: ${intake.fluidName}',
                                          child: Text(
                                            'Drank: ${intake.fluidName}',
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                              color: _colors['background']!,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        subtitle: Semantics(
                                          label:
                                              'Quantity: ${intake.quantity} milliliters',
                                          child: Text(
                                            Utils.formatFluidValue(
                                                intake.quantity),
                                            style: theme.textTheme.titleMedium!
                                                .copyWith(
                                              color: _colors['background']!,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        trailing: Semantics(
                                          label:
                                              'Time: ${Utils.formatTime(intake.timestamp.toDate())}',
                                          child: Text(
                                            Utils.formatTime(
                                                intake.timestamp.toDate()),
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                              color: _colors['background']!,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
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
            );
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: _colors['shade2']!,
            ),
          ),
          error: (error, _) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
      floatingActionButton: isToday
          ? FloatingActionButton(
              onPressed: _showAddFluidIntakeModalSheet,
              elevation: 10,
              backgroundColor: _colors['shade1']!,
              tooltip: 'Add Fluid Intake',
              child: Semantics(
                label: 'Add new fluid intake entry',
                child: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }
}
