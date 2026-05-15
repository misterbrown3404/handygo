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
  static const NOTIFICATIONS = _Paths.NOTIFICATIONS;
  static const SELECT_ROOMS = _Paths.SELECT_ROOMS;
  static const SELECT_ADDRESS = _Paths.SELECT_ADDRESS;
  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const SETTINGS = _Paths.SETTINGS;
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
  static const NOTIFICATIONS = '/notifications';
  static const SELECT_ROOMS = '/select-rooms';
  static const SELECT_ADDRESS = '/select-address';
  static const EDIT_PROFILE = '/edit-profile';
  static const SETTINGS = '/settings';
}
