import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:handygo/app/data/repositories/auth_repository.dart';
import 'package:handygo/app/modules/auth/controllers/auth_controller.dart';

class NotificationService extends GetxService {
  static NotificationService get to => Get.find();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  Future<NotificationService> init() async {
    await _initializeLocalNotifications();
    await _requestPermissions();
    _configureFCM();
    return this;
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Create high importance channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.max,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (details) {
        log("Notification tapped: ${details.payload}");
        // Add navigation logic here if payload contains route info
      },
    );
  }

  Future<void> _requestPermissions() async {
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
    );

    // Set foreground notification presentation options for iOS
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permission');
    } else {
      log('User declined or has not accepted permission');
    }
  }

  void _configureFCM() {
    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Foreground message received: ${message.notification?.title}');
      _showLocalNotification(message);
    });

    // Handle notification click when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('Notification opened app: ${message.data}');
    });

    // Listen for token refresh
    _fcm.onTokenRefresh.listen((newToken) {
      log("FCM Token Refreshed: $newToken");
      _syncTokenWithBackend(newToken);
    });

    // Initial token fetch
    _fcm.getToken().then((token) {
      if (token != null) {
        log("Initial FCM Token: $token");
        _syncTokenWithBackend(token);
      }
    });
  }

  Future<void> _syncTokenWithBackend(String token) async {
    try {
      // Only sync if user is authenticated
      if (Get.isRegistered<AuthController>() && Get.find<AuthController>().user.value != null) {
        final authRepo = AuthRepository();
        await authRepo.updateFcmToken(token);
        log("FCM Token synced with backend");
      }
    } catch (e) {
      log("Failed to sync FCM token: $e");
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    // Don't show if notification is null
    if (message.notification == null) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true),
    );

    await _localNotifications.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: details,
      payload: message.data.toString(),
    );
  }
}

// Global background handler must be a top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, 
  // you must call Firebase.initializeApp() first.
  log("Handling a background message: ${message.messageId}");
}


