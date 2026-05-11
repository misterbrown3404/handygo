import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/dashboard/controllers/dashboard_controller.dart';

class StatusCard extends GetView<DashboardController> {
  const StatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Obx(() => Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: controller.isOnline.value ? const Color(0xFF55B436) : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  )),
              const SizedBox(width: 12),
              Obx(() => Text(
                    controller.isOnline.value ? 'Active & Online' : 'Currently Offline',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  )),
            ],
          ),
          Obx(() => Switch.adaptive(
                value: controller.isOnline.value,
                activeColor: const Color(0xFF55B436),
                onChanged: (val) => controller.toggleOnline(val),
              ))
        ],
      ),
    );
  }
}
