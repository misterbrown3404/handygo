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
    Future.delayed(const Duration(seconds: 2), () {
      final authController = Get.find<AuthController>();

      if (authController.hasToken.value && authController.user.value != null) {
        Get.offNamed(Routes.MAIN);
      } else if (authController.isFirstTime()) {
        Get.offNamed(Routes.ONBOARDING);
      } else {
        Get.offNamed(Routes.SIGN_IN);
      }
    });
  }
}
