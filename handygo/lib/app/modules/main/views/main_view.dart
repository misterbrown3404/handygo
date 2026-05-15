import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/bookings/views/bookings_view.dart';
import 'package:handygo/app/modules/chat/views/chat_view.dart';
import 'package:handygo/app/modules/favorites/views/favorites_view.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';
import 'package:handygo/app/modules/main/views/tabs/home_tab_view.dart';
import 'package:handygo/app/modules/main/widgets/custom_bottom_nav.dart';
import 'package:handygo/app/modules/profile/views/profile_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F8),
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.mainGradient,
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: Obx(() => IndexedStack(
                index: controller.selectedIndex.value,
                children: const [
                  HomeTabView(),
                  BookingsView(),
                  FavoritesView(),
                  ChatView(),
                  ProfileView(),
                ],
              )),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
