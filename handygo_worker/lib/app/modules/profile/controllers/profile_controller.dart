import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/services/storage_service.dart';
import 'package:handygo_worker/app/data/repositories/profile_repository.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';

class ProfileController extends GetxController {
  final ProfileRepository _repository;
  ProfileRepository get repository => _repository;

  var name = ''.obs;
  var phone = ''.obs;
  var email = ''.obs;
  var specialty = ''.obs;
  var bio = ''.obs;
  var rating = (0.0).obs;
  var jobsDone = 0.obs;
  var avatarUrl = Rxn<String>();
  var isLoading = false.obs;
  final StorageService _storage = Get.find<StorageService>();

  ProfileController({ProfileRepository? repository})
      : _repository = repository ?? Get.find<ProfileRepository>();

  @override
  void onInit() {
    super.onInit();
    _updateExperienceLabel();
    ever(jobsDone, (_) => _updateExperienceLabel());
    final token = _storage.read('token');
    if (token == null) return;
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;
      final profile = await _repository.getProfile();

      final user = profile['user'] is Map<String, dynamic>
          ? profile['user'] as Map<String, dynamic>
          : {};

      final worker = profile['worker'] is Map<String, dynamic>
          ? profile['worker'] as Map<String, dynamic>
          : {};

      name.value = user['name']?.toString() ?? '';
      phone.value = user['phone']?.toString() ?? '';
      email.value = user['email']?.toString() ?? '';

      specialty.value = worker['specialty']?.toString() ?? '';
      bio.value = worker['bio']?.toString() ?? '';

      final parsedRating = double.tryParse('${worker['rating'] ?? user['rating'] ?? 0}');
      rating.value = (parsedRating ?? 0).toDouble();

      final parsedJobs = int.tryParse('${worker['total_jobs'] ?? 0}') ?? 0;
      jobsDone.value = parsedJobs;

      avatarUrl.value = user['avatar']?.toString();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      await _storage.remove('token');
      await _storage.remove('user');
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<void> updateProfile({String? newName, String? newPhone, String? newBio, String? newSpecialty}) async {
    try {
      isLoading.value = true;
      final updated = await _repository.updateProfile(name: newName, phone: newPhone, bio: newBio, specialty: newSpecialty);
      if (updated['name'] is String) name.value = updated['name'] as String;
      if (updated['phone'] is String) phone.value = updated['phone'] as String;
      if (updated['specialty'] is String) specialty.value = updated['specialty'] as String;
      if (updated['bio'] is String) bio.value = updated['bio'] as String;
      Get.snackbar('Success', 'Profile updated', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  final RxString experienceLabel = ''.obs;

  void _updateExperienceLabel() {
    if (jobsDone.value >= 50) {
      experienceLabel.value = 'Expert';
    } else if (jobsDone.value >= 20) {
      experienceLabel.value = '3yr';
    } else {
      experienceLabel.value = 'New';
    }
  }
}