import 'package:flutter/material.dart';

class PulsingWidget extends StatefulWidget {
  final Widget Function(Color color) builder;
  final Color errorColor;
  final Color normalColor;
  final Duration duration;

  const PulsingWidget({
    super.key,
    required this.builder,
    required this.errorColor,
    required this.normalColor,
    this.duration = const Duration(milliseconds: 800),
  });

  @override
  State<PulsingWidget> createState() => _PulsingWidgetState();
}

class _PulsingWidgetState extends State<PulsingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: widget.errorColor,
      end: widget.normalColor,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorAnimation,
      builder: (context, child) {
        return widget.builder(_colorAnimation.value ?? widget.normalColor);
      },
    );
  }
}
