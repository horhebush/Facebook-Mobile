import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';

/// On-brand loading animation: pulsing paw with brand colors.
class PawbookLoading extends StatefulWidget {
  const PawbookLoading({
    super.key,
    this.size,
  });

  final double? size;

  @override
  State<PawbookLoading> createState() => _PawbookLoadingState();
}

class _PawbookLoadingState extends State<PawbookLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.size ?? ScreenUtil().setSp(56);
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        );
      },
      child: Icon(
        Icons.pets,
        size: size,
        color: FB_PRIMARY,
      ),
    );
  }
}

/// Alternative: three bouncing dots in brand colors (for tighter spaces).
class PawbookLoadingDots extends StatefulWidget {
  const PawbookLoadingDots({
    super.key,
    this.dotSize = 10,
    this.color,
  });

  final double dotSize;
  final Color? color;

  @override
  State<PawbookLoadingDots> createState() => _PawbookLoadingDotsState();
}

class _PawbookLoadingDotsState extends State<PawbookLoadingDots>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
      (i) => AnimationController(
        duration: Duration(milliseconds: 400 + (i * 150)),
        vsync: this,
      )..repeat(reverse: true),
    );
    _animations = _controllers
        .asMap()
        .entries
        .map((e) => Tween<double>(begin: 0.4, end: 1.0).animate(
              CurvedAnimation(
                parent: e.value,
                curve: Curves.easeInOut,
              ),
            ))
        .toList();
  }

  @override
  void dispose() {
    for (final c in _controllers) c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color color = widget.color ?? FB_PRIMARY;
    final double size = widget.dotSize;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (context, child) {
            return Opacity(
              opacity: _animations[i].value,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: size * 0.4),
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: i == 0
                      ? color
                      : i == 1
                          ? FB_SECONARY
                          : FB_DARK_PRIMARY,
                  shape: BoxShape.circle,
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
