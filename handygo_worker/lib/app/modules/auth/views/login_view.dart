import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo_worker/app/widgets/primary_button.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';
import 'dart:ui';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home_image.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 2. Dark Overlay
          Container(color: Colors.black.withOpacity(0.4)),
          
          // 3. Glass Login Card
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: FadeInAnimation(
                  child: _buildGlassLoginCard(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassLoginCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Worker Login',
                style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Welcome back to HandyGo',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: AppSpacing.xxl),
              _buildGlassTextField(
                controller: controller.phoneController,
                hint: 'Phone Number',
                icon: Icons.phone_android_rounded,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.md),
              _buildGlassTextField(
                controller: controller.passwordController,
                hint: 'Password',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Forgot Password?', style: TextStyle(color: Colors.white70)),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Obx(() => PrimaryButton(
                    text: 'Login',
                    isLoading: controller.isLoading.value,
                    onPressed: () => controller.login(),
                  )),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('New here? ', style: TextStyle(color: Colors.white70)),
                  GestureDetector(
                    onTap: () => Get.toNamed(Routes.SIGNUP),
                    child: const Text(
                      'Join as Worker',
                      style: TextStyle(color: AppColors.primaryColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: Colors.white70, size: 20),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
