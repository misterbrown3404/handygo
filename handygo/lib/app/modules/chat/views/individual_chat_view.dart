import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/chat/widgets/chat_bubble.dart';
import 'package:handygo/app/modules/chat/widgets/chat_input.dart';

class IndividualChatView extends StatelessWidget {
  const IndividualChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 10,
                    width: 10,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Oliver James",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "Online",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: const [
                ChatBubble(
                  text: "Hi! I'd like to book a deep cleaning for my 2BHK apartment this weekend. Are you available?",
                  isSender: true,
                  time: "09:32 AM",
                ),
                ChatBubble(
                  text: "Hello Sarah! 👋\nYes, we're available this Saturday between 10 AM and 4 PM.",
                  isSender: false,
                  time: "09:32 AM",
                ),
                ChatBubble(
                  text: "10 AM works perfectly.",
                  isSender: true,
                  time: "09:30 AM",
                ),
                ChatBubble(
                  text: "Great!",
                  isSender: false,
                  time: "09:25 AM",
                ),
                ChatBubble(
                  text: "Your deep cleaning is confirmed for Saturday at 10 AM. Our team will arrive on time. 😊",
                  isSender: false,
                  time: "09:22 AM",
                ),
                ChatBubble(
                  text: "Awesome, thank you!",
                  isSender: true,
                  time: "09:20 AM",
                ),
              ],
            ),
          ),
          const ChatInput(),
        ],
      ),
    );
  }
}
