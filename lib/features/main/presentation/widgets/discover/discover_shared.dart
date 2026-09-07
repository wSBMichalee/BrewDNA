import 'package:flutter/material.dart';

/// Wrapper dodający fizyczny efekt dotyku (scale-down do 0.97x) przy naciśnięciu.
class InteractiveCard extends StatefulWidget {
  final VoidCallback? onTap;
  final Widget child;

  const InteractiveCard({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      behavior: HitTestBehavior.opaque,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// Wrapper dodający kaskadowy fade-in + slide-up (20px) przy pierwszym załadowaniu.
class StaggeredAnimatedItem extends StatelessWidget {
  final Animation<double> animation;
  final int index;
  final Widget child;

  const StaggeredAnimatedItem({
    super.key,
    required this.animation,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final start = (index * 0.1).clamp(0.0, 0.5);
    final end = (start + 0.5).clamp(0.0, 1.0);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, animChild) {
        final progress = animation.value;
        final t = end > start
            ? ((progress - start) / (end - start)).clamp(0.0, 1.0)
            : 1.0;
        final curveValue = Curves.easeOutCubic.transform(t);

        return Opacity(
          opacity: curveValue,
          child: Transform.translate(
            offset: Offset(0, (1.0 - curveValue) * 20.0),
            child: animChild,
          ),
        );
      },
      child: child,
    );
  }
}
