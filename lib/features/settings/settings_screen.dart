import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/themes/theme_config.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/widgets/nc_alert_dialogue.dart';
import 'package:nephro_care/core/widgets/nc_value_range_chooser.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/settings/change_theme_screen.dart';
import 'package:nephro_care/features/trackers/fluids/fluid_provider.dart';
import 'package:nephro_care/main.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Widget _buildSectionHeader({
    required BuildContext context,
    required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.6),
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    IconData? icon,
    Widget? leading,
    required String title,
    String? subtitle,
    IconData? trailingIcon,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    final tile = ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      visualDensity: const VisualDensity(vertical: -4, horizontal: -2),
      leading: leading ??
          (icon != null
              ? Icon(
                  icon,
                  size: 24,
                  color: iconColor,
                )
              : null),
      title: Text(title),
      tileColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      titleTextStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
            color:
                titleColor ?? Theme.of(context).colorScheme.onPrimaryContainer,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      subtitleTextStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
            color:
                titleColor ?? Theme.of(context).colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.w800,
          ),
      trailing: trailing ??
          (trailingIcon != null
              ? Icon(
                  trailingIcon,
                  size: 24,
                  color: iconColor,
                )
              : null),
    );

    if (onTap != null) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: tile,
      );
    }
    return tile;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final authAsync = ref.read(authProvider.notifier);
    final allowDeleteAll = ref.watch(allowDeleteAllProvider);
    final allowEditPastEntries = ref.watch(allowEditPastEntriesProvider);
    final allowDeletePastEntries = ref.watch(allowDeletePastEntriesProvider);
    final isReminderActive = ref.watch(remindersActiveProvider);
    final fluidLimit = ref.watch(fluidLimitProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        titleSpacing: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: UIConstants.scaffoldBodyPadding,
        child: Container(
          child: ListView(
            children: [
              _buildSectionHeader(
                  context: context, title: 'Data & Permissions'),
              vGap8,
              _buildSettingTile(
                context: context,
                icon: Icons.edit,
                title: 'Edit Past Entries',
                subtitle: allowEditPastEntries
                    ? 'Past entries can be edited'
                    : 'Past entries can\'t be edited',
                trailing: Transform.scale(
                  scale: UIConstants.switchButtonScale,
                  child: Switch(
                    value: allowEditPastEntries,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      ref.read(allowEditPastEntriesProvider.notifier).state =
                          value;
                    },
                  ),
                ),
              ),
              vGap8,
              _buildSettingTile(
                context: context,
                icon: Icons.delete,
                title: 'Delete Past Entries',
                subtitle: allowDeletePastEntries
                    ? 'Past entries can be deleted'
                    : 'Past entries can\'t be deleted',
                trailing: Transform.scale(
                  scale: UIConstants.switchButtonScale,
                  child: Switch(
                    value: allowDeletePastEntries,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      ref.read(allowDeletePastEntriesProvider.notifier).state =
                          value;
                    },
                  ),
                ),
              ),
              vGap8,
              _buildSettingTile(
                context: context,
                icon: Icons.delete_forever,
                title: 'Delete All',
                subtitle: allowDeleteAll
                    ? 'Show delete all button in menu'
                    : 'Hide delete all button in menu',
                trailing: Transform.scale(
                  scale: UIConstants.switchButtonScale,
                  child: Switch(
                    value: allowDeleteAll,
                    onChanged: (value) {
                      HapticFeedback.lightImpact();
                      ref.read(allowDeleteAllProvider.notifier).state = value;
                    },
                  ),
                ),
              ),
              vGap16,
              _buildSectionHeader(context: context, title: 'Notifications'),
              vGap8,
              _buildSettingTile(
                context: context,
                icon: Icons.notifications_active,
                title: 'Reminder Alerts',
                subtitle: isReminderActive
                    ? 'Reminder alerts are active'
                    : 'Reminder alerts are not active',
                trailing: Transform.scale(
                  scale: UIConstants.switchButtonScale,
                  child: Switch(
                    value: isReminderActive,
                    onChanged: (newValue) {
                      HapticFeedback.lightImpact();
                      ref.read(remindersActiveProvider.notifier).state =
                          newValue;
                    },
                  ),
                ),
              ),
              vGap16,
              _buildSectionHeader(context: context, title: 'Trackers'),
              vGap8,
              _buildSettingTile(
                context: context,
                icon: Icons.water_drop,
                title: 'Fluid Limit',
                subtitle: 'Per day (24 Hours)',
                trailing: NCValueRange(
                  value: fluidLimit,
                  onValueChanged: (newValue) {
                    ref.read(fluidLimitProvider.notifier).setFluidLimit(
                          newValue.toDouble(),
                        );
                  },
                  step: 50,
                  minValue: 50,
                ),
              ),
              vGap16,
              _buildSectionHeader(context: context, title: 'Appearance'),
              vGap8,
              _buildSettingTile(
                context: context,
                icon: Icons.color_lens_rounded,
                title: 'Change Accent Color',
                subtitle: 'Available Colors: ${appThemes.length}',
                titleColor: Theme.of(context).colorScheme.onPrimaryContainer,
                onTap: () {
                  HapticFeedback.lightImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThemeSettingsScreen(),
                    ),
                  );
                },
              ),
              vGap16,
              _buildSectionHeader(context: context, title: 'Account'),
              vGap8,
              _buildSettingTile(
                context: context,
                icon: Icons.logout,
                title: 'Logout',
                subtitle: user?.displayName ?? 'User',
                iconColor: Theme.of(context).colorScheme.error,
                onTap: () async {
                  HapticFeedback.lightImpact();
                  final navigator = Navigator.of(context);
                  showNCAlertDialog(
                    context: context,
                    titleText: 'Logout User',
                    content: Text(
                      'Are you sure you want to logout ${user?.displayName ?? 'User'} ?',
                    ),
                    action1: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        navigator.pop(false);
                      },
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    action2: ElevatedButton(
                      onPressed: () async {
                        HapticFeedback.lightImpact();
                        await authAsync.signOut();
                        if (context.mounted) {
                          navigator.pop(true);
                          navigator.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => const AuthWrapper(),
                            ),
                            (route) => false,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.surfaceBright,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
