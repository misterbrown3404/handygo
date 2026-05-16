import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/bookings/views/job_status_view.dart';

class ActiveJobCard extends StatelessWidget {
  const ActiveJobCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Next Scheduled Job',
                style: TextStyle(color: Colors.white70),
              ),
              Icon(Icons.more_horiz, color: Colors.white),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Full House Cleaning',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '12:30 PM • 12, Lagos Street',
            style: TextStyle(color: Colors.white),
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
  }
}
