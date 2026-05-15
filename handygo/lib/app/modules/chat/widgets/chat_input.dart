import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/chat/controllers/individual_chat_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:handygo/app/core/widgets/glass_container.dart';


class ChatInput extends GetView<IndividualChatController> {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      color: Colors.white.withOpacity(0.5),
      child: Row(
        children: [
          Expanded(
            child: GlassContainer(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withOpacity(0.3),
              child: Row(
                children: [
                  Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.grey[400]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: const InputDecoration(
                        hintText: "Write a message...",
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Icon(Icons.link, color: Colors.grey[400]),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => controller.sendMessage(),
            child: GlassContainer(
              height: 48,
              width: 48,
              borderRadius: BorderRadius.circular(24),
              color: AppColors.primaryColor,
              child: const Center(child: Icon(Icons.send, color: Colors.white, size: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
