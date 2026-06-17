import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/profile/controllers/profile_controller.dart';
import 'package:handygo_worker/app/data/repositories/profile_repository.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRepository>(() => ProfileRepository());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
