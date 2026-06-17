import 'package:flutter/material.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';

/// ── SurfaceCard (formerly `GlassCard`) ─────────────────────────
///
/// A clean Material-based card for the admin interface.
/// The class name stays `GlassCard` for backward compatibility,
/// but the appearance is solid-surface with soft elevation.
///
/// All glass/backdrop effects are removed.

class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double elevation;
  final Color? surfaceColor;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = AdminSpacing.md,
    this.padding,
    this.elevation = 2.0,
    this.surfaceColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: elevation,
      borderRadius: BorderRadius.circular(borderRadius),
      color: surfaceColor ?? AdminColors.background,
      child: Container(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: AdminSpacing.lg,
              vertical: AdminSpacing.lg,
            ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: surfaceColor ?? AdminColors.background,
          border: Border.all(
            color: borderColor ?? AdminColors.borderDark,
            width: 1,
          ),
        ),
        child: child,
      ),
    );
  }
}
