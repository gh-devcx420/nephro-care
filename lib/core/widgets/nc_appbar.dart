import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bx.dart';
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
    // final isLight =
    //     MediaQuery.of(context).platformBrightness == Brightness.light;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          hGap2,
          CircleAvatar(
            radius: 18,
            backgroundImage:
                user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
            backgroundColor: user?.photoURL == null
                ? Theme.of(context).colorScheme.surfaceContainer
                : Colors.transparent,
            child: user?.photoURL == null
                ? const Iconify(Bx.bxs_user_circle)
                : null,
          ),
          hGap8,
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
              children: [
                const TextSpan(
                  text: 'Good Morning\n',
                ),
                TextSpan(
                  text: (user?.displayName?.split(' ').first) ?? '',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.0,
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
          hGap4, // Match GenericLogScreen's hGap8
          NCIconButton(
            onButtonTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
            buttonIcon: Icons.settings,
            iconSize: kButtonIconSize,
          ),
        ],
      ),
    );
  }
}
