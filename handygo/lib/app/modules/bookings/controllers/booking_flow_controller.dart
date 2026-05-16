import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../data/models/service_model.dart';
import '../../../data/repositories/bookings_repository.dart';
import '../../../routes/app_pages.dart';

class BookingFlowController extends GetxController {
  final BookingsRepository _bookingsRepo = BookingsRepository();

  late ServiceModel service;

  // Form State
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final notesController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  var selectedRooms = 1.obs;
  var selectedAddress = "".obs;
  var selectedPaymentMethod = "Credit Card".obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ServiceModel) {
      service = Get.arguments;
    }
  }

  Future<void> submitBooking() async {
    try {
      isLoading(true);

      // Parse scheduledAt
      final dateStr = dateController.text;
      final timeStr = timeController.text;
      final scheduledAt = DateTime.parse("$dateStr $timeStr");

      await _bookingsRepo.createBooking(
        serviceId: service.id!,
        scheduledAt: scheduledAt,
        address: selectedAddress.value,
        notes: notesController.text,
      );

      Get.offAllNamed(Routes.MAIN); // Go home after success
      Get.snackbar(
        "Success",
        "Booking created successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Please ensure Date (YYYY-MM-DD) and Time (HH:MM) are correct",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}
