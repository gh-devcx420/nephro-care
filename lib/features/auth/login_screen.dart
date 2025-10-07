import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/bi.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/svg_utils.dart';
import 'package:nephro_care/core/widgets/nc_icon_button.dart';
import 'package:nephro_care/features/auth/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _isLoading = false;
  String _processedSvgString = '';
  bool _isSvgLoading = true;
  Brightness? _lastBrightness;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentBrightness = Theme.of(context).brightness;

    // Only reload if brightness actually changed
    if (_lastBrightness != currentBrightness) {
      _lastBrightness = currentBrightness;
      _loadSvg();
    }
  }

  Future<void> _loadSvg() async {
    if (!mounted) return;

    setState(() => _isSvgLoading = true);

    final colorScheme = Theme.of(context).colorScheme;

    final colorMap = {
      '#3fbdf1': colorScheme.primary,
      '#9fdef9': Colors.white,
    };

    try {
      final loadedString = await SVGUtils.loadMultiColorSvg(
        context,
        'assets/svg/nc_doctor.svg',
        colorMap,
      );

      if (mounted) {
        setState(() {
          _processedSvgString = loadedString ?? '';
          _isSvgLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Failed to load SVG: $e');
      if (mounted) {
        setState(() => _isSvgLoading = false);
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in failed: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final screenSize = MediaQuery.sizeOf(context);

    final circleSize = screenSize.width * 0.85;
    final svgSize = screenSize.width * 0.68;

    ref.listen<User?>(authProvider, (previous, next) {
      if (next != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        });
      }
    });

    if (user != null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _buildHeader(theme),
                const SizedBox(height: 50),
                _buildIllustration(circleSize, svgSize, colorScheme),
                const SizedBox(height: 80),
                _buildSignInButton(theme, colorScheme),
                vGap30,
                _buildTermsText(theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Column(
      children: [
        Text(
          'NephroCare',
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        vGap4,
        Text(
          'Your Trusted Healthcare Partner',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildIllustration(
    double circleSize,
    double svgSize,
    ColorScheme colorScheme,
  ) {
    return Container(
      height: circleSize,
      width: circleSize,
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.7),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: _isSvgLoading
            ? SizedBox(
                height: svgSize * 0.3,
                width: svgSize * 0.3,
                child: CircularProgressIndicator(
                  color: colorScheme.primary,
                ),
              )
            : _processedSvgString.isNotEmpty
                ? SizedBox(
                    height: svgSize,
                    width: svgSize,
                    child: SvgPicture.string(
                      _processedSvgString,
                      fit: BoxFit.contain,
                      semanticsLabel: 'Doctor illustration',
                    ),
                  )
                : Icon(
                    Icons.medical_services_outlined,
                    size: svgSize * 0.5,
                    color: colorScheme.primary.withValues(alpha: 0.5),
                  ),
      ),
    );
  }

  Widget _buildSignInButton(ThemeData theme, ColorScheme colorScheme) {
    return NCIconButton(
      onButtonTap: _handleGoogleSignIn,
      buttonPadding: const EdgeInsets.all(12),
      buttonBackgroundColor: colorScheme.primary,
      iconifyIcon: const Iconify(Bi.google),
      iconSize: 20,
      iconColor: colorScheme.onPrimary,
      gap: hGap12,
      buttonText: 'Sign in with Google',
      buttonTextStyle: theme.textTheme.titleMedium?.copyWith(
        color: colorScheme.onPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w800,
      ),
      buttonChild: _isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(colorScheme.onPrimary),
              ),
            )
          : null,
    );
  }

  Widget _buildTermsText(ThemeData theme) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: theme.textTheme.bodySmall,
        children: const <TextSpan>[
          TextSpan(text: 'By signing in, you agree to our '),
          TextSpan(
            text: 'Terms of Service ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: 'and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: '.'),
        ],
      ),
    );
  }
}
