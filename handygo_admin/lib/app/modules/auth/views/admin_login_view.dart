import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
import 'package:handygo_admin/app/modules/auth/controllers/admin_auth_controller.dart';

class AdminLoginView extends StatelessWidget {
  const AdminLoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminAuthController>();
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      backgroundColor: const Color(0xFFf0f4f8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AdminSpacing.xl),
            child: Container(
              width: isDesktop ? 440 : double.infinity,
              padding: const EdgeInsets.all(AdminSpacing.xxl),
              decoration: BoxDecoration(
                color: AdminColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: AdminShadows.shadowLg,
                border: Border.all(color: AdminColors.borderDark, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Logo ─────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AdminColors.primary, AdminColors.accent],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                    ),
                    child: const Icon(
                      Icons.handyman_rounded,
                      color: AdminColors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: AdminSpacing.lg),
                  Text(
                    'HandyGo Admin',
                    style: AdminTextStyles.h2,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sign in to your admin dashboard',
                    style: AdminTextStyles.bodySmallSecondary,
                  ),
                  const SizedBox(height: AdminSpacing.xxl),

                  // ── Email field ───────────────────────────────────
                  _buildTextField(
                    controller: controller.emailController,
                    label: 'Email Address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: AdminSpacing.md),

                  // ── Password field ───────────────────────────────
                  _buildTextField(
                    controller: controller.passwordController,
                    label: 'Password',
                    icon: Icons.lock_outline,
                    obscureText: true,
                  ),
                  const SizedBox(height: AdminSpacing.xxl),

                  // ── Login button ─────────────────────────────────
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AdminColors.primary,
                          foregroundColor: AdminColors.white,
                          elevation: 3,
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AdminColors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AdminSpacing.lg),
                  Text(
                    'Admin access only. Contact support if locked out.',
                    style: TextStyle(
                      color: AdminColors.textSecondary.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: const TextStyle(color: AdminColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: AdminColors.textSecondary,
          fontSize: 14,
        ),
        prefixIcon: Icon(icon, color: AdminColors.textSecondary, size: 20),
        filled: true,
        fillColor: AdminColors.neutral100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AdminColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AdminColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AdminColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AdminSpacing.md,
          vertical: AdminSpacing.sm + 2,
        ),
      ),
    );
  }
}
