import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/home/widgets/filter_bottom_sheet.dart';
import 'package:handygo/app/core/widgets/glass_container.dart';

import 'package:handygo/app/core/widgets/scale_on_tap.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 55,
            borderRadius: BorderRadius.circular(15),
            child: const Row(
              children: [
                // ignore: deprecated_member_use
                Icon(
                  Icons.search,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(width: 10),
                const Text("Search...", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        ScaleOnTap(
          onTap: () {
            Get.bottomSheet(
              const FilterBottomSheet(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
          child: GlassContainer(
            height: 55,
            width: 55,
            color: AppColors.primaryColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(15),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
