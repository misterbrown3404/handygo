class ApiConstants {
  static const String baseUrl =
      'http://172.20.10.4:8000/api/v1'; // Real IP for Physical Device
  // '0.0.0.0' is for the server, the client must use the IP address.

  // Auth Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';
  static const String fcmToken = '/user/fcm-token';

  // Core Endpoints
  static const String services = '/services';
  static const String workers = '/workers';
  static const String nearbyWorkers = '/workers/nearby';
  static const String bookings = '/bookings';
  static const String jobs = '/jobs';
  static const String chat = '/chat';
  static const String favorites = '/favorites/toggle';
}
