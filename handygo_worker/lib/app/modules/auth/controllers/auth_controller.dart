import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';

class AuthController extends GetxController {
  // Login/Signup Controllers
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();

  // KYC Controllers (Nigerian Market)
  final ninController = TextEditingController();
  final bvnController = TextEditingController();

  var isLoading = false.obs;
  var currentOnboardingStep = 0.obs;

  // Navigation Methods
  void login() {
    isLoading.value = true;
    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      Get.offAllNamed(Routes.MAIN);
    });
  }

  void signup() {
    Get.toNamed(Routes.KYC);
  }

  void submitKyc() {
    if (ninController.text.length != 11 || bvnController.text.length != 11) {
      Get.snackbar(
        'Invalid Input',
        'NIN and BVN must be 11 digits long.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    Get.toNamed(Routes.ONBOARDING);
  }
}
