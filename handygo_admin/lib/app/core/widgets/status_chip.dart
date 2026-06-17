import 'package:flutter/material.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color? color;

  const StatusChip({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? _colorForStatus(label);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AdminSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AdminSpacing.sm),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: AdminTextStyles.captionWith(chipColor, FontWeight.w700),
      ),
    );
  }

  Color _colorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'verified':
      case 'completed':
      case 'approved':
        return AdminColors.success;
      case 'pending':
      case 'in_progress':
      case 'in progress':
        return AdminColors.warning;
      case 'highest':
        return AdminColors.accent;
      case 'suspended':
      case 'rejected':
      case 'cancelled':
      case 'disputed':
        return AdminColors.danger;
      default:
        return AdminColors.accent;
    }
  }
}
