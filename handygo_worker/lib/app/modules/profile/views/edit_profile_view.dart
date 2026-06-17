import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/modules/profile/controllers/edit_profile_controller.dart';
import 'package:handygo_worker/app/widgets/primary_button.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home_image_2.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(color: Colors.black.withValues(alpha: 0.25)),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        ),
                        const Expanded(
                          child: Text(
                            'Edit Profile',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  FadeInAnimation(child: _AvatarCard()),
                  const SizedBox(height: AppSpacing.xl),
                  FadeInAnimation(delay: 100, child: _ProfileForm()),
                  const SizedBox(height: AppSpacing.xl),
                  FadeInAnimation(delay: 200, child: _PasswordSection()),
                  const SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _AvatarCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.pickAndUploadAvatar(),
            child: Obx(() {
              final path = controller.avatarPath.value;
              return CircleAvatar(
                radius: 36,
                backgroundImage: path != null ? AssetImage('assets/images/profile.jpg') : null,
                child: path == null ? const Icon(Icons.camera_alt, size: 22) : null,
              );
            }),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(controller.name.value, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Obx(() => Text(
                  controller.isUploadingAvatar.value ? 'Uploading...' : 'Change profile photo',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ProfileForm() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Personal Details',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildTextField('Full Name', controller.nameController, Icons.person_outline_rounded),
          const SizedBox(height: AppSpacing.md),
          _buildTextField('Phone Number', controller.phoneController, Icons.phone_android_rounded, keyboardType: TextInputType.phone),
          const SizedBox(height: AppSpacing.md),
          _buildTextField('Specialty/Trade', controller.specialtyController, Icons.engineering_rounded),
          const SizedBox(height: AppSpacing.md),
          _buildTextField('Bio', controller.bioController, Icons.description_outlined, maxLines: 3),
          const SizedBox(height: AppSpacing.lg),
          Obx(() => PrimaryButton(
            text: 'Save Changes',
            isLoading: controller.isSavingProfile.value,
            onPressed: () => controller.saveProfile(),
          )),
        ],
      ),
    );
  }

  Widget _PasswordSection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    final decoration = InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primaryColor),
      filled: true,
      fillColor: const Color(0xFFF8F9FA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: decoration,
    );
  }
}
