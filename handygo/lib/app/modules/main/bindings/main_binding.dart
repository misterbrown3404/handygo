import 'package:get/get.dart';
import 'package:handygo/app/modules/main/controllers/main_controller.dart';
import 'package:handygo/app/modules/bookings/controllers/bookings_controller.dart';
import 'package:handygo/app/modules/favorites/controllers/favorites_controller.dart';
import 'package:handygo/app/modules/chat/controllers/chat_controller.dart';

import 'package:handygo/app/modules/profile/controllers/profile_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<BookingsController>(() => BookingsController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
