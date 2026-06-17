import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';
import 'package:handygo/app/modules/main/widgets/fade_in_animation.dart';
import 'package:handygo/app/routes/app_pages.dart';
import 'package:handygo/app/core/widgets/glass_container.dart';

import 'package:handygo/app/core/widgets/scale_on_tap.dart';

class PopularServicesList extends GetView<MainController> {
  const PopularServicesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingServices.value) {
        return _buildLoadingSkeleton();
      }

      if (controller.services.isEmpty) {
        return _buildEmptyState();
      }

      return SizedBox(
        height: 220,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          scrollDirection: Axis.horizontal,
          itemCount: controller.services.length,
          separatorBuilder: (context, index) => const SizedBox(width: 16),
          itemBuilder: (context, index) {
            final service = controller.services[index];
            return FadeInAnimation(
              delay: Duration(milliseconds: index * 100),
              child: ScaleOnTap(
                onTap: () =>
                    Get.toNamed(Routes.SERVICE_DETAILS, arguments: service),
                child: GlassContainer(
                  width: 200,
                  borderRadius: BorderRadius.circular(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          child: Stack(
                            children: [
                              if (_isValidUrl(service.icon))
                                Image.network(
                                  service.icon!,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      _buildPlaceholder(
                                        label: service.name ?? "Svc",
                                      ),
                                )
                              else
                                _buildPlaceholder(
                                  label: service.name ?? "Service",
                                ),
                              Positioned(
                                top: 12,
                                right: 12,
                                child: GlassContainer(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 6,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white.withValues(alpha: 0.5),
                                  child: Text(
                                    service.category ?? "General",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.name ?? "Unknown Service",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Tap to Book",
                              style: TextStyle(
                                color: AppColors.primaryColor.withValues(alpha: 0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
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
      height: 220,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) => Container(
          width: 200,
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
        child: Text("No popular services found."),
      ),
    );
  }

  static bool _isValidUrl(String? url) {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasScheme;
  }

  Widget _buildPlaceholder({String? label}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF55B436),
            Color(0xFF2E7D32),
          ],
        ),
      ),
      child: Center(
        child: Text(
          (label ?? "S").substring(0, 1).toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
      ),
    );
  }
}
