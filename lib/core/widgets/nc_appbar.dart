import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_icons.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/providers/app_providers.dart';
import 'package:nephro_care/core/utils/date_time_utils.dart';
import 'package:nephro_care/core/widgets/nc_button.dart';
import 'package:nephro_care/core/widgets/nc_date_picker.dart';
import 'package:nephro_care/core/widgets/nc_icon.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/settings/settings_screen.dart';

class NCAppbar extends ConsumerWidget {
  const NCAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(authProvider);
    final currentDateTime = DateTime.now();
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          hGap2,
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => Navigator.pushNamed(context, '/user_profile'),
            child: _buildCircleAvatarWithBorder(
              theme: theme,
              user: user,
              radius: 14,
              borderWidth: 2,
            ),
          ),
          hGap8,
          _buildGreeting(theme, currentDateTime, user),
          const Spacer(),
          NCDatePicker(
            dateProvider: selectedDateProvider,
            dateFormatter: DateTimeUtils.formatDateDM,
            prefixIcon: Icons.calendar_month,
            suffixNCIcon: const NCIcon(NCIcons.cancel),
          ),
          hGap4,
          NCButton(
            onButtonTap: () => _navigateToSettings(context),
            buttonIcon: Icons.settings,
            iconSize: UIConstants.buttonIconSize,
          ),
        ],
      ),
    );
  }

  /// Circle avatar with border.
  Widget _buildCircleAvatarWithBorder({
    required ThemeData theme,
    required User? user,
    required double radius,
    required double borderWidth,
  }) {
    return Container(
      padding: EdgeInsets.all(borderWidth),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary,
          width: borderWidth,
        ),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: theme.colorScheme.primaryContainer,
        child: user?.photoURL != null
            ? CachedNetworkImage(
                imageUrl: user!.photoURL!,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => const SizedBox(),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: radius * 0.8,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                maxHeightDiskCache: 100,
                maxWidthDiskCache: 100,
              )
            : Icon(
                Icons.person,
                size: radius * 0.8,
                color: theme.colorScheme.onPrimaryContainer,
              ),
      ),
    );
  }

  /// Greeting widget (User Name with time of day)
  Widget _buildGreeting(ThemeData theme, DateTime currentDateTime, User? user) {
    return RichText(
      text: TextSpan(
        style: theme.textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w700,
          height: 1.2,
          color: theme.colorScheme.onSurface,
        ),
        children: [
          TextSpan(
            text: 'Good ${DateTimeUtils.getTimeOfDay(currentDateTime)}\n',
          ),
          TextSpan(
            text: (user?.displayName?.split(' ').first) ?? '',
            style: theme.textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.w700,
              height: 0.8,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Navigate to settings screen.
  void _navigateToSettings(BuildContext context) {
    // Todo: Add named route for settings in main.
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
}
