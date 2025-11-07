import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nephro_care/core/constants/nc_app_icons.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/widgets/nc_button.dart';
import 'package:nephro_care/core/widgets/nc_divider.dart';
import 'package:nephro_care/core/widgets/nc_foldable_card.dart';
import 'package:nephro_care/core/widgets/nc_info_chip.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';

class UserProfileScreen extends ConsumerStatefulWidget {
  const UserProfileScreen({super.key});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends ConsumerState<UserProfileScreen> {
  String _capitalizeNames(String? name) {
    if (name == null || name.isEmpty) return '';
    return name.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final User? user = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: _buildAppBar(theme),
      body: Padding(
        padding: UIConstants.scaffoldBodyPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileCard(user, theme),
              vGap16,
              _buildSectionHeader('Medical Information', theme),
              vGap8,

              // CKD Stage & Diagnosis
              NCFoldableCard(
                title: 'CKD Stage & Diagnosis',
                ncIcon: NCIcons.kidneys,
                child: _buildCKDInfo(),
              ),

              vGap12,

              // Dialysis Details (conditionally shown)
              NCFoldableCard(
                title: 'Dialysis Details',
                materialIcon: Icons.local_hospital,
                child: _buildDialysisInfo(),
              ),

              vGap12,

              // Comorbidities
              NCFoldableCard(
                title: 'Comorbidities',
                ncIcon: NCIcons.heartBeat,
                child: _buildComorbidities(),
              ),

              vGap12,

              // Medications
              NCFoldableCard(
                title: 'Medications',
                ncIcon: NCIcons.capsule,
                child: _buildMedications(),
              ),

              vGap12,

              // Allergies & Reactions
              NCFoldableCard(
                title: 'Allergies & Reactions',
                ncIcon: NCIcons.allergy,
                child: _buildAllergies(),
              ),

              vGap12,

              // Latest Labs & Vitals
              NCFoldableCard(
                title: 'Labs Reports & Vitals',
                materialIcon: Icons.science,
                child: _buildLabs(),
              ),

              vGap12,

              // Vaccinations
              NCFoldableCard(
                title: 'Vaccinations',
                materialIcon: Icons.vaccines,
                child: _buildVaccinations(),
              ),

              vGap12,

              // Transplant Status (conditionally shown)
              NCFoldableCard(
                title: 'Transplant Status',
                materialIcon: Icons.healing,
                child: _buildTransplant(),
              ),

              vGap12,

              // Lifestyle & Restrictions
              NCFoldableCard(
                title: 'Lifestyle & Restrictions',
                materialIcon: Icons.water_drop,
                child: _buildLifestyle(),
              ),

              vGap12,

              // Care Team
              NCFoldableCard(
                title: 'Care Team',
                materialIcon: Icons.people,
                child: _buildCareTeam(),
              ),

              vGap12,

              // Documents & Reports
              NCFoldableCard(
                title: 'Documents & Reports',
                materialIcon: Icons.description,
                child: _buildDocuments(),
              ),

              vGap24,
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(ThemeData theme) {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          HapticFeedback.lightImpact();
          ScaffoldMessenger.of(context).clearSnackBars();
          Navigator.of(context).pop();
        },
        icon: Icon(
          Icons.arrow_back,
          color: theme.colorScheme.onSurface,
        ),
      ),
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Text(
        'Profile',
        style: theme.textTheme.titleLarge!.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: NCButton(
            onButtonTap: () {},
            buttonIcon: Icons.edit,
            iconSize: 14,
            iconColor: theme.colorScheme.onPrimary,
          ),
        ),
      ],
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: Colors.transparent,
    );
  }

  Widget _buildProfileCard(User? user, ThemeData theme) {
    return Container(
      padding: UIConstants.cardPadding,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileRow(user, theme),
          vGap12,
          NCDivider(
            thickness: 1.2,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.25),
          ),
          vGap12,
          _buildInfoChipsRow(),
        ],
      ),
    );
  }

  Widget _buildProfileRow(User? user, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildProfileAvatar(user, theme),
        hGap12,
        Expanded(child: _buildUserInfo(user, theme)),
        const NcInfoChip(
          ncChipIcon: NCIcons.calendarClock,
          chipText: 'Age',
          chipValue: 56,
        ),
      ],
    );
  }

  Widget _buildProfileAvatar(User? user, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.primary,
          width: 2,
        ),
      ),
      child: CircleAvatar(
        radius: 14,
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
                  size: 20,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                maxHeightDiskCache: 100,
                maxWidthDiskCache: 100,
              )
            : Icon(
                Icons.person,
                size: 20,
                color: theme.colorScheme.onPrimaryContainer,
              ),
      ),
    );
  }

  Widget _buildUserInfo(User? user, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _capitalizeNames(user?.displayName),
          style: theme.textTheme.titleMedium!.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          user?.email ?? '',
          style: theme.textTheme.titleSmall!.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChipsRow() {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: NcInfoChip(
            ncChipIcon: NCIcons.bloodTypeOMinus,
            chipText: 'Blood Group',
            chipSuffix: 'O -ve',
          ),
        ),
        hGap8,
        Expanded(
          child: NcInfoChip(
            ncChipIcon: NCIcons.capsule,
            chipText: 'Medications',
            chipValue: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium!.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.w700,
          fontSize: 14,
        ),
      ),
    );
  }

  // === SKELETON CONTENT BUILDERS ===
  // TODO: Populate these with actual patient data

  Widget _buildCKDInfo() {
    return const Text('CKD Stage & Diagnosis content goes here...');
  }

  Widget _buildDialysisInfo() {
    return const Text('Dialysis details content goes here...');
  }

  Widget _buildComorbidities() {
    return const Text('Comorbidities content goes here...');
  }

  Widget _buildMedications() {
    return const Text('Medications list content goes here...');
  }

  Widget _buildAllergies() {
    return const Text('Allergies & reactions content goes here...');
  }

  Widget _buildLabs() {
    return const Text('Latest labs & vitals content goes here...');
  }

  Widget _buildVaccinations() {
    return const Text('Vaccinations content goes here...');
  }

  Widget _buildTransplant() {
    return const Text('Transplant status content goes here...');
  }

  Widget _buildLifestyle() {
    return const Text('Lifestyle & restrictions content goes here...');
  }

  Widget _buildCareTeam() {
    return const Text('Care team content goes here...');
  }

  Widget _buildDocuments() {
    return const Text('Documents & reports content goes here...');
  }
}
