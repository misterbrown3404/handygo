import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/core/widgets/glass_container.dart';

class AddressItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String address;
  final bool isSelected;
  final VoidCallback onTap;

  const AddressItem({
    super.key,
    required this.icon,
    required this.title,
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryColor
              : Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        child: Row(
          children: [
            GlassContainer(
              padding: const EdgeInsets.all(12),
              borderRadius: BorderRadius.circular(24),
              color: Colors.white.withValues(alpha: 0.5),
              child: Icon(icon, color: AppColors.primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primaryColor : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
