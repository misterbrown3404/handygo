import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/modules/profile/controllers/profile_controller.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildGlassHeader(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  const FadeInAnimation(delay: 200, child: _ProfileStatsRow()),
                  const SizedBox(height: AppSpacing.xl),
                  FadeInAnimation(
                    delay: 300,
                    child: _ProfileMenu(
                      title: 'Account Settings',
                      items: [
                         _MenuItem(
                           Icons.person_outline_rounded,
                           'Edit Profile',
                           () => Get.toNamed(Routes.EDIT_PROFILE),
                         ),
                         _MenuItem(
                           Icons.security_rounded,
                           'KYC Verification',
                           () => Get.snackbar('Info', 'KYC verification is already submitted'),
                           trailing: 'Verified',
                         ),
                         _MenuItem(
                           Icons.notifications_none_rounded,
                           'Notifications',
                           () => Get.snackbar('Info', 'Notifications coming soon'),
                         ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                   FadeInAnimation(
                    delay: 400,
                    child: _ProfileMenu(
                      title: 'Professional',
                      items: [
_MenuItem(
                           Icons.engineering_rounded,
                           'My Services',
                           () => Get.toNamed(Routes.SERVICE_MANAGER),
                         ),
                        _MenuItem(Icons.history_rounded, 'Job History', () {}),
                        _MenuItem(Icons.star_outline_rounded, 'Reviews', () {}),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FadeInAnimation(
                    delay: 500,
                    child: TextButton(
                      onPressed: () => controller.logout(),
                      child: const Text(
                        'Sign Out',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassHeader() {
    return Container(
      height: 320,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home_image_2.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.black.withValues(alpha: 0.3)),
          ),
          SafeArea(
            child: Center(
              child: FadeInAnimation(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_glassProfileCard()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glassProfileCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: Get.width * 0.85,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Obx(() {
                final avatarUrl = controller.avatarUrl.value;
                if (avatarUrl != null && avatarUrl.isNotEmpty) {
                  return CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(avatarUrl),
                  );
                }
                return const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person, size: 40),
                );
              }),
              const SizedBox(height: 16),
              Obx(
                () => Text(
                  controller.name.value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Obx(() => Text(
                controller.specialty.value.isEmpty ? 'Worker' : controller.specialty.value,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              )),
              const SizedBox(height: 12),
              Obx(() => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star_rounded, color: Colors.white, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${controller.rating.value.toStringAsFixed(1)} Rating',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileStatsRow extends GetView<ProfileController> {
  const _ProfileStatsRow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Obx(() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('${controller.jobsDone.value}', 'Jobs Done'),
          _divider(),
          _statItem(controller.rating.value.toStringAsFixed(1), 'Rating'),
          _divider(),
          _statItem(controller.experienceLabel.value, 'Exp'),
        ],
      )),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 30, width: 1, color: Colors.grey[200]);
  }
}

class _ProfileMenu extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _ProfileMenu({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? trailing;

  const _MenuItem(this.icon, this.label, this.onTap, {this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: Colors.black87, size: 22),
      title: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[
            Text(
              trailing!,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
          ],
          const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        ],
      ),
    );
  }
}
