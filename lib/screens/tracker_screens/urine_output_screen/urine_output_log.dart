import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/models/urine_output_model.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/fluid_input_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/providers/urine_output_provider.dart';
import 'package:nephro_care/screens/tracker_screens/urine_output_screen/urine_output_input.dart';
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
  void _showSnackBar(String message, Color backgroundColor) {
    Utils.showSnackBar(context, message, backgroundColor);
  }

  Future<void> _showAddUrineOutputModalSheet() async {
    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ComponentColors.urineBackgroundShade,
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
      confirmColor: ComponentColors.urineColorShade1,
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
      backgroundColor: ComponentColors.urineBackgroundShade,
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
        ComponentColors.urineColorShade2,
      );
    } catch (e) {
      _showSnackBar(
        'Failed to delete entry: $e',
        errorColor,
      );
    }
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
      String userId, List<UrineOutput> urineOutputs, Color errorColor) async {
    try {
      final user = ref.read(authProvider);
      if (user == null) {
        _showSnackBar(
          'User not authenticated. Please log in.',
          errorColor,
        );
        return;
      }
      final batch = FirebaseFirestore.instance.batch();
      for (var output in urineOutputs) {
        batch.delete(
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('urine_output')
              .doc(output.id),
        );
      }
      await batch.commit();

      _showSnackBar(
        'All urine output entries deleted successfully',
        ComponentColors.urineColorShade2,
      );
    } catch (e) {
      _showSnackBar(
        'Failed to delete entries: $e',
        errorColor,
      );
    }
  }

  Future<bool> _showUrineOutputLogDetailsDialogue() async {
    final urineDataAsync = ref.watch(urineOutputDataProvider(
      (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
    ));
    final fluidDataAsync = ref.watch(fluidIntakeDataProvider(
      (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
    ));

    return urineDataAsync.when(
      data: (urineCache) async {
        final urineSummary = ref.read(urineOutputSummaryProvider);
        final fluidSummary = fluidDataAsync.when(
          data: (fluidCache) => ref.read(fluidIntakeSummaryProvider),
          loading: () => {
            'total': 0,
          },
          error: (_, __) => {
            'total': 0,
          },
        );

        final lastUrineTime = urineSummary['lastTime'] ?? 'Unknown';
        final totalUrineTimes = urineSummary['totalUrineToday'] ?? 0;
        double? outputPercent;
        if (fluidSummary['total'] != 0) {
          outputPercent = (urineSummary['total'] / fluidSummary['total']) * 100;
        }
        final theme = Theme.of(context);

        final result = await showNCAlertDialogue(
          context: context,
          titleText: 'Urine Output Details',
          titleColor: ComponentColors.urineColorShade2,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              vGap8,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '• Number of times urinated: ',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    TextSpan(
                      text: '$totalUrineTimes',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ComponentColors.urineColorShade2, // 0xFFA6742E
                      ),
                    ),
                  ],
                ),
              ),
              vGap16,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: outputPercent != null
                          ? '• Urine output ratio: '
                          : '• No data available for output ratio',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    if (outputPercent != null)
                      TextSpan(
                        text: '${outputPercent.toInt()}%',
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: ComponentColors.urineColorShade2, // 0xFFA6742E
                        ),
                      ),
                  ],
                ),
              ),
              vGap16,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '• Last urinated at: ',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    TextSpan(
                      text: lastUrineTime,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w700,
                        color: ComponentColors.urineColorShade2, // 0xFFA6742E
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          action1: const SizedBox(),
          action2: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: ComponentColors.urineColorShade2,
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
          'Loading urine output summary...',
          ComponentColors.urineColorShade2,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final urineDataAsync = ref.watch(urineOutputDataProvider(
      (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
    ));
    final selectedDate = ref.watch(selectedDateProvider);
    final allowDeleteAll = ref.watch(allowDeleteAllProvider);
    final isToday = Utils.isSameDay(selectedDate, DateTime.now());

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: ComponentColors.urineColorShade2,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          'Urine Log',
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ComponentColors.urineColorShade2,
          ),
        ),
        backgroundColor: ComponentColors.urineBackgroundShade,
        surfaceTintColor: Colors.transparent,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: ComponentColors.urineColorShade2,
            ),
            color: ComponentColors.urineBackgroundShade,
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
                          splashColor:
                              ComponentColors.urineColorShade2.withOpacity(0.3),
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 6,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.info,
                                  size: 30,
                                  color: ComponentColors.urineColorShade2,
                                ),
                                hGap8,
                                Text(
                                  'Log Details',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: ComponentColors.urineColorShade2,
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

              if (allowDeleteAll &&
                  urineDataAsync.asData?.value.urineOutputs.isNotEmpty ==
                      true) {
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
                            splashColor: ComponentColors.urineColorShade2
                                .withOpacity(0.3),
                            highlightColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 6,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.delete_forever,
                                    size: 30,
                                    color: ComponentColors.urineColorShade2,
                                  ),
                                  hGap8,
                                  Text(
                                    'Delete All',
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      color: ComponentColors.urineColorShade2,
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
                    final urineOutputs =
                        urineDataAsync.asData?.value.urineOutputs ?? [];
                    await _deleteAllUrineOutputs(
                        user.uid, urineOutputs, errorColor);
                  }
                }
              } else if (value == 'details') {
                await _showUrineOutputLogDetailsDialogue();
              }
            },
          ),
          hGap8,
        ],
      ),
      backgroundColor: ComponentColors.urineBackgroundShade,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: kScaffoldBodyPadding,
            right: kScaffoldBodyPadding,
            bottom: kScaffoldBodyPadding,
          ),
          child: urineDataAsync.when(
            data: (cache) {
              final outputs = cache.urineOutputs;
              final totalUrineQuantity = outputs.fold<double>(
                  0, (total, output) => total + output.quantity);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (outputs.isNotEmpty)
                    Container(
                      width: double.infinity,
                      color: ComponentColors.urineBackgroundShade,
                      padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
                      child: Row(
                        children: [
                          Text(
                            'Total urine output for ${isToday ? 'today :' : 'on ${Utils.formatDateDM(selectedDate)}'}',
                            style: theme.textTheme.titleMedium!.copyWith(
                              color: ComponentColors.urineColorShade2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ComponentColors.urineColorShade2,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              Utils.formatFluidValue(totalUrineQuantity),
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: ComponentColors.urineBackgroundShade,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: outputs.isEmpty
                        ? Center(
                            child: Text(
                              'No entries for ${isToday ? 'today.' : Utils.formatDateDMY(selectedDate)} ${isToday ? '\nAdd a urine output to track now.' : ''}',
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: ComponentColors.urineColorShade2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: 0,
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
                                    color: ComponentColors.urineColorShade2,
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
                                          _showEditUrineOutputModalSheet(
                                              output);
                                        }
                                      },
                                      background: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ComponentColors
                                                .urineColorShade1,
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
                                                  color: ComponentColors
                                                      .urineBackgroundShade,
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
                                                  color: ComponentColors
                                                      .urineBackgroundShade,
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
                                          color:
                                              ComponentColors.urineColorShade2,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.water_drop,
                                            color: ComponentColors
                                                .urineBackgroundShade,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 12),
                                          title: Semantics(
                                            label:
                                                'Output type: ${output.outputName}',
                                            child: Text(
                                              'Output: ${output.outputName}',
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                color: ComponentColors
                                                    .urineBackgroundShade,
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
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                color: ComponentColors
                                                    .urineBackgroundShade,
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
                                                color: ComponentColors
                                                    .urineBackgroundShade,
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
            loading: () => const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: ComponentColors.urineColorShade2,
              ),
            ),
            error: (error, _) => Center(
              child: Text('Error: $error'),
            ),
          ),
        ),
      ),
      floatingActionButton: isToday
          ? FloatingActionButton(
              onPressed: _showAddUrineOutputModalSheet,
              elevation: 10,
              backgroundColor: ComponentColors.urineColorShade1,
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
