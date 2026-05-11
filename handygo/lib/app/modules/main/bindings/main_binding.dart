import 'package:get/get.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
  }
}
