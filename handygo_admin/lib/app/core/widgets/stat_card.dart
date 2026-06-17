import 'package:flutter/material.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';

class StatCard extends StatefulWidget {
  final String title;
  final String value;
  final String change;
  final IconData icon;
  final Color color;
  final bool isPositive;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.icon,
    required this.color,
    this.isPositive = true,
  });

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: Material(
          elevation: 2,
          shadowColor: widget.color.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(AdminSpacing.lg),
          color: AdminColors.background,
          child: Container(
            padding: const EdgeInsets.all(AdminSpacing.lg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AdminSpacing.lg),
              border: Border.all(
                color: AdminColors.borderDark,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top row: icon + change badge ───────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AdminSpacing.sm),
                      decoration: BoxDecoration(
                        color: widget.color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AdminSpacing.sm),
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.color,
                        size: 22,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AdminSpacing.sm - 2,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (widget.isPositive
                                ? AdminColors.accent
                                : AdminColors.danger)
                            .withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AdminSpacing.xs),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.isPositive
                                ? Icons.trending_up_rounded
                                : Icons.trending_down_rounded,
                            color: widget.isPositive
                                ? AdminColors.accent
                                : AdminColors.danger,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.change,
                            style: AdminTextStyles.captionWith(
                              widget.isPositive
                                  ? AdminColors.accent
                                  : AdminColors.danger,
                              FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // ── Flexible spacer above the value ─────────────────
                const Spacer(flex: 2),
                Text(
                  widget.value,
                  style: AdminTextStyles.h1With(AdminColors.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.title,
                  style: AdminTextStyles.bodySmallSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
