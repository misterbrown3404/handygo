import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/chat/views/individual_chat_view.dart';
import 'package:handygo_worker/app/modules/profile/views/edit_profile_view.dart';
import 'package:handygo_worker/app/modules/profile/controllers/edit_profile_controller.dart';
import 'package:handygo_worker/app/modules/auth/views/forgot_password_view.dart';
import 'package:handygo_worker/app/modules/auth/controllers/splash_controller.dart';
import 'package:handygo_worker/app/modules/auth/bindings/auth_binding.dart';
import 'package:handygo_worker/app/modules/profile/bindings/profile_binding.dart';
import 'package:handygo_worker/app/modules/auth/views/login_view.dart';
import 'package:handygo_worker/app/modules/auth/views/signup_view.dart';
import 'package:handygo_worker/app/modules/auth/views/kyc_view.dart';
import 'package:handygo_worker/app/modules/auth/views/onboarding_view.dart';
import 'package:handygo_worker/app/modules/main/views/main_view.dart';
import 'package:handygo_worker/app/modules/main/bindings/main_binding.dart';
import 'package:handygo_worker/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:handygo_worker/app/modules/bookings/bindings/bookings_binding.dart';
import 'package:handygo_worker/app/modules/chat/bindings/chat_binding.dart';
import 'package:handygo_worker/app/modules/wallet/bindings/wallet_binding.dart';
import 'package:handygo_worker/app/modules/services/views/service_manager_view.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<SplashController>(() => SplashController());
      }),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.KYC,
      page: () => const KycView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainView(),
      bindings: [
        MainBinding(),
        DashboardBinding(),
        BookingsBinding(),
        ChatBinding(),
        WalletBinding(),
        ProfileBinding(),
      ],
    ),
    GetPage(
      name: Routes.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<EditProfileController>(() => EditProfileController());
      }),
    ),
    GetPage(
      name: Routes.SERVICE_MANAGER,
      page: () => const ServiceManagerView(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.CHAT,
      page: () => const IndividualChatView(),
      binding: ChatBinding(),
    ),
  ];
}
