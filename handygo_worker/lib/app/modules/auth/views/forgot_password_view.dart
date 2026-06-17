import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo_worker/app/widgets/primary_button.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';

class ForgotPasswordView extends GetView<AuthController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/onboarding_2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.5)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const FadeInAnimation(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Obx(() {
                    final step = controller.forgotPasswordStep.value;
                    String subtitle = 'Enter your email to reset your password';
                    if (step == 1) {
                      subtitle = 'Enter the OTP sent to your email';
                    } else if (step == 2) {
                      subtitle = 'Set your new password';
                    }
                    return FadeInAnimation(
                      child: Text(
                        subtitle,
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.xl),
                  Obx(() {
                    final step = controller.forgotPasswordStep.value;
                    if (step == 0) {
                      return _EmailStep();
                    } else if (step == 1) {
                      return _OtpStep();
                    } else if (step == 2) {
                      return _ResetPasswordStep();
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailStep extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FadeInAnimation(child: _FieldLabel(label: 'Email Address')),
        const SizedBox(height: AppSpacing.sm),
        FadeInAnimation(
          delay: 100,
          child: _buildGlassTextField(
            controller: controller.emailController,
            hint: 'Enter your email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeInAnimation(
          delay: 200,
          child: Obx(
            () => PrimaryButton(
              text: 'Send OTP',
              isLoading: controller.isLoading.value,
              onPressed: () => controller.forgotPassword(),
            ),
          ),
        ),
      ],
    );
  }
}

class _OtpStep extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FadeInAnimation(child: Text(
          'Enter OTP',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        )),
        const SizedBox(height: AppSpacing.sm),
        FadeInAnimation(
          delay: 100,
          child: _buildGlassTextField(
            controller: controller.otpController,
            hint: 'Enter OTP',
            icon: Icons.lock_outline_rounded,
            keyboardType: TextInputType.number,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeInAnimation(
          delay: 200,
          child: Obx(
            () => PrimaryButton(
              text: 'Verify OTP',
              isLoading: controller.isLoading.value,
              onPressed: () => controller.verifyForgotPasswordOtp(),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        FadeInAnimation(
          delay: 300,
          child: TextButton(
            onPressed: () => controller.forgotPasswordStep.value = 0,
            child: const Text(
              'Resend OTP',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResetPasswordStep extends GetView<AuthController> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FadeInAnimation(child: _FieldLabel(label: 'New Password')),
        const SizedBox(height: AppSpacing.sm),
        FadeInAnimation(
          delay: 100,
          child: _buildGlassTextField(
            controller: controller.newPasswordController,
            hint: 'New password',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const FadeInAnimation(child: _FieldLabel(label: 'Confirm Password')),
        const SizedBox(height: AppSpacing.sm),
        FadeInAnimation(
          delay: 150,
          child: _buildGlassTextField(
            controller: controller.confirmNewPasswordController,
            hint: 'Confirm new password',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        FadeInAnimation(
          delay: 200,
          child: Obx(
            () => PrimaryButton(
              text: 'Reset Password',
              isLoading: controller.isLoading.value,
              onPressed: () => controller.resetForgotPassword(),
            ),
          ),
        ),
      ],
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
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
      color: Colors.white.withValues(alpha: 0.1),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),
    ),
  );
}
