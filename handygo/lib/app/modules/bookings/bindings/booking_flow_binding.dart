import 'package:get/get.dart';
import '../controllers/booking_flow_controller.dart';

class BookingFlowBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingFlowController>(() => BookingFlowController());
  }
}
