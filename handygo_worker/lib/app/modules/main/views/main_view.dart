import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/modules/main/controllers/main_controller.dart';
import 'package:handygo_worker/app/modules/dashboard/views/dashboard_view.dart';
import 'package:handygo_worker/app/modules/bookings/views/job_requests_view.dart';
import 'package:handygo_worker/app/modules/chat/views/chat_list_view.dart';
import 'package:handygo_worker/app/modules/wallet/views/wallet_view.dart';
import 'package:handygo_worker/app/modules/profile/views/profile_view.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const DashboardView(),
      const JobRequestsView(),
      const ChatListView(),
      const WalletView(),
      const ProfileView(),
    ];

    return Scaffold(
      body: Obx(() => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: pages[controller.currentIndex.value],
          )),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Obx(
      () => Container(
        margin: const EdgeInsets.only(
          left: AppSpacing.lg,
          right: AppSpacing.lg,
          bottom: AppSpacing.lg,
        ),
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.dashboard_rounded, 0, 'Home'),
            _navItem(Icons.assignment_rounded, 1, 'Jobs'),
            _navItem(Icons.chat_rounded, 2, 'Chat'),
            _navItem(Icons.account_balance_wallet_rounded, 3, 'Wallet'),
            _navItem(Icons.person_rounded, 4, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, String label) {
    final bool isActive = controller.currentIndex.value == index;
    return GestureDetector(
      onTap: () => controller.changePage(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? Colors.white : Colors.grey[600],
              size: 22,
            ),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
