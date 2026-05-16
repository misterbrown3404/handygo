import 'package:dio/dio.dart' as dio;
import '../providers/api_client.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';

class ProfileRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<UserModel> updateProfile({
    required String name,
    required String phone,
    String? address,
  }) async {
    final response = await apiClient.post(
      '/profile/update',
      data: {'name': name, 'phone': phone, 'address': address},
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<String> uploadAvatar(String filePath) async {
    final formData = dio.FormData.fromMap({
      'avatar': await dio.MultipartFile.fromFile(filePath),
    });

    final response = await apiClient.post('/profile/avatar', data: formData);

    if (response.statusCode == 200) {
      return response.data['data']['avatar_url'];
    } else {
      throw Exception('Failed to upload avatar');
    }
  }
}
