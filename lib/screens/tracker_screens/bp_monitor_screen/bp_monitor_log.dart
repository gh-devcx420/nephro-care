import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/models/bp_monitor_model.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/bp_monitor_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/screens/tracker_screens/bp_monitor_screen/bp_monitor_input.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/utils/utils.dart';
import 'package:nephro_care/widgets/nc_alert_dialogue.dart';

class BPMonitorLogScreen extends ConsumerStatefulWidget {
  const BPMonitorLogScreen({super.key});

  @override
  BPMonitorLogScreenState createState() => BPMonitorLogScreenState();
}

class BPMonitorLogScreenState extends ConsumerState<BPMonitorLogScreen> {
  void _showSnackBar(String message, Color backgroundColor) {
    Utils.showSnackBar(context, message, backgroundColor);
  }

  Future<void> _showAddBPValuesModalSheet() async {
    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: ComponentColors.bloodBackgroundShade,
      builder: (_) => const BPMonitorInput(),
    );

    if (result != null) {
      _showSnackBar(result.message, result.backgroundColor);
    }
  }

  Future<bool> _showEditConfirmationDialog() async {
    return Utils.showConfirmationDialog(
      context: context,
      title: 'Edit Entry',
      content: 'Do you want to edit this blood pressure entry?',
      confirmText: 'Edit',
      confirmColor: ComponentColors.bloodColorShade1,
    );
  }

  void _showEditBPMonitorModalSheet(BPMonitor bpMeasure) async {
    final selectedDate = ref.read(selectedDateProvider);
    final entryDate = bpMeasure.timestamp.toDate();

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
      backgroundColor: ComponentColors.bloodBackgroundShade,
      builder: (_) => BPMonitorInput(bpMeasure: bpMeasure),
    );

    if (result != null) {
      _showSnackBar(result.message, result.backgroundColor);
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return Utils.showConfirmationDialog(
      context: context,
      title: 'Delete Entry',
      content: 'Are you sure you want to delete this blood pressure entry?',
      confirmText: 'Delete',
    );
  }

  Future<void> _deleteBPMonitor(
      String userId, String bpMeasureId, Color errorColor) async {
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
          .collection('bp_monitor')
          .doc(bpMeasureId)
          .delete();
      _showSnackBar(
        'Entry deleted successfully',
        ComponentColors.bloodColorShade2,
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
          'Are you sure you want to delete all blood pressure entries for this date?',
      confirmText: 'Delete All',
    );
  }

  Future<void> _deleteAllBPMonitors(
      String userId, List<BPMonitor> bpMonitors, Color errorColor) async {
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
      for (var bpMonitor in bpMonitors) {
        batch.delete(
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('bp_monitor')
              .doc(bpMonitor.id),
        );
      }
      await batch.commit();

      _showSnackBar(
        'All blood pressure entries deleted successfully',
        ComponentColors.bloodColorShade2,
      );
    } catch (e) {
      _showSnackBar(
        'Failed to delete entries: $e',
        errorColor,
      );
    }
  }

  Future<bool> _showBPMonitorLogDetailsDialogue() async {
    final bpCacheAsync = ref.watch(bpMonitorDataProvider(
      (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
    ));

    return bpCacheAsync.when(
      data: (cache) async {
        final bpSummary = ref.read(bpMonitorSummaryProvider);

        final lastTime = bpSummary['lastTime'] ?? 'Unknown';
        final totalMeasurements = bpSummary['totalMeasurements'] ?? 0;
        final averageSystolic = bpSummary['averageSystolic'] ?? 0;
        final averageDiastolic = bpSummary['averageDiastolic'] ?? 0;
        final averagePulse = bpSummary['averagePulse'] ?? 0;
        final averageSpo2 = bpSummary['averageSpo2'] != null
            ? '${bpSummary['averageSpo2'].toStringAsFixed(1)}%'
            : 'N/A';
        final theme = Theme.of(context);

        final result = await showNCAlertDialogue(
          context: context,
          titleText: 'Blood Pressure Details',
          titleColor: ComponentColors.bloodColorShade2,
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              vGap8,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '• Number of measurements: ',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    TextSpan(
                      text: '$totalMeasurements',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: ComponentColors.bloodColorShade2, // 0xFF8E24AA
                      ),
                    ),
                  ],
                ),
              ),
              vGap12,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '• Average BP: ',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    TextSpan(
                      text: '$averageSystolic / $averageDiastolic mmHg',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: ComponentColors.bloodColorShade2, // 0xFF8E24AA
                      ),
                    ),
                  ],
                ),
              ),
              vGap12,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '• Average Pulse: ',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    TextSpan(
                      text: '$averagePulse bpm',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: ComponentColors.bloodColorShade2, // 0xFF8E24AA
                      ),
                    ),
                  ],
                ),
              ),
              vGap12,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '• Average SpO2: ',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    TextSpan(
                      text: averageSpo2,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: ComponentColors.bloodColorShade2, // 0xFF8E24AA
                      ),
                    ),
                  ],
                ),
              ),
              vGap12,
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '• Last measured at: ',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w400,
                        color: theme.textTheme.bodyMedium!.color,
                      ),
                    ),
                    TextSpan(
                      text: lastTime,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: ComponentColors.bloodColorShade2, // 0xFF8E24AA
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
              backgroundColor: ComponentColors.bloodColorShade2,
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
          'Loading blood pressure summary...',
          ComponentColors.bloodColorShade2,
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
    final bpMonitorAsync = ref.watch(bpMonitorDataProvider(
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
            color: ComponentColors.bloodColorShade2,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          'Blood Pressure Log',
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ComponentColors.bloodColorShade2,
          ),
        ),
        backgroundColor: ComponentColors.bloodBackgroundShade,
        surfaceTintColor: Colors.transparent,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: ComponentColors.bloodColorShade2,
            ),
            color: ComponentColors.bloodBackgroundShade,
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
                              ComponentColors.bloodColorShade2.withOpacity(0.3),
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
                                  color: ComponentColors.bloodColorShade2,
                                ),
                                hGap8,
                                Text(
                                  'Log Details',
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: ComponentColors.bloodColorShade2,
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
                  bpMonitorAsync.asData?.value.bpMonitors.isNotEmpty == true) {
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
                            splashColor: ComponentColors.bloodColorShade2
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
                                    color: ComponentColors.bloodColorShade2,
                                  ),
                                  hGap8,
                                  Text(
                                    'Delete All',
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      color: ComponentColors.bloodColorShade2,
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
                  final bpMonitors =
                      bpMonitorAsync.asData?.value.bpMonitors ?? [];
                  if (user != null) {
                    await _deleteAllBPMonitors(
                        user.uid, bpMonitors, errorColor);
                  }
                }
              } else if (value == 'details') {
                await _showBPMonitorLogDetailsDialogue();
              }
            },
          ),
          hGap8,
        ],
      ),
      backgroundColor: ComponentColors.bloodBackgroundShade,
      body: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(
              left: kScaffoldBodyPadding,
              right: kScaffoldBodyPadding,
              bottom: kScaffoldBodyPadding,
            ),
            child: bpMonitorAsync.when(
              data: (cache) {
                final bpMeasures = cache.bpMonitors;
                final bpSummary = ref.read(bpMonitorSummaryProvider);
                final averageBPToday =
                    '${bpSummary['averageSystolic']} / ${bpSummary['averageDiastolic']}';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (bpMeasures.isNotEmpty)
                      Container(
                        width: double.infinity,
                        color: ComponentColors.bloodBackgroundShade,
                        padding: const EdgeInsets.fromLTRB(12, 0, 4, 12),
                        child: Row(
                          children: [
                            Text(
                              'Average BP for ${isToday ? 'today :' : Utils.formatDateDMY(selectedDate)}',
                              style: theme.textTheme.titleMedium!.copyWith(
                                color: ComponentColors.bloodColorShade2,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: ComponentColors.bloodColorShade2,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                averageBPToday,
                                style: theme.textTheme.titleMedium!.copyWith(
                                  color: ComponentColors.bloodBackgroundShade,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: bpMeasures.isEmpty
                          ? Center(
                              child: Text(
                                'No entries for ${isToday ? 'today.' : Utils.formatDateDMY(selectedDate)} ${isToday ? '\nAdd a BP measurement to track now.' : ''}',
                                style: theme.textTheme.titleLarge!.copyWith(
                                  color: ComponentColors.bloodColorShade2,
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
                              itemCount: bpMeasures.length,
                              itemBuilder: (context, index) {
                                final bpMeasure = bpMeasures[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: ClipRRect(
                                    clipBehavior: Clip.hardEdge,
                                    borderRadius: BorderRadius.circular(12),
                                    child: Container(
                                      color: ComponentColors.bloodColorShade2,
                                      child: Dismissible(
                                        key: Key(bpMeasure.id),
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
                                              _showEditBPMonitorModalSheet(
                                                  bpMeasure);
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
                                            _deleteBPMonitor(user.uid,
                                                bpMeasure.id, errorColor);
                                          } else if (direction ==
                                              DismissDirection.startToEnd) {
                                            _showEditBPMonitorModalSheet(
                                                bpMeasure);
                                          }
                                        },
                                        background: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ComponentColors
                                                  .bloodColorShade1,
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
                                                  color: theme.colorScheme
                                                      .surfaceBright,
                                                ),
                                                hGap16,
                                                Text(
                                                  'Edit this Entry',
                                                  style: theme
                                                      .textTheme.titleMedium!
                                                      .copyWith(
                                                    color: ComponentColors
                                                        .bloodBackgroundShade,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        secondaryBackground: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.error,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(
                                                right: 20),
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
                                                        .bloodBackgroundShade,
                                                  ),
                                                ),
                                                hGap16,
                                                Icon(
                                                  Icons.delete,
                                                  color: theme.colorScheme
                                                      .surfaceBright,
                                                ),
                                                hGap8,
                                              ],
                                            ),
                                          ),
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ComponentColors
                                                .bloodColorShade2,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: ListTile(
                                            leading: const Icon(
                                              Icons.monitor_heart_sharp,
                                              color: ComponentColors
                                                  .bloodBackgroundShade,
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            title: Semantics(
                                              label:
                                                  'Blood Pressure: ${bpMeasure.systolic}/${bpMeasure.diastolic}',
                                              child: Text(
                                                'BP: ${bpMeasure.systolic}/${bpMeasure.diastolic}',
                                                style: theme
                                                    .textTheme.titleMedium!
                                                    .copyWith(
                                                  color: ComponentColors
                                                      .bloodBackgroundShade,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            subtitle: Semantics(
                                              label:
                                                  'Pulse: ${bpMeasure.pulse} bpm, SpO2: ${bpMeasure.spo2?.toInt() ?? 'N/A'}%',
                                              child: Text(
                                                'Pulse: ${bpMeasure.pulse} bpm${bpMeasure.spo2 != null ? ' ; SpO2: ${bpMeasure.spo2!.toInt()} %' : ''}',
                                                style: theme
                                                    .textTheme.titleMedium!
                                                    .copyWith(
                                                  color: ComponentColors
                                                      .bloodBackgroundShade,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            trailing: Semantics(
                                              label:
                                                  'Time: ${Utils.formatTime(bpMeasure.timestamp.toDate())}',
                                              child: Text(
                                                Utils.formatTime(bpMeasure
                                                    .timestamp
                                                    .toDate()),
                                                style: theme
                                                    .textTheme.bodyMedium!
                                                    .copyWith(
                                                  color: ComponentColors
                                                      .bloodBackgroundShade,
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
                  color: ComponentColors.bloodColorShade2,
                ),
              ),
              error: (error, _) => Center(
                child: Text('Error: $error'),
              ),
            ),
          )),
      floatingActionButton: isToday
          ? FloatingActionButton(
              onPressed: _showAddBPValuesModalSheet,
              elevation: 10,
              backgroundColor: ComponentColors.bloodColorShade1,
              tooltip: 'Add Blood Pressure Measurement',
              child: Semantics(
                label: 'Add new blood pressure measurement entry',
                child: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }
}
