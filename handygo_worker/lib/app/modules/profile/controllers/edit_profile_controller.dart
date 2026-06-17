import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:handygo_worker/app/data/repositories/profile_repository.dart';
import 'package:handygo_worker/app/modules/profile/controllers/profile_controller.dart';
import 'dart:io';

class EditProfileController extends GetxController {
  final ProfileRepository _repository = Get.find<ProfileRepository>();
  final GetStorage _storage = GetStorage();

  var name = ''.obs;
  var phone = ''.obs;
  var specialty = ''.obs;
  var bio = ''.obs;

  var isSavingProfile = false.obs;
  var isUploadingAvatar = false.obs;
  var avatarPath = Rxn<String>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final specialtyController = TextEditingController();
  final bioController = TextEditingController();

  EditProfileController();

  @override
  void onInit() {
    super.onInit();
    final user = _storage.read('user') ?? {};
    final worker = user['worker'] ?? {};
    name.value = user['name']?.toString() ?? '';
    phone.value = user['phone']?.toString() ?? '';
    specialty.value = worker['specialty']?.toString() ?? '';
    bio.value = worker['bio']?.toString() ?? '';
    nameController.text = name.value;
    phoneController.text = phone.value;
    specialtyController.text = specialty.value;
    bioController.text = bio.value;
  }

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    specialtyController.dispose();
    bioController.dispose();
    super.onClose();
  }

  Future<void> saveProfile() async {
    name.value = nameController.text.trim();
    phone.value = phoneController.text.trim();
    specialty.value = specialtyController.text.trim();
    bio.value = bioController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      Get.snackbar('Validation', 'Name and phone are required.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      isSavingProfile.value = true;
      await _repository.updateProfile(
        name: name.value,
        phone: phone.value,
        bio: bio.value,
        specialty: specialty.value,
      );

      final user = Map<String, dynamic>.from(_storage.read('user') ?? {});
      user['name'] = name.value;
      user['phone'] = phone.value;
      user['worker'] = Map<String, dynamic>.from(user['worker'] ?? {});
      user['worker']['specialty'] = specialty.value;
      user['worker']['bio'] = bio.value;
      await _storage.write('user', user);

      Get.back();
      Get.find<ProfileController>().fetchProfile();

      Get.snackbar('Success', 'Profile updated successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isSavingProfile.value = false;
    }
  }

  Future<void> pickAndUploadAvatar() async {
    try {
      isUploadingAvatar.value = true;
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (file == null) {
        isUploadingAvatar.value = false;
        return;
      }

      final imageFile = File(file.path);
      avatarPath.value = file.path;
      final url = await _repository.updateAvatar(imageFile);

      final user = Map<String, dynamic>.from(_storage.read('user') ?? {});
      user['avatar'] = url;
      user['worker'] = Map<String, dynamic>.from(user['worker'] ?? {});
      user['worker']['avatar'] = url;
      await _storage.write('user', user);

      Get.find<ProfileController>().fetchProfile();

      Get.snackbar('Success', 'Avatar updated successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isUploadingAvatar.value = false;
    }
  }
}
