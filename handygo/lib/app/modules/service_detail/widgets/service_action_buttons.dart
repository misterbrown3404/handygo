import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';

class ServiceActionButtons extends StatelessWidget {
  const ServiceActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionButton(Icons.public, "Website"),
        _buildActionButton(Icons.phone_outlined, "Call"),
        _buildActionButton(Icons.location_on_outlined, "Location"),
        _buildActionButton(Icons.share_outlined, "Share"),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primaryColor, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
