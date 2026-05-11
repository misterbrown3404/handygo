import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/widgets/primary_button.dart';

class JobAlertOverlay extends StatelessWidget {
  const JobAlertOverlay({super.key});

  static void show() {
    Get.bottomSheet(
      const JobAlertOverlay(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: AppSpacing.lg),
          const Icon(Icons.flash_on_rounded, color: AppColors.accentColor, size: 48),
          const SizedBox(height: AppSpacing.md),
          const Text(
            'New Job Nearby!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Text(
            'Respond quickly to secure this booking',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildJobPreview(),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PrimaryButton(
                  text: 'Accept Job',
                  onPressed: () {
                    Get.back();
                    // Navigate to job flow
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }

  Widget _buildJobPreview() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 24, child: Icon(Icons.engineering_rounded)),
          const SizedBox(width: AppSpacing.md),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kitchen Plumbing', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text('2.1 km away • N12,000', style: TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          const Spacer(),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 1.0, end: 0.0),
            duration: const Duration(seconds: 30),
            builder: (context, value, child) => CircularProgressIndicator(
              value: value,
              strokeWidth: 4,
              color: AppColors.primaryColor,
              backgroundColor: Colors.grey[200],
            ),
          )
        ],
      ),
    );
  }
}
