import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/modules/chat/controllers/chat_controller.dart';
import 'package:handygo_worker/app/data/models/chat_model.dart';
import 'package:handygo_worker/app/routes/app_routes.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';

class ChatListView extends GetView<ChatController> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: false,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 200,
            left: -50,
            child: CircleAvatar(
              radius: 100,
              backgroundColor: Colors.blue.withValues(alpha: 0.05),
            ),
          ),
          Obx(() {
            if (controller.chats.isEmpty) {
              return const Center(child: Text('No messages yet'));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              itemCount: controller.chats.length,
              itemBuilder: (context, index) {
                final chat = controller.chats[index];
                return FadeInAnimation(
                  delay: index * 100,
                  child: _ChatListItem(chat: chat),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final ChatModel chat;
  const _ChatListItem({required this.chat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
            ),
              child: ListTile(
                onTap: () => Get.toNamed(Routes.CHAT, arguments: chat),
                contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: chat.profileImage != null ? NetworkImage(chat.profileImage!) : null,
                child: chat.profileImage == null ? const Icon(Icons.person, size: 28) : null,
              ),
              title: Text(
                chat.senderName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                chat.lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: chat.unreadCount > 0 ? Colors.black : Colors.grey),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(chat.time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  if (chat.unreadCount > 0)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
                      child: Text(
                        '${chat.unreadCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
