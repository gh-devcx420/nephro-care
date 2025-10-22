import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_icons.dart';
import 'package:nephro_care/core/constants/nc_app_strings.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/services/firestore_service.dart';
import 'package:nephro_care/core/themes/theme_color_schemes.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/core/utils/ui_utils.dart';
import 'package:nephro_care/core/widgets/nc_alert_dialogue.dart';
import 'package:nephro_care/core/widgets/nc_date_picker.dart';
import 'package:nephro_care/core/widgets/nc_nephro_care_icon.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/trackers/generic/tracker_utils.dart';

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
  final FirestoreService firestoreService;
  final StreamProviderFamily<Cache<T>, (String, DateTime)> dataProvider;
  final Provider<Map<String, dynamic>> summaryProvider;
  final String firestoreCollection;
  final Widget Function(T? item) inputModalSheet;
  final Widget Function(BuildContext context, T item) listItemBuilder;
  final Widget Function(BuildContext context, Map<String, dynamic> summary)
      logDetailsDialogBuilder;
  final List<T> Function(Cache<T>) itemsExtractor;
  final Measurement Function(List<T> items)? headerValue;

  const LogScreen({
    super.key,
    required this.appBarTitle,
    this.headerActionButton,
    this.headerText,
    this.headerTitleString,
    required this.firestoreService,
    required this.dataProvider,
    required this.summaryProvider,
    required this.firestoreCollection,
    required this.inputModalSheet,
    required this.listItemBuilder,
    required this.logDetailsDialogBuilder,
    required this.itemsExtractor,
    this.headerValue,
  });

  @override
  ConsumerState<LogScreen<T>> createState() => _LogScreenState<T>();
}

