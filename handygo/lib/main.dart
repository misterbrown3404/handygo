import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handygo/app/core/theme/theme.dart';
import 'package:handygo/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo/app/routes/app_pages.dart';
import 'app/data/providers/api_client.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:handygo/app/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await Get.putAsync(() => NotificationService().init());
    
    // Initialize Google Sign In (Requirement for 7.x)
    await GoogleSignIn.instance.initialize();
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
    debugPrint("Please ensure google-services.json/GoogleService-Info.plist are added.");
  }
  
  // Initialize Storage
  await GetStorage.init();
  
  // Dependency Injection
  Get.put(ApiClient());
  Get.put(AuthController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HandyGo',
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
