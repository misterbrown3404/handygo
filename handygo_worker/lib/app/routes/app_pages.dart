import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/auth/views/login_view.dart';
import 'package:handygo_worker/app/modules/auth/views/signup_view.dart';
import 'package:handygo_worker/app/modules/auth/views/kyc_view.dart';
import 'package:handygo_worker/app/modules/auth/views/onboarding_view.dart';
import 'package:handygo_worker/app/modules/auth/bindings/auth_binding.dart';
import 'package:handygo_worker/app/modules/main/views/main_view.dart';
import 'package:handygo_worker/app/modules/main/bindings/main_binding.dart';
import 'package:handygo_worker/app/modules/dashboard/bindings/dashboard_binding.dart';
import 'package:handygo_worker/app/modules/bookings/bindings/bookings_binding.dart';
import 'package:handygo_worker/app/modules/chat/bindings/chat_binding.dart';
import 'package:handygo_worker/app/modules/wallet/bindings/wallet_binding.dart';
import 'package:handygo_worker/app/modules/profile/bindings/profile_binding.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
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
  ];
}
