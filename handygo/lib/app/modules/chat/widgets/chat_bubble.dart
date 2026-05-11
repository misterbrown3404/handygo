import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String time;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isSender,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(maxWidth: Get.width * 0.7),
            decoration: BoxDecoration(
              color: isSender ? AppColors.primaryColor : Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: Radius.circular(isSender ? 16 : 0),
                bottomRight: Radius.circular(isSender ? 0 : 16),
              ),
            ),
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isSender ? Colors.white : Colors.black,
                    height: 1.4,
                  ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
