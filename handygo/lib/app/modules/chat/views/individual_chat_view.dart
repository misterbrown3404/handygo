import 'package:handygo/app/core/constant/image_string.dart';
import 'package:handygo/app/modules/chat/controllers/individual_chat_controller.dart';
import 'package:handygo/app/modules/chat/widgets/chat_bubble.dart';
import 'package:handygo/app/modules/chat/widgets/chat_input.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';


class IndividualChatView extends GetView<IndividualChatController> {
  const IndividualChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.grey[200],
              backgroundImage: controller.thread.userAvatar != null && controller.thread.userAvatar!.startsWith('http')
                  ? NetworkImage(controller.thread.userAvatar!) as ImageProvider
                  : const AssetImage(ImageStrings.profilePic),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.thread.userName,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "Online", // This could be dynamic if supported
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.primaryColor),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0EAFC),
              Color(0xFFCFDEF3),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.only(left: 24, right: 24, top: 100, bottom: 24),
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final isSender = msg.senderId != controller.thread.userId;
                    
                    return ChatBubble(
                      text: msg.message,
                      isSender: isSender,
                      time: DateFormat('hh:mm a').format(msg.createdAt),
                    );
                  },
                );
              }),
            ),
            const ChatInput(),
          ],
        ),
      ),
    );
  }
}
