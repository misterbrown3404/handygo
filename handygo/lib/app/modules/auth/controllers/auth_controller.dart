import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/routes/app_pages.dart';

class AuthController extends GetxController {
  // Common
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  var isRememberMe = false.obs;
  var isAgreeTerms = false.obs;
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;

  void togglePasswordVisibility() => obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.value = !obscureConfirmPassword.value;

  final otpController = TextEditingController();

  void signIn() {
    // Implement sign in logic
    Get.offAllNamed(Routes.MAIN);
  }

  void signUp() {
    // Implement sign up logic
    Get.toNamed(Routes.VERIFY_OTP);
  }

  void sendResetCode() {
    // Implement forgot password logic
    Get.toNamed(Routes.VERIFY_OTP);
  }

  void verifyOtp() {
    // Implement OTP verification logic
    Get.toNamed(Routes.NEW_PASSWORD);
  }

  void createNewPassword() {
    // Implement new password logic
    Get.offAllNamed(Routes.SIGN_IN);
  }

  void goToSignIn() => Get.toNamed(Routes.SIGN_IN);
  void goToSignUp() => Get.toNamed(Routes.SIGN_UP);
  void goToForgotPassword() => Get.toNamed(Routes.FORGOT_PASSWORD);
  
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
