import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/core/services/storage_service.dart';
import 'package:handygo_worker/app/widgets/primary_button.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';

class JobStatusView extends StatefulWidget {
  const JobStatusView({super.key});

  @override
  State<JobStatusView> createState() => _JobStatusViewState();
}

class _JobStatusViewState extends State<JobStatusView> {
  int currentStep = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Job In Progress'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.help_outline_rounded)),
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
    final userData = Get.find<StorageService>().read('user') ?? {};
    final workerName = userData['name']?.toString() ?? 'Worker';
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
          '$workerName has arrived at location',
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
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDone || isActive ? AppColors.primaryColor : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isDone ? Icons.check : Icons.circle,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                if (index < 2)
                  Container(
                    width: 2,
                    height: 40,
                    color: isDone ? AppColors.primaryColor : Colors.grey[300],
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        color: isDone || isActive ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
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
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'Call Customer',
                    icon: Icons.phone_rounded,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Message',
                    icon: Icons.message_rounded,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                text: 'Mark as Completed',
                isLoading: false,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _JobDetailHeader extends StatelessWidget {
  const _JobDetailHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.plumbing_rounded,
            color: AppColors.primaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Kitchen Plumbing Repair',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Lekki Phase 1, Lagos',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Active',
            style: TextStyle(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
