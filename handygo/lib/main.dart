import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/theme/theme.dart';
import 'package:handygo/app/routes/app_pages.dart';

void main() {
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
