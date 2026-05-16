import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';
import 'package:handygo/app/core/constant/image_string.dart';
import 'package:handygo/app/modules/main/widgets/fade_in_animation.dart';
import 'package:handygo/app/core/widgets/glass_container.dart';

import 'package:handygo/app/core/widgets/scale_on_tap.dart';

class TopWorkersList extends GetView<MainController> {
  const TopWorkersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingWorkers.value) {
        return _buildLoadingSkeleton();
      }

      if (controller.workers.isEmpty) {
        return _buildEmptyState();
      }

      return SizedBox(
        height: 180,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemCount: controller.workers.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final worker = controller.workers[index];
            return FadeInAnimation(
              delay: Duration(milliseconds: index * 100),
              child: ScaleOnTap(
                onTap: () {}, // Worker profile navigation can be added here
                child: GlassContainer(
                  width: 140,
                  padding: const EdgeInsets.all(16),
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            worker.avatar != null &&
                                worker.avatar!.startsWith('http')
                            ? NetworkImage(worker.avatar!) as ImageProvider
                            : const AssetImage(ImageStrings.profilePic),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        worker.name ?? "Worker",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            "${worker.rating ?? 4.8}",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildLoadingSkeleton() {
    return SizedBox(
      height: 180,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: 4,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) => Container(
          width: 140,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text("No top workers found."),
      ),
    );
  }
}
