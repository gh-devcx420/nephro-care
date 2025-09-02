import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/constants/strings.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/core/widgets/nc_alert_dialogue.dart';
import 'package:nephro_care/core/widgets/nc_icon_button.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/themes/color_schemes.dart';
import 'package:nephro_care/core/utils/date_utils.dart';
import 'package:nephro_care/features/settings/settings_provider.dart';

class Cache<T> {
  final List<T> items;
  final DateTime lastFetched;

  Cache({
    required this.items,
    required this.lastFetched,
  });
}


class LogScreen<T> extends ConsumerStatefulWidget {
  final String appBarTitle;
  final String? headerText;
  final String? headerTitleString;
  final Widget Function(List<T> items)? headerActionButton;
  final Color primaryColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final FirestoreService firestoreService;
  final IconData listItemIcon;
  final StreamProviderFamily<Cache<T>, (String, DateTime)> dataProvider;
  final Provider<Map<String, dynamic>> summaryProvider;
  final String firestoreCollection;
  final Widget Function(T? item) inputModalSheet;
  final Widget Function(BuildContext context, T item) listItemBuilder;
  final Widget Function(BuildContext context, Map<String, dynamic> summary)
      logDetailsDialogBuilder;
  final List<T> Function(Cache<T>) itemsExtractor;
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
    required this.firestoreService,
    required this.listItemIcon,
    required this.dataProvider,
    required this.summaryProvider,
    required this.firestoreCollection,
    required this.inputModalSheet,
    required this.listItemBuilder,
    required this.logDetailsDialogBuilder,
    required this.itemsExtractor,
    required this.totalFormatter,
  });

  @override
  ConsumerState<LogScreen<T>> createState() => _LogScreenState<T>();
}

class _LogScreenState<T> extends ConsumerState<LogScreen<T>> {
  bool _isPressed = false;

  void _showSnackBar({
    required String message,
    required Color backgroundColor,
    int? snackbarDuration,
  }) {
    UIUtils.showNCSnackBar(
      context: context,
      message: message,
      backgroundColor: backgroundColor,
      durationSeconds: snackbarDuration,
    );
  }

