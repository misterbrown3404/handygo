import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/main/controllers/main_controller.dart';
import 'package:handygo_worker/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:handygo_worker/app/modules/bookings/controllers/bookings_controller.dart';
import 'package:handygo_worker/app/modules/chat/controllers/chat_controller.dart';
import 'package:handygo_worker/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:handygo_worker/app/modules/profile/controllers/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(BookingsController(), permanent: true);
    Get.put(ChatController(), permanent: true);
    Get.put(WalletController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
  }
}
