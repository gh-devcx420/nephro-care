import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nephro_care/core/constants/nc_app_icons.dart';
import 'package:nephro_care/core/themes/theme_provider.dart';
import 'package:nephro_care/core/utils/app_spacing.dart';
import 'package:nephro_care/core/utils/svg_utils.dart';
import 'package:nephro_care/core/widgets/nc_icon.dart';
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

    if (_lastBrightness == null || _lastBrightness != currentBrightness) {
      _lastBrightness = currentBrightness;
      setState(() {
        _isSvgLoading = true;
        _processedSvgString = '';
      });
      _loadSvg();
    }
  }

  Future<void> _loadSvg() async {
    if (!mounted) return;

    final colorSchemes = ref.read(colorSchemesProvider);
    final brightness = Theme.of(context).brightness;

    final colorScheme = brightness == Brightness.light
        ? colorSchemes[ThemeMode.light]!
        : colorSchemes[ThemeMode.dark]!;

    final colorMap = {
      '#3fbdf1': colorScheme.primary,
      '#9fdef9': colorScheme.primaryContainer,
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
        body: Center(child: CircularProgressIndicator()),
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
            fontWeight: FontWeight.w800,
          ),
          textAlign: TextAlign.center,
        ),
        vGap4,
        Text(
          'Your Trusted Healthcare Partner',
          style: theme.textTheme.titleLarge?.copyWith(
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
        color: colorScheme.surfaceContainer,
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
                      key: ValueKey(
                        '${_processedSvgString.hashCode}_${Theme.of(context).brightness}',
                      ),
                      fit: BoxFit.contain,
                      semanticsLabel: 'Doctor illustration',
                      placeholderBuilder: (context) {
                        return CircularProgressIndicator(
                          color: colorScheme.primary,
                        );
                      },
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
      ncButtonIcon: const NCIcon(NCIcons.google),
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
                valueColor: AlwaysStoppedAnimation(
                  colorScheme.onPrimary,
                ),
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
        children: const [
          TextSpan(text: 'By signing in, you agree to our '),
          TextSpan(
            text: 'Terms of Service ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: 'and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(text: '.'),
        ],
      ),
    );
  }
}
