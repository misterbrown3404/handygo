import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo_worker/app/widgets/primary_button.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';
import 'dart:ui';

class KycView extends GetView<AuthController> {
  const KycView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/onboarding.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  const FadeInAnimation(
                    child: Text(
                      'Identity Verification',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const FadeInAnimation(
                    delay: 100,
                    child: Text(
                      'Verified providers get 3x more bookings',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  FadeInAnimation(
                    delay: 200,
                    child: _buildGlassKycCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassKycCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _securityBadge(),
              const SizedBox(height: AppSpacing.lg),
              _kycInput(
                controller: controller.ninController,
                label: 'National Identity Number (NIN)',
                hint: '11-digit NIN',
                icon: Icons.badge_outlined,
              ),
              const SizedBox(height: AppSpacing.md),
              _kycInput(
                controller: controller.bvnController,
                label: 'Bank Verification Number (BVN)',
                hint: '11-digit BVN',
                icon: Icons.account_balance_outlined,
              ),
              const SizedBox(height: AppSpacing.xl),
              const Text('Why this matters?', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              const Text(
                'NIN and BVN are required by Nigerian law for financial transactions and identity security on professional platforms.',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                text: 'Verify My Identity',
                onPressed: () => controller.submitKyc(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _securityBadge() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Row(
        children: [
          Icon(Icons.shield_rounded, color: AppColors.primaryColor, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Your data is encrypted and secure.',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _kycInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold, fontSize: 12)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 11,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white24),
              counterText: '',
              prefixIcon: Icon(icon, color: Colors.white70, size: 20),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            ),
          ),
        ),
      ],
    );
  }
}
