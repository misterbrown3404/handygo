import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/core/constant/image_string.dart';
import 'package:handygo/app/data/repositories/chat_repository.dart';
import 'package:intl/intl.dart';

import 'package:handygo/app/core/widgets/glass_container.dart';

class ChatItem extends StatelessWidget {
  final ChatThreadModel thread;
  final VoidCallback onTap;

  const ChatItem({super.key, required this.thread, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GlassContainer(
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                backgroundImage:
                    thread.userAvatar != null &&
                        thread.userAvatar!.startsWith('http')
                    ? NetworkImage(thread.userAvatar!) as ImageProvider
                    : const AssetImage(ImageStrings.profilePic),
              ),
              // We could add an online status if the backend provides it
            ],
          ),
          title: Text(
            thread.userName,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          subtitle: Text(
            thread.lastMessage,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('hh:mm a').format(thread.lastMessageAt),
                style: Theme.of(context).textTheme.labelSmall,
              ),
              if (thread.unreadCount > 0) ...[
                const SizedBox(height: 4),
                GlassContainer(
                  width: 24,
                  height: 24,
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryColor,
                  child: Center(
                    child: Text(
                      "${thread.unreadCount}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
