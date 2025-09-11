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
  String? _processedSvgString;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load SVG only once when dependencies are available
    if (!_isInitialized) {
      _loadSvg();
      _isInitialized = true;
    }
  }

  Future<void> _loadSvg() async {
    if (!mounted) return;

    final colorScheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;

    final colorMap = {
      '#2e2e41': isLight
          ? colorScheme.onSurfaceVariant
          : colorScheme.surfaceContainerLowest,
      '#6c63ff': isLight ? colorScheme.primaryContainer : colorScheme.primary,
      '#e8e9ea':
          isLight ? colorScheme.onPrimary : colorScheme.onPrimaryContainer,
      '#3f3c57': isLight
          ? colorScheme.onSurfaceVariant
          : colorScheme.surfaceContainerLowest,
    };

    try {
      final loadedString = await SVGUtils.loadMultiColorSvg(
        context,
        'assets/svg/doctor.svg',
        colorMap,
      );

      if (mounted) {
        setState(() {
          _processedSvgString = loadedString ?? '';
        });
      }
    } catch (e) {
      // Handle SVG loading error gracefully
      debugPrint('Failed to load SVG: $e');
    }
  }

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return; // Prevent multiple simultaneous requests

    setState(() => _isLoading = true);

    try {
      await ref.read(authProvider.notifier).signInWithGoogle();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sign-in failed: ${e.toString()}'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
    final isLight = theme.brightness == Brightness.light;
    const svgDimensions = Size(300, 300);

    // Handle navigation after user state change
    ref.listen<dynamic>(authProvider, (previous, next) {
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
                // const SizedBox(height: 40),
                // Fixed spacing instead of percentage
                Container(
                  height: svgDimensions.height,
                  width: svgDimensions.width,
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest,
                    borderRadius:
                        BorderRadius.circular(svgDimensions.height * 2),
                  ),
                  child: Center(
                    child: ClipRect(
                      child: SizedBox(
                        height: svgDimensions.height * 0.7,
                        width: svgDimensions.width * 0.7,
                        child: _processedSvgString != null &&
                                _processedSvgString!.isNotEmpty
                            ? SvgPicture.string(
                                _processedSvgString!,
                                clipBehavior: Clip.hardEdge,
                                semanticsLabel: 'Doctor illustration',
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 160),
                // Fixed spacing
                Text(
                  'Welcome to NephroCare',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                  semanticsLabel: 'Welcome to NephroCare',
                ),
                vGap30,
                NCIconButton(
                  onButtonTap: _handleGoogleSignIn,
                  buttonPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  buttonBackgroundColor: isLight
                      ? colorScheme.primaryContainer
                      : colorScheme.primary,
                  iconifyIcon: const Iconify(Bi.google),
                  iconSize: 20,
                  iconColor: isLight
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.primaryContainer,
                  buttonSpacing: hGap8,
                  buttonText: 'Sign in with Google',
                  buttonTextStyle: theme.textTheme.titleMedium?.copyWith(
                    color: isLight
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.primaryContainer,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                  buttonChild: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: isLight
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.primaryContainer,
                            backgroundColor: isLight
                                ? colorScheme.primaryContainer
                                : colorScheme.primary,
                          ),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
