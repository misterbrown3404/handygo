import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/profile/widgets/profile_header.dart';
import 'package:handygo/app/modules/profile/widgets/profile_menu_item.dart';
import 'package:handygo/app/routes/app_pages.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const ProfileHeader(
              name: "Jonathan Richard",
              email: "jonathanrichard123@gmail.com",
            ),
            const SizedBox(height: 40),
            ProfileMenuItem(
              icon: Icons.edit_outlined,
              title: "Edit Profile",
              iconColor: AppColors.primaryColor,
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.location_on_outlined,
              title: "Manage Address",
              iconColor: AppColors.primaryColor,
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.payment_outlined,
              title: "Payment Methods",
              iconColor: AppColors.primaryColor,
              onTap: () => Get.toNamed(Routes.ADD_CARD),
            ),
            ProfileMenuItem(
              icon: Icons.calendar_month_outlined,
              title: "My Booking",
              iconColor: AppColors.primaryColor,
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.settings_outlined,
              title: "Settings",
              iconColor: AppColors.primaryColor,
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.help_outline,
              title: "Help Center",
              iconColor: AppColors.primaryColor,
              onTap: () {},
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
