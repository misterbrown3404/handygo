import '../providers/api_client.dart';
import '../models/service_model.dart';
import 'package:get/get.dart';

class FavoriteRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<List<ServiceModel>> getFavorites() async {
    final response = await apiClient.get('/favorites');
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => ServiceModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load favorites');
    }
  }

  Future<void> toggleFavorite(int serviceId) async {
    await apiClient.post('/favorites/toggle', data: {
      'service_id': serviceId,
    });
  }
}
