import 'package:get/get.dart';
import '../../../data/repositories/chat_repository.dart';
import 'package:flutter/material.dart';

class IndividualChatController extends GetxController {
  final _chatRepo = ChatRepository();
  final messageController = TextEditingController();

  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;

  late ChatThreadModel thread;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is ChatThreadModel) {
      thread = Get.arguments;
      fetchMessages();
    }
  }

  Future<void> fetchMessages() async {
    try {
      isLoading(true);
      final data = await _chatRepo.getMessages(thread.userId);
      messages.assignAll(data);
    } catch (e) {
      print("Error fetching messages: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    final content = messageController.text.trim();
    messageController.clear();

    try {
      final msg = await _chatRepo.sendMessage(thread.userId, content);
      messages.add(msg);
    } catch (e) {
      Get.snackbar("Error", "Failed to send message");
    }
  }
}
