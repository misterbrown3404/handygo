import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo/app/modules/auth/widgets/auth_text_field.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';

class NewPasswordView extends GetView<AuthController> {
  const NewPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CircularBackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "New Password",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            Obx(() => AuthTextField(
                  label: "Password",
                  hint: "••••••••",
                  controller: controller.passwordController,
                  obscureText: controller.obscurePassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscurePassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: controller.togglePasswordVisibility,
                  ),
                )),
            const SizedBox(height: 20),
            Obx(() => AuthTextField(
                  label: "Confirm Password",
                  hint: "••••••••",
                  controller: controller.confirmPasswordController,
                  obscureText: controller.obscureConfirmPassword.value,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.obscureConfirmPassword.value
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: controller.toggleConfirmPasswordVisibility,
                  ),
                )),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.createNewPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Create New Password",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
