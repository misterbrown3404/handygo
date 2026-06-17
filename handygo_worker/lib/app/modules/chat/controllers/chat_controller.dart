import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/data/repositories/chat_repository.dart';
import 'package:handygo_worker/app/data/models/chat_model.dart';
import 'package:handygo_worker/app/data/models/message_model.dart';
import 'package:get_storage/get_storage.dart';

class ChatController extends GetxController {
  final ChatRepository _repository = Get.find<ChatRepository>();
  final GetStorage _storage = Get.find<GetStorage>();

  final chats = <ChatModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final token = _storage.read('token');
    if (token == null) return;
    fetchThreads();
  }

  Future<void> fetchThreads() async {
    try {
      isLoading.value = true;
      final threads = await _repository.getThreads();
      chats.assignAll(threads);
    } catch (e) {
      debugPrint('Error fetching threads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<MessageModel>> fetchMessages(int userId) async {
    try {
      return await _repository.getMessages(userId);
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      return <MessageModel>[];
    }
  }

  Future<void> sendMessage(int receiverId, String content) async {
    try {
      await _repository.sendMessage(receiverId, content);
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }
}
