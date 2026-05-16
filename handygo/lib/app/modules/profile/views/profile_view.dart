import 'package:handygo/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo/app/modules/profile/controllers/profile_controller.dart';
import 'package:handygo/app/modules/profile/widgets/profile_header.dart';
import 'package:handygo/app/modules/profile/widgets/profile_menu_item.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Profile", style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: Obx(() {
        final user = authController.user.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              ProfileHeader(
                name: user?.name ?? "Guest",
                email: user?.email ?? "Sign in to access more features",
                imageUrl: user?.avatar,
              ),
              const SizedBox(height: 40),
              ProfileMenuItem(
                icon: Icons.edit_outlined,
                title: "Edit Profile",
                iconColor: AppColors.primaryColor,
                onTap: () => Get.toNamed(Routes.EDIT_PROFILE),
              ),
              ProfileMenuItem(
                icon: Icons.location_on_outlined,
                title: "Manage Address",
                iconColor: AppColors.primaryColor,
                onTap: () => Get.toNamed(Routes.SELECT_ADDRESS),
              ),
              ProfileMenuItem(
                icon: Icons.calendar_month_outlined,
                title: "My Booking",
                iconColor: AppColors.primaryColor,
                onTap: () => Get.find<MainController>().changeIndex(1),
              ),
              ProfileMenuItem(
                icon: Icons.settings_outlined,
                title: "Settings",
                iconColor: AppColors.primaryColor,
                onTap: () => Get.toNamed(Routes.SETTINGS),
              ),
              ProfileMenuItem(
                icon: Icons.help_outline,
                title: "Help Center",
                iconColor: AppColors.primaryColor,
                onTap: () {},
              ),
              ProfileMenuItem(
                icon: Icons.logout,
                title: "Logout",
                iconColor: Colors.red,
                onTap: () => controller.logout(),
              ),
              const SizedBox(height: 100),
            ],
          ),
        );
      }),
    );
  }
}
