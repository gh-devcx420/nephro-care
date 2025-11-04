import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nephro_care/core/constants/nc_app_spacing_constants.dart';
import 'package:nephro_care/core/constants/nc_app_ui_constants.dart';
import 'package:nephro_care/core/widgets/nc_icon.dart';

class NCFoldableCard extends StatefulWidget {
  final String title;
  final IconData? materialIcon;
  final String? ncIcon;
  final Widget child;
  final bool isCritical;
  final bool initiallyExpanded;
  final Widget? customHeader;
  final Color? backgroundColor;

  const NCFoldableCard({
    super.key,
    required this.title,
    this.materialIcon,
    this.ncIcon,
    required this.child,
    this.isCritical = false,
    this.initiallyExpanded = false,
    this.customHeader,
    this.backgroundColor,
  });

  @override
  State<NCFoldableCard> createState() => _NCFoldableCardState();
}

class _NCFoldableCardState extends State<NCFoldableCard>
    with SingleTickerProviderStateMixin {
  late bool _isExpanded;
  late AnimationController _animationController;
  late Animation<double> _iconRotation;
  late Animation<Color?> _iconColor;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _iconRotation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (_isExpanded) {
      _animationController.value = 1.0;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final theme = Theme.of(context);

    _iconColor = ColorTween(
      begin: theme.colorScheme.primary,
      end: theme.colorScheme.onSurface.withValues(alpha: 0.6),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(UIConstants.borderRadius),
        border: widget.isCritical
            ? Border.all(color: Colors.red.shade300, width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleExpanded,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(UIConstants.borderRadius),
          child: Padding(
            padding: UIConstants.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.customHeader != null)
                  Row(
                    children: [
                      Expanded(child: widget.customHeader!),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return RotationTransition(
                            turns: _iconRotation,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: _iconColor.value,
                            ),
                          );
                        },
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      _buildIcon(theme),
                      hGap12,
                      Expanded(
                        child: Text(
                          widget.title,
                          style: theme.textTheme.titleSmall!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return RotationTransition(
                            turns: _iconRotation,
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: _iconColor.value,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                if (_isExpanded) ...[
                  vGap12,
                  widget.child,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    final effectiveColor = theme.colorScheme.primary;
    const effectiveSize = 20.0;

    if (widget.materialIcon != null) {
      return Icon(
        widget.materialIcon,
        size: effectiveSize,
        color: effectiveColor,
      );
    } else if (widget.ncIcon != null) {
      return NCIcon(
        widget.ncIcon!,
        size: effectiveSize,
        color: effectiveColor,
      );
    } else {
      return Icon(
        Icons.help_outline,
        size: effectiveSize,
        color: effectiveColor,
      );
    }
  }

  void _toggleExpanded() {
    HapticFeedback.lightImpact();
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
}
