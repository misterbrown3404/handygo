import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/splash/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      body: Center(
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
            children: [
              const TextSpan(
                text: "Handy",
                style: TextStyle(color: Colors.black),
              ),
              const TextSpan(
                text: "Go",
                style: TextStyle(color: AppColors.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}