import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/models/other_generic_models.dart';
import 'package:nephro_care/models/urine_output_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/fluid_input_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/providers/urine_output_provider.dart';
import 'package:nephro_care/screens/urine_output_screen/urine_output_input.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';
import 'package:nephro_care/widgets/nc_alert_dialogue.dart';

class UrineOutputLogScreen extends ConsumerStatefulWidget {
  const UrineOutputLogScreen({super.key});

  @override
  UrineOutputLogScreenState createState() => UrineOutputLogScreenState();
}

class UrineOutputLogScreenState extends ConsumerState<UrineOutputLogScreen> {
  final _colors = {
    'shade1': ComponentColors.urineColorShade1,
    'shade2': ComponentColors.urineColorShade2,
    'background': ComponentColors.urineBackgroundShade,
  };

  void _showSnackBar(String message, Color backgroundColor) {
    Utils.showSnackBar(context, message, backgroundColor);
  }

  Future<void> _showAddUrineOutputModalSheet() async {
    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: _colors['background']!,
      builder: (_) => const UrineOutputInput(),
    );

    if (result != null) {
      _showSnackBar(result.message, result.backgroundColor);
    }
  }

  Future<bool> _showEditConfirmationDialog() async {
    return Utils.showConfirmationDialog(
      context: context,
      title: 'Edit Entry',
      content: 'Do you want to edit this urine output entry?',
      confirmText: 'Edit',
      confirmColor: _colors['shade1'],
    );
  }

  void _showEditUrineOutputModalSheet(UrineOutput output) async {
    final selectedDate = ref.read(selectedDateProvider);
    final entryDate = output.timestamp.toDate();

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
      builder: (_) => UrineOutputInput(output: output),
    );

    if (result != null) {
      _showSnackBar(result.message, result.backgroundColor);
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return Utils.showConfirmationDialog(
      context: context,
      title: 'Delete Entry',
      content: 'Are you sure you want to delete this urine output entry?',
      confirmText: 'Delete',
    );
  }

  Future<bool> _showDeleteAllConfirmationDialog() async {
    return Utils.showConfirmationDialog(
      context: context,
      title: 'Delete All Entries',
      content:
          'Are you sure you want to delete all urine output entries for this date?',
      confirmText: 'Delete All',
    );
  }

  Future<void> _deleteAllUrineOutputs(
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
          .collection('urine_output')
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
        'All urine output entries deleted successfully',
        _colors['shade2']!,
      );
    } catch (e) {
      _showSnackBar(
        'Failed to delete entries: $e',
        errorColor,
      );
    }
  }

  Future<void> _deleteUrineOutput(
      String userId, String outputId, Color errorColor) async {
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
          .collection('urine_output')
          .doc(outputId)
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

  Future<bool> _showUrineOutputInformationDialogue() async {
    final fluidInputSummary = ref.watch(fluidIntakeSummaryProvider);
    final urineOutputSummary = ref.watch(urineOutputSummaryProvider);
    double? outputPercent;
    if (fluidInputSummary.asData?.value['total'] != null &&
        urineOutputSummary.asData?.value['total'] != null &&
        fluidInputSummary.asData!.value['total'] != 0) {
      outputPercent = (urineOutputSummary.asData!.value['total'] /
              fluidInputSummary.asData!.value['total']) *
          100;
    } else {
      outputPercent = null;
    }
    final lastUrineTime = urineOutputSummary.asData?.value['lastTime'] ?? 'N/A';
    final totalUrineTimes =
        urineOutputSummary.asData?.value['totalUrineToday']?.toString() ?? '0';

    final result = await showNCAlertDialogue(
      context: context,
      titleText: 'Urine Output Details',
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          vGap8,
          Text('• Number of times urinated today: $totalUrineTimes'),
          vGap16,
          Text(
            outputPercent != null
                ? '• Urine output ratio: ${outputPercent.toInt()}% of fluid intake'
                : '• No data available for output ratio',
          ),
          vGap16,
          Text(
            '• Last urinated at: $lastUrineTime',
          ),
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
  }

  Widget _buildHeader(
    bool isToday,
    String totalUrineQuantityFormatted,
    ThemeData theme,
    DateTime selectedDate,
  ) {
    return Container(
      width: double.infinity,
      color: _colors['background']!,
      padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
      child: Row(
        children: [
          Text(
            'Showing entries for ${isToday ? 'Today' : Utils.formatDateDMY(selectedDate)}',
            style: theme.textTheme.titleMedium!.copyWith(
              color: _colors['shade2']!,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _colors['shade2']!,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              totalUrineQuantityFormatted,
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
    final urineOutputAsync = ref.watch(urineOutputListProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    final allowDeleteAll = ref.watch(allowDeleteAllProvider);
    final isToday = Utils.isSameDay(selectedDate, DateTime.now());
    final isUrineLogEmpty = urineOutputAsync.asData?.value.isEmpty;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: _colors['shade2']!,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          'Urine Log',
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

              if (allowDeleteAll && isUrineLogEmpty == false) {
                items.insert(
                  0,
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
                final confirmed = await _showDeleteAllConfirmationDialog();
                if (confirmed) {
                  final user = ref.read(authProvider);
                  if (user != null) {
                    await _deleteAllUrineOutputs(
                        user.uid, selectedDate, errorColor);
                  }
                }
              } else if (value == 'details') {
                await _showUrineOutputInformationDialogue();
              }
            },
          ),
          hGap8,
        ],
      ),
      backgroundColor: _colors['background']!,
      body: SafeArea(
        top: false,
        child: urineOutputAsync.when(
          data: (outputs) {
            final totalUrineQuantity = outputs.fold<double>(
                0, (total, output) => total + output.quantity);
            final totalUrineQuantityFormatted =
                Utils.formatFluidValue(totalUrineQuantity);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (outputs.isNotEmpty)
                  _buildHeader(
                    isToday,
                    totalUrineQuantityFormatted,
                    theme,
                    selectedDate,
                  ),
                Expanded(
                  child: outputs.isEmpty
                      ? Center(
                          child: Text(
                            'No entries for ${isToday ? 'today.' : Utils.formatDateDMY(selectedDate)} ${isToday ? '\nAdd a urine output to track now.' : ''}',
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
                          itemCount: outputs.length,
                          itemBuilder: (context, index) {
                            final output = outputs[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: _colors['shade2']!,
                                  child: Dismissible(
                                    key: Key(output.id),
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
                                            await _showEditConfirmationDialog();
                                        if (confirmed) {
                                          _showEditUrineOutputModalSheet(
                                              output);
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
                                        _deleteUrineOutput(
                                            user.uid, output.id, errorColor);
                                      } else if (direction ==
                                          DismissDirection.startToEnd) {
                                        _showEditUrineOutputModalSheet(output);
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
                                              'Output type: ${output.outputName}',
                                          child: Text(
                                            'Output: ${output.outputName}',
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
                                              'Quantity: ${output.quantity} milliliters',
                                          child: Text(
                                            Utils.formatFluidValue(
                                                output.quantity),
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
                                              'Time: ${Utils.formatTime(output.timestamp.toDate())}',
                                          child: Text(
                                            Utils.formatTime(
                                                output.timestamp.toDate()),
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
              onPressed: _showAddUrineOutputModalSheet,
              elevation: 10,
              backgroundColor: _colors['shade1']!,
              tooltip: 'Add Urine Output',
              child: Semantics(
                label: 'Add new urine output entry',
                child: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }
}
