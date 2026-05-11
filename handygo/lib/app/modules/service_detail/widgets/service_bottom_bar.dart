import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/data/models/app_models.dart';
import 'package:handygo/app/routes/app_pages.dart';

class ServiceBottomBar extends StatelessWidget {
  final ServiceModel service;
  const ServiceBottomBar({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\$${service.price.toStringAsFixed(0)}",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                Text(
                  "/hour",
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: ElevatedButton(
                onPressed: () => Get.toNamed(Routes.BOOKING_FORM),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text(
                  "Book Now",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