  PopupMenuItem<String> buildPopupMenuItem({
    required String value,
    required IconData icon,
    required String text,
  }) {
    return PopupMenuItem<String>(
      value: value,
      padding: EdgeInsets.zero,
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context, value);
              },
              borderRadius: BorderRadius.circular(8),
              splashColor: widget.primaryColor.withValues(alpha: 0.3),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 26,
                      color: widget.primaryColor,
                    ),
                    hGap8,
                    Text(
                      text,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
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
    );
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
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop(true);
            },
            child: const Text(
              Strings.okButton,
            ),
          ),
        );
        return result ?? false;
      },
      loading: () {
        _showSnackBar(
          message: 'Loading summary...',
          backgroundColor: widget.primaryColor,
        );
        return false;
      },
      error: (e, _) {
        _showSnackBar(
          message: 'Failed to load summary: $e',
          backgroundColor: Theme.of(context).colorScheme.error,
        );
        return false;
      },
    );
  }

  Future<void> _showAddInputModalSheet() async {
    final result = await showModalBottomSheet<Result>(
      context: context,
      isScrollControlled: true,
      builder: (_) => widget.inputModalSheet(null),
    );

    if (result != null) {
      _showSnackBar(
        message: result.message,
        backgroundColor: result.backgroundColor,
        snackbarDuration: 2,
      );
    }
  }

  Future<bool> _showEditConfirmationDialog() async {
    return UIUtils.showNCConfirmationDialog(
      context: context,
      title: Strings.editEntryTitle,
      content:
          '${Strings.editEntryContentPrefix}${widget.appBarTitle.toLowerCase()}${Strings.entrySuffix}',
      confirmText: Strings.editConfirmText,
      confirmColor: widget.primaryColor,
    );
  }

  void _showEditModalSheet({required T logItem}) async {
    final result = await showModalBottomSheet<Result>(
      context: context,
      isScrollControlled: true,
      builder: (_) => widget.inputModalSheet(logItem),
    );

    if (result != null) {
      _showSnackBar(
        message: result.message,
        backgroundColor: Colors.green,
        snackbarDuration: 2,
      );
    }
  }

  Future<bool> _showDeleteConfirmationDialog() async {
    return UIUtils.showNCConfirmationDialog(
      context: context,
      title: Strings.deleteEntryTitle,
      content:
          '${Strings.deleteEntryContentPrefix}${widget.appBarTitle.toLowerCase()}${Strings.entrySuffix}',
      confirmText: Strings.deleteConfirmText,
    );
  }

  Future<void> _deleteEntry({
    required String userId,
    required String logItemId,
    required Color errorColor,
    required Color successColor,
  }) async {
    final user = ref.read(authProvider);

    if (user == null) {
      _showSnackBar(
        message: Strings.userNotAuthenticated,
        backgroundColor: errorColor,
      );
      return;
    }

    final result = await widget.firestoreService.deleteEntry(
      userId: user.uid,
      collection: widget.firestoreCollection,
      docId: logItemId,
      successMessage: Strings.entryDeletedSuccessfully,
      successColor: successColor,
      errorMessagePrefix: Strings.failedToDeleteEntryPrefix,
      errorColor: errorColor,
    );
    _showSnackBar(
      message: result.message,
      backgroundColor: result.backgroundColor,
      snackbarDuration: 2,
    );
  }

  Future<bool> _showDeleteAllConfirmationDialog() async {
    return UIUtils.showNCConfirmationDialog(
      context: context,
      title: Strings.deleteAllEntriesTitle,
      content:
          '${Strings.deleteAllEntriesContentPrefix}${widget.appBarTitle.toLowerCase()}${Strings.entriesForDateSuffix}',
      confirmText: Strings.deleteAllConfirmText,
    );
  }

  Future<void> _deleteAllEntries({
    required String userId,
    required List<T> logItems,
    required Color errorColor,
    required Color successColor,
  }) async {
    final user = ref.read(authProvider);

    if (user == null) {
      _showSnackBar(
        message: Strings.userNotAuthenticated,
        backgroundColor: errorColor,
      );
      return;
    }

    final docIds =
        logItems.map((item) => (item as dynamic).id as String).toList();

    final result = await widget.firestoreService.deleteAllEntries(
      userId: user.uid,
      collection: widget.firestoreCollection,
      docIds: docIds,
      successMessage:
          '${Strings.allEntriesDeletedSuccessfullyPrefix} ${Strings.allEntriesDeletedSuccessfullySuffix}',
      successMessageColor: successColor,
      errorMessagePrefix: Strings.failedToDeleteEntryPrefix,
      errorColor: errorColor,
    );

    _showSnackBar(
      message: result.message,
      backgroundColor: result.backgroundColor,
      snackbarDuration: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    final successColor = AppColors.successColor;
    final selectedDate = ref.watch(selectedDateProvider);
    final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());
    final today =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
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
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          widget.appBarTitle,
        ),
        backgroundColor: widget.backgroundColor,
        surfaceTintColor: Colors.transparent,
        actions: [
          NCIconButton(
            onButtonTap: () async {
              if (isToday) {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1990),
                  lastDate: today,
                );
                HapticFeedback.lightImpact();
                if (pickedDate != null && context.mounted) {
                  final updatedDate = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                  );
                  ref.read(selectedDateProvider.notifier).state = updatedDate;
                  UIUtils.showNCSnackBar(
                    context: context,
                    message:
                        'Showing Entries for ${DateTimeUtils.formatDateDM(updatedDate)}',
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    durationSeconds: 2,
                  );
                }
              } else {
                final updatedDate = today;
                ref.read(selectedDateProvider.notifier).state = updatedDate;
                UIUtils.showNCSnackBar(
                  context: context,
                  message: 'Showing Entries for Today',
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  durationSeconds: 1,
                );
              }
            },
            buttonIcon: isToday ? Icons.calendar_month : null,
            iconifyIcon: !isToday ? const Iconify(Mdi.calendar_refresh) : null,
            buttonText: !isToday ? 'Reset' : null,
            buttonBackgroundColor: Theme.of(context).colorScheme.primary,
            iconColor: Theme.of(context).colorScheme.onPrimary,
          ),
          hGap4,
          InkWell(
            onTap: () async {
              HapticFeedback.lightImpact();
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(
                  button.localToGlobal(Offset(button.size.width, MediaQuery.of(context).padding.top), // This sets the topmost position (below status bar)
                      ancestor: overlay),
                  button.localToGlobal(button.size.bottomRight(Offset(MediaQuery.of(context).padding.top, 0)), // Adjust bottom-right to align with top
                      ancestor: overlay),
                ),
                Offset.zero & overlay.size,
              );

              final itemsList = <PopupMenuEntry<String>>[
                buildPopupMenuItem(
                  value: 'details',
                  icon: Icons.info,
                  text: Strings.logDetails,
                ),
              ];
              if (allowDeleteAll &&
                  widget.itemsExtractor(dataAsync.asData!.value).isNotEmpty) {
                itemsList.insert(
                  0,
                  buildPopupMenuItem(
                    value: 'delete_all',
                    icon: Icons.delete_forever,
                    text: Strings.deleteAllConfirmText,
                  ),
                );
              }

              final value = await showMenu<String>(
                context: context,
                position: position,
                items: itemsList,
                color: widget.backgroundColor,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );

              if (value != null) {
                if (value == 'delete_all') {
                  final confirmed = await _showDeleteAllConfirmationDialog();
                  if (confirmed) {
                    final user = ref.read(authProvider);
                    final items =
                        widget.itemsExtractor(dataAsync.asData!.value);
                    if (user != null) {
                      await _deleteAllEntries(
                        userId: user.uid,
                        logItems: items,
                        errorColor: errorColor,
                        successColor: successColor,
                      );
                    }
                  }
                } else if (value == 'details') {
                  await _showLogDetailsDialog();
                }
              }
            },
            onHighlightChanged: (isHighlighted) {
              setState(() {
                _isPressed = isHighlighted;
              });
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: AnimatedScale(
              scale: _isPressed ? 0.9 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.more_vert,
                  size: kButtonIconSize,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          hGap8,
        ],
      ),
      backgroundColor: widget.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(
          left: 8,
          right: 8,
          bottom: 8,
        ),
        child: dataAsync.when(
          data: (cache) {
            final logItems = widget.itemsExtractor(cache);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (logItems.isNotEmpty)
                  Container(
                    width: double.infinity,
                    color: widget.backgroundColor,
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Row(
                      children: [
                        Text(
                          widget.headerText ??
                              'Total ${widget.headerTitleString?.toLowerCase()} ${isToday ? 'for today :' : 'on ${DateTimeUtils.formatDateDM(selectedDate)}'}',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                //color: widget.primaryColor,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        const Spacer(),
                        widget.headerActionButton != null
                            ? widget.headerActionButton!(logItems)
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: widget.primaryColor,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                                child: UIUtils
                                    .createRichTextValueWithUnit(
                                  value: widget
                                      .totalFormatter(logItems)
                                      .number,
                                  unit:
                                      widget.totalFormatter(logItems).unit,
                                  valueStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: widget.backgroundColor,
                                        fontSize: kValueFontSize,
                                        fontWeight: FontWeight.w800,
                                      ),
                                  unitStyle: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
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
                  child: logItems.isEmpty
                      ? Center(
                          child: Text(
                            '${Strings.noEntriesPrefix}${isToday ? 'today.' : DateTimeUtils.formatDateDMY(selectedDate)} ${isToday ? '\n${Strings.addEntryPromptSuffix}${widget.appBarTitle.toLowerCase()}${Strings.toTrackNow}' : ''}',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  color: widget.primaryColor,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(
                            top: 8,
                          ),
                          itemCount: logItems.length,
                          itemBuilder: (context, index) {
                            final logItem = logItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                              ),
                              child: ClipRRect(
                                clipBehavior: Clip.hardEdge,
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  color: widget.primaryColor,
                                  child: Dismissible(
                                    key: Key((logItem as dynamic).id),
                                    direction: isToday
                                        ? DismissDirection.horizontal
                                        : DismissDirection.endToStart,
                                    confirmDismiss: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        HapticFeedback.selectionClick();
                                        return _showDeleteConfirmationDialog();
                                      } else if (direction ==
                                          DismissDirection.startToEnd) {
                                        HapticFeedback.selectionClick();

                                        final confirmed =
                                            await _showEditConfirmationDialog();
                                        if (confirmed) {
                                          _showEditModalSheet(
                                              logItem: logItem);
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
                                        HapticFeedback.selectionClick();
                                        _deleteEntry(
                                          userId: user.uid,
                                          logItemId: (logItem as dynamic).id,
                                          successColor: successColor,
                                          errorColor: errorColor,
                                        );
                                      } else if (direction ==
                                          DismissDirection.startToEnd) {
                                        HapticFeedback.selectionClick();
                                        _showEditModalSheet(logItem: logItem);
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
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surfaceBright,
                                            ),
                                            hGap16,
                                            Text(
                                              'Edit this Entry',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: widget
                                                        .backgroundColor,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
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
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium!
                                                  .copyWith(
                                                    color: widget
                                                        .backgroundColor,
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
                                        color: widget.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(12),
                                      ),
                                      child: widget.listItemBuilder(
                                        context,
                                        logItem,
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
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Theme.of(context).colorScheme.primary,
                backgroundColor: Theme.of(context).colorScheme.surface,
              ),
            ),
          ),
          error: (error, _) => Center(
            child: Text('Error: $error'),
          ),
        ),
      ),
      floatingActionButton: isToday
          ? FloatingActionButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                _showAddInputModalSheet();
              },
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
