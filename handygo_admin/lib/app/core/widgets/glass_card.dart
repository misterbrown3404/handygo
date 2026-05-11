import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final Color? glowColor;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.padding,
    this.blur = 12,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            color: AdminColors.cardDark.withOpacity(0.75),
            border: Border.all(color: AdminColors.borderDark.withOpacity(0.8), width: 1),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.4),
                Colors.white.withOpacity(0.1),
              ],
            ),
            boxShadow: [
              if (glowColor != null)
                BoxShadow(color: glowColor!.withOpacity(0.15), blurRadius: 30, offset: const Offset(0, 10)),
              BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
