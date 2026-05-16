import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/data/models/service_model.dart';
import 'package:handygo/app/routes/app_pages.dart';
import 'package:handygo/app/core/widgets/glass_container.dart';

import 'package:handygo/app/core/widgets/scale_on_tap.dart';

class ServiceBottomBar extends StatelessWidget {
  final ServiceModel service;
  const ServiceBottomBar({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: GlassContainer(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        color: Colors.white.withValues(alpha: 0.5),
        child: Row(
          children: [
            Expanded(
              child: ScaleOnTap(
                onTap: () =>
                    Get.toNamed(Routes.BOOKING_FORM, arguments: service),
                child: ElevatedButton(
                  onPressed: null, // Tap handled by ScaleOnTap
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    disabledBackgroundColor: AppColors.primaryColor,
                    disabledForegroundColor: Colors.white,
                  ),
                  child: const Text("Book Now"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
