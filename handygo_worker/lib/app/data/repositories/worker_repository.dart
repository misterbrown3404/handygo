import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../providers/api_client.dart';

class WorkerRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  WorkerRepository();

  Future<bool> toggleAvailability(int workerId) async {
    final dio.Response response = await _apiClient.post('/workers/$workerId/toggle-status');
    final Map<String, dynamic> responseData = response.data;
    if (responseData['success'] == true) {
      final workerData = responseData['data'] ?? {};
      return (workerData['status'] ?? '').toLowerCase() == 'active';
    }
    throw Exception(responseData['message'] ?? 'Failed to toggle availability status');
  }
}
