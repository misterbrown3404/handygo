import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/core/widgets/glass_card.dart';

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
        scale: _isHovered ? 1.03 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: GlassCard(
          glowColor: widget.color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(widget.icon, color: widget.color, size: 22),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: (widget.isPositive ? AdminColors.success : AdminColors.error).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          widget.isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                          color: widget.isPositive ? AdminColors.success : AdminColors.error,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.change,
                          style: TextStyle(
                            color: widget.isPositive ? AdminColors.success : AdminColors.error,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(widget.value, style: const TextStyle(color: AdminColors.textPrimary, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(widget.title, style: const TextStyle(color: AdminColors.textSecondary, fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
