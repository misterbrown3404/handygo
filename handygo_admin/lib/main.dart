import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:handygo_admin/app/core/theme/admin_theme.dart';
import 'package:handygo_admin/app/core/widgets/admin_shell.dart';
import 'package:handygo_admin/app/data/providers/admin_api_client.dart';
import 'package:handygo_admin/app/modules/auth/controllers/admin_auth_controller.dart';
import 'package:handygo_admin/app/modules/auth/views/admin_login_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Dependency Injection
  Get.put(AdminApiClient());
  Get.put(AdminAuthController());

  runApp(const HandyGoAdmin());
}

class HandyGoAdmin extends StatelessWidget {
  const HandyGoAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AdminAuthController>();

    return GetMaterialApp(
      title: 'HandyGo Admin',
      debugShowCheckedModeBanner: false,
      theme: adminTheme(),
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const AdminLoginView()),
        GetPage(
          name: '/dashboard',
          page: () => const AdminShell(),
          middlewares: [AdminAuthMiddleware()],
        ),
      ],
    );
  }
}

/// Middleware that redirects unauthenticated users to login.
class AdminAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final storage = GetStorage();
    final token = storage.read('admin_token');
    if (token == null) {
      return const RouteSettings(name: '/login');
    }
    return null;
  }
}
