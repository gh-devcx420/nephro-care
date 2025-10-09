import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:nephro_care/core/constants/ui_constants.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/date_utils.dart';
import 'package:nephro_care/core/widgets/nc_date_picker.dart';
import 'package:nephro_care/core/widgets/nc_icon_button.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';
import 'package:nephro_care/features/settings/settings_provider.dart';
import 'package:nephro_care/features/settings/settings_screen.dart';

class NCAppbar extends ConsumerWidget {
  const NCAppbar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final User? user = ref.watch(authProvider);
    final currentDateTime = DateTime.now();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          hGap2,
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            foregroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            child: user?.photoURL == null
                ? Icon(
                    Icons.person,
                    size: 20,
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                : null,
          ),
          hGap8,
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              children: [
                TextSpan(
                  text: 'Good ${DateTimeUtils.getTimeOfDay(currentDateTime)}\n',
                ),
                TextSpan(
                  text: (user?.displayName?.split(' ').first) ?? '',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 0.8,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          NCDatePicker(
            dateProvider: selectedDateProvider,
            dateFormatter: DateTimeUtils.formatDateDM,
            prefixIcon: Icons.calendar_month,
            suffixIconifyIcon: const Iconify(MaterialSymbols.replay),
          ),
          hGap4,
          NCIconButton(
            onButtonTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            buttonIcon: Icons.settings,
            iconSize: UIConstants.buttonIconSize,
          ),
        ],
      ),
    );
  }
}
