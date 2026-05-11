import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[100]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                children: [
                  Icon(Icons.sentiment_satisfied_alt_outlined, color: Colors.grey[400]),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
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
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
