import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handygo/app/data/models/user_model.dart';
import 'package:handygo/app/data/repositories/profile_repository.dart';
import 'package:handygo/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo/app/routes/app_pages.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final _storage = GetStorage();
  final authController = Get.find<AuthController>();
  final _profileRepo = ProfileRepository();
  final _picker = ImagePicker();

  // Controllers for Edit Profile
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController addressController;

  var isLoading = false.obs;
  var selectedImagePath = "".obs;

  @override
  void onInit() {
    super.onInit();
    final user = authController.user.value;
    nameController = TextEditingController(text: user?.name);
    phoneController = TextEditingController(text: user?.phone);
    emailController = TextEditingController(text: user?.email);
    addressController = TextEditingController(text: user?.address);
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImagePath.value = image.path;
      await uploadAvatar(image.path);
    }
  }

  Future<void> uploadAvatar(String path) async {
    try {
      isLoading(true);
      final avatarUrl = await _profileRepo.uploadAvatar(path);

      // Update local user state
      final updatedUser = authController.user.value!;
      final newUser = UserModel(
        id: updatedUser.id,
        name: updatedUser.name,
        email: updatedUser.email,
        phone: updatedUser.phone,
        role: updatedUser.role,
        avatar: avatarUrl,
        address: updatedUser.address,
      );

      authController.user.value = newUser;
      await _storage.write('user', newUser.toJson());

      Get.snackbar(
        "Success",
        "Profile picture updated",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to upload image: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading(true);
      final updatedUser = await _profileRepo.updateProfile(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
        address: addressController.text.trim(),
      );

      authController.user.value = updatedUser;
      await _storage.write('user', updatedUser.toJson());

      Get.back(); // Go back to profile view
      Get.snackbar(
        "Success",
        "Profile updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update profile: $e",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  void logout() async {
    await _storage.remove('token');
    await _storage.remove('user');
    await _storage.remove('rememberMe');
    authController.user.value = null;
    Get.offAllNamed(Routes.SIGN_IN);
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
