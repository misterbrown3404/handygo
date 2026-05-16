import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/widgets/primary_button.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';

class JobStatusView extends StatefulWidget {
  const JobStatusView({super.key});

  @override
  State<JobStatusView> createState() => _JobStatusViewState();
}

class _JobStatusViewState extends State<JobStatusView> {
  int currentStep = 1; // 0: To Location, 1: Arrived, 2: In Progress

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Job In Progress'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildMapPreview(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const FadeInAnimation(child: _JobDetailHeader()),
                  const SizedBox(height: AppSpacing.xl),
                  _buildTimeline(),
                ],
              ),
            ),
          ),
          _buildActionSection(),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://images.unsplash.com/photo-1526778548025-fa2f459cd5c1?q=80&w=2066&auto=format&fit=crop',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded, color: Colors.red, size: 16),
              SizedBox(width: 8),
              Text(
                '2.1 km to Destination',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeline() {
    return Column(
      children: [
        _timelineStep(
          0,
          'To Destination',
          'Navigating to Lekki Phase 1',
          isDone: currentStep > 0,
        ),
        _timelineStep(
          1,
          'Arrived',
          'Provider has arrived at location',
          isDone: currentStep > 1,
          isActive: currentStep == 1,
        ),
        _timelineStep(
          2,
          'Job Completion',
          'Finalizing the service',
          isActive: currentStep == 2,
        ),
      ],
    );
  }

  Widget _timelineStep(
    int index,
    String title,
    String subtitle, {
    bool isDone = false,
    bool isActive = false,
  }) {
    return FadeInAnimation(
      delay: index * 100,
      child: IntrinsicHeight(
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isDone
                        ? AppColors.primaryColor
                        : (isActive
                              ? AppColors.primaryColor.withValues(alpha: 0.2)
                              : Colors.grey[300]),
                    shape: BoxShape.circle,
                    border: isActive
                        ? Border.all(color: AppColors.primaryColor, width: 2)
                        : null,
                  ),
                  child: isDone
                      ? const Icon(Icons.check, color: Colors.white, size: 14)
                      : null,
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: index == 2 ? Colors.transparent : Colors.grey[300],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isActive || isDone ? Colors.black : Colors.grey,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: PrimaryButton(
          text: currentStep == 1
              ? 'Start Service'
              : (currentStep == 2 ? 'Complete Job' : 'I have Arrived'),
          onPressed: () {
            if (currentStep < 2) {
              setState(() => currentStep++);
            } else {
              _showCompletionDialog();
            }
          },
        ),
      ),
    );
  }

  void _showCompletionDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primaryColor,
                size: 64,
              ),
              const SizedBox(height: 16),
              const Text(
                'Job Complete!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Are you sure you want to finish?',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              _uploadBox('Take Completion Photo'),
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'Submit & Earn N12,000',
                onPressed: () {
                  Get.back();
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Job completed and funds added to wallet!',
                    backgroundColor: AppColors.primaryColor,
                    colorText: Colors.white,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _uploadBox(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          const Icon(Icons.camera_alt_rounded, color: AppColors.primaryColor),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _JobDetailHeader extends StatelessWidget {
  const _JobDetailHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Row(
        children: [
          CircleAvatar(radius: 24, child: Icon(Icons.person)),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sarah Williams',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                'Kitchen Plumbing Service',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          Spacer(),
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
