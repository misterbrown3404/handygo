import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:handygo/app/data/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handygo/app/routes/app_pages.dart';
import 'package:handygo/app/data/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepo = AuthRepository();
  final _storage = GetStorage();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  // Observables
  final user = Rxn<UserModel>();
  var isRememberMe = false.obs;
  var isAgreeTerms = false.obs;
  var obscurePassword = true.obs;
  var obscureConfirmPassword = true.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    final userData = _storage.read('user');
    final rememberMe = _storage.read('rememberMe') ?? false;
    isRememberMe.value = rememberMe;

    if (rememberMe && userData != null) {
      user.value = UserModel.fromJson(userData);
    }
  }

  bool isFirstTime() {
    return _storage.read('seenOnboarding') ?? true;
  }

  void markOnboardingAsSeen() {
    _storage.write('seenOnboarding', false);
  }

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> signIn() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Input Error',
        'Please enter both email and password',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final AuthResponse response = await _authRepo.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      await _handleAuthSuccess(response);
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final response = await _authRepo.signInWithGoogle();
      await _handleAuthSuccess(response);
    } catch (e) {
      if (e.toString().contains('cancelled')) return; // Ignore cancellations
      Get.snackbar(
        'Google Login Failed',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithApple() async {
    try {
      isLoading.value = true;
      final response = await _authRepo.signInWithApple();
      await _handleAuthSuccess(response);
    } catch (e) {
      Get.snackbar(
        'Apple Login Failed',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleAuthSuccess(AuthResponse response) async {
    // Store credentials
    await _storage.write('token', response.token);
    await _storage.write('user', response.user.toJson());
    await _storage.write('rememberMe', isRememberMe.value);
    user.value = response.user;

    // Sync FCM Token
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _authRepo.updateFcmToken(fcmToken);
      }
    } catch (e) {
      debugPrint("FCM token sync failed: $e");
    }

    Get.offAllNamed(Routes.MAIN);
  }

  Future<void> signUp() async {
    if (!isAgreeTerms.value) {
      Get.snackbar(
        'Agreement Required',
        'Please accept the Terms and Conditions to continue',
        backgroundColor: Colors.orangeAccent,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _authRepo.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        phone: phoneController.text.trim(),
      );

      Get.snackbar(
        'Registration Successful',
        'Welcome to HandyGo! Please login to continue.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed(Routes.SIGN_IN);
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        e.toString(),
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void sendResetCode() => Get.toNamed(Routes.VERIFY_OTP);
  void verifyOtp() => Get.toNamed(Routes.NEW_PASSWORD);
  void createNewPassword() => Get.offAllNamed(Routes.SIGN_IN);

  void goToSignIn() => Get.toNamed(Routes.SIGN_IN);
  void goToSignUp() => Get.toNamed(Routes.SIGN_UP);
  void goToForgotPassword() => Get.toNamed(Routes.FORGOT_PASSWORD);

  // No manual dispose needed for GetX controllers using TextEditingControllers
  // to avoid "used after being disposed" errors during route transitions.
}
