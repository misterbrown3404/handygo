part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const ONBOARDING = _Paths.ONBOARDING;
  static const SIGN_IN = _Paths.SIGN_IN;
  static const SIGN_UP = _Paths.SIGN_UP;
  static const FORGOT_PASSWORD = _Paths.FORGOT_PASSWORD;
  static const VERIFY_OTP = _Paths.VERIFY_OTP;
  static const NEW_PASSWORD = _Paths.NEW_PASSWORD;
  static const SERVICE_DETAILS = _Paths.SERVICE_DETAILS;
  static const MAIN = _Paths.MAIN;
  static const BOOKING_FORM = _Paths.BOOKING_FORM;
  static const INDIVIDUAL_CHAT = _Paths.INDIVIDUAL_CHAT;
  static const E_RECEIPT = _Paths.E_RECEIPT;
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
  static const ADD_CARD = _Paths.ADD_CARD;
  static const REVIEW_SUMMARY = _Paths.REVIEW_SUMMARY;
  static const SELECT_ROOMS = _Paths.SELECT_ROOMS;
  static const SELECT_ADDRESS = _Paths.SELECT_ADDRESS;
  static const SELECT_PAYMENT_METHOD = _Paths.SELECT_PAYMENT_METHOD;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/';
  static const ONBOARDING = '/onboarding';
  static const SIGN_IN = '/sign-in';
  static const SIGN_UP = '/sign-up';
  static const FORGOT_PASSWORD = '/forgot-password';
  static const VERIFY_OTP = '/verify-otp';
  static const NEW_PASSWORD = '/new-password';
  static const SERVICE_DETAILS = '/service-details';
  static const MAIN = '/main';
  static const BOOKING_FORM = '/booking-form';
  static const INDIVIDUAL_CHAT = '/individual-chat';
  static const E_RECEIPT = '/e-receipt';
  static const NOTIFICATIONS = '/notifications';
  static const ADD_CARD = '/add-card';
  static const REVIEW_SUMMARY = '/review-summary';
  static const SELECT_ROOMS = '/select-rooms';
  static const SELECT_ADDRESS = '/select-address';
  static const SELECT_PAYMENT_METHOD = '/select-payment-method';
}
