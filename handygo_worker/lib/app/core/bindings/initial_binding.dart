import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handygo_worker/app/core/services/storage_service.dart';
import 'package:handygo_worker/app/data/providers/api_client.dart';
import 'package:handygo_worker/app/data/repositories/profile_repository.dart';
import 'package:handygo_worker/app/modules/main/controllers/main_controller.dart';
import 'package:handygo_worker/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:handygo_worker/app/modules/bookings/controllers/bookings_controller.dart';
import 'package:handygo_worker/app/modules/wallet/controllers/wallet_controller.dart';
import 'package:handygo_worker/app/modules/profile/controllers/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(GetStorage(), permanent: true);
    Get.put(StorageService(), permanent: true);
    Get.put(ApiClient(Get.find<StorageService>()), permanent: true);
    Get.put(MainController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(BookingsController(), permanent: true);
    Get.put(WalletController(), permanent: true);
    Get.put(ProfileRepository(), permanent: true);
    Get.put(ProfileController(), permanent: true);
  }
}
