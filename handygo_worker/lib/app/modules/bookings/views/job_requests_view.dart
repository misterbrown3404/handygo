import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/bookings/controllers/bookings_controller.dart';
import 'package:handygo_worker/app/modules/bookings/widgets/job_request_card.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';

class JobRequestsView extends GetView<BookingsController> {
  const JobRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Incoming Requests'),
        centerTitle: false,
      ),
      body: Obx(() => ListView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: controller.requests.length,
            itemBuilder: (context, index) {
              return FadeInAnimation(
                delay: index * 100,
                child: JobRequestCard(request: controller.requests[index]),
              );
            },
          )),
    );
  }
}
