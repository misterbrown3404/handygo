import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/core/constant/color.dart';
import 'package:handygo_worker/app/core/constant/spacing.dart';
import 'package:handygo_worker/app/modules/chat/controllers/chat_controller.dart';
import 'package:handygo_worker/app/data/models/chat_model.dart';
import 'package:handygo_worker/app/data/models/message_model.dart';

class IndividualChatView extends StatefulWidget {
  const IndividualChatView({super.key});

  @override
  State<IndividualChatView> createState() => _IndividualChatViewState();
}

class _IndividualChatViewState extends State<IndividualChatView> {
  final TextEditingController _messageController = TextEditingController();
  final messages = <MessageModel>[].obs;
  final ChatController _chatController = Get.find<ChatController>();

  late final ChatModel chat;

  @override
  void initState() {
    super.initState();
    chat = Get.arguments;
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final msgs = await _chatController.fetchMessages(int.parse(chat.id));
      messages.assignAll(msgs);
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    await _chatController.sendMessage(int.parse(chat.id), text);
    _messageController.clear();
    await _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: chat.profileImage != null ? NetworkImage(chat.profileImage!) : null,
              child: chat.profileImage == null ? const Icon(Icons.person, size: 20) : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chat.senderName, style: const TextStyle(fontSize: 16)),
                  const Text('Online', style: TextStyle(fontSize: 12, color: Color(0xFF55B436))),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildJobContext(),
          Expanded(child: _buildMessageList()),
          _buildChatInput(),
        ],
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
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
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
    return Obx(() => ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: messages.map((msg) => _MessageBubble(text: msg.text, isMe: msg.isMe, time: _formatTime(msg.time))).toList(),
    ));
  }

  String _formatTime(DateTime time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')} ${time.hour >= 12 ? 'PM' : 'AM'}';
  }

  Widget _buildChatInput() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primaryColor)),
            Expanded(
              child: TextField(
                controller: _messageController,
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
            CircleAvatar(
              backgroundColor: AppColors.primaryColor,
              child: IconButton(icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20), onPressed: _sendMessage),
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
            bottomRight: Radius.circular(isMe ? 20 : 0),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(text, style: TextStyle(color: isMe ? Colors.white : Colors.black, fontSize: 14)),
            const SizedBox(height: 4),
            Text(time, style: TextStyle(color: isMe ? Colors.white70 : Colors.grey, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
