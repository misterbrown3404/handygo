import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../providers/api_client.dart';
import '../models/job_request_model.dart';

class BookingRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();

  Future<List<JobRequestModel>> getBookings() async {
    final dio.Response response = await _apiClient.get('/bookings');
    final Map<String, dynamic> responseData = response.data;
    final List list = responseData['data'] ?? [];
    return list.map((e) => JobRequestModel.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<JobRequestModel> acceptBooking(String id) async {
    final dio.Response response = await _apiClient.post('/bookings/$id/accept');
    final Map<String, dynamic> responseData = response.data;
    final bookingJson = responseData['data'] ?? responseData;
    return JobRequestModel.fromJson(bookingJson as Map<String, dynamic>);
  }

  Future<JobRequestModel> declineBooking(String id) async {
    final dio.Response response = await _apiClient.post('/bookings/$id/decline');
    final Map<String, dynamic> responseData = response.data;
    final bookingJson = responseData['data'] ?? responseData;
    return JobRequestModel.fromJson(bookingJson as Map<String, dynamic>);
  }

  Future<JobRequestModel> completeBooking(String id) async {
    final dio.Response response = await _apiClient.post('/bookings/$id/complete');
    final Map<String, dynamic> responseData = response.data;
    final bookingJson = responseData['data'] ?? responseData;
    return JobRequestModel.fromJson(bookingJson as Map<String, dynamic>);
  }

  Future<JobRequestModel> cancelBooking(String id) async {
    final dio.Response response = await _apiClient.post('/bookings/$id/cancel');
    final Map<String, dynamic> responseData = response.data;
    final bookingJson = responseData['data'] ?? responseData;
    return JobRequestModel.fromJson(bookingJson as Map<String, dynamic>);
  }
}
