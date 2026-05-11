import 'package:get/get.dart';
import 'package:handygo/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Navigate to next screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(Routes.ONBOARDING);
    });
  }
}
