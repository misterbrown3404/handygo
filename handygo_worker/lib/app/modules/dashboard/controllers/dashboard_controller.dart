import 'package:get/get.dart';
import 'package:handygo_worker/app/core/services/storage_service.dart';
import 'package:handygo_worker/app/data/models/job_request_model.dart';
import 'package:handygo_worker/app/data/repositories/booking_repository.dart';
import 'package:handygo_worker/app/data/repositories/wallet_repository.dart';
import 'package:handygo_worker/app/data/repositories/worker_repository.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  final BookingRepository _bookingRepository = BookingRepository();
  final WalletRepository _walletRepository = WalletRepository();
  final WorkerRepository _workerRepository = WorkerRepository();
  final StorageService _storage = Get.find<StorageService>();

  var isOnline = false.obs;
  var totalEarnings = '₦0'.obs;
  var jobsDone = '0'.obs;
  final nextJob = Rxn<JobRequestModel>();
  var workerName = ''.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final token = _storage.read('token');
    if (token == null) return;
    _loadInitialData();
    refreshDashboard();
  }

  void _loadInitialData() {
    final userData = _storage.read('user') ?? {};
    workerName.value = userData['name'] ?? '';
    final workerData = userData['worker'] ?? {};
    isOnline.value = (workerData['status'] ?? '').toLowerCase() == 'active';
  }

  Future<void> refreshDashboard() async {
    try {
      isLoading.value = true;
      if (_storage.read('token') == null) return;

      await _walletRepository.getBalance();
      final bookings = await _bookingRepository.getBookings();
      
      final completed = bookings.where((b) => b.status.toLowerCase() == 'completed').toList();
      jobsDone.value = completed.length.toString();

      double total = 0.0;
      for (var b in completed) {
        final cleanedPrice = b.price.replaceAll('₦', '').replaceAll(',', '').trim();
        total += double.tryParse(cleanedPrice) ?? 0.0;
      }
      totalEarnings.value = '₦${total.toStringAsFixed(0)}';

      final activeJob = bookings.firstWhereOrNull(
        (b) => b.status.toLowerCase() == 'accepted' || 
               b.status.toLowerCase() == 'ongoing' || 
               b.status.toLowerCase() == 'in_progress'
      );
      nextJob.value = activeJob;

    } catch (e) {
      debugPrint('Error refreshing dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleOnline(bool value) async {
    try {
      final userData = _storage.read('user') ?? {};
      final workerData = userData['worker'] ?? {};
      final int? workerId = workerData['id'];

      if (workerId == null) {
        Get.snackbar('Error', 'Worker profile not found.');
        return;
      }

      final updatedStatus = await _workerRepository.toggleAvailability(workerId);
      isOnline.value = updatedStatus;

      workerData['status'] = updatedStatus ? 'active' : 'inactive';
      userData['worker'] = workerData;
      await _storage.write('user', userData);

      Get.snackbar(
        'Status Updated',
        updatedStatus ? 'You are now online and available for jobs.' : 'You are now offline.',
        backgroundColor: updatedStatus ? Colors.green : Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Error toggling status: $e');
      Get.snackbar(
        'Error',
        'Failed to update status: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
