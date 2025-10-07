import 'dart:async';

import 'package:flutter/material.dart';

class ShakingWidget extends StatefulWidget {
  final Widget child;
  final Duration shakeDuration;
  final Duration shakeInterval;
  final double shakeOffset;
  final int shakeCount;

  const ShakingWidget({
    super.key,
    required this.child,
    this.shakeDuration = const Duration(milliseconds: 500),
    this.shakeInterval = const Duration(seconds: 4),
    this.shakeOffset = 10.0,
    this.shakeCount = 3,
  });

  @override
  State<ShakingWidget> createState() => _ShakingWidgetState();
}

class _ShakingWidgetState extends State<ShakingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _offsetAnimation;
  Timer? _intervalTimer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.shakeDuration,
      vsync: this,
    );

    // Create shake animation that goes: 0 -> right -> left -> right -> left -> 0
    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: widget.shakeOffset)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween:
            Tween<double>(begin: widget.shakeOffset, end: -widget.shakeOffset)
                .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween:
            Tween<double>(begin: -widget.shakeOffset, end: widget.shakeOffset)
                .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 3,
      ),
      TweenSequenceItem(
        tween:
            Tween<double>(begin: widget.shakeOffset, end: -widget.shakeOffset)
                .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 2,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -widget.shakeOffset, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]).animate(_controller);

    // Start the periodic shake
    _startShaking();
  }

  void _startShaking() {
    // Shake immediately
    _controller.forward();

    // Then shake every interval
    _intervalTimer = Timer.periodic(widget.shakeInterval, (timer) {
      if (mounted) {
        _controller.forward(from: 0.0);
      }
    });
  }

  @override
  void dispose() {
    _intervalTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: widget.child,
        );
      },
    );
  }
}
