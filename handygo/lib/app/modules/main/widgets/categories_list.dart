import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';

class CategoriesList extends StatelessWidget {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {"icon": Icons.cleaning_services, "label": "Cleaning"},
      {"icon": Icons.build, "label": "Repairing"},
      {"icon": Icons.format_paint, "label": "Painting"},
      {"icon": Icons.more_horiz, "label": "More"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey[100]!),
              ),
              child: Icon(cat["icon"] as IconData, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 8),
            Text(cat["label"] as String, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
          ],
        );
      }).toList(),
    );
  }
}
