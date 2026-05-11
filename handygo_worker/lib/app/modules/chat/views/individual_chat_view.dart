import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_worker/app/data/models/chat_model.dart';

class IndividualChatView extends StatelessWidget {
  final ChatModel chat;
  const IndividualChatView({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(radius: 18, child: Icon(Icons.person, size: 20)),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.senderName, style: const TextStyle(fontSize: 16)),
                const Text('Online', style: TextStyle(fontSize: 12, color: Color(0xFF55B436))),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildMessage('Hello! I wanted to confirm the time.', false),
                _buildMessage('Yes, I will be there at 12:30 PM.', true),
                _buildMessage('Perfect, thank you!', false),
              ],
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessage(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(maxWidth: Get.width * 0.7),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF55B436) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black87),
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(color: Color(0xFF55B436), shape: BoxShape.circle),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
