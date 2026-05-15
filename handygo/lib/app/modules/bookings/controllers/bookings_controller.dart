import 'package:handygo/app/data/models/booking_model.dart';
import 'package:handygo/app/data/repositories/bookings_repository.dart';
import 'package:get/get.dart';

class BookingsController extends GetxController {
  final _bookingsRepo = BookingsRepository();
  
  final ongoingBookings = <BookingModel>[].obs;
  final completedBookings = <BookingModel>[].obs;
  final cancelledBookings = <BookingModel>[].obs;
  
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllBookings();
  }

  Future<void> fetchAllBookings() async {
    try {
      isLoading(true);
      final all = await _bookingsRepo.getBookings();
      
      ongoingBookings.assignAll(all.where((b) => b.status?.toLowerCase() == 'ongoing' || b.status?.toLowerCase() == 'pending').toList());
      completedBookings.assignAll(all.where((b) => b.status?.toLowerCase() == 'completed').toList());
      cancelledBookings.assignAll(all.where((b) => b.status?.toLowerCase() == 'cancelled').toList());
    } catch (e) {
      print("Error fetching bookings: $e");
    } finally {
      isLoading(false);
    }
  }
}
