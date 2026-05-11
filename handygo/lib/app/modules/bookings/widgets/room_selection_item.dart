import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';

class RoomSelectionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  const RoomSelectionItem({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    required this.onAdd,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 24),
          const SizedBox(width: 16),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: onRemove,
                  child: const Icon(Icons.remove, size: 20, color: Colors.grey),
                ),
                const SizedBox(width: 12),
                Text(
                  "$count",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: onAdd,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.add, size: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
