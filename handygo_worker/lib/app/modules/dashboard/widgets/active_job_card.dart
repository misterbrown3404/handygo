import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/bookings/views/job_status_view.dart';
import 'package:handygo_worker/app/modules/dashboard/controllers/dashboard_controller.dart';

class ActiveJobCard extends GetView<DashboardController> {
  const ActiveJobCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final job = controller.nextJob.value;
      if (job == null) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: const Column(
            children: [
              Icon(Icons.calendar_today_rounded, color: Colors.grey, size: 32),
              SizedBox(height: 12),
              Text(
                'No Active Schedule',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              Text(
                'Go online to receive new requests.',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF55B436), Color(0xFF2E7D32)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${job.status.toUpperCase()} Job',
                  style: const TextStyle(color: Colors.white70),
                ),
                const Icon(Icons.more_horiz, color: Colors.white),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              job.serviceType,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${job.customerName} • ${job.location}',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.to(() => const JobStatusView()),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF55B436),
                minimumSize: const Size(double.infinity, 45),
              ),
              child: const Text('View Details'),
            ),
          ],
        ),
      );
    });
  }
}
