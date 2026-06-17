import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';

class SplashController extends GetxController {
  final GetStorage _storage = Get.find<GetStorage>();
  var isChecking = true.obs;
  var errorMessage = Rxn<String>();

  @override
  void onReady() {
    super.onReady();
    _resolveStartRoute();
  }

  void _resolveStartRoute() {
    Future.delayed(const Duration(milliseconds: 800), () {
      try {
        final token = _storage.read('token');
        final user = _storage.read('user');

        if (token != null && user is Map<String, dynamic>) {
          final role = (user['role'] ?? '').toString().toLowerCase();
          if (role == 'worker') {
            Get.offAllNamed(Routes.MAIN);
            return;
          }
          _clearAndRedirect(role);
          return;
        }

        Get.offAllNamed(Routes.LOGIN);
      } catch (e) {
        errorMessage.value = e.toString();
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  void _clearAndRedirect(String? role) {
    _storage.remove('token');
    _storage.remove('user');
    final message = role == null || role.isEmpty
        ? 'Please log in'
        : 'This app is for workers only.';
    Get.offAllNamed(Routes.LOGIN, arguments: {'message': message});
  }
}

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(() {
          if (controller.errorMessage.value != null) {
            return Text(
              controller.errorMessage.value ?? 'Something went wrong.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red),
            );
          }
          return const CircularProgressIndicator();
        }),
      ),
    );
  }
}
