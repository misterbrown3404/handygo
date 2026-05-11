import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:handygo/app/modules/auth/bindings/auth_binding.dart';
import 'package:handygo/app/modules/auth/views/forgot_password_view.dart';
import 'package:handygo/app/modules/auth/views/new_password_view.dart';
import 'package:handygo/app/modules/auth/views/sign_in_view.dart';
import 'package:handygo/app/modules/auth/views/sign_up_view.dart';
import 'package:handygo/app/modules/auth/views/verify_otp_view.dart';
import 'package:handygo/app/modules/main/bindings/main_binding.dart';
import 'package:handygo/app/modules/main/views/main_view.dart';
import 'package:handygo/app/modules/onboarding/bindings/onboarding_binding.dart';
import 'package:handygo/app/modules/service_detail/bindings/service_detail_binding.dart';
import 'package:handygo/app/modules/service_detail/views/service_detail_view.dart';
import 'package:handygo/app/modules/onboarding/views/onboarding_view.dart';
import 'package:handygo/app/modules/splash/views/splash.dart';
import 'package:handygo/app/modules/bookings/views/booking_form_view.dart';
import 'package:handygo/app/modules/bookings/views/e_receipt_view.dart';
import 'package:handygo/app/modules/chat/views/individual_chat_view.dart';
import 'package:handygo/app/modules/notifications/views/notifications_view.dart';
import 'package:handygo/app/modules/payment/views/add_card_view.dart';
import 'package:handygo/app/modules/payment/views/payment_method_selection_view.dart';
import 'package:handygo/app/modules/payment/views/review_summary_view.dart';
import 'package:handygo/app/modules/address/views/address_selection_view.dart';
import 'package:handygo/app/modules/bookings/views/room_selection_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => const SignInView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_UP,
      page: () => const SignUpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.VERIFY_OTP,
      page: () => const VerifyOtpView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => const NewPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SERVICE_DETAILS,
      page: () => const ServiceDetailView(),
      binding: ServiceDetailBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING_FORM,
      page: () => const BookingFormView(),
    ),
    GetPage(
      name: _Paths.INDIVIDUAL_CHAT,
      page: () => const IndividualChatView(),
    ),
    GetPage(
      name: _Paths.E_RECEIPT,
      page: () => const EReceiptView(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
    ),
    GetPage(
      name: _Paths.ADD_CARD,
      page: () => const AddCardView(),
    ),
    GetPage(
      name: _Paths.REVIEW_SUMMARY,
      page: () => const ReviewSummaryView(),
    ),
    GetPage(
      name: _Paths.SELECT_ROOMS,
      page: () => const RoomSelectionView(),
    ),
    GetPage(
      name: _Paths.SELECT_ADDRESS,
      page: () => const AddressSelectionView(),
    ),
    GetPage(
      name: _Paths.SELECT_PAYMENT_METHOD,
      page: () => const PaymentMethodSelectionView(),
    ),
  ];
}
