import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/services/storage_service.dart';
import 'package:handygo_worker/app/data/providers/api_client.dart';
import 'dart:io';

typedef DioFormData = dio.FormData;

class ProfileRepository extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final StorageService _storage = Get.find<StorageService>();

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _apiClient.get('/auth/me');
    final data = response.data;
    if (data['success'] != true) {
      throw data['message'] ?? 'Failed to load profile';
    }
    return data['data'] ?? {};
  }

  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? bio,
    String? specialty,
  }) async {
    final payload = <String, dynamic>{};
    if (name != null && name.isNotEmpty) payload['name'] = name;
    if (phone != null && phone.isNotEmpty) payload['phone'] = phone;
    if (bio != null) payload['bio'] = bio;
    if (specialty != null) payload['specialty'] = specialty;

    final response = await _apiClient.post('/profile/update', data: payload);
    final data = response.data;
    if (data['success'] != true) {
      throw data['message'] ?? 'Failed to update profile';
    }
    return data['data'] ?? {};
  }

  Future<String> updateAvatar(File imageFile) async {
    final fileName = imageFile.path.split('/').last;
    final formData = DioFormData();
    final multipart = dio.MultipartFile.fromFileSync(imageFile.path, filename: fileName);
    formData.files.add(MapEntry('avatar', multipart));

    final response = await _apiClient.post('/profile/avatar', data: formData);
    final data = response.data;
    if (data['success'] != true) {
      throw data['message'] ?? 'Failed to upload avatar';
    }
    return data['data']['avatar_url'] ?? '';
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await _apiClient.put(
      '/auth/change-password',
      data: {
        'current_password': currentPassword,
        'password': newPassword,
        'password_confirmation': newPassword,
      },
    );
    final data = response.data;
    if (data['success'] == false) {
      throw data['message'] ?? 'Failed to change password';
    }
  }

  Future<void> logout() async {
    final response = await _apiClient.post('/auth/logout');
    final data = response.data;
    await _storage.remove('token');
    await _storage.remove('user');
    if (data['success'] == false) {
      throw data['message'] ?? 'Logout failed';
    }
  }
}
