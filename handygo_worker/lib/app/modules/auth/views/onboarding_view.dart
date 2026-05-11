import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';
import 'package:handygo_worker/app/widgets/primary_button.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';
import 'dart:ui';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  int currentStep = 0;

  final List<Map<String, String>> steps = [
    {'title': 'Professional Profile', 'subtitle': 'Tell us about your expertise'},
    {'title': 'Service Selection', 'subtitle': 'Choose categories you offer'},
    {'title': 'Verify Identity', 'subtitle': 'Upload ID & certificates'},
  ];

  void _nextStep() => currentStep < steps.length - 1 ? setState(() => currentStep++) : Get.offAllNamed(Routes.MAIN);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Asset
          Positioned.fill(
            child: Image.asset('assets/images/onboarding.jpg', fit: BoxFit.cover),
          ),
          Container(color: Colors.black.withOpacity(0.4)),
          
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _buildProgressHeader(),
                ),
                const Spacer(),
                FadeInAnimation(
                  key: ValueKey(currentStep),
                  child: _buildGlassStepCard(),
                ),
                const SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassStepCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(steps[currentStep]['title']!, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(steps[currentStep]['subtitle']!, style: const TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: AppSpacing.xl),
                PrimaryButton(
                  text: currentStep == steps.length - 1 ? 'Get Started' : 'Continue',
                  onPressed: _nextStep,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Row(
      children: List.generate(
        steps.length,
        (index) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: 4,
            decoration: BoxDecoration(
              color: index <= currentStep ? Colors.white : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
