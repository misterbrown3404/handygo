import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/theme/theme.dart';
import 'package:handygo_worker/app/core/bindings/initial_binding.dart';
import 'package:handygo_worker/app/routes/app_pages.dart';

void main() {
  runApp(const WorkerApp());
}

class WorkerApp extends StatelessWidget {
  const WorkerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HandyGo Worker',
      debugShowCheckedModeBanner: false,
      theme: workerTheme(),
      initialBinding: InitialBinding(),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
