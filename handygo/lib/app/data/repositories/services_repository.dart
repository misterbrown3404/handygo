import '../providers/api_client.dart';
import '../models/service_model.dart';
import 'package:get/get.dart';

class ServicesRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<List<ServiceModel>> getServices() async {
    final response = await apiClient.get('/services');
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => ServiceModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load services');
    }
  }

  Future<ServiceModel> getServiceDetails(int id) async {
    final response = await apiClient.get('/services/$id');
    if (response.statusCode == 200) {
      return ServiceModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load service details');
    }
  }
}
