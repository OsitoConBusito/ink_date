import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/animation_controller_state.dart';

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({
    Key? key,
    required this.child,
    this.shakeCount = 3,
    this.shakeDuration = const Duration(milliseconds: 400),
    required this.shakeOffset,
  }) : super(key: key);

  final Widget child;
  final int shakeCount;
  final Duration shakeDuration;
  final double shakeOffset;

  @override
  // ignore: no_logic_in_create_state
  ShakeWidgetState createState() => ShakeWidgetState(shakeDuration);
}

class ShakeWidgetState extends AnimationControllerState<ShakeWidget> {
  ShakeWidgetState(Duration duration) : super(duration);

  @override
  void initState() {
    super.initState();
    animationController.addStatusListener(_updateStatus);
  }

  @override
  void dispose() {
    animationController.removeStatusListener(_updateStatus);
    super.dispose();
  }

  void _updateStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      animationController.reset();
    }
  }

  void shake() {
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      child: widget.child,
      builder: (
        BuildContext context,
        Widget? child,
      ) {
        return Transform.translate(
          offset: Offset(
            sin(widget.shakeCount * 2 * pi * animationController.value) *
                widget.shakeOffset,
            0.0,
          ),
          child: child,
        );
      },
    );
  }
}
