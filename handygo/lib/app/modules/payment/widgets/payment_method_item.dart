import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';

class PaymentMethodItem extends StatelessWidget {
  final Widget? logo;
  final IconData? icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodItem({
    super.key,
    this.logo,
    this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: logo ?? Icon(icon ?? Icons.payment, color: AppColors.primaryColor, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Spacer(),
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
