import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/modules/service_detail/controllers/service_detail_controller.dart';
import 'package:handygo/app/modules/service_detail/widgets/service_action_buttons.dart';
import 'package:handygo/app/modules/service_detail/widgets/service_bottom_bar.dart';
import 'package:handygo/app/modules/service_detail/widgets/service_image_header.dart';
import 'package:handygo/app/modules/service_detail/widgets/service_reviews_section.dart';
import 'package:handygo/app/modules/service_detail/widgets/service_stats_section.dart';
import 'package:handygo/app/modules/service_detail/widgets/service_title_section.dart';

class ServiceDetailView extends GetView<ServiceDetailController> {
  const ServiceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<ServiceDetailController>()) {
      Get.lazyPut(() => ServiceDetailController());
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3F4F8),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0EAFC),
              Color(0xFFCFDEF3),
            ],
          ),
        ),
        child: Obx(() {
          if (controller.service.value == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final s = controller.service.value!;
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ServiceImageHeader(service: s),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ServiceTitleSection(service: s),
                          const SizedBox(height: 24),
                          const ServiceActionButtons(),
                          const SizedBox(height: 32),
                          _buildAboutSection(s.description ?? ""),
                          const SizedBox(height: 32),
                          ServiceStatsSection(service: s),
                          const SizedBox(height: 32),
                          const ServiceReviewsSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ServiceBottomBar(service: s),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildAboutSection(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "About This Service",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: TextStyle(color: Colors.grey[600], fontSize: 14, height: 1.5),
        ),
      ],
    );
  }
}
