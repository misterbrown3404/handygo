import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/core/constant/image_string.dart';
import 'package:handygo/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo/app/modules/auth/widgets/auth_text_field.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/auth/widgets/social_button.dart';

class SignUpView extends GetView<AuthController> {
  const SignUpView({super.key});

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
              "Sign Up",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            AuthTextField(
              label: "Email Address",
              hint: "Enter Email Address",
              controller: controller.emailController,
            ),
            const SizedBox(height: 20),
            Obx(() => AuthTextField(
                  label: "Password",
                  hint: "Enter Password",
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
                  hint: "Enter Password",
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
            const SizedBox(height: 10),
            Row(
              children: [
                Obx(() => Checkbox(
                      value: controller.isAgreeTerms.value,
                      onChanged: (val) => controller.isAgreeTerms.value = val!,
                      activeColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )),
                const Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "I agree to the ",
                      children: [
                        TextSpan(
                          text: "Terms and Conditions",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: controller.signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text("Or", style: TextStyle(color: Colors.grey)),
                ),
                Expanded(child: Divider()),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SocialButton(assetPath: ImageStrings.google),
                const SizedBox(width: 20),
                SocialButton(assetPath: ImageStrings.faceBook),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Already have an account? "),
                GestureDetector(
                  onTap: controller.goToSignIn,
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
