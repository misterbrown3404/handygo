import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:handygo_worker/app/modules/dashboard/widgets/status_card.dart';
import 'package:handygo_worker/app/modules/dashboard/widgets/active_job_card.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'dart:ui';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Gradient/Blob for Glassmorphism depth
          Positioned(
            top: -100,
            right: -50,
            child: CircleAvatar(radius: 150, backgroundColor: AppColors.primaryColor.withOpacity(0.1)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FadeInAnimation(child: _HeaderSection()),
                  const SizedBox(height: AppSpacing.lg),
                  const FadeInAnimation(delay: 100, child: StatusCard()),
                  const SizedBox(height: AppSpacing.lg),
                  const FadeInAnimation(
                    delay: 200,
                    child: Text('Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const FadeInAnimation(delay: 300, child: _StatsGrid()),
                  const SizedBox(height: AppSpacing.lg),
                  const FadeInAnimation(
                    delay: 350,
                    child: Text('Active Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const FadeInAnimation(delay: 400, child: ActiveJobCard()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSection extends GetView<DashboardController> {
  const _HeaderSection();
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome back,', style: TextStyle(color: Colors.grey)),
            Text('John Provider', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primaryColor, width: 2)),
              child: const CircleAvatar(radius: 22, backgroundImage: AssetImage('assets/images/profile.jpg')),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(color: const Color(0xFF55B436), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              ),
            )
          ],
        )
      ],
    );
  }
}

class _StatsGrid extends GetView<DashboardController> {
  const _StatsGrid();
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        _glassStatCard('Earnings', controller.totalEarnings.value, Icons.payments_rounded, Colors.blue),
        _glassStatCard('Jobs Done', controller.jobsDone.value, Icons.task_alt_rounded, Colors.orange),
      ],
    );
  }

  Widget _glassStatCard(String label, String value, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
