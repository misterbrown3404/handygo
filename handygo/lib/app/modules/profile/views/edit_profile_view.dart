import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/profile/controllers/profile_controller.dart';

import 'package:handygo/app/core/constant/image_string.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Edit Profile",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: AppColors.mainGradient,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildAvatarSection(),
                const SizedBox(height: 40),
                _buildEditForm(),
                const SizedBox(height: 40),
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : () => controller.updateProfile(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          "Update Profile",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Stack(
      children: [
        Obx(() {
          final user = controller.authController.user.value;
          final localImage = controller.selectedImagePath.value;
          
          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
            ),
            child: CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white.withOpacity(0.1),
              backgroundImage: localImage.isNotEmpty
                  ? FileImage(File(localImage)) as ImageProvider
                  : (user?.avatar != null && user!.avatar!.startsWith('http')
                      ? NetworkImage(user.avatar!) as ImageProvider
                      : const AssetImage(ImageStrings.profilePic)),
            ),
          );  
        }),
        Positioned( 
          bottom: 4,
          right: 4,
          child: InkWell(
            onTap: () => controller.pickImage(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        _buildTextField("Full Name", controller.nameController, Icons.person_outline),
        const SizedBox(height: 20),
        _buildTextField("Email Address", controller.emailController, Icons.email_outlined, enabled: false),
        const SizedBox(height: 20),
        _buildTextField("Phone Number", controller.phoneController, Icons.phone_outlined),
        const SizedBox(height: 20),
        _buildTextField("Address", controller.addressController, Icons.location_on_outlined),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController textController, IconData icon, {bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: textController,
          enabled: enabled,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primaryColor.withOpacity(0.7)),
            filled: true,
            fillColor: Colors.white.withOpacity(0.4),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
            ),
            hintText: "Enter your $label",
            hintStyle: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ],
    );
  }

}
