import 'package:get/get.dart';
import 'package:handygo/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 3), () {
      final authController = Get.find<AuthController>();

      if (authController.isFirstTime()) {
        Get.offNamed(Routes.ONBOARDING);
      } else if (authController.user.value != null) {
        Get.offNamed(Routes.MAIN);
      } else {
        Get.offNamed(Routes.SIGN_IN);
      }
    });
  }
}
