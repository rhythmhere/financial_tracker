import 'dart:ui';

import 'package:flutter/material.dart';

/// A small frosted glass card with rounded corners, optional blur, and soft shadow.
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blurSigma;
  final Color? color;
  final EdgeInsetsGeometry padding;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 18,
    this.blurSigma = 10,
    this.color,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
  final surfaceColor = color ?? Theme.of(context).colorScheme.surface.withAlpha(153);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
            border: Border.all(color: Colors.white.withAlpha(15)),
          ),
          child: child,
        ),
      ),
    );
  }
}
