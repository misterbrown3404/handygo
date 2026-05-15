import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';

import 'package:handygo/app/core/widgets/glass_container.dart';

import 'package:handygo/app/core/widgets/scale_on_tap.dart';

class CategoriesList extends GetView<MainController> {
  const CategoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final categories = controller.categories.take(3).toList();
      
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...categories.map((cat) {
            return _buildCategoryItem(context, cat, _getIconForCategory(cat));
          }),
          _buildCategoryItem(context, "More", Icons.more_horiz),
        ],
      );
    });
  }

  Widget _buildCategoryItem(BuildContext context, String label, IconData icon) {
    return ScaleOnTap(
      onTap: () {},
      child: Column(
        children: [
          GlassContainer(
            width: 60,
            height: 60,
            borderRadius: BorderRadius.circular(30),
            child: Center(
              child: Icon(icon, color: AppColors.primaryColor),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'cleaning':
        return Icons.cleaning_services;
      case 'repairing':
        return Icons.build;
      case 'plumbing':
        return Icons.plumbing;
      case 'painting':
        return Icons.format_paint;
      default:
        return Icons.category;
    }
  }
}
