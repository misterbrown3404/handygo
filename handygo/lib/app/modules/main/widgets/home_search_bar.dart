import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/home/widgets/filter_bottom_sheet.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey[100]!),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 10),
                Text("Search...", style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 15),
        GestureDetector(
          onTap: () {
            Get.bottomSheet(
              const FilterBottomSheet(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
          child: Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.tune, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
