import 'package:flutter/material.dart';
import '../theme.dart';

class PremiumCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final bool elevated;
  final bool greenish;

  const PremiumCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.elevated = true, this.greenish = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: isDark ? kCardDark : kCardLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: elevated ? softShadows(greenish: greenish) : null,
        border: Border.all(color: isDark ? Colors.white10 : Colors.black12),
      ),
      child: child,
    );
  }
}
