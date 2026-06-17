import 'package:get/get.dart';
import 'package:handygo_worker/app/modules/chat/controllers/chat_controller.dart';
import 'package:handygo_worker/app/data/repositories/chat_repository.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatRepository>(() => ChatRepository());
    Get.lazyPut<ChatController>(() => ChatController());
  }
}
