import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/theme/admin_theme.dart';
import 'package:handygo_admin/app/core/widgets/admin_shell.dart';

void main() {
  runApp(const HandyGoAdmin());
}

class HandyGoAdmin extends StatelessWidget {
  const HandyGoAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HandyGo Admin',
      debugShowCheckedModeBanner: false,
      theme: adminTheme(),
      home: const AdminShell(),
    );
  }
}
