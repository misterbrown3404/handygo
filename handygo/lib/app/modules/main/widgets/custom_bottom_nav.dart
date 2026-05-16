import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';

import 'package:handygo/app/core/widgets/glass_container.dart';

import 'package:handygo/app/core/widgets/scale_on_tap.dart';

class CustomBottomNav extends GetView<MainController> {
  const CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      height: 70,
      borderRadius: BorderRadius.circular(35),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(0, Icons.home_rounded, Icons.home_outlined),
            _buildNavItem(
              1,
              Icons.calendar_month_rounded,
              Icons.calendar_month_outlined,
            ),
            _buildNavItem(2, Icons.favorite_rounded, Icons.favorite_outline),
            _buildNavItem(3, Icons.chat_rounded, Icons.chat_outlined),
            _buildNavItem(4, Icons.person_rounded, Icons.person_outline),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon) {
    final isSelected = controller.selectedIndex.value == index;
    return ScaleOnTap(
      onTap: () => controller.changeIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor.withValues(alpha: 0.15)
              : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: AnimatedScale(
          scale: isSelected ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 300),
          child: Icon(
            isSelected ? activeIcon : inactiveIcon,
            color: isSelected ? AppColors.primaryColor : Colors.grey[600],
            size: 26,
          ),
        ),
      ),
    );
  }
}
