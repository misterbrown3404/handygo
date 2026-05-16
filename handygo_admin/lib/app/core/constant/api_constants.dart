class AdminApiConstants {
  // Change this to your server IP/domain
  static const String baseUrl = 'http://172.20.10.4:8000/api/v1';

  // Admin endpoints
  static const String login = '/auth/login';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';

  // Dashboard
  static const String dashboardStats = '/admin/dashboard/stats';
  static const String dashboardRevenue = '/admin/dashboard/revenue';
  static const String workersByCategory =
      '/admin/dashboard/workers-by-category';

  // Services / Categories
  static const String services = '/services';
  static const String adminServices = '/admin/services';

  // Jobs
  static const String jobs = '/jobs';

  // Workers
  static const String workers = '/workers';

  // Customers
  static const String customers = '/customers';

  // KYC
  static const String kyc = '/admin/kyc';

  // Subscriptions
  static const String adminSubscriptions = '/admin/subscriptions';

  // Notifications
  static const String broadcastNotifications = '/admin/notifications/broadcast';

  // Settings
  static const String adminSettings = '/admin/settings';

  // Analytics
  static const String analyticsOverview = '/admin/analytics/overview';
  static const String analyticsRevenue = '/admin/analytics/revenue';
  static const String analyticsJobsByCategory =
      '/admin/analytics/jobs-by-category';
  static const String analyticsWeeklyVolume = '/admin/analytics/weekly-volume';
  static const String analyticsTopWorkers = '/admin/analytics/top-workers';
}
