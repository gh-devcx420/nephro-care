import 'package:flutter/material.dart';
import 'package:nephro_care/constants.dart';
import 'package:nephro_care/providers/settings_provider.dart';
import 'package:nephro_care/themes/color_schemes.dart';
import 'package:nephro_care/utils/ui_helper.dart';
import 'package:nephro_care/widgets/nc_value_range_chooser.dart';

class FluidIntakeSettings extends StatelessWidget {
  const FluidIntakeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).clearSnackBars();
            Navigator.of(context).pop();
          },
          color: ComponentColors.waterColorShade2,
          icon: const Icon(
            Icons.arrow_back,
            color: ComponentColors.waterColorShade2,
          ),
        ),
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Text(
          'Settings',
          style: theme.textTheme.headlineSmall!.copyWith(
            color: ComponentColors.waterColorShade2,
          ),
        ),
        backgroundColor: ComponentColors.waterBackgroundShade,
        surfaceTintColor: Colors.transparent,
      ),
      backgroundColor: ComponentColors.waterBackgroundShade,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: kScaffoldBodyPadding,
          vertical: 0,
        ),
        child: Column(
          children: [
            vGap8,
            ListTile(
              tileColor: Colors.transparent,
              leading: const Icon(
                Icons.water,
                color: ComponentColors.waterColorShade2,
              ),
              //dense: false,
              //isThreeLine: true,
              title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Fluid Limit',
                ),
              ),
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ComponentColors.waterColorShade2,
                  ),
              // subtitle: const Text('Your daily fluid limit'),
              // subtitleTextStyle:
              //     Theme.of(context).textTheme.titleMedium?.copyWith(
              //           color: ComponentColors.waterColorShade2,
              //         ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              trailing: ValueRangeChooser(
                provider: fluidLimitProvider,
                step: 50,
                minValue: 50,
                color: ComponentColors.waterColorShade2,
              ),
            ),
            vGap8,
            ListTile(
              tileColor: Colors.transparent,
              leading: const Icon(
                Icons.straighten_rounded,
                color: ComponentColors.waterColorShade2,
              ),
              //dense: false,
              //isThreeLine: true,
              title: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'SI Unit',
                ),
              ),
              titleTextStyle: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: ComponentColors.waterColorShade2,
                  ),
              // subtitle: const Text('Your daily fluid limit'),
              // subtitleTextStyle:
              //     Theme.of(context).textTheme.titleMedium?.copyWith(
              //           color: ComponentColors.waterColorShade2,
              //         ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              trailing: Container(
                decoration: BoxDecoration(
                  color: ComponentColors.waterColorShade2,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 6,
                ),
                child: Text(
                  'Litres',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: ComponentColors.waterBackgroundShade,
                      ),
                ),
              ),
            ),

            // NCDivider(
            //   color: ComponentColors.waterColorShade2,
            //   widthFactor: 0.9,
            // ),
          ],
        ),
      ),
    );
  }
}
