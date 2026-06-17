import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/services/storage_service.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';
import 'package:handygo_worker/app/data/providers/api_client.dart';
import 'package:handygo_worker/app/data/repositories/profile_repository.dart';

class AuthController extends GetxController {
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ninController = TextEditingController();
  final bvnController = TextEditingController();

  final otpController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmNewPasswordController = TextEditingController();

  var isLoading = false.obs;
  var currentOnboardingStep = 0.obs;
  var forgotPasswordStep = 0.obs;

  var user = Rxn<Map<String, dynamic>>();
  final StorageService _storage = Get.find<StorageService>();

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    fullNameController.dispose();
    emailController.dispose();
    confirmPasswordController.dispose();
    ninController.dispose();
    bvnController.dispose();
    otpController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.onClose();
  }

  void login() async {
    if (phoneController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both phone number and password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/auth/login',
        data: {
          'email': phoneController.text.trim(),
          'password': passwordController.text.trim(),
        },
      );

      final Map<String, dynamic> responseData = response.data;
      if (responseData['success'] == true) {
        final token = responseData['data']?['token'];
        final userData = responseData['data']?['user'];

        if (userData != null && userData['role'] == 'worker') {
          _storage.write('token', token);
          _storage.write('user', userData);
          user.value = userData;
          Get.offAllNamed(Routes.MAIN);
        } else {
          Get.snackbar(
            'Access Denied',
            'Only worker accounts can log in here.',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Login failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void signup() async {
    if (fullNameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.trim().length < 8) {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/auth/register',
        data: {
          'name': fullNameController.text.trim(),
          'email': emailController.text.trim(),
          'phone': phoneController.text.trim(),
          'password': passwordController.text.trim(),
          'role': 'worker',
        },
      );

      final Map<String, dynamic> responseData = response.data;
      if (responseData['success'] == true) {
        Get.toNamed(Routes.KYC);
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'Registration failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('Signup error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void submitKyc() async {
    if (ninController.text.length != 11 || bvnController.text.length != 11) {
      Get.snackbar(
        'Invalid Input',
        'NIN and BVN must be 11 digits long.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/kyc/submit',
        data: {
          'nin': ninController.text.trim(),
          'bvn': bvnController.text.trim(),
        },
      );

      final Map<String, dynamic> responseData = response.data;
      if (responseData['success'] == true) {
        Get.toNamed(Routes.ONBOARDING);
      } else {
        Get.snackbar(
          'Error',
          responseData['message'] ?? 'KYC submission failed',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint('KYC error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void forgotPassword() async {
    if (emailController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/auth/forgot-password',
        data: {
          'email': emailController.text.trim(),
        },
      );

      final Map<String, dynamic> responseData = response.data;
      Get.snackbar(
        'Success',
        responseData['message'] ?? 'OTP sent to your email',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      forgotPasswordStep.value = 1;
      otpController.clear();
    } catch (e) {
      debugPrint('Forgot password error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void verifyForgotPasswordOtp() async {
    if (otpController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter the OTP',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/auth/verify-otp',
        data: {
          'email': emailController.text.trim(),
          'otp': otpController.text.trim(),
        },
      );

      final Map<String, dynamic> responseData = response.data;
      Get.snackbar(
        'Success',
        responseData['message'] ?? 'OTP verified',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      forgotPasswordStep.value = 2;
      newPasswordController.clear();
      confirmNewPasswordController.clear();
    } catch (e) {
      debugPrint('Verify OTP error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resetForgotPassword() async {
    if (newPasswordController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a new password',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text.trim().length < 8) {
      Get.snackbar(
        'Error',
        'Password must be at least 8 characters',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPasswordController.text.trim() != confirmNewPasswordController.text.trim()) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final ApiClient apiClient = Get.find<ApiClient>();
      final response = await apiClient.post(
        '/auth/reset-password',
        data: {
          'email': emailController.text.trim(),
          'token': otpController.text.trim(),
          'password': newPasswordController.text.trim(),
          'password_confirmation': confirmNewPasswordController.text.trim(),
        },
      );

      final Map<String, dynamic> responseData = response.data;
      Get.snackbar(
        'Success',
        responseData['message'] ?? 'Password reset successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      _clearForgotPasswordFields();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      debugPrint('Reset password error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _clearForgotPasswordFields() {
    emailController.clear();
    otpController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    forgotPasswordStep.value = 0;
  }

  void logout() async {
    try {
      final repo = Get.find<ProfileRepository>();
      await repo.logout();
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      await _storage.remove('token');
      await _storage.remove('user');
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  void changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (currentPassword.trim().isEmpty || newPassword.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all password fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.trim().length < 8) {
      Get.snackbar(
        'Error',
        'New password must be at least 8 characters',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    try {
      final repo = Get.find<ProfileRepository>();
      await repo.changePassword(
        currentPassword: currentPassword.trim(),
        newPassword: newPassword.trim(),
      );

      Get.snackbar(
        'Success',
        'Password changed successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      debugPrint('Change password error: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
