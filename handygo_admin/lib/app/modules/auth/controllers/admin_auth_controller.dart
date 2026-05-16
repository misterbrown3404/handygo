import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/core/constant/api_constants.dart';

class AdminAuthController extends GetxController {
  final AdminApiClient _api = Get.find<AdminApiClient>();
  final _storage = GetStorage();

  final isLoading = false.obs;
  final isLoggedIn = false.obs;
  final adminUser = Rxn<Map<String, dynamic>>();

  // Form fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _checkAuth();
  }

  void _checkAuth() {
    final token = _storage.read('admin_token');
    if (token != null) {
      isLoggedIn.value = true;
      adminUser.value = _storage.read('admin_user');
    }
  }

  Future<void> login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final response = await _api.post(
        AdminApiConstants.login,
        data: {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['access_token'] ?? data['token'];
        final user = data['user'];

        // Verify this user is an admin
        if (user['role'] != 'admin') {
          Get.snackbar(
            'Access Denied',
            'Only admin accounts can access this panel',
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
          return;
        }

        await _storage.write('admin_token', token);
        await _storage.write('admin_user', user);
        isLoggedIn.value = true;
        adminUser.value = user;

        Get.offAllNamed('/dashboard');
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        'Invalid email or password',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await _api.post(AdminApiConstants.logout);
    } catch (_) {}

    await _storage.remove('admin_token');
    await _storage.remove('admin_user');
    isLoggedIn.value = false;
    adminUser.value = null;
    Get.offAllNamed('/login');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
