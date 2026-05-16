import '../providers/api_client.dart';
import '../models/worker_model.dart';
import 'package:get/get.dart';

class WorkerRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<List<WorkerModel>> getNearbyWorkers({
    required double lat,
    required double lng,
    int? serviceId,
  }) async {
    final response = await apiClient.get('/workers/nearby', queryParameters: {
      'lat': lat,
      'lng': lng,
      if (serviceId != null) 'service_id': serviceId,
    });

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => WorkerModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load nearby workers');
    }
  }

  Future<WorkerModel> getWorkerDetails(int id) async {
    final response = await apiClient.get('/workers/$id');
    if (response.statusCode == 200) {
      return WorkerModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to load worker details');
    }
  }

  Future<List<WorkerModel>> getWorkers({String? location, String? search}) async {
    final response = await apiClient.get('/workers', queryParameters: {
      if (location != null && location.isNotEmpty) 'location': location,
      if (search != null && search.isNotEmpty) 'search': search,
    });
    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => WorkerModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load workers');
    }
  }
}
