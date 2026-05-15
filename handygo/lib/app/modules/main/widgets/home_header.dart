import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/image_string.dart';
import 'package:handygo/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo/app/routes/app_pages.dart';

import 'package:handygo/app/core/widgets/glass_container.dart';

import 'package:handygo/app/core/widgets/scale_on_tap.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Obx(() {
      final user = authController.user.value;
      
      return Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.grey[300],
            backgroundImage: user?.avatar != null && user!.avatar!.startsWith('http')
                ? NetworkImage(user.avatar!) as ImageProvider
                : const AssetImage(ImageStrings.profilePic),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Hi, ${user?.name ?? 'Guest'}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                user?.address ?? "Location not set",
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const Spacer(),
          ScaleOnTap(
            onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
            child: GlassContainer(
              width: 45,
              height: 45,
              borderRadius: BorderRadius.circular(22.5),
              child: const Center(
                child: Badge(
                  child: Icon(Icons.notifications_outlined),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