class _LogScreenState<T> extends ConsumerState<LogScreen<T>> {
  static const double _minButtonHeight = UIConstants.minButtonHeight;
  static const double _minButtonWidth = UIConstants.minButtonWidth;
  static const double _defaultPaddingValue = 4.0;
  static const double _defaultRoundness = _defaultPaddingValue * 4;
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
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context, value);
              },
              borderRadius: BorderRadius.circular(8),
              splashColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
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
                      icon,
                      size: 26,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    hGap8,
                    Text(
                      text,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
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
        (
          ref.watch(authProvider)!.uid,
          ref.watch(selectedDateProvider),
        ),
      ),
    );

    return dataAsync.when(
      data: (cache) async {
        final summary = ref.read(widget.summaryProvider);
        final result = await showNCAlertDialog(
          context: context,
          titleText: AppStrings.logDetails,
          content: widget.logDetailsDialogBuilder(context, summary),
          action1: const SizedBox(),
          action2: ElevatedButton(
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop(true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: const Text(
              AppStrings.ok,
            ),
          ),
        );
        return result ?? false;
      },
      loading: () {
        _showSnackBar(
          message: 'Loading summary...',
          backgroundColor: Theme.of(context).colorScheme.primary,
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
      title: AppStrings.editEntryTitle,
      content: AppStrings.editEntryContent(widget.appBarTitle.toLowerCase()),
      confirmText: AppStrings.editConfirm,
      confirmColor: Theme.of(context).colorScheme.primary,
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
      title: AppStrings.deleteEntryTitle,
      content: AppStrings.deleteEntryContent(widget.appBarTitle.toLowerCase()),
      confirmText: AppStrings.deleteConfirm,
    );
  }

  Future<bool> _showDeleteAllConfirmationDialog() async {
    final selectedDate = ref.watch(selectedDateProvider);
    final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());

    return UIUtils.showNCConfirmationDialog(
      context: context,
      title: AppStrings.deleteAllEntriesTitle,
      content: isToday
          ? '${AppStrings.deleteAllEntriesPrompt}for today?'
          : '${AppStrings.deleteAllEntriesPrompt}for ${DateTimeUtils.formatDateDM(selectedDate)}?',
      confirmText: AppStrings.deleteAllConfirm,
    );
  }

  Future<void> _deleteEntries({
    required List<String> docIds,
    required Color errorColor,
    required Color successColor,
    String? successMessage,
  }) async {
    final user = ref.read(authProvider);

    if (user == null) {
      _showSnackBar(
        message: AppStrings.userNotAuthenticated,
        backgroundColor: errorColor,
      );
      return;
    }

    final isOnlineAsync = ref.watch(connectivityProvider);
    final isOnline = isOnlineAsync.maybeWhen(
      data: (online) => online,
      orElse: () => true,
    );

    final Result result;

    if (docIds.length == 1) {
      result = await widget.firestoreService.deleteEntry(
        userId: user.uid,
        collection: widget.firestoreCollection,
        docId: docIds.first,
        successMessage: successMessage ?? AppStrings.entryDeletedSuccess,
        successColor: successColor,
        errorMessagePrefix: AppStrings.failedToDeleteEntry,
        errorColor: errorColor,
        isOnline: isOnline,
      );
    } else {
      result = await widget.firestoreService.deleteAllEntries(
        userId: user.uid,
        collection: widget.firestoreCollection,
        docIds: docIds,
        successMessage: successMessage ??
            AppStrings.allEntriesDeleted(widget.appBarTitle.toLowerCase()),
        successMessageColor: successColor,
        errorMessagePrefix: AppStrings.failedToDeleteEntry,
        errorColor: errorColor,
        isOnline: isOnline,
      );
    }

    _showSnackBar(
      message: result.message,
      backgroundColor: result.backgroundColor,
      snackbarDuration: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final errorColor = colorScheme.error;
    const successColor = AppColors.successColor;
    final selectedDate = ref.watch(selectedDateProvider);
    final isToday = DateTimeUtils.isSameDay(selectedDate, DateTime.now());
    final allowDeleteAll = ref.watch(allowDeleteAllProvider);
    final user = ref.watch(authProvider);
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.appBarTitle)),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final dataAsync = ref.watch(widget.dataProvider(
      (user.uid, ref.watch(selectedDateProvider)),
    ));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: colorScheme.onSurface,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          widget.appBarTitle,
          style: theme.textTheme.titleLarge!.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        actions: [
          NCDatePicker(
              dateProvider: selectedDateProvider,
              dateFormatter: DateTimeUtils.formatDateDM,
              prefixIcon: Icons.calendar_month,
              suffixNCIcon: const NCIcon(NCIcons.cancel)),
          hGap4,
          InkWell(
            onTap: () async {
              HapticFeedback.lightImpact();
              final RenderBox button = context.findRenderObject() as RenderBox;
              final RenderBox overlay =
                  Overlay.of(context).context.findRenderObject() as RenderBox;
              final RelativeRect position = RelativeRect.fromRect(
                Rect.fromPoints(
                  button.localToGlobal(
                      Offset(
                        button.size.width,
                        MediaQuery.of(context).padding.top,
                      ),
                      ancestor: overlay),
                  button.localToGlobal(
                      button.size.bottomRight(
                        Offset(MediaQuery.of(context).padding.top, 0),
                      ),
                      ancestor: overlay),
                ),
                Offset.zero & overlay.size,
              );

              final itemsList = <PopupMenuEntry<String>>[
                buildPopupMenuItem(
                  value: 'details',
                  icon: Icons.info,
                  text: AppStrings.logDetails,
                ),
              ];
              if (allowDeleteAll &&
                  widget.itemsExtractor(dataAsync.asData!.value).isNotEmpty) {
                itemsList.insert(
                  0,
                  buildPopupMenuItem(
                    value: 'delete_all',
                    icon: Icons.delete_forever,
                    text: AppStrings.deleteAllConfirm,
                  ),
                );
              }

              final value = await showMenu<String>(
                context: context,
                position: position,
                items: itemsList,
                color: colorScheme.surfaceContainer,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );

              if (value != null) {
                if (value == 'delete_all') {
                  final confirmed = await _showDeleteAllConfirmationDialog();
                  if (confirmed) {
                    final items =
                        widget.itemsExtractor(dataAsync.asData!.value);
                    final docIds = items
                        .map((item) => (item as dynamic).id as String)
                        .toList();
                    await _deleteEntries(
                      docIds: docIds,
                      errorColor: errorColor,
                      successColor: successColor,
                    );
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
            borderRadius: BorderRadius.circular(_defaultRoundness),
            child: AnimatedScale(
              scale: _isPressed
                  ? UIConstants.animationScaleMin
                  : UIConstants.animationScaleMax,
              duration: UIConstants.buttonTapDuration,
              curve: Curves.easeInOut,
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: _minButtonHeight,
                  minWidth: _minButtonWidth,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(_defaultRoundness),
                ),
                padding: const EdgeInsets.all(_defaultPaddingValue),
                child: Icon(
                  Icons.more_vert,
                  size: UIConstants.buttonIconSize,
                  color: colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          hGap8,
        ],
      ),
      backgroundColor: colorScheme.surface,
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
                    color: colorScheme.surface,
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Row(
                      children: [
                        Text(
                          widget.headerText ??
                              'Total ${widget.headerTitleString?.toLowerCase()} ${isToday ? 'for today :' : 'on ${DateTimeUtils.formatDateDM(selectedDate)}'}',
                          style: theme.textTheme.titleLarge!.copyWith(
                            color: colorScheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        widget.headerActionButton != null
                            ? widget.headerActionButton!(logItems)
                            : widget.headerValue != null
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme
                                          .colorScheme.surfaceContainerHighest,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: UIUtils.createRichTextValueWithUnit(
                                      value: widget.headerValue!(logItems)
                                          .formattedValue!,
                                      unit: widget
                                          .headerValue!(logItems).unitString!,
                                      valueStyle:
                                          theme.textTheme.titleMedium!.copyWith(
                                        color: theme.colorScheme.onSurface,
                                        fontSize: UIConstants.valueFontSize,
                                        fontWeight: FontWeight.w800,
                                      ),
                                      unitStyle:
                                          theme.textTheme.titleMedium!.copyWith(
                                        color: theme.colorScheme.onSurface,
                                        fontSize: UIConstants.siUnitFontSize,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer,
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                    child: Text(
                                      'No Data',
                                      style:
                                          theme.textTheme.titleMedium!.copyWith(
                                        color: theme
                                            .colorScheme.onPrimaryContainer,
                                        fontSize: UIConstants.valueFontSize,
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
                            isToday
                                ? '${AppStrings.noEntriesMessage('today')}.\n${AppStrings.addEntryMessage(widget.appBarTitle.toLowerCase())}'
                                : AppStrings.noEntriesMessage(
                                    DateTimeUtils.formatDateDMY(selectedDate),
                                  ),
                            style: theme.textTheme.titleLarge,
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
                                  color:
                                      theme.colorScheme.surfaceContainerHighest,
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
                                          _showEditModalSheet(logItem: logItem);
                                        }
                                        return false;
                                      }
                                      return false;
                                    },
                                    onDismissed: (direction) async {
                                      if (direction ==
                                          DismissDirection.endToStart) {
                                        HapticFeedback.selectionClick();
                                        await _deleteEntries(
                                          docIds: [(logItem as dynamic).id],
                                          errorColor: errorColor,
                                          successColor: successColor,
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
                                          color: theme.colorScheme
                                              .surfaceContainerLowest,
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
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                            hGap16,
                                            Text(
                                              'Edit',
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                color:
                                                    theme.colorScheme.onSurface,
                                                fontWeight: FontWeight.w800,
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
                                          color:
                                              theme.colorScheme.errorContainer,
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
                                              'Delete',
                                              style: theme
                                                  .textTheme.titleMedium!
                                                  .copyWith(
                                                color: theme.colorScheme
                                                    .onErrorContainer,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                            hGap16,
                                            Icon(
                                              Icons.delete,
                                              color: theme
                                                  .colorScheme.onErrorContainer,
                                            ),
                                            hGap8,
                                          ],
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: theme.colorScheme
                                            .surfaceContainerHighest,
                                        borderRadius: BorderRadius.circular(12),
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
                color: colorScheme.primary,
                backgroundColor: colorScheme.surface,
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
              backgroundColor: colorScheme.primary,
              tooltip: 'Add ${widget.appBarTitle} Entry',
              child: Semantics(
                label: 'Add new ${widget.appBarTitle.toLowerCase()} entry',
                child: Icon(
                  Icons.add,
                  color: colorScheme.onPrimary,
                ),
              ),
            )
          : null,
    );
  }
}
