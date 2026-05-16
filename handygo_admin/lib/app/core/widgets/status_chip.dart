import 'package:flutter/material.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color? color;

  const StatusChip({super.key, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? _colorForStatus(label);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: chipColor.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _colorForStatus(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'verified':
      case 'completed':
        return AdminColors.success;
      case 'pending':
      case 'in progress':
        return AdminColors.warning;
      case 'suspended':
      case 'rejected':
      case 'cancelled':
      case 'disputed':
        return AdminColors.error;
      default:
        return AdminColors.accent;
    }
  }
}
