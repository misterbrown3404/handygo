import 'package:get/get.dart';
import 'package:handygo_worker/app/data/models/job_request_model.dart';
import 'package:handygo_worker/app/data/repositories/booking_repository.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class BookingsController extends GetxController {
  final BookingRepository _bookingRepository = BookingRepository();
  final GetStorage _storage = Get.find<GetStorage>();

  final requests = <JobRequestModel>[].obs;
  var isLoading = false.obs;
  var hasError = false.obs;

  @override
  void onInit() {
    super.onInit();
    final token = _storage.read('token');
    if (token == null) return;
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      final data = await _bookingRepository.getBookings();
      requests.assignAll(data.where((b) => b.status.toLowerCase() == 'pending').toList());
    } catch (e) {
      hasError.value = true;
      debugPrint('Error fetching job requests: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptRequest(String id) async {
    try {
      isLoading.value = true;
      await _bookingRepository.acceptBooking(id);
      Get.snackbar(
        'Success',
        'Job request accepted successfully.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      await fetchRequests();
    } catch (e) {
      debugPrint('Error accepting request: $e');
      Get.snackbar(
        'Error',
        'Failed to accept request: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> declineRequest(String id) async {
    try {
      isLoading.value = true;
      await _bookingRepository.declineBooking(id);
      Get.snackbar(
        'Success',
        'Job request declined.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      await fetchRequests();
    } catch (e) {
      debugPrint('Error declining request: $e');
      Get.snackbar(
        'Error',
        'Failed to decline request: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
