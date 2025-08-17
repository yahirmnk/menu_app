import 'package:flutter/material.dart';

class FadeSlide extends StatelessWidget {
  final Widget child;
  final Duration duration;
  final Curve curve;
  final Offset beginOffset;
  final double beginOpacity;

  const FadeSlide({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOut,
    this.beginOffset = const Offset(0, 0.06),
    this.beginOpacity = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: beginOpacity, end: 1),
      duration: duration,
      curve: curve,
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * (beginOffset.dy * 100)),
            child: child,
          ),
        );
      },
    );
  }
}

class PulseOnTap extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double scale;
  final Duration duration;

  const PulseOnTap({
    super.key,
    required this.child,
    this.onTap,
    this.scale = 0.96,
    this.duration = const Duration(milliseconds: 120),
  });

  @override
  State<PulseOnTap> createState() => _PulseOnTapState();
}

class _PulseOnTapState extends State<PulseOnTap> {
  double _scale = 1;

  void _down(_) => setState(() => _scale = widget.scale);
  void _up(_) => setState(() => _scale = 1);

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _down,
      onPointerUp: _up,
      onPointerCancel: _up,
      child: AnimatedScale(
        scale: _scale,
        duration: widget.duration,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(16),
          child: widget.child,
        ),
      ),
    );
  }
}

class LikeSwitcher extends StatelessWidget {
  final bool liked;
  final int count;
  final VoidCallback onPressed;
  final Color? activeColor;

  const LikeSwitcher({
    super.key,
    required this.liked,
    required this.count,
    required this.onPressed,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) =>
              ScaleTransition(scale: anim, child: child),
          child: IconButton(
            key: ValueKey(liked),
            icon: Icon(liked ? Icons.favorite : Icons.favorite_border),
            color: liked ? (activeColor ?? Theme.of(context).colorScheme.secondary) : null,
            onPressed: onPressed,
            tooltip: liked ? "Ya no me encanta" : "Me encanta",
          ),
        ),
        const SizedBox(width: 4),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, anim) =>
              FadeTransition(opacity: anim, child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, .2), end: Offset.zero).animate(anim),
                child: child,
              )),
          child: Text(
            "$count",
            key: ValueKey(count),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: liked ? (activeColor ?? Theme.of(context).colorScheme.secondary) : null,
            ),
          ),
        ),
      ],
    );
  }
}
