import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/constants/constants.dart';
import 'package:nephro_care/constants/strings_constants.dart';
import 'package:nephro_care/constants/ui_helper.dart';
import 'package:nephro_care/models/other_models.dart';
import 'package:nephro_care/providers/auth_provider.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/utils/date_time_utils.dart';
import 'package:nephro_care/utils/measurement_utils.dart';
import 'package:nephro_care/utils/ui_utils.dart';
import 'package:nephro_care/widgets/nc_alert_dialogue.dart';

class LogScreen<T> extends ConsumerStatefulWidget {
  final String appBarTitle;
  final String? headerText;
  final String? headerTitleString;
  final Widget Function(List<T> items)? headerActionButton;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final IconData listItemIcon;
  final StreamProviderFamily<dynamic, (String, DateTime)> dataProvider;
  final Provider<Map<String, dynamic>> summaryProvider;
  final String firestoreCollection;
  final Widget Function(T? item) inputWidgetBuilder;
  final Widget Function(BuildContext context, T item) listItemBuilder;
  final Widget Function(BuildContext context, Map<String, dynamic> summary)
      logDetailsDialogBuilder;
  final List<T> Function(dynamic cache) itemsExtractor;
  final ({String number, String unit}) Function(List<T> items) totalFormatter;

  const LogScreen({
    super.key,
    required this.appBarTitle,
    this.headerActionButton,
    this.headerText,
    this.headerTitleString,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.listItemIcon,
    required this.dataProvider,
    required this.summaryProvider,
    required this.firestoreCollection,
    required this.inputWidgetBuilder,
    required this.listItemBuilder,
    required this.logDetailsDialogBuilder,
    required this.itemsExtractor,
    required this.totalFormatter,
  });

  @override
  ConsumerState<LogScreen<T>> createState() => _LogScreenState<T>();
}

class _LogScreenState<T> extends ConsumerState<LogScreen<T>> {

  void _showSnackBar(String message, Color backgroundColor) {
    UIUtils.showSnackBar(context, message, backgroundColor);
  }


  Future<void> _showAddInputModalSheet() async {
    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.backgroundColor,
      builder: (_) => widget.inputWidgetBuilder(null),
    );

