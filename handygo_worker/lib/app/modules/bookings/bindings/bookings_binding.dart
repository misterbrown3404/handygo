import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/bookings/controllers/bookings_controller.dart';

class BookingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingsController>(() => BookingsController());
  }
}
