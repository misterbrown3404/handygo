import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/modules/chat/controllers/chat_controller.dart';
import 'package:handygo_worker/app/widgets/fade_in_animation.dart';
import 'dart:ui';

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
          // Background blobs for depth
          Positioned(top: 200, left: -50, child: CircleAvatar(radius: 100, backgroundColor: Colors.blue.withOpacity(0.05))),
          Obx(() => ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                itemCount: controller.chats.length,
                itemBuilder: (context, index) {
                  final chat = controller.chats[index];
                  return FadeInAnimation(
                    delay: index * 100,
                    child: _ChatListItem(chat: chat),
                  );
                },
              )),
        ],
      ),
    );
  }
}

class _ChatListItem extends StatelessWidget {
  final Map<String, String> chat;
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
              color: Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: ListTile(
              onTap: () => Get.to(() => const IndividualChatView()),
              contentPadding: EdgeInsets.zero,
              leading: Stack(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundImage: AssetImage('assets/images/profile.jpg'),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                  )
                ],
              ),
              title: Text(chat['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Text(
                chat['lastMsg']!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: chat['unread'] == '1' ? Colors.black : Colors.grey),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(chat['time']!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 4),
                  if (chat['unread'] == '1')
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
                      child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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

class IndividualChatView extends StatelessWidget {
  const IndividualChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sarah Williams', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('Online', style: TextStyle(fontSize: 12, color: AppColors.primaryColor)),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Imagery/Blobs
          Positioned(bottom: 100, right: -50, child: CircleAvatar(radius: 120, backgroundColor: AppColors.primaryColor.withOpacity(0.05))),
          Column(
            children: [
              _buildJobContext(),
              Expanded(child: _buildMessageList()),
              _buildQuickReplies(),
              _buildChatInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickReplies() {
    final replies = ["I'm on my way", "I've arrived", "Almost done", "On my way back"];
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: replies.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(right: 8),
          child: ActionChip(
            label: Text(replies[index], style: const TextStyle(fontSize: 12, color: AppColors.primaryColor)),
            backgroundColor: AppColors.primaryColor.withOpacity(0.05),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {},
          ),
        ),
      ),
    );
  }

  Widget _buildJobContext() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.5)),
            ),
            child: const Row(
              children: [
                Icon(Icons.engineering_rounded, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text('Ongoing Job: Kitchen Plumbing', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                Spacer(),
                Icon(Icons.chevron_right_rounded, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: const [
        _MessageBubble(text: "Hello! Are you still coming for the plumbing fix?", isMe: false, time: "10:30 AM"),
        _MessageBubble(text: "Yes, I'm just gathering my tools. I'll be there in 20 minutes.", isMe: true, time: "10:32 AM"),
        _MessageBubble(text: "Perfect, see you then!", isMe: false, time: "10:33 AM"),
      ],
    );
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryColor)),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const _MessageBubble({required this.text, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(maxWidth: Get.width * 0.7),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isMe ? 20 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 20),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(color: isMe ? Colors.white70 : Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