    if (result != null) {
      _showSnackBar(result.message, result.backgroundColor);
    }
  }


  Future<bool> _showEditConfirmationDialog() async {
    return UIUtils.showConfirmationDialog(
      context: context,
      title: Strings.editEntryTitle,
      content:
          '${Strings.editEntryContentPrefix}${widget.appBarTitle.toLowerCase()}${Strings.entrySuffix}',
      confirmText: Strings.editConfirmText,
      confirmColor: widget.primaryColor,
    );
  }


  void _showEditModalSheet(T item) async {
    final selectedDate = ref.read(selectedDateProvider);
    final entryDate = (item as dynamic).timestamp.toDate();

    if (!DateTimeUtils.isSameDay(entryDate, selectedDate)) {
      _showSnackBar(
        Strings.editTodayOnly,
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    final result = await showModalBottomSheet<DialogResult>(
      context: context,
      isScrollControlled: true,
      backgroundColor: widget.backgroundColor,
      builder: (_) => widget.inputWidgetBuilder(item),
    );

    if (result != null) {
      _showSnackBar(result.message, result.backgroundColor);
    }
  }


  Future<bool> _showDeleteConfirmationDialog() async {
    return UIUtils.showConfirmationDialog(
      context: context,
      title: Strings.deleteEntryTitle,
      content:
          '${Strings.deleteEntryContentPrefix}${widget.appBarTitle.toLowerCase()}${Strings.entrySuffix}',
      confirmText: Strings.deleteConfirmText,
    );
  }


  Future<void> _deleteEntry(
      String userId, String itemId, Color errorColor) async {
    try {
      final user = ref.read(authProvider);
      if (user == null) {
        _showSnackBar(Strings.userNotAuthenticated, errorColor);
        return;
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection(widget.firestoreCollection)
          .doc(itemId)
          .delete();
      _showSnackBar(Strings.entryDeletedSuccessfully, widget.primaryColor);
    } catch (e) {
      _showSnackBar('${Strings.failedToDeleteEntryPrefix}$e', errorColor);
    }
  }


  Future<bool> _showDeleteAllConfirmationDialog() async {
    return UIUtils.showConfirmationDialog(
      context: context,
      title: Strings.deleteAllEntriesTitle,
      content:
          '${Strings.deleteAllEntriesContentPrefix}${widget.appBarTitle.toLowerCase()}${Strings.entriesForDateSuffix}',
      confirmText: Strings.deleteAllConfirmText,
    );
  }


  Future<void> _deleteAllEntries(
      String userId, List<T> items, Color errorColor) async {
    try {
      final user = ref.read(authProvider);
      if (user == null) {
        _showSnackBar(Strings.userNotAuthenticated, errorColor);
        return;
      }

      final batch = FirebaseFirestore.instance.batch();
      for (var item in items) {
        batch.delete(
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection(widget.firestoreCollection)
              .doc((item as dynamic).id),
        );
      }
      await batch.commit();

      _showSnackBar(
        '${Strings.allEntriesDeletedSuccessfullyPrefix}${widget.appBarTitle.toLowerCase()}${Strings.allEntriesDeletedSuccessfullySuffix}',
        widget.primaryColor,
      );
    } catch (e) {
      _showSnackBar('${Strings.failedToDeleteEntriesPrefix}$e', errorColor);
    }
  }


  Future<bool> _showLogDetailsDialog() async {
    final dataAsync = ref.watch(
      widget.dataProvider(
        (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
      ),
    );

    return dataAsync.when(
      data: (cache) async {
        final summary = ref.read(widget.summaryProvider);
        final result = await showNCAlertDialog(
          context: context,
          titleText: Strings.logDetails,
          titleColor: widget.primaryColor,
          content: widget.logDetailsDialogBuilder(context, summary),
          action1: const SizedBox(),
          action2: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(widget.primaryColor),
            ),
            child: Text(
              Strings.okButton,
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: Theme.of(context).colorScheme.surfaceBright,
                  ),
            ),
          ),
        );
        return result ?? false;
      },
      loading: () {
        _showSnackBar('Loading summary...', widget.primaryColor);
        return false;
      },
      error: (e, _) {
        _showSnackBar(
            'Failed to load summary: $e', Theme.of(context).colorScheme.error);
        return false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final errorColor = theme.colorScheme.error;
    final selectedDate = ref.watch(selectedDateProvider);
    final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());
    final allowDeleteAll = ref.watch(allowDeleteAllProvider);
    final dataAsync = ref.watch(widget.dataProvider(
      (ref.watch(authProvider)!.uid, ref.watch(selectedDateProvider)),
    ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back, color: widget.primaryColor),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          widget.appBarTitle,
        ),
        backgroundColor: widget.backgroundColor,
        surfaceTintColor: Colors.transparent,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: widget.primaryColor,
            ),
            color: widget.backgroundColor,
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
                        horizontal: 4,
                        vertical: 0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: InkWell(
                          onTap: () => Navigator.pop(context, 'details'),
                          borderRadius: BorderRadius.circular(8),
                          splashColor:
                              widget.primaryColor.withValues(alpha: 0.3),
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 6,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  size: 26,
                                  color: widget.primaryColor,
                                ),
                                hGap8,
                                Text(
                                  Strings.logDetails,
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    color: widget.primaryColor,
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
                  widget.itemsExtractor(dataAsync.asData?.value).isNotEmpty ==
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
                          horizontal: 4,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: InkWell(
                            onTap: () => Navigator.pop(context, 'delete_all'),
                            borderRadius: BorderRadius.circular(8),
                            splashColor: widget.primaryColor.withValues(
                              alpha: 0.3,
                            ),
                            highlightColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.delete_forever,
                                    size: 26,
                                    color: widget.primaryColor,
                                  ),
                                  hGap8,
                                  Text(
                                    Strings.deleteAllConfirmText,
                                    style:
                                        theme.textTheme.titleMedium!.copyWith(
                                      color: widget.primaryColor,
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
                  final items = widget.itemsExtractor(dataAsync.asData?.value);
                  if (user != null) {
                    await _deleteAllEntries(user.uid, items, errorColor);
                  }
                }
              } else if (value == 'details') {
                await _showLogDetailsDialog();
              }
            },
          ),
          hGap8,
        ],
      ),
      backgroundColor: widget.backgroundColor,
      body: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.only(
            left: kScaffoldBodyPadding,
            right: kScaffoldBodyPadding,
            bottom: kScaffoldBodyPadding,
          ),
          child: dataAsync.when(
            data: (cache) {
              final items = widget.itemsExtractor(cache);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (items.isNotEmpty)
                    Container(
                      width: double.infinity,
                      color: widget.backgroundColor,
                      padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                      child: Row(
                        children: [
                          Text(
                            widget.headerText ??
                                'Total ${widget.headerTitleString?.toLowerCase()} ${isToday ? 'for today :' : 'on ${DateTimeUtils.formatDateDM(selectedDate)}'}',
                            style: theme.textTheme.titleLarge!.copyWith(
                              color: widget.primaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          widget.headerActionButton != null
                              ? widget.headerActionButton!(items)
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: widget.primaryColor,
                                    borderRadius: BorderRadius.circular(32),
                                  ),
                                  child:
                                      MeasurementUtils.createRichTextValueWithUnit(
                                    value: widget.totalFormatter(items).number,
                                    unit: widget.totalFormatter(items).unit,
                                    valueStyle:
                                        theme.textTheme.titleMedium!.copyWith(
                                      color: widget.backgroundColor,
                                      fontSize: kValueFontSize,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    unitStyle:
                                        theme.textTheme.titleMedium!.copyWith(
                                      color: widget.backgroundColor,
                                          fontSize: kSIUnitFontSize,
                                          fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: items.isEmpty
                        ? Center(
                            child: Text(
                              '${Strings.noEntriesPrefix}${isToday ? 'today.' : DateTimeUtils.formatDateDMY(selectedDate)} ${isToday ? '\n${Strings.addEntryPromptSuffix}${widget.appBarTitle.toLowerCase()}${Strings.toTrackNow}' : ''}',
                              style: theme.textTheme.titleLarge!.copyWith(
                                color: widget.primaryColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              top: kScaffoldBodyPadding * 1.5,
                            ),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: kScaffoldBodyPadding),
                                child: ClipRRect(
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(12),
                                  child: Container(
                                    color: widget.primaryColor,
                                    child: Dismissible(
                                      key: Key((item as dynamic).id),
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
                                            _showEditModalSheet(item);
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
                                          _deleteEntry(user.uid,
                                              (item as dynamic).id, errorColor);
                                        } else if (direction ==
                                            DismissDirection.startToEnd) {
                                          _showEditModalSheet(item);
                                        }
                                      },
                                      background: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: widget.secondaryColor,
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
                                                color: theme
                                                    .colorScheme.surfaceBright,
                                              ),
                                              hGap16,
                                              Text(
                                                'Edit this Entry',
                                                style: theme
                                                    .textTheme.titleMedium!
                                                    .copyWith(
                                                  color: widget.backgroundColor,
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
                                                  color: widget.backgroundColor,
                                                ),
                                              ),
                                              hGap16,
                                              Icon(Icons.delete,
                                                  color: theme.colorScheme
                                                      .surfaceBright),
                                              hGap8,
                                            ],
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: widget.primaryColor,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: widget.listItemBuilder(
                                          context,
                                          item,
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
                color: widget.primaryColor,
              ),
            ),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ),
      ),
      floatingActionButton: isToday
          ? FloatingActionButton(
              onPressed: _showAddInputModalSheet,
              elevation: 10,
              backgroundColor: widget.primaryColor,
              tooltip: 'Add ${widget.appBarTitle} Entry',
              child: Semantics(
                label: 'Add new ${widget.appBarTitle.toLowerCase()} entry',
                child: const Icon(Icons.add),
              ),
            )
          : null,
    );
  }
}
