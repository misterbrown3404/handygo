import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/modules/bookings/views/bookings_view.dart';
import 'package:handygo/app/modules/chat/views/chat_view.dart';
import 'package:handygo/app/modules/favorites/views/favorites_view.dart';
import 'package:handygo/app/modules/main/views/tabs/home_tab_view.dart';
import 'package:handygo/app/modules/profile/views/profile_view.dart';
import 'package:handygo/app/modules/home/widgets/custom_bottom_nav.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';

class HomeView extends GetView<MainController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Obx(
          () => IndexedStack(
            index: controller.selectedIndex.value,
            children: const [
              HomeTabView(),
              BookingsView(),
              FavoritesView(),
              ChatView(),
              ProfileView(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNav(),
    );
  }
}
