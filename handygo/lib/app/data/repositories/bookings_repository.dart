import '../providers/api_client.dart';
import '../models/booking_model.dart';
import 'package:get/get.dart';

class BookingsRepository {
  final ApiClient apiClient = Get.find<ApiClient>();

  Future<List<BookingModel>> getBookings({String? status}) async {
    final queryParams = status != null ? {'status': status} : null;
    final response = await apiClient.get(
      '/bookings',
      queryParameters: queryParams,
    );

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => BookingModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load bookings');
    }
  }

  Future<BookingModel> createBooking({
    required int serviceId,
    required DateTime scheduledAt,
    String? notes,
    String? address,
    double? amount,
  }) async {
    final response = await apiClient.post(
      '/bookings',
      data: {
        'service_id': serviceId,
        'scheduled_at': scheduledAt.toIso8601String(),
        'notes': notes,
        'address': address,
        'amount': amount,
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      return BookingModel.fromJson(response.data['data']);
    } else {
      throw Exception('Failed to create booking');
    }
  }

  Future<void> cancelBooking(int id) async {
    await apiClient.post('/bookings/$id/cancel');
  }

  Future<void> completeBooking(int id) async {
    await apiClient.post('/bookings/$id/complete');
  }
}
